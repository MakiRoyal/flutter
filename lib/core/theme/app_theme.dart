import 'package:flutter/material.dart';

class AppTheme {
  // Gaming color palette
  static const Color primaryPurple = Color(0xFF6C63FF);
  static const Color darkPurple = Color(0xFF5548C8);
  static const Color neonPink = Color(0xFFFF6B9D);
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color cardBackground = Color(0xFF16213E);
  
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.deepPurple,
      primaryColor: primaryPurple,
      scaffoldBackgroundColor: const Color(0xFF0F0F23),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.dark,
        primary: primaryPurple,
        secondary: neonPink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
        color: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        filled: true,
        fillColor: cardBackground,
      ),
    );
  }
}
