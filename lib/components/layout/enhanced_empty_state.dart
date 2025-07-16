import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

/// Enhanced empty state component for iOS 18 design
class EnhancedEmptyState extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;
  final double iconSize;
  final Color? iconColor;

  const EnhancedEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
    this.iconSize = 80,
    this.iconColor,
  });

  @override
  State<EnhancedEmptyState> createState() => _EnhancedEmptyStateState();
}

class _EnhancedEmptyStateState extends State<EnhancedEmptyState>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: AppAnimations.pageTransition,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: AppAnimations.smooth),
    );

    // Start animations
    _fadeController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _fadeController]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated icon with glassmorphic background
                Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: widget.iconSize + 32,
                    height: widget.iconSize + 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                AppColors.darkGlass.withValues(alpha: 0.2),
                                AppColors.darkGlass.withValues(alpha: 0.1),
                              ]
                            : [
                                AppColors.lightGlass.withValues(alpha: 0.3),
                                AppColors.lightGlass.withValues(alpha: 0.1),
                              ],
                      ),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkGlassStroke.withValues(alpha: 0.2)
                            : AppColors.lightGlassStroke.withValues(alpha: 0.2),
                        width: 0.5,
                      ),
                    ),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Icon(
                          widget.icon,
                          size: widget.iconSize,
                          color:
                              widget.iconColor ??
                              (isDark
                                  ? AppColors.darkOnSurface.withValues(alpha: 0.4)
                                  : AppColors.lightOnSurface.withValues(alpha: 0.4)),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  widget.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDark
                        ? AppColors.darkOnSurface.withValues(alpha: 0.8)
                        : AppColors.lightOnSurface.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  widget.subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? AppColors.darkOnSurface.withValues(alpha: 0.6)
                        : AppColors.lightOnSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Action button
                if (widget.action != null) ...[
                  const SizedBox(height: 32),
                  widget.action!,
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
