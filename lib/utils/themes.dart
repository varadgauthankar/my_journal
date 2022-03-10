import 'package:flutter/material.dart';
import 'package:my_journal/utils/color_schemes.dart';

ThemeData myLightTheme = ThemeData(
  colorSchemeSeed: seed,

  // floating action theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: lightColorScheme.tertiaryContainer,
    foregroundColor: lightColorScheme.onTertiaryContainer,
    extendedSizeConstraints: const BoxConstraints.tightFor(
      height: 70,
      width: 150,
    ),
    sizeConstraints: const BoxConstraints.tightFor(
      height: 70,
      width: 70,
    ),
    extendedPadding: const EdgeInsets.all(22.0),
    extendedIconLabelSpacing: 16.0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(22),
      ),
    ),
  ),

  // app bar theme
  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.secondaryContainer,
    elevation: 0,
    // titleTextStyle: MyTextStyles.heading.copyWith(color: kBlackColor),
    // iconTheme: const IconThemeData(
    //   color: kBlackColor,
    // ),
  ),
);

ThemeData myDarkTheme = ThemeData(
  colorSchemeSeed: seed,
  // floating action theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: darkColorScheme.tertiaryContainer,
    foregroundColor: darkColorScheme.onTertiaryContainer,
    extendedSizeConstraints: const BoxConstraints.tightFor(
      height: 70,
      width: 150,
    ),
    sizeConstraints: const BoxConstraints.tightFor(
      height: 70,
      width: 70,
    ),
    extendedPadding: const EdgeInsets.all(22.0),
    extendedIconLabelSpacing: 16.0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(22),
      ),
    ),
  ),

  // app bar theme
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.secondaryContainer,
    elevation: 0,
    // titleTextStyle: MyTextStyles.heading.copyWith(color: kBlackColor),
    // iconTheme: const IconThemeData(
    //   color: kBlackColor,
    // ),
  ),
);
