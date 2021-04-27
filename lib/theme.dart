import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData getTheme() => ThemeData(
        /// @todo: adjust time picker theme style.
        timePickerTheme: TimePickerThemeData(),
        primaryColor: Color.fromRGBO(17, 16, 41, 1),
        scaffoldBackgroundColor: Color.fromRGBO(17, 16, 41, 0.9),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),
      );
}
