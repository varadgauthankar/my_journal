import 'package:flutter/material.dart';
import 'package:my_journal/utils/sort_by_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SortBy _sortBy = SortBy.createdAt;

  SortBy get sortBy => _sortBy;

  final String _key = 'sortBy';

  SettingsProvider() {
    _getSortByFromPrefs();
  }

  void setSortBy(SortBy sortBy) {
    _sortBy = sortBy;
    _saveSortByToPrefs();
    notifyListeners();
  }

  void _getSortByFromPrefs() async {
    final _prefs = await SharedPreferences.getInstance();
    final sortByFromPrefs = SortBy.values[_prefs.getInt(_key) ?? 1];
    _sortBy = sortByFromPrefs;
    notifyListeners();
  }

  void _saveSortByToPrefs() async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setInt(_key, _sortBy.index);
  }
}
