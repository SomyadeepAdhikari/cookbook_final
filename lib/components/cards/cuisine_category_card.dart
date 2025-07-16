import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

class CuisineCategoryCard extends StatefulWidget {
  final String cuisineName;
  final String emoji;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const CuisineCategoryCard({
    super.key,
    required this.cuisineName,
    required this.emoji,
    required this.description,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  State<CuisineCategoryCard> createState() => _CuisineCategoryCardState();
}

class _CuisineCategoryCardState extends State<CuisineCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.isSelected
                        ? theme.colorScheme.secondary.withOpacity(0.3)
                        : (isDark
                              ? AppColors.darkShadow
                              : AppColors.lightShadow),
                    blurRadius: _isPressed ? 8 : 16,
                    offset: Offset(0, _isPressed ? 4 : 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isSelected
                            ? [
                                theme.colorScheme.secondary.withOpacity(0.8),
                                theme.colorScheme.secondary.withOpacity(0.6),
                              ]
                            : isDark
                            ? AppColors.darkCardGradient
                            : AppColors.cardGradient,
                      ),
                      border: Border.all(
                        color: widget.isSelected
                            ? theme.colorScheme.secondary.withOpacity(0.5)
                            : (isDark
                                  ? AppColors.darkGlassStroke
                                  : AppColors.lightGlassStroke),
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Shimmer effect for selected state
                        if (widget.isSelected)
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _shimmerAnimation,
                              builder: (context, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(
                                        -1.0 + 2.0 * _shimmerAnimation.value,
                                        0.0,
                                      ),
                                      end: Alignment(
                                        1.0 + 2.0 * _shimmerAnimation.value,
                                        0.0,
                                      ),
                                      colors: [
                                        Colors.transparent,
                                        Colors.white.withOpacity(0.1),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Emoji with glow effect
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.isSelected
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.transparent,
                                  boxShadow: widget.isSelected
                                      ? [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Text(
                                  widget.emoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Cuisine name
                              Flexible(
                                child: Text(
                                  widget.cuisineName,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: widget.isSelected
                                        ? Colors.white
                                        : (isDark
                                              ? AppColors.darkOnSurface
                                              : AppColors.lightOnSurface),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              const SizedBox(height: 2),

                              // Description
                              Flexible(
                                child: Text(
                                  widget.description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: widget.isSelected
                                        ? Colors.white.withOpacity(0.9)
                                        : (isDark
                                              ? AppColors.darkOnSurface
                                                    .withOpacity(0.7)
                                              : AppColors.lightOnSurface
                                                    .withOpacity(0.7)),
                                    fontSize: 9,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
