import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker/database/habit_database.dart';
import 'package:provider/provider.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButton(
              onPressed: () {
                String newHabitName = controller.text;
                context.read<HabitDatabase>().addHabit(newHabitName);
                Navigator.pop(context);
                controller.clear();
              },
              child: Text(
                "Save",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                controller.clear();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        )
      ],
      content: TextField(
        controller: controller,
        decoration:
        const InputDecoration(hintText: "Create a new habit"),
      ),
    );
  }
}

