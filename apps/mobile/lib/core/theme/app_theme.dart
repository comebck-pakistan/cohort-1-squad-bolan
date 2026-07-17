import 'package:flutter/material.dart';

abstract final class AppColors {
  static const ink = Color(0xFF172B22);
  static const brand = Color(0xFF146B4A);
  static const mint = Color(0xFFDDF5E8);
  static const canvas = Color(0xFFF7F8F4);
  static const warning = Color(0xFFD96D19);
  static const danger = Color(0xFFC84343);
  static const muted = Color(0xFF68736D);
}

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: Brightness.light,
      surface: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.canvas,
      fontFamily: 'Arial',
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.canvas, foregroundColor: AppColors.ink, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDDE3DD))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDDE3DD))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
