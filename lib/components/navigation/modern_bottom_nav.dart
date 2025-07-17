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
          // Enhanced shadow for better depth
          BoxShadow(
            color: isDark 
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.grey.shade300.withValues(alpha: 0.3),
            blurRadius: 25,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
          if (isDark)
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.03),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              // Enhanced glassmorphic background
              color: isDark
                  ? const Color(0xFF1C1C1E).withValues(alpha: 0.85)
                  : Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.white.withValues(alpha: 0.02),
                        const Color(0xFF2C2C2E).withValues(alpha: 0.4),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.3),
                        Colors.white.withValues(alpha: 0.15),
                        Colors.grey.shade50.withValues(alpha: 0.1),
                      ],
                stops: const [0.0, 0.5, 1.0],
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
                                  // Icon with enhanced glassmorphic background
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? (isDark
                                              ? theme.colorScheme.secondary.withValues(alpha: 0.15)
                                              : theme.colorScheme.secondary.withValues(alpha: 0.12))
                                          : Colors.transparent,
                                      // Enhanced glassmorphic effect for active state
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: isDark
                                                    ? theme.colorScheme.secondary.withValues(alpha: 0.2)
                                                    : theme.colorScheme.secondary.withValues(alpha: 0.1),
                                                blurRadius: 8,
                                                spreadRadius: 0,
                                              ),
                                            ]
                                          : null,
                                      border: isSelected
                                          ? Border.all(
                                              color: isDark
                                                  ? theme.colorScheme.secondary.withValues(alpha: 0.3)
                                                  : theme.colorScheme.secondary.withValues(alpha: 0.2),
                                              width: 1,
                                            )
                                          : null,
                                    ),
                                    child: Icon(
                                      isSelected ? item.activeIcon : item.icon,
                                      size: 22,
                                      color: isSelected
                                          ? (isDark 
                                              ? theme.colorScheme.secondary.withValues(alpha: 0.95)
                                              : theme.colorScheme.secondary)
                                          : (isDark
                                                ? AppColors.darkOnSurface.withValues(alpha: 0.7)
                                                : AppColors.lightOnSurface.withValues(alpha: 0.65)),
                                    ),
                                  ),

                                  const SizedBox(height: 2),

                                  // Label with enhanced dark mode styling
                                  Flexible(
                                    child: AnimatedDefaultTextStyle(
                                      duration: AppAnimations.fast,
                                      style: theme.textTheme.labelSmall!
                                          .copyWith(
                                            color: isSelected
                                                ? (isDark
                                                    ? theme.colorScheme.secondary.withValues(alpha: 0.9)
                                                    : theme.colorScheme.secondary)
                                                : (isDark
                                                      ? AppColors.darkOnSurface.withValues(alpha: 0.7)
                                                      : AppColors.lightOnSurface.withValues(alpha: 0.65)),
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                            fontSize: 10,
                                            letterSpacing: 0.2,
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
