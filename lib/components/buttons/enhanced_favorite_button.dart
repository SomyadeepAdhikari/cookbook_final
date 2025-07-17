import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';

/// Enhanced favorite button with modern iOS 18 design - simplified and elegant
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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown() {
    _animationController.forward();
  }

  void _handleTapUp() {
    _animationController.reverse();
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final activeColor = widget.activeColor ?? Colors.red;
    final inactiveColor =
        widget.inactiveColor ??
        (isDark
            ? AppColors.darkOnSurface.withOpacity(0.6)
            : AppColors.lightOnSurface.withOpacity(0.6));

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => _handleTapDown(),
          onTapUp: (_) => _handleTapUp(),
          onTapCancel: _handleTapCancel,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size + 16,
              height: widget.size + 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isFavorite
                    ? activeColor.withOpacity(0.1)
                    : (isDark
                        ? AppColors.darkSurface.withOpacity(0.3)
                        : AppColors.lightSurface.withOpacity(0.3)),
                border: widget.isFavorite
                    ? Border.all(
                        color: activeColor.withOpacity(0.3),
                        width: 1.5,
                      )
                    : null,
                boxShadow: widget.isFavorite
                    ? [
                        BoxShadow(
                          color: activeColor.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: (isDark ? Colors.black : Colors.grey.shade400)
                              .withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    key: ValueKey(widget.isFavorite),
                    size: widget.size,
                    color: widget.isFavorite ? activeColor : inactiveColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
