import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.blue.shade700, // AI-green for accents
      onPrimary: Colors.white, // Text/icons on green buttons
      secondary: Colors.green.shade400, // Secondary accent (lighter green)
      onSecondary: Colors.blue, // Text/icons on secondary elements
      background: Colors.white, // Main background
      onBackground: Colors.black, // Text/icons on white background
      surface: Colors.grey.shade100, // Chat bubble background
      onSurface: Colors.black, // Text/icons on bubbles
      error: Colors.red.shade700, // Error messages
      onError: Colors.white, // Text/icons on error
    ),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue.shade700,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    ),
    iconTheme: IconThemeData(color: Colors.black),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.blue.shade400, // AI-neon green
      onPrimary: Colors.black, // Text/icons on neon green buttons
      secondary: Colors.white70, // Lighter neon green
      onSecondary: Colors.black, // Text/icons on secondary elements
      background: Colors.black, // Deep black background
      onBackground: Colors.white, // White text/icons
      surface: Colors.grey.shade900, // Dark chat bubbles
      onSurface: Colors.white, // Text/icons on bubbles
      error: Colors.redAccent.shade700, // Error messages
      onError: Colors.black, // Text/icons on error
    ),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    ),
    iconTheme: IconThemeData(color: Colors.white),
  );
}
