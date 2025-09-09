import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timegrid/components/edit_course_bottom_sheet.dart';
import 'package:timegrid/components/file_io_json.dart';
import 'package:timegrid/models/course_model.dart';
import 'package:timegrid/models/storage_service.dart';
import 'package:timegrid/models/time_cell_model.dart';
import 'package:timegrid/provider.dart';
import 'package:timegrid/theme/Theme.dart';
import 'dart:math' as math;

import 'components/course_card.dart';
import 'components/edit_time_cell_bottom_sheet.dart';
import 'models/active_overlay.dart'; // 內含 DragPayload

class ScheduleController extends ChangeNotifier {
  final StorageService storage;
  int days;
  int rows;

  ScheduleController({required this.storage})
    : days = storage.days,
      rows = storage.rows;


  void _persist() {
    storage.setDays(days);
    storage.setRows(rows);
  }

  void addDay() {
    days = math.min(days + 1, 7);
    _persist();
    notifyListeners();
  }

  void removeDay() {
    days = math.max(days - 1, 5);
    _persist();
    notifyListeners();
  }

  void addRow() {
    rows += 1;
    _persist();
    notifyListeners();
  }

  void removeRow() {
    rows = math.max(rows - 1, 1);
    _persist();
    notifyListeners();
  }

  void reloadFromStorage() {
    days = storage.days;
    rows = storage.rows;
    notifyListeners();
  }
}

class ScheduleBody extends StatelessWidget {
  final bool isEditMode;
  final ScheduleController controller;

  const ScheduleBody({
    Key? key,
    this.isEditMode = true,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: ScheduleGrid(
          editMode: isEditMode,
          controller: controller,
        ));
  }
}

class ScheduleGrid extends ConsumerStatefulWidget {
  final double rowHeight;
  final double dayHeaderHeight;
  final double timeLabelWidth;
  final bool showHeaders;
  final double cellHGap;
  final double cellVGap;
  final bool editMode;
  final ScheduleController controller;

  const ScheduleGrid({
    Key? key,
    this.rowHeight = 60.0,
    this.dayHeaderHeight = 48.0,
    this.timeLabelWidth = 56.0,
    this.showHeaders = true,
    this.cellHGap = 3.0,
    this.cellVGap = 3.0,
    this.editMode = true,
    required this.controller,
  }) : super(key: key);

  @override
  ConsumerState<ScheduleGrid> createState() => _ScheduleGridState();

  Future<CourseModel?> _openEditCourseModal(BuildContext ctx, CourseModel course, WidgetRef ref, VoidCallback? onDelete)
    => editCourseBottomSheet(ctx, course, ref, onDelete);

  Future<TimeCellModel?> _openEditTimeCellModal(BuildContext ctx, TimeCellModel time, WidgetRef ref)
    => editTimeCellBottomSheet(ctx, time, ref);

}

class _ScheduleGridState extends ConsumerState<ScheduleGrid> {
  bool _isLoadingFromHive = false;
  final Map<String, CourseModel> _occupiedMap = {}; // cell -> course
  final ScrollController _scrollController = ScrollController();

  String _keyFor(int row, int day) => '$row,$day';

  CourseModel? _getCourseAt(int row, int day) => _occupiedMap[_keyFor(row, day)];

  bool _isHeadCell(int row, int day, CourseModel c) => c.row == row && c.day == day;

  Future<void> _saveSchedule() async {
    try {
      final storage = ref.read(storageProvider);
      final unique = <String, CourseModel>{};
      for (final c in _occupiedMap.values) {
        unique[c.id] = c;
      }
      await storage.clearCourses();
      await storage.putAllCourses(unique);
    } catch (e, st) {
      debugPrint('Hive saveSchedule error: $e\n$st');
    }
  }

  Future<void> _loadSchedule() async {
    _isLoadingFromHive = true;
    try {
      final storage = ref.read(storageProvider);
      _occupiedMap.clear();
      for (final dynamic v in storage.getAllCourses()) {
        final CourseModel c = v as CourseModel;
        _placeCourse(c);
      }
      setState(() {});
    } catch (e, st) {
      debugPrint('Hive loadSchedule error: $e\n$st');
    } finally {
      _isLoadingFromHive = false;
    }
  }

  void _scheduleChanged() {
    if (_isLoadingFromHive) return;
    _saveSchedule();
  }

  void _onControllerChanged() {
    setState(() {
      debugPrint('ScheduleGrid: days=${widget.controller.days}, rows=${widget.controller.rows}');
    });
  }

  ActiveOverlay? _active; // 為 null 代表沒有在預覽

  double _overlayDragAccDy = 0.0;
  double? _overlayStartTop;
  double? _overlayStartHeight;

  void _addAt(int row, int day) {
    final id = UniqueKey().toString();
    final c = CourseModel(
      id: id,
      title: 'New Course',
      room: 'R101',
      color: colorLibrary[(row + day) % colorLibrary.length],
      day: day,
      row: row,
      duration: 1,
    );
    setState(() => _placeCourse(c));
    _scheduleChanged();
  }

