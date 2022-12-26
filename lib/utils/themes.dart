import 'package:flutter/material.dart';
import 'package:my_journal/utils/color_schemes.dart';

class MyThemes {
  static lightTheme(ColorScheme? colorScheme) {
    return ThemeData(
      useMaterial3: true,

      colorScheme: colorScheme ?? lightColorScheme,
      // floating action theme
      // floatingActionButtonTheme: FloatingActionButtonThemeData(
      //   backgroundColor: colorScheme?.tertiary,
      //   foregroundColor: colorScheme?.onTertiary,
      // ),

      // chip themes

      chipTheme: ChipThemeData(
        backgroundColor: colorScheme != null
            ? colorScheme.secondaryContainer
            : lightColorScheme.secondaryContainer,
        selectedColor: colorScheme != null
            ? colorScheme.primary
            : lightColorScheme.primary,
      ),
      scaffoldBackgroundColor: colorScheme?.background,
    );
  }

  static darkTheme(ColorScheme? colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme ?? darkColorScheme,
      // floatingActionButtonTheme: FloatingActionButtonThemeData(
      //   backgroundColor: colorScheme?.tertiary,
      //   foregroundColor: colorScheme?.onTertiary,
      // ),

      chipTheme: ChipThemeData(
        backgroundColor: colorScheme != null
            ? colorScheme.secondaryContainer
            : darkColorScheme.secondaryContainer,
        selectedColor:
            colorScheme != null ? colorScheme.primary : darkColorScheme.primary,
      ),
      scaffoldBackgroundColor: colorScheme?.surface,
    );
  }
}
