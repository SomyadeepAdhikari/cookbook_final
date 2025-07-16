import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';

/// Modern iOS 18-inspired theme for the cookbook app
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'ArialRounded', // Fallback to existing font
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightSecondary,
        tertiary: AppColors.lightAccent,
        surface: AppColors.lightSurface,
        onPrimary: AppColors.lightOnPrimary,
        onSecondary: Colors.white,
        onSurface: AppColors.lightOnSurface,
        error: AppColors.error,
      ),

      scaffoldBackgroundColor: AppColors.lightBackground,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface.withValues(alpha: 0.9),
        elevation: 0,
        toolbarHeight: 90,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineMedium.copyWith(
          color: AppColors.lightOnSurface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.lightSecondary,
          size: 28,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface.withValues(alpha: 0.95),
        selectedItemColor: AppColors.lightSecondary,
        unselectedItemColor: AppColors.lightOnSurface.withValues(alpha: 0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.labelSmall,
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.lightCardBackground,
        elevation: 8,
        shadowColor: AppColors.lightShadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(
          color: AppColors.lightOnSurface,
        ),
        displayMedium: AppTypography.displayMedium.copyWith(
          color: AppColors.lightOnSurface,
        ),
        displaySmall: AppTypography.displaySmall.copyWith(
          color: AppColors.lightOnSurface,
        ),
        headlineLarge: AppTypography.headlineLarge.copyWith(
          color: AppColors.lightOnSurface,
        ),
        headlineMedium: AppTypography.headlineMedium.copyWith(
          color: AppColors.lightOnSurface,
        ),
        headlineSmall: AppTypography.headlineSmall.copyWith(
          color: AppColors.lightOnSurface,
        ),
        titleLarge: AppTypography.titleLarge.copyWith(
          color: AppColors.lightOnSurface,
        ),
        titleMedium: AppTypography.titleMedium.copyWith(
          color: AppColors.lightOnSurface,
        ),
        titleSmall: AppTypography.titleSmall.copyWith(
          color: AppColors.lightOnSurface,
        ),
        bodyLarge: AppTypography.bodyLarge.copyWith(
          color: AppColors.lightOnSurface,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightOnSurface,
        ),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: AppColors.lightOnSurface,
        ),
        labelLarge: AppTypography.labelLarge.copyWith(
          color: AppColors.lightOnSurface,
        ),
        labelMedium: AppTypography.labelMedium.copyWith(
          color: AppColors.lightOnSurface,
        ),
        labelSmall: AppTypography.labelSmall.copyWith(
          color: AppColors.lightOnSurface,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.lightOnSurface.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.lightSecondary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightOnSurface.withValues(alpha: 0.6),
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightSecondary,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: AppColors.lightSecondary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedColor: AppColors.lightSecondary,
        disabledColor: AppColors.lightOnSurface.withValues(alpha: 0.1),
        labelStyle: AppTypography.chipText.copyWith(
          color: AppColors.lightOnSurface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'ArialRounded', // Fallback to existing font
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkSecondary,
        tertiary: AppColors.darkAccent,
        surface: AppColors.darkSurface,
        onPrimary: AppColors.darkOnPrimary,
        onSecondary: Colors.black,
        onSurface: AppColors.darkOnSurface,
        error: AppColors.error,
      ),

      scaffoldBackgroundColor: AppColors.darkBackground,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface.withValues(alpha: 0.9),
        elevation: 0,
        toolbarHeight: 90,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineMedium.copyWith(
          color: AppColors.darkOnSurface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.darkSecondary,
          size: 28,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface.withValues(alpha: 0.95),
        selectedItemColor: AppColors.darkSecondary,
        unselectedItemColor: AppColors.darkOnSurface.withValues(alpha: 0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.labelSmall,
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.darkCardBackground,
        elevation: 8,
        shadowColor: AppColors.darkShadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(
          color: AppColors.darkOnSurface,
        ),
        displayMedium: AppTypography.displayMedium.copyWith(
          color: AppColors.darkOnSurface,
        ),
        displaySmall: AppTypography.displaySmall.copyWith(
          color: AppColors.darkOnSurface,
        ),
        headlineLarge: AppTypography.headlineLarge.copyWith(
          color: AppColors.darkOnSurface,
        ),
        headlineMedium: AppTypography.headlineMedium.copyWith(
          color: AppColors.darkOnSurface,
        ),
        headlineSmall: AppTypography.headlineSmall.copyWith(
          color: AppColors.darkOnSurface,
        ),
        titleLarge: AppTypography.titleLarge.copyWith(
          color: AppColors.darkOnSurface,
        ),
        titleMedium: AppTypography.titleMedium.copyWith(
          color: AppColors.darkOnSurface,
        ),
        titleSmall: AppTypography.titleSmall.copyWith(
          color: AppColors.darkOnSurface,
        ),
        bodyLarge: AppTypography.bodyLarge.copyWith(
          color: AppColors.darkOnSurface,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkOnSurface,
        ),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: AppColors.darkOnSurface,
        ),
        labelLarge: AppTypography.labelLarge.copyWith(
          color: AppColors.darkOnSurface,
        ),
        labelMedium: AppTypography.labelMedium.copyWith(
          color: AppColors.darkOnSurface,
        ),
        labelSmall: AppTypography.labelSmall.copyWith(
          color: AppColors.darkOnSurface,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.darkOnSurface.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.darkSecondary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkOnSurface.withValues(alpha: 0.6),
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkSecondary,
          foregroundColor: Colors.black,
          elevation: 8,
          shadowColor: AppColors.darkSecondary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedColor: AppColors.darkSecondary,
        disabledColor: AppColors.darkOnSurface.withValues(alpha: 0.1),
        labelStyle: AppTypography.chipText.copyWith(
          color: AppColors.darkOnSurface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
      ),
    );
  }
}
