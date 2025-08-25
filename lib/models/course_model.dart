import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'type_converter.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

@freezed
abstract class CourseModel with _$CourseModel {
  const factory CourseModel({
    required String id,
    required int day,
    required int row,
    @Default(1) int duration,

    // Display Detail
    required String title,
    required String room,
    @ColorConverter() required Color color,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) => _$CourseModelFromJson(json);
}