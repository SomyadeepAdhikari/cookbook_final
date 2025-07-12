import 'package:flutter/material.dart';

// Theme Provider for Light/Dark Mode
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      fontFamily: 'ArialRounded',
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        color: Color(0xFFFDFAF6),
        toolbarHeight: 75,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        ),
        shadowColor: Color(0xFFFFF0BD),
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 26,
          fontFamily: 'ArialRounded',
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          fontFamily: 'ArialRounded',
        ),
        bodySmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          fontFamily: 'ArialRounded',
        ),
      ),
      primaryColor: Color(0xFFFDFAF6),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Color(0xFFFFA726),
        tertiary: Color(0xFFEBE5C2),
        error: Color(0xFFD32F2F),
        brightness: Brightness.light,
        primary: Color(0xFFFDFAF6),
        surface: Color(0xFFE4EFE7),
        onPrimary: Color(0xFF2C3E50),
        onSecondary: Color(0xFF2C3E50),
        onSurface: Color(0xFF2C3E50),
      ),
      scaffoldBackgroundColor: Color(0xFFF8F3D9),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'ArialRounded',
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        color: Color(0xFF1A1A1A),
        toolbarHeight: 75,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        shadowColor: Color(0xFF4A4A4A),
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 26,
          fontFamily: 'ArialRounded',
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          fontFamily: 'ArialRounded',
        ),
        bodySmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          fontFamily: 'ArialRounded',
        ),
      ),
      primaryColor: Color(0xFF2C2C2C),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Color(0xFFFFB74D),
        error: Color(0xFFEF5350),
        brightness: Brightness.dark,
        primary: Color(0xFF2C2C2C),
        surface: Color(0xFF1A1A1A),
        onPrimary: Color(0xFFE0E0E0),
        onSecondary: Color(0xFF1A1A1A),
        onSurface: Color(0xFFE0E0E0),
      ),
      scaffoldBackgroundColor: Color(0xFF121212),
    );
  }
}
