import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();
  @override
  Color fromJson(int json) => Color(json);
  @override
  int toJson(Color color) => color.toARGB32();
}

class TimeOfDayConverter implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) {
    final hour = json['hour'] as int? ?? 0;
    final minute = json['minute'] as int? ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay object) => {
    'hour': object.hour,
    'minute': object.minute,
  };
}