import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryIndigo = Color(0xFF4F46E5);
  static const Color primaryIndigoLight = Color(0xFF818CF8);
  static const Color accent = Color(0xFFF43F5E);
  static const Color accentAmber = Color(0xFFF59E0B);

  // Dark tokens
  static const Color darkBg = Color(0xFF0F0F14);
  static const Color darkSurface = Color(0xFF1A1A24);
  static const Color darkCard = Color(0xFF22223A);
  static const Color darkBorder = Color(0xFF2E2E4A);
  static const Color darkTextPrimary = Color(0xFFF1F1F8);
  static const Color darkTextSecondary = Color(0xFF8B8BAE);

  // Light tokens
  static const Color lightBg = Color(0xFFF5F5FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE4E4F0);
  static const Color lightTextPrimary = Color(0xFF0F0F2D);
  static const Color lightTextSecondary = Color(0xFF6B6B8A);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryIndigo,
    scaffoldBackgroundColor: darkBg,
    colorScheme: const ColorScheme.dark(
      primary: primaryIndigo,
      secondary: accent,
      surface: darkSurface,
      error: Color(0xFFEF4444),
      onPrimary: Colors.white,
      onSurface: darkTextPrimary,
    ),
    cardTheme: const CardThemeData(
      color: darkCard,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: darkBorder, width: 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: darkTextPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(color: darkTextPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCard,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: darkBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: darkBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryIndigo, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      labelStyle: const TextStyle(color: darkTextSecondary),
      hintStyle: const TextStyle(color: darkTextSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryIndigo,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: darkCard,
      selectedColor: primaryIndigo,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      side: const BorderSide(color: darkBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: darkTextPrimary, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1.5),
      headlineLarge: TextStyle(color: darkTextPrimary, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1),
      headlineMedium: TextStyle(color: darkTextPrimary, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5),
      titleLarge: TextStyle(color: darkTextPrimary, fontSize: 18, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: darkTextPrimary, fontSize: 15, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: darkTextPrimary, fontSize: 16, height: 1.6),
      bodyMedium: TextStyle(color: darkTextSecondary, fontSize: 14, height: 1.5),
      bodySmall: TextStyle(color: darkTextSecondary, fontSize: 12),
      labelLarge: TextStyle(color: darkTextPrimary, fontSize: 13, fontWeight: FontWeight.w600),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryIndigo,
    scaffoldBackgroundColor: lightBg,
    colorScheme: const ColorScheme.light(
      primary: primaryIndigo,
      secondary: accent,
      surface: lightSurface,
      error: Color(0xFFEF4444),
      onPrimary: Colors.white,
      onSurface: lightTextPrimary,
    ),
    cardTheme: const CardThemeData(
      color: lightCard,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: lightBorder, width: 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBg,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: lightTextPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(color: lightTextPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: lightBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: lightBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryIndigo, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      labelStyle: const TextStyle(color: lightTextSecondary),
      hintStyle: const TextStyle(color: lightTextSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryIndigo,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: lightSurface,
      selectedColor: primaryIndigo,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      side: const BorderSide(color: lightBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: lightTextPrimary, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1.5),
      headlineLarge: TextStyle(color: lightTextPrimary, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1),
      headlineMedium: TextStyle(color: lightTextPrimary, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5),
      titleLarge: TextStyle(color: lightTextPrimary, fontSize: 18, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: lightTextPrimary, fontSize: 15, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: lightTextPrimary, fontSize: 16, height: 1.6),
      bodyMedium: TextStyle(color: lightTextSecondary, fontSize: 14, height: 1.5),
      bodySmall: TextStyle(color: lightTextSecondary, fontSize: 12),
      labelLarge: TextStyle(color: lightTextPrimary, fontSize: 13, fontWeight: FontWeight.w600),
    ),
  );
}
