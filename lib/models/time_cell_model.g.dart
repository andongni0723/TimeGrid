// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_cell_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeCellModel _$TimeCellModelFromJson(Map<String, dynamic> json) =>
    _TimeCellModel(
      displayName: json['displayName'] as String,
      startTime: const TimeOfDayConverter()
          .fromJson(json['startTime'] as Map<String, dynamic>),
      endTime: const TimeOfDayConverter()
          .fromJson(json['endTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimeCellModelToJson(_TimeCellModel instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'startTime': const TimeOfDayConverter().toJson(instance.startTime),
      'endTime': const TimeOfDayConverter().toJson(instance.endTime),
    };
