import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
        brightness: Brightness.light,
        /// Clicked color
        splashColor: const Color(0xFF87832D),
        /// Texfield focuse
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF87832D),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.white
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
        brightness: Brightness.dark,
        /// Clicked color
        splashColor: const Color(0xFF959396),
        /// Texfield focuse
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF5D5C58),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black
    );
  }
}
