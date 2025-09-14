// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_widget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseWidgetModel _$CourseWidgetModelFromJson(Map<String, dynamic> json) =>
    _CourseWidgetModel(
      title: json['title'] as String,
      room: json['room'] as String,
      color: const ColorConverter().fromJson((json['color'] as num).toInt()),
      weekday: (json['weekday'] as num).toInt(),
      startTime: const TimeOfDayConverter()
          .fromJson(json['startTime'] as Map<String, dynamic>),
      endTime: const TimeOfDayConverter()
          .fromJson(json['endTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseWidgetModelToJson(_CourseWidgetModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'room': instance.room,
      'color': const ColorConverter().toJson(instance.color),
      'weekday': instance.weekday,
      'startTime': const TimeOfDayConverter().toJson(instance.startTime),
      'endTime': const TimeOfDayConverter().toJson(instance.endTime),
    };
