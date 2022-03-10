import 'package:flutter/material.dart';
import 'package:my_journal/pages/home_page.dart';
import 'package:my_journal/utils/color_schemes.dart';
import 'package:my_journal/utils/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: myLightTheme,
      darkTheme: myLightTheme,
      home: const HomePage(),
    );
  }
}
