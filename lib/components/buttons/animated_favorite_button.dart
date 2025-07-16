import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

/// An animated favorite button with scale and color transitions
class AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final double size;
  final Color? favoriteColor;
  final Color? unfavoriteColor;

  const AnimatedFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
    this.size = 32,
    this.favoriteColor,
    this.unfavoriteColor,
  });

  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: AppAnimations.favoriteAnimation,
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: AppAnimations.favoriteAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: AppAnimations.elasticOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _rotationController, curve: AppAnimations.smooth),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();

    // Trigger animations
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    if (widget.isFavorite) {
      _rotationController.forward().then((_) {
        _rotationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoriteColor = widget.favoriteColor ?? AppColors.error;
    final unfavoriteColor =
        widget.unfavoriteColor ??
        (isDark
            ? AppColors.darkOnSurface.withValues(alpha: 0.6)
            : AppColors.lightOnSurface.withValues(alpha: 0.6));

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: widget.size + 16,
                height: widget.size + 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.9),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? AppColors.darkShadow
                          : AppColors.lightShadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: AppAnimations.fast,
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      widget.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      key: ValueKey(widget.isFavorite),
                      size: widget.size,
                      color: widget.isFavorite
                          ? favoriteColor
                          : unfavoriteColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
