import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:timegrid/models/type_converter.dart';

part 'time_cell_model.freezed.dart';
part 'time_cell_model.g.dart';

@freezed
abstract class TimeCellModel with _$TimeCellModel {
  const factory TimeCellModel({
    required String id,
    required String displayName,
    @TimeOfDayConverter() required TimeOfDay startTime,
    @TimeOfDayConverter() required TimeOfDay endTime,
    required bool showStartTime,
    required bool showEndTime,
  }) = _TimeCellModel;

  factory TimeCellModel.fromJson(Map<String, dynamic> json) => _$TimeCellModelFromJson(json);
}

extension TimeOfDayFormatting on TimeOfDay {
  String format24Hour() =>
      '${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}';
}


class TimeCellModelAdapter extends TypeAdapter<TimeCellModel> {
  @override
  final int typeId = 2;

  @override
  TimeCellModel read(BinaryReader reader) {
    final jsonStr = reader.readString();
    final Map<String, dynamic> map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return TimeCellModel.fromJson(map);
  }

  @override
  void write(BinaryWriter writer, TimeCellModel obj) {
    final map = obj.toJson();
    writer.writeString(jsonEncode(map));
  }
}