import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/pages/auth_pages/auth_wrapper.dart';
import 'package:my_journal/pages/home_page.dart';
import 'package:my_journal/pages/lock_screen_pages/create_pin_page.dart';
import 'package:my_journal/pages/lock_screen_pages/lock_screen_page.dart';

import 'package:my_journal/pages/auth_pages/sign_in_page.dart';
import 'package:my_journal/providers/auth_provider.dart';
import 'package:my_journal/providers/journal_provider.dart';
import 'package:my_journal/providers/pin_provider.dart';
import 'package:my_journal/providers/settings_provider.dart';
import 'package:my_journal/providers/labels_provider.dart';
import 'package:my_journal/providers/theme_provider.dart';
import 'package:my_journal/utils/themes.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // git ignored

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => JournalProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => LabelsProvider()),
        ChangeNotifierProvider(create: (_) => PinProvider()),
      ],
      child: Consumer<ThemeProvider>(builder: (context, value, child) {
        return MaterialApp(
          title: 'MyJournal',
          theme: myLightTheme,
          darkTheme: myDarkTheme,
          themeMode: value.themeMode,
          home: const AuthWrapper(),
        );
      }),
    );
  }
}
