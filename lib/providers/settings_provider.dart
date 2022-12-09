import 'package:flutter/material.dart';
import 'package:my_journal/utils/sort_by_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SortBy _sortBy = SortBy.createdAt;

  SortBy get sortBy => _sortBy;

  final String _key = 'sortBy';

  bool _showFilterChips = true;
  bool get showFilterChips => _showFilterChips;

  SettingsProvider() {
    _getSortByFromPrefs();
    _getShowFilterChipsFromPrefs();
  }

  void setShowFilterChips(bool value) {
    _showFilterChips = value;
    _saveShowFilterChipsToPrefs();
    notifyListeners();
  }

  void setSortBy(SortBy sortBy) {
    _sortBy = sortBy;
    _saveSortByToPrefs();
    notifyListeners();
  }

  void _getSortByFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final sortByFromPrefs = SortBy.values[prefs.getInt(_key) ?? 1];
    _sortBy = sortByFromPrefs;
    notifyListeners();
  }

  void _saveSortByToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_key, _sortBy.index);
  }

  void _saveShowFilterChipsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('showFilterChips', _showFilterChips);
  }

  void _getShowFilterChipsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _showFilterChips = prefs.getBool('showFilterChips') ?? true;
    notifyListeners();
  }
}
