import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestorePinService {
  FirebaseFirestore? _firestore;
  DocumentReference? _userDoc;

  String? _uid;

  FirestorePinService() {
    _firestore = FirebaseFirestore.instance;
    _uid = FirebaseAuth.instance.currentUser?.uid;
    _userDoc = _firestore?.collection('users').doc(_uid);
  }

  Future<void> createPin(int pin) async {
    await _userDoc?.set({
      'pin': pin,
    });
  }

  Future<int?> getPin() async {
    final pin = await _userDoc?.get();
    if (pin!.exists) {
      return pin['pin'];
    }

    return null;
  }

  Future<bool> isPinExists() async {
    final userDoc = await _userDoc?.get();

    try {
      // exception is thrown if the pin doesn't exist.
      userDoc?.get('pin');
      return true;
    } catch (e) {
      return false;
    }
  }
}
