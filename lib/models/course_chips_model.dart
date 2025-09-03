import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'type_converter.dart';

part 'course_chips_model.freezed.dart';
part 'course_chips_model.g.dart';

@freezed
abstract class CourseChipsModel with _$CourseChipsModel {
  const factory CourseChipsModel({
    required String id,
    required String title,
    @ColorConverter() required Color color,
  }) = _CourseChipsModel;

  factory CourseChipsModel.fromJson(Map<String, dynamic> json) => _$CourseChipsModelFromJson(json);
}