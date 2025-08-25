// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => _CourseModel(
      id: json['id'] as String,
      day: (json['day'] as num).toInt(),
      row: (json['row'] as num).toInt(),
      duration: (json['duration'] as num?)?.toInt() ?? 1,
      title: json['title'] as String,
      room: json['room'] as String,
      color: const ColorConverter().fromJson((json['color'] as num).toInt()),
    );

Map<String, dynamic> _$CourseModelToJson(_CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'day': instance.day,
      'row': instance.row,
      'duration': instance.duration,
      'title': instance.title,
      'room': instance.room,
      'color': const ColorConverter().toJson(instance.color),
    };
