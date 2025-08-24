import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

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

/// ScheduleGrid 現在是 Stateful，內部管理已加入的課程 (row, day)
class ScheduleGrid extends StatefulWidget {
  final int days;
  final int rows;
  final double rowHeight;
  final double dayHeaderHeight;
  final double timeLabelWidth;
  final bool showHeaders;

  const ScheduleGrid({
    Key? key,
    this.days = 5,
    this.rows = 8,
    this.rowHeight = 75.0,
    this.dayHeaderHeight = 48.0,
    this.timeLabelWidth = 56.0,
    this.showHeaders = true,
  }) : super(key: key);

  @override
  State<ScheduleGrid> createState() => _ScheduleGridState();
}

class _ScheduleGridState extends State<ScheduleGrid> {
  // 用 string key "r,d" 表示 (row,day)；也可以改成自訂型別
  final Set<String> _occupied = {};

  String _keyFor(int row, int day) => '$row,$day';

  bool _isOccupied(int row, int day) => _occupied.contains(_keyFor(row, day));

  void _addAt(int row, int day) {
    setState(() {
      _occupied.add(_keyFor(row, day));
    });
  }

  void _removeAt(int row, int day) {
    setState(() {
      _occupied.remove(_keyFor(row, day));
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width;
      final rightWidth = (maxWidth - widget.timeLabelWidth).clamp(0.0, maxWidth);
      final dayWidth = widget.days > 0 ? rightWidth / widget.days : 0.0;
      final totalHeight = widget.rows * widget.rowHeight;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showHeaders)
            SizedBox(
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
                          child: _HeaderCell(
                            label: (d < dayNames.length) ? dayNames[d] : 'Day ${d + 1}',
                            color: cs.primaryContainer,
                            textColor: cs.onPrimaryContainer,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(
            height: totalHeight,
            child: Row(
              children: [
                // 時間欄（左）
                SizedBox(
                  width: widget.timeLabelWidth,
                  child: _TimeColumn(
                    rows: widget.rows,
                    rowHeight: widget.rowHeight,
                    bgColor: cs.primaryContainer,
                    textColor: cs.onPrimaryContainer,
                  ),
                ),

                // 格子區（右）
                SizedBox(
                  width: rightWidth,
                  child: Column(
                    children: List.generate(widget.rows, (r) {
                      return SizedBox(
                        height: widget.rowHeight,
                        child: Row(
                          children: List.generate(widget.days, (d) {
                            final occupied = _isOccupied(r, d);
                            return SizedBox(
                              width: dayWidth,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (!occupied) {
                                      // 新增課程（示範）
                                      _addAt(r, d);
                                    }
                                  },
                                  onLongPress: () {
                                    if (occupied) {
                                      _removeAt(r, d);
                                    }
                                  },
                                  child: occupied
                                      ? _CourseCard(
                                    title: 'English',
                                    room: 'R101',
                                    color: cs.primary,
                                  )
                                      : _EmptyCell(
                                    borderColor: cs.onSurface.withValues(alpha: 0.25),
                                    radius: 8,
                                    dashWidth: 6,
                                    dashGap: 4,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

/// Header 單日 cell
class _HeaderCell extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _HeaderCell({
    Key? key,
    required this.label,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// 左側時間 column（每個 slot 的 decoration 與 header 一致）
class _TimeColumn extends StatelessWidget {
  final int rows;
  final double rowHeight;
  final Color bgColor;
  final Color textColor;

  const _TimeColumn({
    Key? key,
    required this.rows,
    required this.rowHeight,
    required this.bgColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(rows, (r) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
          child: Container(
            height: rowHeight - 12, // 扣掉 padding
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              'Slot ${r + 1}',
              style: TextStyle(color: textColor, fontSize: 12),
            ),
          ),
        );
      }),
    );
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

class _CourseCard extends StatelessWidget {
  final String title;
  final String room;
  final Color color;

  const _CourseCard({
    Key? key,
    required this.title,
    required this.room,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // 以主題色為背景並帶點圓角與陰影
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 1))],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
          const SizedBox(height: 4),
          Text(room, style: const TextStyle(color: Colors.white70, fontSize: 9)),
        ],
      ),
    );
  }
}

/// CustomPainter：沿著 roundRect 繪製 dashed path
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
