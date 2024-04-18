import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode =>
      _themeData == darkMode;

  ThemeProvider() {
    loadThemeData();
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveThemeData();
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
      _saveThemeData();
    } else {
      themeData = lightMode;
      _saveThemeData();
    }
  }

  Future<void> loadThemeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeData =
        (prefs.getString('themeData') == "darkMode") ? darkMode : lightMode;
    notifyListeners();
  }

  Future<void> _saveThemeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'themeData', (_themeData == darkMode) ? "darkMode" : "lightMode");
  }
}
