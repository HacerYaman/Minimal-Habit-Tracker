import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker/components/habit_tile.dart';
import 'package:minimal_habit_tracker/components/heatmap.dart';
import 'package:minimal_habit_tracker/components/my_alert_dialog.dart';
import 'package:minimal_habit_tracker/components/my_drawer.dart';
import 'package:minimal_habit_tracker/database/habit_database.dart';
import 'package:minimal_habit_tracker/models/habit.dart';
import 'package:minimal_habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    super.initState();
  }

  final controller = TextEditingController();

  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => MyAlertDialog(controller: controller));
  }

  void editHabit(Habit habit) {
    controller.text = habit.habitName;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: controller,
              ),
              actions: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        String newHabitName = controller.text;
                        context
                            .read<HabitDatabase>()
                            .updateHabitName(habit.id, newHabitName);
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
            ));
  }

  void deleteHabit(Habit habit) {
    controller.text = habit.habitName;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Text("Are you sure?"),
              actions: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        context.read<HabitDatabase>().deleteHabit(habit.id);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Delete",
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
            ));
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    //update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  void buildHelpDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("How to use?"),
              content: const Text(
                  "Create a habit with floating button. \nSlide the habit for seeing options."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Okay"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
              onPressed: () {
                buildHelpDialog();
              },
              icon: const Icon(Icons.help_outline))
        ],
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          createNewHabit();
        },
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: ListView(children: [_buildHeatMap(), _buildHabitList()]),
    );
  }

  Widget _buildHeatMap() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabit;

    return FutureBuilder<DateTime?>(
        future: habitDatabase.getFirstLaunchDate(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HeatMapWidget(
              startDate: snapshot.data!,
              datasets: prepareHeatMapDataset(currentHabits),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabit;

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        //her habiti çek
        final habit = currentHabits[index];

        // habit bugün tamamlanmış mı kontrol et
        bool isCompletedToday = isHabitCompletedToday(habit.complatedDays);

        //habit ui
        return HabitTile(
          deleteHabit: (context) {
            deleteHabit(habit);
          },
          editHabit: (context) {
            editHabit(habit);
          },
          isCompleted: isCompletedToday,
          habitName: habit.habitName,
          onChanged: (value) => checkHabitOnOff(value, habit),
        );
      },
    );
  }
}
