import 'package:hive/hive.dart';
import 'package:timegrid/models/course_chips_model.dart';
import 'package:timegrid/models/course_model.dart';

class Boxes {
  static const String courses = 'courses_box';
  static const String chips = 'chips_box';
  static const String settings = 'settings_box';
}

class StorageService {
  final Box<CourseModel> _coursesBox;
  final Box<CourseChipsModel> _chipsBox;
  final Box _settingsBox;

  StorageService._(this._coursesBox, this._chipsBox, this._settingsBox);

  static Future<StorageService> create() async {
    final coursesBox = await Hive.openBox<CourseModel>(Boxes.courses);
    final chipsBox = await Hive.openBox<CourseChipsModel>(Boxes.chips);
    final settingsBox = await Hive.openBox(Boxes.settings);
    return StorageService._(coursesBox, chipsBox, settingsBox);
  }

  // courses
  List<CourseModel> getAllCourses() => _coursesBox.values.toList();
  CourseModel? getCourse(String id) => _coursesBox.get(id);
  Future<void> putCourse(CourseModel course) => _coursesBox.put(course.id, course);
  Future<void> putAllCourses(Map<String, CourseModel> map) => _coursesBox.putAll(map);
  Future<void> deleteCourse(String id) => _coursesBox.delete(id);
  Future<void> clearCourses() => _coursesBox.clear();

  // chips
  CourseChipsModel? getChip(String id) => _chipsBox.get(id);
  List<CourseChipsModel> getAllChips() => _chipsBox.values.toList();
  Future<void> putChip(CourseChipsModel chip) => _chipsBox.put(chip.id, chip);
  Future<void> removeChip(String id) => _chipsBox.delete(id);
  Future<void> clearChips() => _chipsBox.clear();

  // settings
  int get days => _settingsBox.get('days', defaultValue: 5) as int;
  int get rows => _settingsBox.get('rows', defaultValue: 8) as int;
  Future<void> setDays(int days) => _settingsBox.put('days', days);
  Future<void> setRows(int rows) => _settingsBox.put('rows', rows);

  Stream<BoxEvent> watchCourses() => _coursesBox.watch();
}