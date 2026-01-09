import 'package:flutter/material.dart';
import 'package:timegrid/models/course_model.dart';

/// 拖移的 payload（保留給非 overlay 狀態使用）
class DragPayload {
  final String courseId;
  const DragPayload(this.courseId);
}

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final bool editMode;
  final bool draggable;
  final VoidCallback? onTap;
  // 上/下 handle 的拖動回呼（把 dy 回傳給外層）
  final void Function(double dy)? onTopHandleDragUpdate;
  final VoidCallback? onTopHandleDragEnd;
  final void Function(double dy)? onBottomHandleDragUpdate;
  final VoidCallback? onBottomHandleDragEnd;

  const CourseCard({
    Key? key,
    required this.course,
    this.editMode = true,
    this.draggable = true,
    this.onTap,
    this.onTopHandleDragUpdate,
    this.onTopHandleDragEnd,
    this.onBottomHandleDragUpdate,
    this.onBottomHandleDragEnd,
  }) : super(key: key);

  // ===== 文字量測輔助 =====
  double _maxFontForSingleLine({
    required String text,
    required TextStyle baseStyle,
    required double maxWidth,
    required double minFont,
    required double maxFont,
    required TextDirection textDirection,
  }) {
    if (maxWidth <= 0) return minFont;
    double l = minFont, r = maxFont;
    for (int i = 0; i < 10; i++) {
      final mid = (l + r) / 2;
      final tp = TextPainter(
        text: TextSpan(text: text, style: baseStyle.copyWith(fontSize: mid)),
        textDirection: textDirection,
        maxLines: 2,
      )..layout(maxWidth: maxWidth);
      if (tp.didExceedMaxLines || tp.width > maxWidth) {
        r = mid;
      } else {
        l = mid;
      }
    }
    return l;
  }

  double _measureHeight({
    required String text,
    required TextStyle style,
    required double maxWidth,
    required int maxLines,
    required TextDirection textDirection,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: textDirection,
      maxLines: maxLines,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth);
    return tp.height;
  }

  Color _darken(Color color, [double amount = .15]) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  Widget _horizontalLine(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _darken(course.color),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildCardBody(BuildContext context) {
    const horizontalPadding = 6.0;
    const verticalPadding = 4.0;
    const innerSpacing = 4.0;
    const double lineHeight = 6.0;

    const double titleMaxFont = 13.0;
    const double titleMinFont = 10.0;
    const double roomMaxFont = 10.0;
    const double roomMinFont = 8.0;

    final int titleMaxLine = editMode ? 2 : course.duration + 1;
    const int roomMaxLine = 2;

    const double handleHitHeight = 40.0;

    final textDir = Directionality.of(context);
    final titleBase = DefaultTextStyle.of(context).style.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    final roomBase = DefaultTextStyle.of(context).style.copyWith(
      color: Colors.white70,
    );

    return LayoutBuilder(builder: (context, constraints) {
      final availW = (constraints.maxWidth - horizontalPadding * 2).clamp(0.0, double.infinity);
      final availH = (constraints.maxHeight - verticalPadding * 2).clamp(0.0, double.infinity);
      final contentAvailH = (availH - lineHeight * 2).clamp(0.0, double.infinity);

      final titleFontSingle = _maxFontForSingleLine(
        text: course.title,
        baseStyle: titleBase,
        maxWidth: availW,
        minFont: titleMinFont,
        maxFont: titleMaxFont,
        textDirection: textDir,
      );
      final roomFontSingle = _maxFontForSingleLine(
        text: course.room,
        baseStyle: roomBase,
        maxWidth: availW,
        minFont: roomMinFont,
        maxFont: roomMaxFont,
        textDirection: textDir,
      );

      final titleHeightSingle = _measureHeight(
        text: course.title,
        style: titleBase.copyWith(fontSize: titleFontSingle),
        maxWidth: availW,
        maxLines: titleMaxLine,
        textDirection: textDir,
      );
      final roomHeightSingle = _measureHeight(
        text: course.room,
        style: roomBase.copyWith(fontSize: roomFontSingle),
        maxWidth: availW,
        maxLines: roomMaxLine,
        textDirection: textDir,
      );
      final totalSingleHeight = titleHeightSingle + innerSpacing + roomHeightSingle;

      bool useSingleLine = totalSingleHeight <= contentAvailH + 0.001;

      double finalTitleFont = titleFontSingle;
      double finalRoomFont = roomFontSingle;
      if (!useSingleLine) {
        finalTitleFont = titleMinFont;
        finalRoomFont = roomMinFont;

        final titleHeightWrap = _measureHeight(
          text: course.title,
          style: titleBase.copyWith(fontSize: finalTitleFont),
          maxWidth: availW,
          maxLines: titleMaxLine,
          textDirection: textDir,
        );
        final roomHeightWrap = _measureHeight(
          text: course.room,
          style: roomBase.copyWith(fontSize: finalRoomFont),
          maxWidth: availW,
          maxLines: roomMaxLine,
          textDirection: textDir,
        );
      }

      final cardCore = Container(
        constraints: BoxConstraints.tightFor(width: constraints.maxWidth, height: constraints.maxHeight),
        decoration: BoxDecoration(
          color: course.color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 1))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (editMode)
              Align(
                alignment: Alignment.center,
                child: _horizontalLine(40, lineHeight),
              ),

            // Course Title & Room
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: availW),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: titleBase.copyWith(fontSize: useSingleLine ? titleFontSingle : finalTitleFont),
                        maxLines: titleMaxLine,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: innerSpacing),
                      if (!editMode)
                        Text(
                          course.room,
                          style: roomBase.copyWith(fontSize: useSingleLine ? roomFontSingle : finalRoomFont),
                          maxLines: roomMaxLine,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
            ),

            if (editMode)
              Align(
                alignment: Alignment.center,
                child: _horizontalLine(40, lineHeight),
              )
          ],
        ),
      );

      return Stack(
        clipBehavior: Clip.none,
        children: [
          cardCore,
          if (editMode)
            Positioned(
              top: 0, left: 0, right: 0, height:handleHitHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragStart: (_) {
                },
                onVerticalDragUpdate: (d) {
                  if (onTopHandleDragUpdate != null) onTopHandleDragUpdate!(d.delta.dy);
                },
                onVerticalDragEnd: (_) {
                  if (onTopHandleDragEnd != null) onTopHandleDragEnd!();
                },
              ),
            ),

          if (editMode)
            Positioned(
              bottom: 0, left: 0, right: 0, height:handleHitHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragStart: (_) {
                },
                onVerticalDragUpdate: (d) {
                  if(onBottomHandleDragUpdate != null) onBottomHandleDragUpdate!(d.delta.dy);
                },
                onVerticalDragEnd: (_) {
                  if (onBottomHandleDragEnd != null) onBottomHandleDragEnd!();
                },
              ),
            ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = _buildCardBody(context);

    // overlay（拖拉預覽）時：draggable=false，直接回傳 body
    if (!editMode || !draggable) return body;

    // 一般模式：長按才可拖移（讓點一下仍可觸發 onTap 等）
    return LongPressDraggable<DragPayload>(
      data: DragPayload(course.id),
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(width: 120, height: 64, child: body),
      ),
      childWhenDragging: Opacity(opacity: 0.25, child: body),
      child: GestureDetector(onTap: onTap, child: body),
    );
  }
}