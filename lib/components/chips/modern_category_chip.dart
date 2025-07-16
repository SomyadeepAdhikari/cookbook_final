import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

/// Modern, iOS 18-inspired category chip with glow effects and animations
class ModernCategoryChip extends StatefulWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showNotification;

  const ModernCategoryChip({
    super.key,
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
    this.showNotification = false,
  });

  @override
  State<ModernCategoryChip> createState() => _ModernCategoryChipState();
}

class _ModernCategoryChipState extends State<ModernCategoryChip>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late AnimationController _notificationController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _notificationAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: AppAnimations.cardTap,
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _notificationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: AppAnimations.smooth),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _notificationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _notificationController,
        curve: Curves.elasticOut,
      ),
    );

    if (widget.isSelected) {
      _glowController.repeat(reverse: true);
    }

    if (widget.showNotification) {
      _notificationController.forward();
    }
  }

  @override
  void didUpdateWidget(ModernCategoryChip oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _glowController.repeat(reverse: true);
      } else {
        _glowController.stop();
        _glowController.reset();
      }
    }

    if (widget.showNotification != oldWidget.showNotification) {
      if (widget.showNotification) {
        _notificationController.forward();
      } else {
        _notificationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    _notificationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _glowAnimation,
        _notificationAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.onTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Glow effect for selected state
                if (widget.isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.secondary.withOpacity(
                            0.3 * _glowAnimation.value,
                          ),
                          blurRadius: 20 * _glowAnimation.value,
                          spreadRadius: 2 * _glowAnimation.value,
                        ),
                      ],
                    ),
                  ),

                // Main chip container
                AnimatedContainer(
                  duration: AppAnimations.fast,
                  curve: AppAnimations.smooth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: widget.isSelected
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.secondary,
                              theme.colorScheme.secondary.withOpacity(0.8),
                            ],
                          )
                        : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isDark
                                ? AppColors.darkCardGradient
                                : AppColors.cardGradient,
                          ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.isSelected
                          ? theme.colorScheme.secondary.withOpacity(0.3)
                          : isDark
                          ? AppColors.darkGlassStroke
                          : AppColors.lightGlassStroke,
                      width: widget.isSelected ? 1.5 : 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.isSelected
                            ? theme.colorScheme.secondary.withOpacity(0.2)
                            : isDark
                            ? AppColors.darkShadow
                            : AppColors.lightShadow,
                        blurRadius: widget.isSelected ? 12 : 8,
                        offset: Offset(0, widget.isSelected ? 6 : 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Emoji with background
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: widget.isSelected
                              ? Colors.white.withOpacity(0.2)
                              : theme.colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            widget.emoji,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Label
                      Text(
                        widget.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: widget.isSelected
                              ? Colors.white
                              : isDark
                              ? AppColors.darkOnSurface
                              : AppColors.lightOnSurface,
                          fontWeight: widget.isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          fontSize: 13,
                          letterSpacing: widget.isSelected ? 0.2 : 0,
                        ),
                      ),

                      // Selection indicator
                      if (widget.isSelected) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Notification badge
                if (widget.showNotification)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Transform.scale(
                      scale: _notificationAnimation.value,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBackground
                                : AppColors.lightBackground,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.error.withOpacity(0.3),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
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
