// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_cell_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeCellModel {
  String get displayName;
  @TimeOfDayConverter()
  TimeOfDay get startTime;
  @TimeOfDayConverter()
  TimeOfDay get endTime;
  bool get showStartTime;
  bool get showEndTime;

  /// Create a copy of TimeCellModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimeCellModelCopyWith<TimeCellModel> get copyWith =>
      _$TimeCellModelCopyWithImpl<TimeCellModel>(
          this as TimeCellModel, _$identity);

  /// Serializes this TimeCellModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimeCellModel &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.showStartTime, showStartTime) ||
                other.showStartTime == showStartTime) &&
            (identical(other.showEndTime, showEndTime) ||
                other.showEndTime == showEndTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, displayName, startTime, endTime, showStartTime, showEndTime);

  @override
  String toString() {
    return 'TimeCellModel(displayName: $displayName, startTime: $startTime, endTime: $endTime, showStartTime: $showStartTime, showEndTime: $showEndTime)';
  }
}

/// @nodoc
abstract mixin class $TimeCellModelCopyWith<$Res> {
  factory $TimeCellModelCopyWith(
          TimeCellModel value, $Res Function(TimeCellModel) _then) =
      _$TimeCellModelCopyWithImpl;
  @useResult
  $Res call(
      {String displayName,
      @TimeOfDayConverter() TimeOfDay startTime,
      @TimeOfDayConverter() TimeOfDay endTime,
      bool showStartTime,
      bool showEndTime});
}

/// @nodoc
class _$TimeCellModelCopyWithImpl<$Res>
    implements $TimeCellModelCopyWith<$Res> {
  _$TimeCellModelCopyWithImpl(this._self, this._then);

  final TimeCellModel _self;
  final $Res Function(TimeCellModel) _then;

  /// Create a copy of TimeCellModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? showStartTime = null,
    Object? showEndTime = null,
  }) {
    return _then(_self.copyWith(
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      endTime: null == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      showStartTime: null == showStartTime
          ? _self.showStartTime
          : showStartTime // ignore: cast_nullable_to_non_nullable
              as bool,
      showEndTime: null == showEndTime
          ? _self.showEndTime
          : showEndTime // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [TimeCellModel].
extension TimeCellModelPatterns on TimeCellModel {
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
    TResult Function(_TimeCellModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TimeCellModel() when $default != null:
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
    TResult Function(_TimeCellModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimeCellModel():
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
    TResult? Function(_TimeCellModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimeCellModel() when $default != null:
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
            String displayName,
            @TimeOfDayConverter() TimeOfDay startTime,
            @TimeOfDayConverter() TimeOfDay endTime,
            bool showStartTime,
            bool showEndTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TimeCellModel() when $default != null:
        return $default(_that.displayName, _that.startTime, _that.endTime,
            _that.showStartTime, _that.showEndTime);
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
            String displayName,
            @TimeOfDayConverter() TimeOfDay startTime,
            @TimeOfDayConverter() TimeOfDay endTime,
            bool showStartTime,
            bool showEndTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimeCellModel():
        return $default(_that.displayName, _that.startTime, _that.endTime,
            _that.showStartTime, _that.showEndTime);
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
            String displayName,
            @TimeOfDayConverter() TimeOfDay startTime,
            @TimeOfDayConverter() TimeOfDay endTime,
            bool showStartTime,
            bool showEndTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TimeCellModel() when $default != null:
        return $default(_that.displayName, _that.startTime, _that.endTime,
            _that.showStartTime, _that.showEndTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TimeCellModel implements TimeCellModel {
  const _TimeCellModel(
      {required this.displayName,
      @TimeOfDayConverter() required this.startTime,
      @TimeOfDayConverter() required this.endTime,
      required this.showStartTime,
      required this.showEndTime});
  factory _TimeCellModel.fromJson(Map<String, dynamic> json) =>
      _$TimeCellModelFromJson(json);

  @override
  final String displayName;
  @override
  @TimeOfDayConverter()
  final TimeOfDay startTime;
  @override
  @TimeOfDayConverter()
  final TimeOfDay endTime;
  @override
  final bool showStartTime;
  @override
  final bool showEndTime;

  /// Create a copy of TimeCellModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TimeCellModelCopyWith<_TimeCellModel> get copyWith =>
      __$TimeCellModelCopyWithImpl<_TimeCellModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TimeCellModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TimeCellModel &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.showStartTime, showStartTime) ||
                other.showStartTime == showStartTime) &&
            (identical(other.showEndTime, showEndTime) ||
                other.showEndTime == showEndTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, displayName, startTime, endTime, showStartTime, showEndTime);

  @override
  String toString() {
    return 'TimeCellModel(displayName: $displayName, startTime: $startTime, endTime: $endTime, showStartTime: $showStartTime, showEndTime: $showEndTime)';
  }
}

/// @nodoc
abstract mixin class _$TimeCellModelCopyWith<$Res>
    implements $TimeCellModelCopyWith<$Res> {
  factory _$TimeCellModelCopyWith(
          _TimeCellModel value, $Res Function(_TimeCellModel) _then) =
      __$TimeCellModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String displayName,
      @TimeOfDayConverter() TimeOfDay startTime,
      @TimeOfDayConverter() TimeOfDay endTime,
      bool showStartTime,
      bool showEndTime});
}

/// @nodoc
class __$TimeCellModelCopyWithImpl<$Res>
    implements _$TimeCellModelCopyWith<$Res> {
  __$TimeCellModelCopyWithImpl(this._self, this._then);

  final _TimeCellModel _self;
  final $Res Function(_TimeCellModel) _then;

  /// Create a copy of TimeCellModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? displayName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? showStartTime = null,
    Object? showEndTime = null,
  }) {
    return _then(_TimeCellModel(
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      endTime: null == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      showStartTime: null == showStartTime
          ? _self.showStartTime
          : showStartTime // ignore: cast_nullable_to_non_nullable
              as bool,
      showEndTime: null == showEndTime
          ? _self.showEndTime
          : showEndTime // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
