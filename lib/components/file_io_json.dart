import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timegrid/models/course_model.dart';
import 'package:timegrid/models/course_chips_model.dart';

final ValueNotifier<int> importNotifier = ValueNotifier<int>(0);

String _generateExportJson() {
  final coursesBox = Hive.box<CourseModel>('courses_box');
  final chipsBox = Hive.box<CourseChipsModel>('chips_box');

  final courses = coursesBox.values.map((c) => c.toJson()).toList();
  final chips = chipsBox.values.map((c) => c.toJson()).toList();
  final map = {
    'courses' : courses,
    'chips' : chips,
    'exported_at': DateTime.now().toIso8601String(),
  };

  return const JsonEncoder.withIndent('    ').convert(map);
}

Future<void> exportJsonToSystemShare(BuildContext context) async {
  try {
    final jsonStr = _generateExportJson();
    final tmp = await getTemporaryDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final filename = 'timegrid_export_$timestamp.json';
    final file = File('${tmp.path}/$filename');

    await file.writeAsString(jsonStr);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'TimeGrid export',
      )
    );
    if(!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export prepared: $filename'))
    );
  } catch (e) {
    if(!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export failed: $e'))
    );
  }
}

Future<void> importJsonFromSystemFile(
    BuildContext context, {
    VoidCallback? onImport,
}) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: false,
    );
    if (!context.mounted) return;
    if (result == null || result.files.isEmpty) return;

    final path = result.files.single.path;

    if (path == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot get file path')));
      return;
    }

    final file = File(path);
    final content = await file.readAsString();
    final res = await _importDataFromJsonString(content);

    try {
      onImport?.call();
    } catch (e) {
      debugPrint('onImported callback error: $e');
    }

    importNotifier.value++;
    if(!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Imported ${res['courses']} courses, ${res['chips']} chips')),
    );
  } catch (e) {
    if(!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Import failed: $e')),
    );
  }
}

Future<Map<String, int>> _importDataFromJsonString(String jsonStr) async {
  final dynamic decoded = jsonDecode(jsonStr);
  final coursesBox = Hive.box<CourseModel>('courses_box');
  final chipsBox = Hive.box<CourseChipsModel>('chips_box');

  coursesBox.clear();
  chipsBox.clear();

  int coursesCount = 0;
  int chipsCount = 0;

  if (decoded is Map) {
    if (decoded.containsKey('courses')) {
      final list = decoded['courses'] as List<dynamic>;
      for(final item in list) {
        final m = Map<String, dynamic>.from(item as Map);
        final course = CourseModel.fromJson(m);
        await coursesBox.put(course.id, course);
        debugPrint('course: ${course.toJson()}');
        coursesCount++;
      }
    }
    if (decoded.containsKey('chips')) {
      final list = decoded['chips'] as List<dynamic>;
      for (final item in list) {
        final m = Map<String, dynamic>.from(item as Map);
        final chip = CourseChipsModel.fromJson(m);
        await chipsBox.put(chip.id, chip);
        chipsCount++;
      }
    }
  } else if (decoded is List) {
    for(final item in decoded) {
      final m = Map<String, dynamic>.from(item as Map);
      final course = CourseModel.fromJson(m);
      await coursesBox.put(course.id, course);
      coursesCount++;
    }
  } else {
    throw const FormatException('Unsupported JSON format');
  }

  return {'courses': coursesCount, 'chips': chipsCount};
}