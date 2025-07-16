import 'package:flutter/material.dart';

/// iOS 18-inspired typography system
class AppTypography {
  // Base font family - using existing ArialRounded for now
  static String get fontFamily => 'ArialRounded';

  // Display text styles
  static TextStyle get displayLarge => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get displayMedium => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
  );

  static TextStyle get displaySmall => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  // Headline text styles
  static TextStyle get headlineLarge => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );

  static TextStyle get headlineMedium => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
  );

  static TextStyle get headlineSmall => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.4,
  );

  // Title text styles
  static TextStyle get titleLarge => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static TextStyle get titleMedium => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static TextStyle get titleSmall => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5,
  );

  // Body text styles
  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.6,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.5,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.4,
  );

  // Label text styles
  static TextStyle get labelLarge => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static TextStyle get labelMedium => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.3,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.2,
  );

  // Custom recipe app specific styles
  static TextStyle get recipeTitleLarge => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.2,
  );

  static TextStyle get recipeTitleMedium => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  static TextStyle get recipeSubtitle => TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.4,
    color: Colors.grey[600],
  );

  static TextStyle get buttonText => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    height: 1.2,
  );

  static TextStyle get chipText => const TextStyle(
    fontFamily: 'ArialRounded',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.2,
  );
}
