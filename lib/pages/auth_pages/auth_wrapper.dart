import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/constants/prefs_string.dart';
import 'package:my_journal/pages/auth_pages/sign_in_page.dart';
import 'package:my_journal/pages/home_page.dart';
import 'package:my_journal/pages/lock_screen_pages/create_pin_page.dart';
import 'package:my_journal/pages/lock_screen_pages/lock_screen_page.dart';
import 'package:my_journal/services/firestore_pin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // using stream to check the auth state.
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          // for checking pin state.
          // using future builder to be able to use async operations in build().
          return FutureBuilder(
            // isPinExists check if pin exists in the database.
            future: Future.wait([
              FirestorePinService().isPinExists(), // 0 index
              SharedPreferences.getInstance() // 1 index
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // multiple futures gives list of results.
                final data = snapshot.data as List;

                final isPinExists = data[0] as bool;
                final prefs = data[1] as SharedPreferences;

                // if pin exists then go to lock screen.

                if (isPinExists == true) {
                  // 0 index is FirestorePinService....
                  return const LockScreenPage();
                }

                // if its first launch then go to pin on-boarding page.
                // if pin doesn't exist then go to home page.

                // todo: create pin on-boarding page.
                else if (prefs.getBool(PrefKeys.isPinSkipped) ?? false) {
                  return const HomePage();
                } else {
                  return const CreatePinPage();
                }
              }

              // show a loading indicator while waiting for the future to finish.
              else {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
        }

        // go to sign in page is user is not logged in.
        else {
          return const SignInPage();
        }
      }),
    );
  }
}
