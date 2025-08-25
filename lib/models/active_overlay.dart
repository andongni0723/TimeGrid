import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_overlay.freezed.dart';

@freezed
abstract class ActiveOverlay with _$ActiveOverlay {
  const factory ActiveOverlay({
    required String id,
    required int day,
    required int row,
    required int duration,
    required double left,
    required double top,
    required double width,
    required double height,
  }) = _ActiveOverlay;

  const ActiveOverlay._();

  ActiveOverlay moveBy({double dx = 0.0, double dy = 0.0}) =>
      copyWith(left: left + dx, top: top + dy);

  ActiveOverlay moveTo({required double left, required double right}) =>
      copyWith(left: left, top: top);

  ActiveOverlay withSize({double? width, double? height}) =>
      copyWith(width: width ?? this.width, height: height ?? this.height);

  ActiveOverlay translateTop(double dy) => copyWith(top: top + dy);

  ActiveOverlay translateHeight(double dh) => copyWith(height: height + dh);

  Rect get rect => Rect.fromLTWH(left, top, width, height);

  @override
  String toString() {
    return 'ActiveOverlay(id:$id, day:$day, row:$row, dur:$duration, left:${left.toStringAsFixed(1)}, top:${top.toStringAsFixed(1)}, w:${width.toStringAsFixed(1)}, h:${height.toStringAsFixed(1)})';
  }
}