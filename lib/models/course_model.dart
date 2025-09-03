import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
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

class CourseModelAdapter extends TypeAdapter<CourseModel> {
  @override
  final int typeId = 0;

  @override
  CourseModel read(BinaryReader reader) {
    final jsonStr = reader.readString();
    final Map<String, dynamic> map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return CourseModel.fromJson(map);
  }

  @override
  void write(BinaryWriter writer, CourseModel obj) {
    final map = obj.toJson();
    writer.writeString(jsonEncode(map));
  }
}