import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timegrid/models/course_chips_model.dart';
import 'package:timegrid/models/course_model.dart';
import 'package:timegrid/utils/basic_dialog_util.dart';

import '../provider.dart';
import '../theme/Theme.dart';

Future<CourseModel?> editCourseBottomSheet(
    BuildContext ctx, CourseModel course, WidgetRef ref, VoidCallback? onDelete) {
  final formKey = GlobalKey<FormState>();
  final roomController = TextEditingController(text: course.room);
  final cs = Theme.of(ctx).colorScheme;

  final storage = ref.read(storageProvider);
  List<CourseChipsModel> chipsData = storage.getAllChips();

  String? selectedChipId = chipsData.isNotEmpty ? chipsData[0].id : null;

  return showModalBottomSheet<CourseModel>(
    context: ctx,
    backgroundColor: cs.surfaceContainer,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: StatefulBuilder(builder: (context, setState) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title
                        Center(child: Text('Edit Course', style: Theme.of(context).textTheme.titleLarge)),

                        // Delete Course Button
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            onDelete?.call();
                            Navigator.pop(context, null);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Course"),
                        Wrap(
                          spacing: 8,
                          children: [
                            ...chipsData.asMap().entries.map((entry) {
                              final data = entry.value;

                              // Course Chips
                              return InputChip(
                                label: Text(data.title),
                                avatar: CircleAvatar(backgroundColor: data.color),
                                selected: selectedChipId == data.id,
                                side: selectedChipId == data.id
                                    ? BorderSide(color: cs.primary, width: 2)
                                    : BorderSide.none,
                                onSelected: (bool selected) {
                                  setState(() {
                                    selectedChipId = selected ? data.id : null;
                                    roomController.text = data.room;
                                  });
                                },
                                deleteIcon: const Icon(
                                  Icons.close,
                                  size: 18,
                                ),
                                onDeleted: () async {
                                  void deleteChip() async {
                                    final idToRemove = data.id;
                                    setState(() {
                                      if (selectedChipId == data.id) selectedChipId = null;
                                      chipsData.removeWhere((c) => c.id == idToRemove);
                                    });
                                    await storage.removeChip(idToRemove);
                                  }

                                  await showConfirmLeaveDialog(
                                    context,
                                    title: "Delete Course Chip",
                                    text: "Are you sure you want to delete this course chip?",
                                    onDismiss: () => {},
                                    confirmText: "Delete",
                                    confirmType: ConfirmType.delete,
                                    onClick: deleteChip,
                                  );
                                },
                              );
                            }).toList(),

                            // Add course chips button
                            IconButton.outlined(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                openAddCourseChipDialog(context, (newClipData) {
                                  setState(() => chipsData.add(newClipData));
                                  storage.putChip(newClipData);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Form(
                      key: formKey,
                      child: Column(spacing: 8, children: [
                        TextFormField(
                          controller: roomController,
                          decoration: const InputDecoration(
                            labelText: 'Room',
                          ),
                        )
                      ]),
                    ),

                    // Bottom sheet actions buttons
                    Row(
                      spacing: 12,
                      children: [
                        // Cancel Button
                        Expanded(
                          child:
                              FilledButton.tonal(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        ),

                        // Save Button
                        Expanded(
                          child: FilledButton(
                            onPressed: selectedChipId == null
                                ? null
                                : () {
                                    final updated = course.copyWith(
                                      title: storage.getChip(selectedChipId!)?.title ?? 'New Course',
                                      room: roomController.text.trim(),
                                      color: storage.getChip(selectedChipId!)?.color ?? colorLibrary[0],
                                    );
                                    Navigator.pop(context, updated);
                                  },
                            child: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    },
  );
}

void openAddCourseChipDialog(
  BuildContext context,
  void Function(CourseChipsModel) onSave,
) {
  final titleController = TextEditingController();
  final roomController = TextEditingController();
  Color? picked = colorLibrary[0];

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, dialogSetState) {
        return AlertDialog(
          title: const Text('Add Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                child: Column(
                  spacing: 24,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Course Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: roomController,
                      decoration: const InputDecoration(
                        labelText: 'Room',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    // Color picker
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: colorLibrary.map((color) {
                        final isPicked = picked == color;
                        return InkWell(
                          onTap: () {
                            dialogSetState(() {
                              picked = color;
                              debugPrint("pick $color");
                            });
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                              border: picked == color ? Border.all(color: Colors.white, width: 2) : null,
                            ),
                            child: isPicked ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            // Save Button
            FilledButton(
              onPressed: () {
                final newChip = CourseChipsModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text.isEmpty ? 'New Course' : titleController.text.trim(),
                    room: roomController.text.trim(),
                    color: picked ?? colorLibrary[0]);
                onSave(newChip);
                Navigator.of(ctx).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ),
  );
}

Future<bool?> confirmDialog(
  BuildContext ctx,
  String title,
  String content,
) async {
  return showDialog<bool>(
    context: ctx,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
