import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData =>
      _themeData; // getter method to acces the theme from other parts of code

  bool get isDarkMode =>
      _themeData ==
      darkMode; //getter method to see if we are in dark mode or not

  set themeData(ThemeData themeData) {
    _themeData = themeData; // setter method to set the new theme
  }

  void toggleTheme() =>
      themeData = (_themeData == lightMode) ? darkMode : lightMode;
}
