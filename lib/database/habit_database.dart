import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:minimal_habit_tracker/models/app_settings.dart';
import 'package:minimal_habit_tracker/models/habit.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // initalize database
  static Future<void> initalize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema], // oluşturulan Isar.g dosyalarından
      directory: dir.path,
    );
  }

  // save first date of app startup (for heatmap)

  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  //List of habits
  final List<Habit> currentHabit = [];

  //add new habit

  Future<void> addHabit(String habitHame) async {
    final newHabit = Habit()..habitName = habitHame;

    await isar.writeTxn(() => isar.habits.put(newHabit));

    readHabits();
  }

  Future<void> readHabits() async {
    // fetch all habits from db and give it
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    currentHabit.clear();
    currentHabit.addAll(fetchedHabits);

    notifyListeners(); //update ui
  }

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        // if habit is completed add the current date to the completedDays list
        if (isCompleted && !habit.complatedDays.contains(DateTime.now())) {
          //today
          final today = DateTime.now();

          //add current date if its not already in the list
          habit.complatedDays.add(DateTime(today.year, today.month, today.day));

          // if habit is NOT completed -> remove the current date  from the list
        } else {
          //remove the current date if the habit is marked as not completed
          habit.complatedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        //save the updated habits back to the db
        await isar.habits.put(habit);
      });
    }
    //re-read from db
    readHabits();
    notifyListeners();
  }

  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);

    //update habit name
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.habitName = newName;
        // save updated habit back to the db
        await isar.habits.put(habit);
      });
    }
    // re-read from db
    readHabits();
  }

  Future<void> deleteHabit(int id) async {
    // perform the delete

    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    readHabits();
  }
}
