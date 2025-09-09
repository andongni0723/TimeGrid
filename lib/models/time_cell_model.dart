import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timegrid/models/type_converter.dart';

part 'time_cell_model.freezed.dart';
part 'time_cell_model.g.dart';

@freezed
abstract class TimeCellModel with _$TimeCellModel {
  const factory TimeCellModel({
    required String displayName,
    @TimeOfDayConverter() required TimeOfDay startTime,
    @TimeOfDayConverter() required TimeOfDay endTime,
  }) = _TimeCellModel;

  factory TimeCellModel.fromJson(Map<String, dynamic> json) => _$TimeCellModelFromJson(json);
}