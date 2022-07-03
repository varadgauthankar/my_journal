import 'package:firebase_auth/firebase_auth.dart';
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
      await _googleSignInService.signInWithGoogle();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  User? getCurrentUser() {
    return _googleSignInService.getCurrentUser();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void setState(AuthState state) {
    _state = state;
    notifyListeners();
  }
}
