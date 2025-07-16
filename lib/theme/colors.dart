import 'package:flutter/material.dart';

/// iOS 18-inspired color palette for the cookbook app
class AppColors {
  // Light theme colors
  static const Color lightPrimary = Color(0xFFFEFEFE);
  static const Color lightSecondary = Color(0xFFFF6B6B);
  static const Color lightAccent = Color(0xFFFFE66D);
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnPrimary = Color(0xFF1A1A1A);
  static const Color lightOnSurface = Color(0xFF2D3748);
  static const Color lightCardBackground = Color(0xFFFBFBFB);

  // Glassmorphism colors
  static const Color lightGlass = Color(0x30FFFFFF);
  static const Color lightGlassStroke = Color(0x20FFFFFF);

  // Dark theme colors
  static const Color darkPrimary = Color(0xFF1A1A1A);
  static const Color darkSecondary = Color(0xFFFF7875);
  static const Color darkAccent = Color(0xFFFFD93D);
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF1C1C1E);
  static const Color darkOnPrimary = Color(0xFFF2F2F7);
  static const Color darkOnSurface = Color(0xFFE5E5E7);
  static const Color darkCardBackground = Color(0xFF2C2C2E);

  // Glassmorphism colors for dark theme
  static const Color darkGlass = Color(0x30000000);
  static const Color darkGlassStroke = Color(0x20FFFFFF);

  // Gradient colors
  static const List<Color> lightGradient = [
    Color(0xFFF8F9FA),
    Color(0xFFE9ECEF),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF1A1A1A),
    Color(0xFF2D2D30),
  ];

  static const List<Color> accentGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFFFE66D),
  ];

  static const List<Color> cardGradient = [
    Color(0xFFFBFBFB),
    Color(0xFFF0F0F0),
  ];

  static const List<Color> darkCardGradient = [
    Color(0xFF2C2C2E),
    Color(0xFF3C3C3E),
  ];

  // Shadow colors - lighter shadows for light mode, subtle for dark mode
  static const Color lightShadow = Color(0x05000000); // Much lighter shadow
  static const Color darkShadow = Color(0x20000000); // Reduced dark shadow

  // Status colors
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}
