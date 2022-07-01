import 'package:flutter/material.dart';

class LabelsProvider extends ChangeNotifier {
  bool _isLabelsExist = false;

  bool get isLabelsExist => _isLabelsExist;

  void setLabelsExist(bool value) {
    _isLabelsExist = value;
    notifyListeners();
  }
}
