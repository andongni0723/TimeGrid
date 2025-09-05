// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_chips_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseChipsModel {
  String get id;
  String get title;
  String get room;
  @ColorConverter()
  Color get color;

  /// Create a copy of CourseChipsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CourseChipsModelCopyWith<CourseChipsModel> get copyWith =>
      _$CourseChipsModelCopyWithImpl<CourseChipsModel>(
          this as CourseChipsModel, _$identity);

  /// Serializes this CourseChipsModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CourseChipsModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.room, room) || other.room == room) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, room, color);

  @override
  String toString() {
    return 'CourseChipsModel(id: $id, title: $title, room: $room, color: $color)';
  }
}

/// @nodoc
abstract mixin class $CourseChipsModelCopyWith<$Res> {
  factory $CourseChipsModelCopyWith(
          CourseChipsModel value, $Res Function(CourseChipsModel) _then) =
      _$CourseChipsModelCopyWithImpl;
  @useResult
  $Res call(
      {String id, String title, String room, @ColorConverter() Color color});
}

/// @nodoc
class _$CourseChipsModelCopyWithImpl<$Res>
    implements $CourseChipsModelCopyWith<$Res> {
  _$CourseChipsModelCopyWithImpl(this._self, this._then);

  final CourseChipsModel _self;
  final $Res Function(CourseChipsModel) _then;

  /// Create a copy of CourseChipsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? room = null,
    Object? color = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [CourseChipsModel].
extension CourseChipsModelPatterns on CourseChipsModel {
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
    TResult Function(_CourseChipsModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CourseChipsModel() when $default != null:
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
    TResult Function(_CourseChipsModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseChipsModel():
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
    TResult? Function(_CourseChipsModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseChipsModel() when $default != null:
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
    TResult Function(String id, String title, String room,
            @ColorConverter() Color color)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CourseChipsModel() when $default != null:
        return $default(_that.id, _that.title, _that.room, _that.color);
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
            String id, String title, String room, @ColorConverter() Color color)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseChipsModel():
        return $default(_that.id, _that.title, _that.room, _that.color);
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
    TResult? Function(String id, String title, String room,
            @ColorConverter() Color color)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourseChipsModel() when $default != null:
        return $default(_that.id, _that.title, _that.room, _that.color);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CourseChipsModel implements CourseChipsModel {
  const _CourseChipsModel(
      {required this.id,
      required this.title,
      required this.room,
      @ColorConverter() required this.color});
  factory _CourseChipsModel.fromJson(Map<String, dynamic> json) =>
      _$CourseChipsModelFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String room;
  @override
  @ColorConverter()
  final Color color;

  /// Create a copy of CourseChipsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CourseChipsModelCopyWith<_CourseChipsModel> get copyWith =>
      __$CourseChipsModelCopyWithImpl<_CourseChipsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CourseChipsModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CourseChipsModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.room, room) || other.room == room) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, room, color);

  @override
  String toString() {
    return 'CourseChipsModel(id: $id, title: $title, room: $room, color: $color)';
  }
}

/// @nodoc
abstract mixin class _$CourseChipsModelCopyWith<$Res>
    implements $CourseChipsModelCopyWith<$Res> {
  factory _$CourseChipsModelCopyWith(
          _CourseChipsModel value, $Res Function(_CourseChipsModel) _then) =
      __$CourseChipsModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id, String title, String room, @ColorConverter() Color color});
}

/// @nodoc
class __$CourseChipsModelCopyWithImpl<$Res>
    implements _$CourseChipsModelCopyWith<$Res> {
  __$CourseChipsModelCopyWithImpl(this._self, this._then);

  final _CourseChipsModel _self;
  final $Res Function(_CourseChipsModel) _then;

  /// Create a copy of CourseChipsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? room = null,
    Object? color = null,
  }) {
    return _then(_CourseChipsModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

// dart format on
