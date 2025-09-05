import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'type_converter.dart';

part 'course_chips_model.freezed.dart';
part 'course_chips_model.g.dart';

@freezed
abstract class CourseChipsModel with _$CourseChipsModel {
  const factory CourseChipsModel({
    required String id,
    required String title,
    required String room,
    @ColorConverter() required Color color,
  }) = _CourseChipsModel;

  factory CourseChipsModel.fromJson(Map<String, dynamic> json) => _$CourseChipsModelFromJson(json);
}

class CourseChipsModelAdapter extends TypeAdapter<CourseChipsModel> {
  @override
  final int typeId = 1;

  @override
  CourseChipsModel read(BinaryReader reader) {
    final jsonStr = reader.readString();
    final Map<String, dynamic> map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return CourseChipsModel.fromJson(map);
  }

  @override
  void write(BinaryWriter writer, CourseChipsModel obj) {
    final map = obj.toJson();
    writer.writeString(jsonEncode(map));
  }
}