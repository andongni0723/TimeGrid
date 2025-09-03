// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_chips_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseChipsModel _$CourseChipsModelFromJson(Map<String, dynamic> json) =>
    _CourseChipsModel(
      id: json['id'] as String,
      title: json['title'] as String,
      color: const ColorConverter().fromJson((json['color'] as num).toInt()),
    );

Map<String, dynamic> _$CourseChipsModelToJson(_CourseChipsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'color': const ColorConverter().toJson(instance.color),
    };