  void _placeCourse(CourseModel c) {
    for (int r = c.row; r < c.row + c.duration; r++) {
      _occupiedMap[_keyFor(r, c.day)] = c;
    }
    _scheduleChanged();
  }

  void _clearCourse(CourseModel c) {
    _occupiedMap.removeWhere((k, v) => v.id == c.id);
    _scheduleChanged();
  }

  CourseModel? _findById(String id) {
    try {
      return _occupiedMap.values.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  bool _canPlace({required int row, required int day, required int duration, String? ignoreId}) {
    if (day < 0 || day >= widget.controller.days) return false;
    if (row < 0 || row + duration > widget.controller.rows) return false;
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
    final newOverlay = _overlayFromCourse(c: c, dayWidth: dayWidth, rowHeight: rowHeight, hGap: hGap, vGap: vGap);

    if (_active == null || _active!.id != c.id) {
      setState(() {
        _active = newOverlay;
        _overlayStartTop = newOverlay.top;
        _overlayStartHeight = newOverlay.height;
        _overlayDragAccDy = 0.0;
      });
    } else {
      _overlayStartTop = _active!.top;
      _overlayStartHeight = _active!.height;
      _overlayDragAccDy = 0.0;
    }
  }

  // 將 overlay 幾何貼齊格線並嘗試套用（移動或縮放結果）
  void _commitOverlay({
    required double dayWidth,
    required double rowHeight,
  }) {
    final a = _active;
    if (a == null) return;
    // 換算到格線
    final snappedDay =
        a.left < 0 ? 0 : ((a.left + dayWidth / 2) / dayWidth).floor().clamp(0, widget.controller.days - 1);
    final snappedRow =
        a.top < 0 ? 0 : ((a.top + rowHeight / 2) / rowHeight).floor().clamp(0, widget.controller.rows - 1);
    int snappedDur = math.max(1, ((a.height + rowHeight / 2) / rowHeight).floor());
    if (snappedRow + snappedDur > widget.controller.rows) snappedDur = widget.controller.rows - snappedRow;

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
        _overlayStartTop = null;
        _overlayStartHeight = null;
        _overlayDragAccDy = 0.0;
      });
    } else {
      // 放不下就取消預覽
      setState(() {
        _active = null;
        _overlayStartTop = null;
        _overlayStartHeight = null;
        _overlayDragAccDy = 0.0;
      });
    }
  }

  void _handleEdgeDrag({
    required bool isTop,
    required CourseModel course,
    required double dy,
    required double dayWidth,
  }) {
    _startOverlayIfNeeded(course, dayWidth, widget.rowHeight, widget.cellHGap, widget.cellVGap);
    if (_active == null) return;

    setState(() {
      _overlayDragAccDy += dy;
      final totalDy = _overlayDragAccDy;

      final minH = widget.rowHeight - 2 * widget.cellVGap;
      final baseTop = _overlayStartTop ?? _active!.top;
      final maxH = (widget.controller.rows * widget.rowHeight) - baseTop;
      final baseHeight = _overlayStartHeight ?? _active!.height;

      double newTop = baseTop;
      double newHeight = baseHeight;

      if (isTop) {
        newTop = (baseTop + totalDy).clamp(0.0, baseTop + baseHeight - minH);
        newHeight = (baseHeight - totalDy).clamp(minH, maxH);
      } else {
        newHeight = (baseHeight + totalDy).clamp(minH, maxH);
      }

      _active = _active!.copyWith(top: newTop, height: newHeight);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSchedule();
    importNotifier.addListener(_loadSchedule);
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    importNotifier.removeListener(_loadSchedule);
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width;
      final rightWidth = (maxWidth - widget.timeLabelWidth).clamp(0.0, maxWidth);
      final dayWidth = widget.controller.days > 0 ? rightWidth / widget.controller.days : 0.0;
      final totalHeight = widget.controller.rows * widget.rowHeight;

      // final timeSlots = List<String>.generate(widget.controller.rows, (i) => 'Slot ${i + 1}');

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
                  children: List.generate(widget.controller.days, (d) {
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
                            dayNames[d],
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

      // Left Time Column
      Widget timeColumn() {
        List<String> slotNames = [];
        return GestureDetector(
          onTap: () async {
            final TimeCellModel? edited = await widget._openEditTimeCellModal(
                context,
                const TimeCellModel(displayName: 'A', startTime: TimeOfDay(hour: 8, minute: 0), endTime: TimeOfDay(hour: 9, minute: 0)),
                ref);
            // final TimeOfDay? picked = await showTimePicker(
            //   context: context,
            //   initialTime: const TimeOfDay(hour: 0, minute: 0),
            //   builder: (BuildContext context, Widget? child) {
            //     return MediaQuery(
            //       data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            //       child: child!,
            //     );
            //   },
            // );
          },
          child: SizedBox(
            width: widget.timeLabelWidth,
            child: Column(
              children: List.generate(widget.controller.rows, (r) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: widget.cellVGap, horizontal: widget.cellHGap),
                  child: Container(
                    height: widget.rowHeight - (widget.cellVGap * 2),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '08:00',
                          style: TextStyle(color: cs.tertiary, fontSize: 9),
                        ),
                        Text(
                          r < slotNames.length ? slotNames[r] : (r+1).toString(),
                          style: TextStyle(color: cs.onPrimaryContainer, fontSize: 16),
                        ),
                        Text(
                          '08:00',
                          style: TextStyle(color: cs.tertiary, fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      }

      // 一個 cell（底層格線/拖放目標）
      Widget buildCell(int r, int d) {
        final course = _getCourseAt(r, d);
        final occupied = course != null;
        final isHead = occupied && _isHeadCell(r, d, course);

        //FIXME: course card expand logic has been removed, the code has not activated.
        // final hideHeadBecauseOverlay = _active != null && occupied && isHead && _active!.id == course.id;

        return Stack(clipBehavior: Clip.none, children: [
          SizedBox(
            width: dayWidth,
            height: widget.rowHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.cellHGap, vertical: widget.cellVGap),
              child: DragTarget<DragPayload>(
                onWillAcceptWithDetails: (details) {
                  final c = _findById(details.data.courseId);
                  if (c == null) return false;
                  return _canPlace(row: r, day: d, duration: c.duration, ignoreId: c.id);
                },
                onAcceptWithDetails: (details) {
                  _moveCourse(details.data.courseId, r, d);
                },
                builder: (context, candidate, rejected) {
                  final highlight = candidate.isNotEmpty;

                  // In normal mode, draw a space
                  if (!widget.editMode) {
                    if (isHead || occupied) return const SizedBox();
                    return _EmptyCell(
                      borderColor: cs.onSurface.withValues(alpha: 0.25),
                      radius: 8,
                      dashWidth: 6,
                      dashGap: 4,
                    );
                  }

                  // The cell is class head
                  if (isHead) {
                    return CourseCard(
                      course: course,
                      editMode: widget.editMode,
                      draggable: true,
                      // 非 overlay 時使用 Draggable
                      onTap: () async {
                        final updated = await widget._openEditCourseModal(
                            context, course, ref, () => setState(() => _clearCourse(course)));

                        if (updated == null) return;
                        final newCourse = course.copyWith(
                          title: updated.title,
                          room: updated.room,
                          color: updated.color,
                        );
                        setState(() {
                          _clearCourse(course);
                          _placeCourse(newCourse);
                        });
                      },
                      onTopHandleDragUpdate: (dy) =>
                          _handleEdgeDrag(isTop: true, course: course, dy: dy, dayWidth: dayWidth),
                      onBottomHandleDragUpdate: (dy) =>
                          _handleEdgeDrag(isTop: false, course: course, dy: dy, dayWidth: dayWidth),
                      onTopHandleDragEnd: () {
                        _commitOverlay(dayWidth: dayWidth, rowHeight: widget.rowHeight);
                      },
                      onBottomHandleDragEnd: () {
                        _commitOverlay(dayWidth: dayWidth, rowHeight: widget.rowHeight);
                      },
                    );
                  }

                  // This grid is the other time of the course above.
                  if (occupied) {
                    return AbsorbPointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: course.color,
                          // color: cs.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }

                  // //FIXME: course card expand logic has been removed, the code has not activated.
                  // if (hideHeadBecauseOverlay) {
                  //   return AbsorbPointer(
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         color: cs.primary.withValues(alpha: 0.06),
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //     ),
                  //   );
                  // }

                  // Empty cell
                  return GestureDetector(
                    onTap: () {
                      if (!occupied && widget.editMode) _addAt(r, d);
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
                              color: cs.primary.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          if (!widget.editMode && isHead)
            Positioned(
              top: 0,
              left: 0,
              width: dayWidth,
              height: course.duration * widget.rowHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.cellHGap, vertical: widget.cellVGap),
                child: CourseCard(course: course, draggable: false, editMode: false),
              ),
            ),
        ]);
      }

      // 右側區：底層格線 + overlay 疊在最上層
      Widget rightArea() {
        return SizedBox(
          width: rightWidth,
          child: Stack(
            children: [
              // 底層：格線（每列 row，裡面是每日 cell）
              Column(
                children: List.generate(widget.controller.rows, (r) {
                  return SizedBox(
                    child: Row(
                      children: List.generate(widget.controller.days, (d) => buildCell(r, d)),
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
                            top: moved.top.clamp(0.0, totalHeight - moved.height));
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
                    ),
                  ),
                ),
            ],
          ),
        );
      }

      final visibleHeight = math.min(totalHeight, constraints.maxHeight);

      return SizedBox(
        height: visibleHeight,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
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
              const SizedBox(height: 50),
            ],
          ),
        ),
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
