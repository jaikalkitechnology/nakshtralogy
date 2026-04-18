import 'package:flutter/material.dart';

class AppColors {
  // Primary — Deep cosmic
  static const Color midnight = Color(0xFF0B0B2E);
  static const Color cosmicVoid = Color(0xFF06061A);
  static const Color nebula = Color(0xFF1A1642);
  static const Color twilight = Color(0xFF2D2458);

  // Accent — Celestial gold & saffron
  static const Color gold = Color(0xFFE8B547);
  static const Color goldBright = Color(0xFFF4CC6B);
  static const Color saffron = Color(0xFFE07A3C);
  static const Color roseGold = Color(0xFFD4896B);

  // Mystical secondary
  static const Color lavender = Color(0xFFB8A7E0);
  static const Color indigo = Color(0xFF4A3B8C);
  static const Color cosmicPink = Color(0xFFE8689C);
  static const Color aurora = Color(0xFF7BC4C4);

  // Neutrals
  static const Color ivory = Color(0xFFF5EEE0);
  static const Color parchment = Color(0xFFEDE4D0);
  static const Color smoke = Color(0xFF8A8298);
  static const Color ash = Color(0xFF3A3550);

  // Semantic
  static const Color success = Color(0xFF6BB88A);
  static const Color error = Color(0xFFD95555);
  static const Color warning = Color(0xFFE8B547);

  // Legacy aliases (for backward compatibility with existing widgets)
  static const Color primary = gold;
  static const Color primaryDark = saffron;
  static const Color background = cosmicVoid;
  static const Color surface = nebula;
  static const Color card = Color(0xFF1A1642);
  static const Color textPrimary = ivory;
  static const Color textSecondary = smoke;
  static const Color accent = indigo;
  static const Color border = Color(0xFF2D2458);
}

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.cosmicVoid,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.gold,
      secondary: AppColors.indigo,
      surface: AppColors.nebula,
      error: AppColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.ivory,
      ),
      iconTheme: IconThemeData(color: AppColors.ivory),
    ),
    cardTheme: CardThemeData(
      color: AppColors.nebula,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.gold.withOpacity(0.15)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.midnight,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.gold,
        side: BorderSide(color: AppColors.gold.withOpacity(0.5)),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.nebula,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.gold.withOpacity(0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.gold.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(color: AppColors.smoke, fontFamily: 'Manrope'),
      hintStyle: const TextStyle(color: AppColors.smoke, fontFamily: 'Manrope'),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w800, color: AppColors.ivory),
      headlineMedium: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700, color: AppColors.ivory),
      bodyLarge: TextStyle(fontFamily: 'Manrope', color: AppColors.ivory),
      bodyMedium: TextStyle(fontFamily: 'Manrope', color: AppColors.smoke),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.midnight,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: AppColors.smoke,
    ),
    dividerTheme: DividerThemeData(color: AppColors.gold.withOpacity(0.1)),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.nebula,
      contentTextStyle: TextStyle(fontFamily: 'Manrope', color: AppColors.ivory),
    ),
  );
}
