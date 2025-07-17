import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme/colors.dart';

/// Modern glassmorphic "See All" button with iOS 18 styling
class GlassmorphicSeeAllButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final IconData? icon;
  final Color? color;
  final double? fontSize;

  const GlassmorphicSeeAllButton({
    super.key,
    required this.onTap,
    this.text = 'See All',
    this.icon,
    this.color,
    this.fontSize,
  });

  @override
  State<GlassmorphicSeeAllButton> createState() =>
      _GlassmorphicSeeAllButtonState();
}

class _GlassmorphicSeeAllButtonState extends State<GlassmorphicSeeAllButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final buttonColor = widget.color ?? theme.colorScheme.secondary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onTap: widget.onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (isDark ? AppColors.darkGlass : AppColors.lightGlass)
                      .withOpacity(0.8),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkGlassStroke
                        : AppColors.lightGlassStroke,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: buttonColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.text,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: buttonColor,
                            fontWeight: FontWeight.w600,
                            fontSize: widget.fontSize ?? 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          widget.icon ?? Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: buttonColor,
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
