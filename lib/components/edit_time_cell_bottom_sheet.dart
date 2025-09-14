import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timegrid/models/time_cell_model.dart';
import 'package:timegrid/provider.dart';
import 'package:timegrid/widget_bridge.dart';

Future<TimeCellModel?> editTimeCellBottomSheet(BuildContext context, TimeCellModel timeCellModel, WidgetRef ref) {
  final textTheme = Theme
      .of(context)
      .textTheme;
  final colorScheme = Theme
      .of(context)
      .colorScheme;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: timeCellModel.displayName);

  final storage = ref.watch(storageProvider);
  debugPrint('Editing TimeCell: ${timeCellModel.displayName}\n controller text: ${nameController.text}');

  var current = storage.getTimeCell(timeCellModel.id) ?? timeCellModel;

  Widget timePickerField({required TimeOfDay originTime, Function(TimeOfDay)? onTimePicked}) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: originTime,
            builder: (BuildContext builderContext, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(builderContext).copyWith(alwaysUse24HourFormat: true),
                child: child!,
              );
            },
          );

          if (picked != null) {
            onTimePicked?.call(picked);
            debugPrint('picked: ${picked.format(context)}');
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Theme
                .of(context)
                .colorScheme
                .secondaryContainer,
          ),
          child: Center(child: Text(originTime.format24Hour(), style: Theme
              .of(context)
              .textTheme
              .bodyLarge)),
        ),
      ),
    );
  }

  return showModalBottomSheet<TimeCellModel?>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext ctx) {
      return StatefulBuilder(builder: (ctx2, sheetSetState) {
        return timeGridBottomSheetHeader(
          context: ctx2,
          parentSetState: sheetSetState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Text('Edit Time Cell', style: textTheme.titleLarge),
              ),
              Form(
                key: formKey,
                child: Column(
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Title', style: textTheme.bodyLarge),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: nameController,
                            maxLines: 1,
                            maxLength: 4,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                            (v == null || v
                                .trim()
                                .isEmpty) ? 'Input Cell Title' : null,
                            onFieldSubmitted: (_) async {
                              if (formKey.currentState?.validate() ?? false) {
                                final updated = current.copyWith(displayName: nameController.text.trim());
                                await storage.editTimeCell(updated);
                                current = updated;
                                sheetSetState(() {});
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    // Cell Time Range
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cell Time Range', style: textTheme.bodyLarge),
                        SizedBox(
                          width: 200,
                          child: Row(
                            spacing: 8,
                            children: [
                              timePickerField(
                                originTime: current.startTime,
                                onTimePicked: (newTime) async {
                                  final updated = current.copyWith(startTime: newTime);
                                  await storage.editTimeCell(updated);
                                  await pushWidgetCourse(ref);
                                  current = updated;
                                  sheetSetState(() {});
                                },
                              ),
                              const Text(' - '),
                              timePickerField(
                                originTime: current.endTime,
                                onTimePicked: (newTime) async {
                                  final updated = current.copyWith(endTime: newTime);
                                  await storage.editTimeCell(updated);
                                  await pushWidgetCourse(ref);
                                  current = updated;
                                  sheetSetState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Show Start Time
                    SwitchListTile(
                      title: const Text('Show Start Time'),
                      contentPadding: EdgeInsets.zero,
                      value: current.showStartTime,
                      onChanged: (v) {
                        final updated = current.copyWith(showStartTime: v);
                        storage.editTimeCell(updated);
                        current = updated;
                        sheetSetState(() {});
                      },
                    ),

                    // Show End Time
                    SwitchListTile(
                      title: const Text('Show End Time'),
                      contentPadding: EdgeInsets.zero,
                      value: current.showEndTime,
                      onChanged: (v) {
                        final updated = current.copyWith(showEndTime: v);
                        storage.editTimeCell(updated);
                        current = updated;
                        sheetSetState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}

Widget timeGridBottomSheetHeader({required BuildContext context, StateSetter? parentSetState, Widget? child}) {
  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery
        .of(context)
        .viewInsets
        .bottom),
    child: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              child ?? const SizedBox.shrink(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
  );
}
