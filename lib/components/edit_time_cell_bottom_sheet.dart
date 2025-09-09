import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timegrid/models/time_cell_model.dart';

Future<TimeCellModel?> editTimeCellBottomSheet(BuildContext context, TimeCellModel timeCell, WidgetRef ref) {
  return showModalBottomSheet<TimeCellModel?>(
    context: context,
    builder: (BuildContext ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: StatefulBuilder(builder: (context, setState) {
          return const Text("Edit Time Cell");
        }),
      );
    },
  );
}
