import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timegrid/models/storage_service.dart';
import 'package:timegrid/schedule.dart';

final storageProvider = Provider<StorageService>(
    (ref) => throw UnimplementedError('StorageService not initialized'),
);

final scheduleProvider = ChangeNotifierProvider<ScheduleController>((ref) {
  final storage = ref.read(storageProvider);
  final controller = ScheduleController(storage: storage);
  ref.onDispose(() => controller.dispose());
  return controller;
});