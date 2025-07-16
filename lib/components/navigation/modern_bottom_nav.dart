import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

/// Modern glassmorphic bottom navigation bar with iOS 18-inspired design
class ModernBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<ModernBottomNavItem> items;

  const ModernBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<ModernBottomNav> createState() => _ModernBottomNavState();
}

class _ModernBottomNavState extends State<ModernBottomNav>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      widget.items.length,
      (index) =>
          AnimationController(duration: AppAnimations.medium, vsync: this),
    );

    _scaleAnimations = _animationControllers
        .map(
          (controller) => Tween<double>(begin: 1.0, end: 1.2).animate(
            CurvedAnimation(
              parent: controller,
              curve: AppAnimations.elasticOut,
            ),
          ),
        )
        .toList();

    _slideAnimations = _animationControllers
        .map(
          (controller) => Tween<double>(begin: 0.0, end: -4.0).animate(
            CurvedAnimation(parent: controller, curve: AppAnimations.smooth),
          ),
        )
        .toList();

    // Animate the initially selected item
    if (widget.currentIndex < _animationControllers.length) {
      _animationControllers[widget.currentIndex].forward();
    }
  }

  @override
  void didUpdateWidget(ModernBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      // Reset previous animation
      if (oldWidget.currentIndex < _animationControllers.length) {
        _animationControllers[oldWidget.currentIndex].reverse();
      }
      // Start new animation
      if (widget.currentIndex < _animationControllers.length) {
        _animationControllers[widget.currentIndex].forward();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.darkShadow : AppColors.lightShadow,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.9)
                  : AppColors.lightSurface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isDark
                    ? AppColors.darkGlassStroke
                    : AppColors.lightGlassStroke,
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: isDark ? 0.1 : 0.2),
                  Colors.white.withValues(alpha: isDark ? 0.05 : 0.1),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(widget.items.length, (index) {
                final item = widget.items[index];
                final isSelected = index == widget.currentIndex;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.onTap(index);
                      // Add haptic feedback
                      // HapticFeedback.lightImpact();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: AnimatedBuilder(
                        animation: Listenable.merge([
                          _scaleAnimations[index],
                          _slideAnimations[index],
                        ]),
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _slideAnimations[index].value),
                            child: Transform.scale(
                              scale: _scaleAnimations[index].value,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon with animated background
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? theme.colorScheme.secondary
                                                .withValues(alpha: 0.2)
                                          : Colors.transparent,
                                    ),
                                    child: Icon(
                                      isSelected ? item.activeIcon : item.icon,
                                      size: 24,
                                      color: isSelected
                                          ? theme.colorScheme.secondary
                                          : (isDark
                                                ? AppColors.darkOnSurface
                                                      .withValues(alpha: 0.6)
                                                : AppColors.lightOnSurface
                                                      .withValues(alpha: 0.6)),
                                    ),
                                  ),

                                  const SizedBox(height: 1),

                                  // Label with smooth transitions
                                  Flexible(
                                    child: AnimatedDefaultTextStyle(
                                      duration: AppAnimations.fast,
                                      style: theme.textTheme.labelSmall!
                                          .copyWith(
                                            color: isSelected
                                                ? theme.colorScheme.secondary
                                                : (isDark
                                                      ? AppColors.darkOnSurface
                                                            .withValues(alpha: 0.6)
                                                      : AppColors.lightOnSurface
                                                            .withValues(alpha: 0.6)),
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            fontSize: 10,
                                          ),
                                      child: Text(
                                        item.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

/// Data class for bottom navigation items
class ModernBottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const ModernBottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}
