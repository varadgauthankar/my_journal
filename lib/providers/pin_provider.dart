import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/services/firestore_pin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PinState {
  initial,
  loading,
  complete,
  error,
}

class PinProvider extends ChangeNotifier {
  PinState _state = PinState.initial;
  PinState get state => _state;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final _firestorePinService = FirestorePinService();

  final _pinController = TextEditingController();
  TextEditingController get pinController => _pinController;

  Future<bool> createPin() async {
    _setState(PinState.loading);

    // validate the text field.
    if (_formKey.currentState!.validate()) {
      try {
        // create pin and store it in firestore.
        await _firestorePinService.createPin(int.parse(_pinController.text));
        _setState(PinState.complete);
        // saves pin status to the prefs.
        _savePinStatusToPrefs(status: true);
        return true;
      } on FirebaseException catch (e) {
        _errorMessage = e.message;
        _setState(PinState.error);
      }
    }

    return false;
  }

  Future<bool> checkPin() async {
    _setState(PinState.loading);
    // getting pin from the firestore.
    final pinFromFirestore = await _firestorePinService.getPin();

    // validating the text field
    if (_formKey.currentState!.validate()) {
      // checking if the pin from the firestore is equal to the pin from the text field.
      if (pinFromFirestore == int.parse(_pinController.text)) {
        _setState(PinState.complete);

        return true;
      } else {
        // show wrong pin error message, if pin doesn't match.
        _errorMessage = 'Wrong PIN!';
        _setState(PinState.error);
        return false;
      }
    }

    return false;
  }

  void _setState(PinState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> _savePinStatusToPrefs({required bool status}) async {
    // this function just saves the flag that the user has set a pin.
    // used when the user opens the app next time.
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPin', status);
  }
}
