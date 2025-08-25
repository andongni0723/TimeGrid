import 'package:flutter/material.dart';
import 'package:timegrid/models/course_model.dart';
import 'dart:math' as math;

import 'components/course_card.dart';
import 'models/active_overlay.dart'; // 內含 DragPayload

class ScheduleBody extends StatelessWidget {
  const ScheduleBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(child: ScheduleGrid()),
    );
  }
}

class ScheduleGrid extends StatefulWidget {
  final int days;
  final int rows;
  final double rowHeight;
  final double dayHeaderHeight;
  final double timeLabelWidth;
  final bool showHeaders;
  final double cellHGap;
  final double cellVGap;
  final bool editMode;

  const ScheduleGrid({
    Key? key,
    this.days = 5,
    this.rows = 8,
    this.rowHeight = 75.0,
    this.dayHeaderHeight = 48.0,
    this.timeLabelWidth = 56.0,
    this.showHeaders = true,
    this.cellHGap = 3.0,
    this.cellVGap = 3.0,
    this.editMode = true,
  }) : super(key: key);

  @override
  State<ScheduleGrid> createState() => _ScheduleGridState();
}

class _ScheduleGridState extends State<ScheduleGrid> {
  // cell -> course
  final Map<String, CourseModel> _occupiedMap = {};
  String _keyFor(int row, int day) => '$row,$day';
  CourseModel? _getCourseAt(int row, int day) => _occupiedMap[_keyFor(row, day)];
  bool _isHeadCell(int row, int day, CourseModel c) => c.row == row && c.day == day;

  // === Overlay（即時拖拉/移動的視覺） ===
  ActiveOverlay? _active; // 為 null 代表沒有在預覽

  // 新增一堂示範課
  void _addAt(int row, int day) {
    final id = UniqueKey().toString();
    final c = CourseModel(
      id: id,
      title: '自然科學與人工智慧導論',
      room: 'R101',
      color: Colors.primaries[(row + day) % Colors.primaries.length],
      day: day,
      row: row,
      duration: 1,
    );
    setState(() => _placeCourse(c));
  }

  void _placeCourse(CourseModel c) {
    for (int r = c.row; r < c.row + c.duration; r++) {
      _occupiedMap[_keyFor(r, c.day)] = c;
    }
  }

  void _clearCourse(CourseModel c) {
    _occupiedMap.removeWhere((k, v) => v.id == c.id);
  }

