import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme/colors.dart';

/// Enhanced animated favorite button with glow effects and beautiful animations
class EnhancedFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const EnhancedFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
    this.size = 32,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<EnhancedFavoriteButton> createState() => _EnhancedFavoriteButtonState();
}

class _EnhancedFavoriteButtonState extends State<EnhancedFavoriteButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late AnimationController _glowController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    if (widget.isFavorite) {
      _glowController.forward();
    }
  }

  @override
  void didUpdateWidget(EnhancedFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      if (widget.isFavorite) {
        _bounceController.forward().then((_) => _bounceController.reverse());
        _glowController.forward();
        _pulseController.repeat();
      } else {
        _glowController.reverse();
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final activeColor = widget.activeColor ?? AppColors.error;
    final inactiveColor =
        widget.inactiveColor ??
        (isDark
            ? AppColors.darkOnSurface.withValues(alpha: 0.4)
            : AppColors.lightOnSurface.withValues(alpha: 0.4));

    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseController,
        _bounceController,
        _glowController,
      ]),
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTap();
          },
          child: SizedBox(
            width: widget.size + 20,
            height: widget.size + 20,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow effect
                if (widget.isFavorite)
                  Container(
                    width: (widget.size + 10) * _pulseAnimation.value,
                    height: (widget.size + 10) * _pulseAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          activeColor.withValues(
                            alpha: 0.4 * _glowAnimation.value,
                          ),
                          activeColor.withValues(
                            alpha: 0.1 * _glowAnimation.value,
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                // Backdrop blur container
                ClipRRect(
                  borderRadius: BorderRadius.circular(widget.size),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: widget.size + 16,
                      height: widget.size + 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  AppColors.darkGlass.withValues(alpha: 0.8),
                                  AppColors.darkGlass.withValues(alpha: 0.6),
                                ]
                              : [
                                  AppColors.lightGlass.withValues(alpha: 0.8),
                                  AppColors.lightGlass.withValues(alpha: 0.6),
                                ],
                        ),
                        border: Border.all(
                          color: widget.isFavorite
                              ? activeColor.withValues(alpha: 0.6)
                              : (isDark
                                    ? AppColors.darkGlassStroke
                                    : AppColors.lightGlassStroke),
                          width: widget.isFavorite ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.isFavorite
                                ? activeColor.withValues(alpha: 0.3)
                                : (isDark ? Colors.black : Colors.grey.shade300)
                                      .withValues(alpha: 0.2),
                            blurRadius: widget.isFavorite ? 20 : 12,
                            spreadRadius: widget.isFavorite ? 2 : 0,
                          ),
                        ],
                      ),
                      child: Transform.scale(
                        scale: _bounceAnimation.value,
                        child: Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: Icon(
                            widget.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: widget.size,
                            color: widget.isFavorite
                                ? activeColor
                                : inactiveColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Shimmer effect when favorited
                if (widget.isFavorite)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _glowController,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(
                                  alpha: 0.3 * _glowAnimation.value,
                                ),
                                Colors.transparent,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
