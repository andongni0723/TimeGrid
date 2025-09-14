import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timegrid/models/type_converter.dart';

part 'course_widget_model.freezed.dart';
part 'course_widget_model.g.dart';

@freezed
abstract class CourseWidgetModel with _$CourseWidgetModel {
  const factory CourseWidgetModel({
    required String title,
    required String room,
    @ColorConverter() required Color color,
    required int weekday, // 1 (Mon) to 7 (Sun)
    @TimeOfDayConverter() required TimeOfDay startTime,
    @TimeOfDayConverter() required TimeOfDay endTime,
  }) = _CourseWidgetModel;

  factory CourseWidgetModel.fromJson(Map<String, dynamic> json) => _$CourseWidgetModelFromJson(json);
}