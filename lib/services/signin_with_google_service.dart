import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    _user = googleUser;

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  bool isSignedIn() {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      return false;
    } else {
      return true;
    }
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }
}
