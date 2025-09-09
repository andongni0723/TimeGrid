import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timegrid/models/time_cell_model.dart';

Future<TimeCellModel?> editTimeCellBottomSheet(BuildContext context, TimeCellModel timeCellModel, WidgetRef ref) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: timeCellModel.displayName);
  final showStartTime = timeCellModel.showStartTime;

  debugPrint('Editing TimeCell: ${timeCellModel.displayName}\n controller text: ${nameController.text}');

  Widget timePickerField() {
    TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

    final formatted =
        '${selectedTime.hour.toString().padLeft(2, '0')}:'
        '${selectedTime.minute.toString().padLeft(2, '0')}';

    return Expanded(
      child: InkWell(
        onTap: () async {
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: selectedTime,
            builder: (BuildContext builderContext, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(builderContext).copyWith(alwaysUse24HourFormat: true),
                child: child!,
              );
            },
          );

          if (picked != null) {
            // setState(() {
            //   selectedTime = picked;
            // });
            debugPrint('picked: ${picked.format(context)}');
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          child: Center(child: Text(formatted, style: Theme.of(context).textTheme.bodyLarge)),
        ),
      ),
    );
  }

  return showModalBottomSheet<TimeCellModel?>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext ctx) {
      return timeGridBottomSheetHeader(
        context: ctx,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
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
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Input Cell Title' : null,
                          onFieldSubmitted: (_) {
                            if (formKey.currentState?.validate() ?? false) {
                              debugPrint('Submitted: ${nameController.text}');
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
                            timePickerField(),
                            const Text(' - '),
                            timePickerField(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Show Start Time
                  SwitchListTile(
                    title: const Text('Show Start Time'),
                    contentPadding: EdgeInsets.zero,
                    value: showStartTime,
                    onChanged: (v) {},
                  ),

                  // Show End Time
                  SwitchListTile(
                    title: const Text('Show End Time'),
                    contentPadding: EdgeInsets.zero,
                    value: showStartTime,
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );


}

Widget timeGridBottomSheetHeader({required BuildContext context, Widget? child}) {
  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: StatefulBuilder(builder: (context, setState) {
      return SafeArea(
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
      );
    }),
  );
}

