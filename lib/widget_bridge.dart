import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timegrid/models/time_cell_model.dart';
import 'package:timegrid/provider.dart';

import 'models/course_model.dart';

const _ch = MethodChannel('com.andongni.timegrid/widget');

Future<void> pushWidgetCourse(WidgetRef ref) async {
  final storage = ref.read(storageProvider);
  final List<dynamic> allCourses = storage.getAllCourses();
  final List<dynamic> allTimeCells = storage.getAllTimeCells();
  final cells = allTimeCells.cast<TimeCellModel>();
  cells.sort((a, b) {
    int ai = int.parse(a.id.toString());
    int bi = int.parse(b.id.toString());
    return ai.compareTo(bi);
  });

  debugPrint('allTimeCells:');
  cells.forEach((obj) => debugPrint(obj.toString()));

  String colorToHex(Color c) =>
    '#${c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

  final list = <Map<String, dynamic>>[];

  for (final dynamic v in allCourses) {
    final c = v as CourseModel;

    // skip invalid course
    if (c.row < 0 || c.row >= cells.length) {
      debugPrint('skip invalid course: ${c.toJson()}');
      continue;
    }

    final int startIdx = c.row.clamp(0, cells.length - 1);
    final int endIdx = (c.row + c.duration - 1).clamp(0, cells.length - 1);

    final start = cells[startIdx].startTime;
    final end = cells[endIdx].endTime;

    list.add({
      'title': c.title,
      'room': c.room,
      'color': colorToHex(c.color),
      'weekday': c.day,
      'start': start.format24Hour(),
      'end': end.format24Hour(),
    });
  }

  final payload = jsonEncode({'courses': list});
  await _ch.invokeMethod('updateCourseList', {'json': payload});
}

Future<void> startWidgetAutoTick() => _ch.invokeMethod('schedulePeriodicTick');
Future<void> stopWidgetAutoTick() => _ch.invokeMethod('cancelPeriodicTick');