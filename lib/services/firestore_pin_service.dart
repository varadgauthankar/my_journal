import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestorePinService {
  FirebaseFirestore? _firestore;
  DocumentReference? _pin;

  String? _uid;

  FirestorePinService() {
    _firestore = FirebaseFirestore.instance;
    _uid = FirebaseAuth.instance.currentUser?.uid;
    _pin = _firestore?.collection('users').doc(_uid);
  }

  Future<void> createPin(int pin) async {
    await _pin?.set({
      'pin': pin,
    });
  }

  Future<int?> getPin() async {
    final pin = await _pin?.get();
    if (pin!.exists) {
      return pin['pin'];
    }

    return null;
  }

  Future<bool> isPinExists() async {
    final pin = await _pin?.get();
    return pin?.exists ?? false;
  }
}
