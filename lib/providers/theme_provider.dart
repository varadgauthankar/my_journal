import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  final String _key = 'themeMode';

  ThemeProvider() {
    _getThemeFromPrefs();
  }

  void setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    _saveThemeToPrefs();
    notifyListeners();
  }

  void _getThemeFromPrefs() async {
    final _prefs = await SharedPreferences.getInstance();
    final themeFromPrefs = ThemeMode.values[_prefs.getInt(_key) ?? 1];
    _themeMode = themeFromPrefs;
    notifyListeners();
  }

  void _saveThemeToPrefs() async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setInt(_key, themeMode.index);
  }
}
