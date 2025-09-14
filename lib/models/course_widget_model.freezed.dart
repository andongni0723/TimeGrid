// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_widget_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseWidgetModel {
  String get title;
  String get room;
  @ColorConverter()
  Color get color;
  int get weekday; // 1 (Mon) to 7 (Sun)
  @TimeOfDayConverter()
  TimeOfDay get startTime;
  @TimeOfDayConverter()
  TimeOfDay get endTime;

  /// Create a copy of CourseWidgetModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CourseWidgetModelCopyWith<CourseWidgetModel> get copyWith =>
      _$CourseWidgetModelCopyWithImpl<CourseWidgetModel>(
          this as CourseWidgetModel, _$identity);

  /// Serializes this CourseWidgetModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CourseWidgetModel &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.room, room) || other.room == room) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.weekday, weekday) || other.weekday == weekday) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, room, color, weekday, startTime, endTime);

  @override
  String toString() {
    return 'CourseWidgetModel(title: $title, room: $room, color: $color, weekday: $weekday, startTime: $startTime, endTime: $endTime)';
  }
}

/// @nodoc
abstract mixin class $CourseWidgetModelCopyWith<$Res> {
  factory $CourseWidgetModelCopyWith(
          CourseWidgetModel value, $Res Function(CourseWidgetModel) _then) =
      _$CourseWidgetModelCopyWithImpl;
  @useResult
  $Res call(
      {String title,
      String room,
      @ColorConverter() Color color,
      int weekday,
      @TimeOfDayConverter() TimeOfDay startTime,
      @TimeOfDayConverter() TimeOfDay endTime});
}

/// @nodoc
class _$CourseWidgetModelCopyWithImpl<$Res>
    implements $CourseWidgetModelCopyWith<$Res> {
  _$CourseWidgetModelCopyWithImpl(this._self, this._then);

  final CourseWidgetModel _self;
  final $Res Function(CourseWidgetModel) _then;

  /// Create a copy of CourseWidgetModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? room = null,
    Object? color = null,
    Object? weekday = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      room: null == room
          ? _self.room
          : room // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      weekday: null == weekday
          ? _self.weekday
          : weekday // ignore: cast_nullable_to_non_nullable
              as int,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      endTime: null == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
    ));
  }
}

/// Adds pattern-matching-related methods to [CourseWidgetModel].
extension CourseWidgetModelPatterns on CourseWidgetModel {
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
    TResult Function(_CourseWidgetModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CourseWidgetModel() when $default != null:
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
    TResult Function(_CourseWidgetModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseWidgetModel():
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
    TResult? Function(_CourseWidgetModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseWidgetModel() when $default != null:
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
    TResult Function(
            String title,
            String room,
            @ColorConverter() Color color,
            int weekday,
            @TimeOfDayConverter() TimeOfDay startTime,
            @TimeOfDayConverter() TimeOfDay endTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CourseWidgetModel() when $default != null:
        return $default(_that.title, _that.room, _that.color, _that.weekday,
            _that.startTime, _that.endTime);
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
    TResult Function(
            String title,
            String room,
            @ColorConverter() Color color,
            int weekday,
            @TimeOfDayConverter() TimeOfDay startTime,
            @TimeOfDayConverter() TimeOfDay endTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseWidgetModel():
        return $default(_that.title, _that.room, _that.color, _that.weekday,
            _that.startTime, _that.endTime);
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
    TResult? Function(
            String title,
            String room,
            @ColorConverter() Color color,
            int weekday,
            @TimeOfDayConverter() TimeOfDay startTime,
            @TimeOfDayConverter() TimeOfDay endTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseWidgetModel() when $default != null:
        return $default(_that.title, _that.room, _that.color, _that.weekday,
            _that.startTime, _that.endTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CourseWidgetModel implements CourseWidgetModel {
  const _CourseWidgetModel(
      {required this.title,
      required this.room,
      @ColorConverter() required this.color,
      required this.weekday,
      @TimeOfDayConverter() required this.startTime,
      @TimeOfDayConverter() required this.endTime});
  factory _CourseWidgetModel.fromJson(Map<String, dynamic> json) =>
      _$CourseWidgetModelFromJson(json);

  @override
  final String title;
  @override
  final String room;
  @override
  @ColorConverter()
  final Color color;
  @override
  final int weekday;
// 1 (Mon) to 7 (Sun)
  @override
  @TimeOfDayConverter()
  final TimeOfDay startTime;
  @override
  @TimeOfDayConverter()
  final TimeOfDay endTime;

  /// Create a copy of CourseWidgetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CourseWidgetModelCopyWith<_CourseWidgetModel> get copyWith =>
      __$CourseWidgetModelCopyWithImpl<_CourseWidgetModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CourseWidgetModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CourseWidgetModel &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.room, room) || other.room == room) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.weekday, weekday) || other.weekday == weekday) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, room, color, weekday, startTime, endTime);

  @override
  String toString() {
    return 'CourseWidgetModel(title: $title, room: $room, color: $color, weekday: $weekday, startTime: $startTime, endTime: $endTime)';
  }
}

/// @nodoc
abstract mixin class _$CourseWidgetModelCopyWith<$Res>
    implements $CourseWidgetModelCopyWith<$Res> {
  factory _$CourseWidgetModelCopyWith(
          _CourseWidgetModel value, $Res Function(_CourseWidgetModel) _then) =
      __$CourseWidgetModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String title,
      String room,
      @ColorConverter() Color color,
      int weekday,
      @TimeOfDayConverter() TimeOfDay startTime,
      @TimeOfDayConverter() TimeOfDay endTime});
}

/// @nodoc
class __$CourseWidgetModelCopyWithImpl<$Res>
    implements _$CourseWidgetModelCopyWith<$Res> {
  __$CourseWidgetModelCopyWithImpl(this._self, this._then);

  final _CourseWidgetModel _self;
  final $Res Function(_CourseWidgetModel) _then;

  /// Create a copy of CourseWidgetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
    Object? room = null,
    Object? color = null,
    Object? weekday = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_CourseWidgetModel(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      room: null == room
          ? _self.room
          : room // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      weekday: null == weekday
          ? _self.weekday
          : weekday // ignore: cast_nullable_to_non_nullable
              as int,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      endTime: null == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
    ));
  }
}

// dart format on
