import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// Elegant text-based loading indicator with subtle animations
class ElegantLoadingText extends StatefulWidget {
  final String message;
  final TextStyle? style;
  final bool showDots;
  final Duration animationDuration;

  const ElegantLoadingText({
    super.key,
    this.message = 'Loading',
    this.style,
    this.showDots = true,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<ElegantLoadingText> createState() => _ElegantLoadingTextState();
}

class _ElegantLoadingTextState extends State<ElegantLoadingText>
    with TickerProviderStateMixin {
  late AnimationController _dotsController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _dot1Animation;
  late Animation<double> _dot2Animation;
  late Animation<double> _dot3Animation;

  @override
  void initState() {
    super.initState();

    _dotsController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Staggered dot animations
    _dot1Animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _dotsController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _dot2Animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _dotsController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeInOut),
      ),
    );

    _dot3Animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _dotsController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeInOut),
      ),
    );

    _dotsController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _dotsController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([_dotsController, _pulseController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        AppColors.darkGlass.withOpacity(0.3),
                        AppColors.darkGlass.withOpacity(0.1),
                      ]
                    : [
                        AppColors.lightGlass.withOpacity(0.3),
                        AppColors.lightGlass.withOpacity(0.1),
                      ],
              ),
              border: Border.all(
                color: isDark
                    ? AppColors.darkGlassStroke.withOpacity(0.3)
                    : AppColors.lightGlassStroke.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.message,
                  style:
                      widget.style ??
                      theme.textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? AppColors.darkOnSurface.withOpacity(0.8)
                            : AppColors.lightOnSurface.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                ),
                if (widget.showDots) ...[
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      _buildDot(_dot1Animation.value, theme, isDark),
                      const SizedBox(width: 4),
                      _buildDot(_dot2Animation.value, theme, isDark),
                      const SizedBox(width: 4),
                      _buildDot(_dot3Animation.value, theme, isDark),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDot(double opacity, ThemeData theme, bool isDark) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.secondary.withOpacity(opacity),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.secondary.withOpacity(opacity * 0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

/// Simple elegant loading text without animations
class SimpleLoadingText extends StatelessWidget {
  final String message;
  final TextStyle? style;
  final Widget? icon;

  const SimpleLoadingText({
    super.key,
    this.message = 'Loading...',
    this.style,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark
            ? AppColors.darkGlass.withOpacity(0.2)
            : AppColors.lightGlass.withOpacity(0.2),
        border: Border.all(
          color: isDark
              ? AppColors.darkGlassStroke.withOpacity(0.3)
              : AppColors.lightGlassStroke.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Text(
            message,
            style:
                style ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkOnSurface.withOpacity(0.7)
                      : AppColors.lightOnSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
