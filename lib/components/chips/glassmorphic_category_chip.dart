import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

/// Enhanced glassmorphic category chip with modern iOS 18 design
class GlassmorphicCategoryChip extends StatefulWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final bool isActive;
  final VoidCallback onTap;
  final EdgeInsets margin;

  const GlassmorphicCategoryChip({
    super.key,
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
    this.isActive = true,
    this.margin = const EdgeInsets.only(right: 12),
  });

  @override
  State<GlassmorphicCategoryChip> createState() =>
      _GlassmorphicCategoryChipState();
}

class _GlassmorphicCategoryChipState extends State<GlassmorphicCategoryChip>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _selectionController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      duration: AppAnimations.cardTap,
      vsync: this,
    );

    _selectionController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _pressController, curve: AppAnimations.smooth),
    );

    _elevationAnimation = Tween<double>(begin: 8.0, end: 16.0).animate(
      CurvedAnimation(parent: _pressController, curve: AppAnimations.smooth),
    );

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isSelected) {
      _selectionController.value = 1.0;
    }

    // Start pulse animation for selected chips
    if (widget.isSelected) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(GlassmorphicCategoryChip oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _selectionController.forward();
        _pulseController.repeat(reverse: true);
      } else {
        _selectionController.reverse();
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _selectionController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isActive) return;

    _pressController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isActive) return;

    _pressController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    if (!widget.isActive) return;

    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: widget.margin,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _pressController,
          _selectionController,
          _pulseController,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    // Base shadow
                    BoxShadow(
                      color: (isDark ? Colors.black : Colors.grey.shade400)
                          .withOpacity(isDark ? 0.6 : 0.15),
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                    // Selection glow
                    if (widget.isSelected)
                      BoxShadow(
                        color: theme.colorScheme.secondary.withOpacity(
                          0.3 + (_pulseAnimation.value * 0.2),
                        ),
                        blurRadius: 15 + (_pulseAnimation.value * 5),
                        offset: const Offset(0, 0),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _getGradientColors(theme, isDark),
                        ),
                        border: Border.all(
                          color: _getBorderColor(theme, isDark),
                          width: widget.isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Emoji
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.isSelected
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  widget.emoji,
                                  style: const TextStyle(
                                    fontSize: 14,
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
                                fontWeight: widget.isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                fontSize: 14,
                                color: _getTextColor(theme, isDark),
                                letterSpacing: -0.2,
                              ),
                            ),

                            // Selection indicator
                            if (widget.isSelected) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getIndicatorColor(theme, isDark),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
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

  List<Color> _getGradientColors(ThemeData theme, bool isDark) {
    if (!widget.isActive) {
      return isDark
          ? [
              AppColors.darkCardGradient[0].withOpacity(0.3),
              AppColors.darkCardGradient[1].withOpacity(0.3),
            ]
          : [
              AppColors.cardGradient[0].withOpacity(0.3),
              AppColors.cardGradient[1].withOpacity(0.3),
            ];
    }

    if (widget.isSelected) {
      return [
        theme.colorScheme.secondary.withOpacity(0.9),
        theme.colorScheme.secondary.withOpacity(0.7),
      ];
    }

    return isDark
        ? [
            AppColors.darkCardGradient[0].withOpacity(0.8),
            AppColors.darkCardGradient[1].withOpacity(0.6),
          ]
        : [
            AppColors.cardGradient[0].withOpacity(0.8),
            AppColors.cardGradient[1].withOpacity(0.6),
          ];
  }

  Color _getBorderColor(ThemeData theme, bool isDark) {
    if (!widget.isActive) {
      return isDark
          ? AppColors.darkGlassStroke.withOpacity(0.3)
          : AppColors.lightGlassStroke.withOpacity(0.3);
    }

    if (widget.isSelected) {
      return theme.colorScheme.secondary.withOpacity(0.8);
    }

    return isDark ? AppColors.darkGlassStroke : AppColors.lightGlassStroke;
  }

  Color _getTextColor(ThemeData theme, bool isDark) {
    if (!widget.isActive) {
      return isDark
          ? AppColors.darkOnSurface.withOpacity(0.5)
          : AppColors.lightOnSurface.withOpacity(0.5);
    }

    if (widget.isSelected) {
      return Colors.white;
    }

    return isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
  }

  Color _getIndicatorColor(ThemeData theme, bool isDark) {
    return widget.isSelected ? Colors.white : theme.colorScheme.secondary;
  }
}

/// Chip section with horizontal scrolling
class GlassmorphicChipSection extends StatelessWidget {
  final List<Map<String, String>> categories;
  final String selectedCategory;
  final Function(String) onCategoryChanged;
  final EdgeInsets padding;
  final double height;

  const GlassmorphicChipSection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category['name'];

          return GlassmorphicCategoryChip(
            label: category['name']!,
            emoji: category['emoji']!,
            isSelected: isSelected,
            onTap: () => onCategoryChanged(category['name']!),
            margin: EdgeInsets.only(
              right: index < categories.length - 1 ? 12 : 0,
            ),
          );
        },
      ),
    );
  }
}
