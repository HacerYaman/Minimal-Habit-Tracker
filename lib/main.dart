import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker/database/habit_database.dart';
import 'package:minimal_habit_tracker/pages/home_page.dart';
import 'package:minimal_habit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDatabase.initalize();
  await HabitDatabase().saveFirstLaunchDate();
  runApp(
    MultiProvider(
        providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider())
    ],
    child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habbit Tracker',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const HomePage(),
    );
  }
}
