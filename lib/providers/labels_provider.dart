import 'package:flutter/material.dart';
import 'package:my_journal/models/label.dart';

class LabelsProvider extends ChangeNotifier {
  bool _isLabelsExist = false;
  final List<Label> _selectedLabels = [];
  List<Label> get selectedLabels => _selectedLabels;

  bool get isLabelsExist => _isLabelsExist;

  void setLabelsExist(bool value) {
    _isLabelsExist = value;
    notifyListeners();
  }

  void addLabel(Label label) {
    _selectedLabels.add(label);
    notifyListeners();
  }

  void removeLabel(Label label) {
    _selectedLabels.remove(label);
    notifyListeners();
  }
}
