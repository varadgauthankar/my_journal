import 'package:flutter/material.dart';
import 'package:my_journal/services/signin_with_google_service.dart';

enum AuthState {
  initial,
  loading,
  complete,
  error,
}

class AuthProvider extends ChangeNotifier {
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  AuthState _state = AuthState.initial;
  AuthState get state => _state;

  final String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void signInWithGoogle() async {
    try {
      final user = await _googleSignInService.signInWithGoogle();
    } catch (e) {
      print(e);
    }
  }

  void setState(AuthState state) {
    _state = state;
    notifyListeners();
  }
}