  CourseModel? _findById(String id) {
    try {
      return _occupiedMap.values.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  bool _canPlace({required int row, required int day, required int duration, String? ignoreId}) {
    if (day < 0 || day >= widget.days) return false;
    if (row < 0 || row + duration > widget.rows) return false;
    for (int r = row; r < row + duration; r++) {
      final exist = _occupiedMap[_keyFor(r, day)];
      if (exist != null && exist.id != ignoreId) return false;
    }
    return true;
  }

  // ====== 既有：離散格為單位的移動/縮放（放手後套用） ======
  bool _moveCourse(String courseId, int toRow, int toDay) {
    final c = _findById(courseId);
    if (c == null) return false;
    if (!_canPlace(row: toRow, day: toDay, duration: c.duration, ignoreId: courseId)) return false;
    setState(() {
      _clearCourse(c);
      _placeCourse(c.copyWith(row: toRow, day: toDay));
    });
    return true;
  }

  bool _resizeTop(String courseId, int deltaRows) {
    final c = _findById(courseId);
    if (c == null || deltaRows == 0) return false;

    int newRow = c.row + deltaRows;
    int newDuration = c.duration - deltaRows;

    if (newDuration < 1) {
      newRow += (newDuration - 1);
      newDuration = 1;
    }
    if (newRow < 0) {
      newDuration += newRow;
      newRow = 0;
    }
    if (newRow + newDuration > widget.rows) {
      newDuration = widget.rows - newRow;
    }
    if (newDuration < 1) return false;

    if (!_canPlace(row: newRow, day: c.day, duration: newDuration, ignoreId: courseId)) return false;

    setState(() {
      _clearCourse(c);
      _placeCourse(c.copyWith(row: newRow, duration: newDuration));
    });
    return true;
  }

  bool _resizeBottom(String courseId, int deltaRows) {
    final c = _findById(courseId);
    if (c == null || deltaRows == 0) return false;

    int newDuration = c.duration + deltaRows;
    if (newDuration < 1) newDuration = 1;
    if (c.row + newDuration > widget.rows) {
      newDuration = widget.rows - c.row;
    }
    if (!_canPlace(row: c.row, day: c.day, duration: newDuration, ignoreId: courseId)) return false;

    setState(() {
      _clearCourse(c);
      _placeCourse(c.copyWith(duration: newDuration));
    });
    return true;
  }

  // ====== Overlay 工具 ======
  ActiveOverlay _overlayFromCourse({
    required CourseModel c,
    required double dayWidth,
    required double rowHeight,
    required double hGap,
    required double vGap,
  }) {
    return ActiveOverlay(
      id: c.id,
      day: c.day,
      row: c.row,
      duration: c.duration,
      left: c.day * dayWidth + hGap,
      top: c.row * rowHeight + vGap,
      width: dayWidth - 2 * hGap,
      height: c.duration * rowHeight - 2 * vGap,
    );
  }

  void _startOverlayIfNeeded(CourseModel c, double dayWidth, double rowHeight, double hGap, double vGap) {
    _active ??= _overlayFromCourse(c: c, dayWidth: dayWidth, rowHeight: rowHeight, hGap: hGap, vGap: vGap);
  }

  // 將 overlay 幾何貼齊格線並嘗試套用（移動或縮放結果）
  void _commitOverlay({
    required double dayWidth,
    required double rowHeight,
  }) {
    final a = _active;
    if (a == null) return;
    // 換算到格線
    final snappedDay = a.left < 0 ? 0 : ((a.left + dayWidth / 2) / dayWidth).floor().clamp(0, widget.days - 1);
    final snappedRow = a.top < 0 ? 0 : ((a.top + rowHeight / 2) / rowHeight).floor().clamp(0, widget.rows - 1);
    int snappedDur = math.max(1, ((a.height + rowHeight / 2) / rowHeight).floor());
    if (snappedRow + snappedDur > widget.rows) snappedDur = widget.rows - snappedRow;

    final c = _findById(a.id);
    if (c == null) {
      setState(() => _active = null);
      return;
    }

    // 嘗試放置
    if (_canPlace(row: snappedRow, day: snappedDay, duration: snappedDur, ignoreId: c.id)) {
      setState(() {
        _clearCourse(c);
        _placeCourse(c.copyWith(row: snappedRow, day: snappedDay, duration: snappedDur));
        _active = null;
      });
    } else {
      // 放不下就取消預覽
      setState(() => _active = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width;
      final rightWidth = (maxWidth - widget.timeLabelWidth).clamp(0.0, maxWidth);
      final dayWidth = widget.days > 0 ? rightWidth / widget.days : 0.0;
      final totalHeight = widget.rows * widget.rowHeight;

      final timeSlots = List<String>.generate(widget.rows, (i) => 'Slot ${i + 1}');

      // Header
      Widget header() {
        if (!widget.showHeaders) return const SizedBox.shrink();
        return SizedBox(
          height: widget.dayHeaderHeight,
          child: Row(
            children: [
              SizedBox(width: widget.timeLabelWidth),
              SizedBox(
                width: rightWidth,
                child: Row(
                  children: List.generate(widget.days, (d) {
                    return SizedBox(
                      width: dayWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: widget.cellHGap, vertical: widget.cellVGap),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            d < dayNames.length ? dayNames[d] : 'Day ${d + 1}',
                            style: TextStyle(color: cs.onPrimaryContainer, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      }

      // 左側時間欄
      Widget timeColumn() {
        return SizedBox(
          width: widget.timeLabelWidth,
          child: Column(
            children: List.generate(widget.rows, (r) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: widget.cellVGap, horizontal: widget.cellHGap),
                child: Container(
                  height: widget.rowHeight - (widget.cellVGap * 2),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    r < timeSlots.length ? timeSlots[r] : 'Slot ${r + 1}',
                    style: TextStyle(color: cs.onPrimaryContainer, fontSize: 16),
                  ),
                ),
              );
            }),
          ),
        );
      }

      // 一個 cell（底層格線/拖放目標）
      Widget buildCell(int r, int d) {
        final course = _getCourseAt(r, d);
        final occupied = course != null;
        final isHead = occupied && _isHeadCell(r, d, course);

        // 當該課程正被 overlay 預覽時，head cell 不再畫實體卡（避免底下重疊）；畫透明佔位即可
        final hideHeadBecauseOverlay = _active != null && occupied && isHead && _active!.id == course.id;

        return SizedBox(
          width: dayWidth,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.cellHGap, vertical: widget.cellVGap),
            child: DragTarget<DragPayload>(
              onWillAcceptWithDetails: (details) {
                final payload = details.data;
                final c = _findById(payload.courseId);
                if (c == null) return false;
                return _canPlace(row: r, day: d, duration: c.duration, ignoreId: c.id);
              },
              onAcceptWithDetails: (details) {
                final payload = details.data;
                _moveCourse(payload.courseId, r, d);
              },
              builder: (context, candidate, rejected) {
                final highlight = candidate.isNotEmpty;

                if (hideHeadBecauseOverlay) {
                  return AbsorbPointer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }

                if (isHead) {
                  // 正常情況：在 head cell 畫 CourseCard（非 overlay 的版本）
                  return CourseCard(
                    course: course,
                    editMode: widget.editMode,
                    draggable: true, // 非 overlay 時使用 Draggable
                    // 這裡仍保留原本「以格為單位」的縮放（放手才換格）
                    onTopHandleDragUpdate: (dy) {
                      // 走舊邏輯（累積到 1 格再縮）
                      final steps = (dy / widget.rowHeight).truncate();
                      if (steps != 0) _resizeTop(course.id, steps);
                    },
                    onBottomHandleDragUpdate: (dy) {
                      final steps = (dy / widget.rowHeight).truncate();
                      if (steps != 0) _resizeBottom(course.id, steps);
                    },
                  );
                }

                if (occupied) {
                  // 同課程的其它格：透明佔位
                  return AbsorbPointer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }

                // 空格：虛線框 + 被拖到時高亮
                return GestureDetector(
                  onTap: () {
                    if (!occupied) _addAt(r, d);
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _EmptyCell(
                        borderColor: cs.onSurface.withValues(alpha: 0.25),
                        radius: 8,
                        dashWidth: 6,
                        dashGap: 4,
                      ),
                      if (highlight)
                        Container(
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }

      // 右側區：底層格線 + overlay 疊在最上層
      Widget rightArea() {
        return SizedBox(
          width: rightWidth,
          child: Stack(
            children: [
              // 底層：格線（每列 row，裡面是每日 cell）
              Column(
                children: List.generate(widget.rows, (r) {
                  return SizedBox(
                    height: widget.rowHeight,
                    child: Row(
                      children: List.generate(widget.days, (d) => buildCell(r, d)),
                    ),
                  );
                }),
              ),

              // Overlay：如果有正在編輯的課程，直接用像素放一個 Positioned CourseCard
              if (_active != null)
                Positioned(
                  left: _active!.left,
                  top: _active!.top,
                  width: _active!.width,
                  height: _active!.height,
                  child: GestureDetector(
                    // 中間拖移（移動整張卡）
                    onPanStart: (_) {},
                    onPanUpdate: (d) {
                      setState(() {
                        final moved = _active!.moveBy(dx: d.delta.dx, dy: d.delta.dy);
                        _active = moved.copyWith(
                          left: moved.left.clamp(0.0, rightWidth - moved.width),
                          top: moved.top.clamp(0.0, totalHeight - moved.height)
                        );
                      });
                    },
                    onPanEnd: (_) {
                      // 放手：貼齊格線並嘗試套用
                      _commitOverlay(dayWidth: dayWidth, rowHeight: widget.rowHeight);
                    },
                    child: CourseCard(
                      course: _findById(_active!.id)!, // 顯示用
                      editMode: widget.editMode,
                      draggable: false, // overlay 由外層處理拖移，不用 Draggable
                      onTopHandleDragUpdate: (dy) {
                        // 進入 overlay 預覽模式（若未啟動）
                        final c = _findById(_active!.id);
                        if (c == null) return;
                        _startOverlayIfNeeded(c, dayWidth, widget.rowHeight, widget.cellHGap, widget.cellVGap);

                        setState(() {
                          final newTop = (_active!.top + dy).clamp(0.0, _active!.top + _active!.height - (widget.rowHeight - 2 * widget.cellVGap));
                          final newHeight = (_active!.height - dy).clamp(widget.rowHeight - 2 * widget.cellVGap, totalHeight - newTop);
                          _active = _active!.copyWith(top: newTop, height: newHeight);
                        });
                      },
                      onTopHandleDragEnd: () {
                        _commitOverlay(dayWidth: dayWidth, rowHeight: widget.rowHeight);
                      },
                      onBottomHandleDragUpdate: (dy) {
                        final c = _findById(_active!.id);
                        if (c == null) return;
                        _startOverlayIfNeeded(c, dayWidth, widget.rowHeight, widget.cellHGap, widget.cellVGap);

                        setState(() {
                          final newHeight = (_active!.height + dy).clamp(widget.rowHeight - 2 * widget.cellVGap, totalHeight - _active!.top);
                          _active = _active!.copyWith(height: newHeight);
                        });
                      },
                      onBottomHandleDragEnd: () {
                        _commitOverlay(dayWidth: dayWidth, rowHeight: widget.rowHeight);
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header(),
          SizedBox(
            height: totalHeight,
            child: Row(
              children: [
                timeColumn(),
                rightArea(),
              ],
            ),
          ),
        ],
      );
    });
  }
}

/// 空格子：透明填滿 + 虛線圓角框
class _EmptyCell extends StatelessWidget {
  final Color borderColor;
  final double radius;
  final double dashWidth;
  final double dashGap;

  const _EmptyCell({
    Key? key,
    required this.borderColor,
    this.radius = 8,
    this.dashWidth = 6,
    this.dashGap = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRoundedRectPainter(
        color: borderColor,
        radius: radius,
        dashWidth: dashWidth,
        dashGap: dashGap,
      ),
      child: Container(
        padding: const EdgeInsets.all(6),
        alignment: Alignment.topLeft,
      ),
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;

  _DashedRoundedRectPainter({
    required this.color,
    this.radius = 8,
    this.dashWidth = 6,
    this.dashGap = 4,
    this.strokeWidth = 1.2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;

    final pm = path.computeMetrics();
    for (final metric in pm) {
      double distance = 0.0;
      final length = metric.length;
      while (distance < length) {
        final next = math.min(dashWidth, length - distance);
        final extract = metric.extractPath(distance, distance + next);
        canvas.drawPath(extract, paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter old) {
    return old.color != color ||
        old.radius != radius ||
        old.dashWidth != dashWidth ||
        old.dashGap != dashGap ||
        old.strokeWidth != strokeWidth;
  }
}