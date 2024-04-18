import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const HabitTile(
      {super.key,
      required this.isCompleted,
      required this.habitName,
      this.onChanged,
      this.editHabit, this.deleteHabit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: editHabit,
            backgroundColor: Colors.grey.shade800,
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(8),
          ),
          SlidableAction(
            onPressed: deleteHabit,
            backgroundColor: Colors.red.shade800,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(8),
          ),
        ]),
        child: GestureDetector(
          onTap: () {
            onChanged!(!isCompleted);
          },
          child: Container(
            decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              title: Text(habitName, style: TextStyle(
                color: isCompleted ? Colors.white : Theme.of(context).colorScheme.inversePrimary,
              ),),
              leading: Checkbox(value: isCompleted, onChanged: onChanged),
            ),
          ),
        ),
      ),
    );
  }
}
