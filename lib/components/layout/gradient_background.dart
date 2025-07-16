import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/colors.dart';

/// A glassmorphic background with blur effect for iOS 18-style design
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final bool? isDark;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIsDark = isDark ?? (theme.brightness == Brightness.dark);
    final gradientColors =
        colors ??
        (effectiveIsDark ? AppColors.darkGradient : AppColors.lightGradient);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: child,
    );
  }
}

/// A glassmorphic container with blur effects
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double opacity;
  final Color? color;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.opacity = 0.1,
    this.color,
    this.border,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? AppColors.darkGlass : AppColors.lightGlass;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: (color ?? defaultColor).withOpacity(opacity),
        borderRadius: BorderRadius.circular(borderRadius),
        border:
            border ??
            Border.all(
              color: isDark
                  ? AppColors.darkGlassStroke
                  : AppColors.lightGlassStroke,
              width: 1,
            ),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.darkShadow : AppColors.lightShadow,
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(isDark ? 0.1 : 0.2),
                  Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A neumorphic container for subtle depth effects
class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final bool isPressed;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isPressed
            ? [
                BoxShadow(
                  color: isDark ? Colors.black54 : Colors.grey.shade400,
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ]
            : [
                BoxShadow(
                  color: isDark ? Colors.black87 : Colors.grey.shade300,
                  offset: const Offset(8, 8),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: isDark ? Colors.grey.shade800 : Colors.white,
                  offset: const Offset(-8, -8),
                  blurRadius: 16,
                ),
              ],
      ),
      child: child,
    );
  }
}
