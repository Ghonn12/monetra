import 'package:flutter/material.dart';

class AppTheme {
  // MAIN PALETTE
  static const Color primary = Color(0xFF1A3E5C);
  static const Color secondary = Color(0xFF28A745);
  static const Color background = Color(0xFFF4F8F9); // Warna putih kustom Anda

  // ACCENT PALETTE
  static const Color error = Color(0xFFE63946);
  static const Color warning = Color(0xFFFFC107);
  static const Color textDark = Color(0xFF4A444A);

  // --- TEMA TERANG ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      error: error,
      background: background,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: textDark,
      onError: Colors.white,
      surface: Colors.white, // Warna Card
      onSurface: textDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primary, width: 2),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: textDark.withOpacity(0.6),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );

  // --- TEMA GELAP ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: Color(0xFF121212),
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      error: error,
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E), // Warna Card
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xFFE0E0E0),
      onError: Colors.white,
      onSurface: Color(0xFFE0E0E0),
    ),
    appBarTheme: lightTheme.appBarTheme,
    elevatedButtonTheme: lightTheme.elevatedButtonTheme,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primary, width: 2),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: primary,
      unselectedItemColor: Colors.grey[400],
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}