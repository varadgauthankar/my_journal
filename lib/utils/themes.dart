import 'package:flutter/material.dart';
import 'package:my_journal/utils/color_schemes.dart';

ThemeData myLightTheme = ThemeData(
  useMaterial3: true,
  // colorSchemeSeed: seed,
  colorScheme: lightColorScheme,
  // floating action theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: lightColorScheme.tertiaryContainer,
    foregroundColor: lightColorScheme.onTertiaryContainer,
    // extendedSizeConstraints: const BoxConstraints.tightFor(
    //   height: 70,
    //   width: 150,
    // ),
    // sizeConstraints: const BoxConstraints.tightFor(
    //   height: 70,
    //   width: 70,
    // ),
    // extendedPadding: const EdgeInsets.all(22.0),
    // extendedIconLabelSpacing: 16.0,
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.all(
    //     Radius.circular(22),
    //   ),
    // ),
  ),

  // app bar theme
  // appBarTheme: AppBarTheme(
  //   backgroundColor: lightColorScheme.surface,
  //   elevation: 0,
  //   titleTextStyle: TextStyle(
  //     fontSize: 22,
  //     color: lightColorScheme.onPrimaryContainer,
  //     fontWeight: FontWeight.bold,
  //   ),
  //   iconTheme: IconThemeData(
  //     color: lightColorScheme.onPrimaryContainer,
  //   ),
  // ),

  scaffoldBackgroundColor: lightColorScheme.background,
);

ThemeData myDarkTheme = ThemeData(
  useMaterial3: true,
  // colorSchemeSeed: seed,
  colorScheme: darkColorScheme,
  // floating action theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: darkColorScheme.tertiaryContainer,
    foregroundColor: darkColorScheme.onTertiaryContainer,
    // extendedSizeConstraints: const BoxConstraints.tightFor(
    //   height: 70,
    //   width: 150,
    // ),
    // sizeConstraints: const BoxConstraints.tightFor(
    //   height: 70,
    //   width: 70,
    // ),
    // extendedPadding: const EdgeInsets.all(22.0),
    // extendedIconLabelSpacing: 16.0,
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.all(
    //     Radius.circular(22),
    //   ),
    // ),
  ),

  // app bar theme
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.surface,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 22,
      color: darkColorScheme.onPrimaryContainer,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: darkColorScheme.onPrimaryContainer,
    ),
  ),
  scaffoldBackgroundColor: darkColorScheme.background,
);
