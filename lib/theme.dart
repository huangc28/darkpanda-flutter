import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData getTheme() => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        toggleableActiveColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
      );
}
