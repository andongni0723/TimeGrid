// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_overlay.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActiveOverlay {
  String get id;
  int get day;
  int get row;
  int get duration;
  double get left;
  double get top;
  double get width;
  double get height;

  /// Create a copy of ActiveOverlay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActiveOverlayCopyWith<ActiveOverlay> get copyWith =>
      _$ActiveOverlayCopyWithImpl<ActiveOverlay>(
          this as ActiveOverlay, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActiveOverlay &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.row, row) || other.row == row) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.left, left) || other.left == left) &&
            (identical(other.top, top) || other.top == top) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, day, row, duration, left, top, width, height);
}

/// @nodoc
abstract mixin class $ActiveOverlayCopyWith<$Res> {
  factory $ActiveOverlayCopyWith(
          ActiveOverlay value, $Res Function(ActiveOverlay) _then) =
      _$ActiveOverlayCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      int day,
      int row,
      int duration,
      double left,
      double top,
      double width,
      double height});
}

/// @nodoc
class _$ActiveOverlayCopyWithImpl<$Res>
    implements $ActiveOverlayCopyWith<$Res> {
  _$ActiveOverlayCopyWithImpl(this._self, this._then);

  final ActiveOverlay _self;
  final $Res Function(ActiveOverlay) _then;

  /// Create a copy of ActiveOverlay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? day = null,
    Object? row = null,
    Object? duration = null,
    Object? left = null,
    Object? top = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      day: null == day
          ? _self.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
      row: null == row
          ? _self.row
          : row // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      left: null == left
          ? _self.left
          : left // ignore: cast_nullable_to_non_nullable
              as double,
      top: null == top
          ? _self.top
          : top // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ActiveOverlay].
extension ActiveOverlayPatterns on ActiveOverlay {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ActiveOverlay value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActiveOverlay() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ActiveOverlay value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActiveOverlay():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ActiveOverlay value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActiveOverlay() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, int day, int row, int duration, double left,
            double top, double width, double height)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActiveOverlay() when $default != null:
        return $default(_that.id, _that.day, _that.row, _that.duration,
            _that.left, _that.top, _that.width, _that.height);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, int day, int row, int duration, double left,
            double top, double width, double height)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActiveOverlay():
        return $default(_that.id, _that.day, _that.row, _that.duration,
            _that.left, _that.top, _that.width, _that.height);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, int day, int row, int duration, double left,
            double top, double width, double height)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActiveOverlay() when $default != null:
        return $default(_that.id, _that.day, _that.row, _that.duration,
            _that.left, _that.top, _that.width, _that.height);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ActiveOverlay extends ActiveOverlay {
  const _ActiveOverlay(
      {required this.id,
      required this.day,
      required this.row,
      required this.duration,
      required this.left,
      required this.top,
      required this.width,
      required this.height})
      : super._();

  @override
  final String id;
  @override
  final int day;
  @override
  final int row;
  @override
  final int duration;
  @override
  final double left;
  @override
  final double top;
  @override
  final double width;
  @override
  final double height;

  /// Create a copy of ActiveOverlay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActiveOverlayCopyWith<_ActiveOverlay> get copyWith =>
      __$ActiveOverlayCopyWithImpl<_ActiveOverlay>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActiveOverlay &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.row, row) || other.row == row) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.left, left) || other.left == left) &&
            (identical(other.top, top) || other.top == top) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, day, row, duration, left, top, width, height);
}

/// @nodoc
abstract mixin class _$ActiveOverlayCopyWith<$Res>
    implements $ActiveOverlayCopyWith<$Res> {
  factory _$ActiveOverlayCopyWith(
          _ActiveOverlay value, $Res Function(_ActiveOverlay) _then) =
      __$ActiveOverlayCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      int day,
      int row,
      int duration,
      double left,
      double top,
      double width,
      double height});
}

/// @nodoc
class __$ActiveOverlayCopyWithImpl<$Res>
    implements _$ActiveOverlayCopyWith<$Res> {
  __$ActiveOverlayCopyWithImpl(this._self, this._then);

  final _ActiveOverlay _self;
  final $Res Function(_ActiveOverlay) _then;

  /// Create a copy of ActiveOverlay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? day = null,
    Object? row = null,
    Object? duration = null,
    Object? left = null,
    Object? top = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_ActiveOverlay(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      day: null == day
          ? _self.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
      row: null == row
          ? _self.row
          : row // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      left: null == left
          ? _self.left
          : left // ignore: cast_nullable_to_non_nullable
              as double,
      top: null == top
          ? _self.top
          : top // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
