import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/colors.dart';

/// Modern skeleton loading component with shimmer effects for iOS 18 design
class SkeletonLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const SkeletonLoading({
    super.key,
    required this.child,
    required this.isLoading,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<SkeletonLoading> createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );

    if (widget.isLoading) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(SkeletonLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor =
        widget.baseColor ??
        (isDark
            ? AppColors.darkGlass.withOpacity(0.3)
            : AppColors.lightGlass.withOpacity(0.3));
    final highlightColor =
        widget.highlightColor ??
        (isDark
            ? AppColors.darkGlass.withOpacity(0.5)
            : AppColors.lightGlass.withOpacity(0.5));

    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Pre-built skeleton card for recipe list loading
class SkeletonRecipeCard extends StatelessWidget {
  const SkeletonRecipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark
            ? AppColors.darkGlass.withOpacity(0.1)
            : AppColors.lightGlass.withOpacity(0.1),
        border: Border.all(
          color: isDark
              ? AppColors.darkGlassStroke.withOpacity(0.3)
              : AppColors.lightGlassStroke.withOpacity(0.3),
          width: 0.5,
        ),
        // Remove shadows from skeleton for cleaner look
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            constraints: const BoxConstraints(minHeight: 180),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Skeleton Image
                Container(
                  width: 140,
                  height: 140,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isDark
                        ? AppColors.darkGlass.withOpacity(0.3)
                        : AppColors.lightGlass.withOpacity(0.3),
                  ),
                ),

                // Skeleton Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title skeleton
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: isDark
                                  ? AppColors.darkGlass.withOpacity(0.4)
                                  : AppColors.lightGlass.withOpacity(0.4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 18,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: isDark
                                  ? AppColors.darkGlass.withOpacity(0.3)
                                  : AppColors.lightGlass.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Description skeleton
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: isDark
                                  ? AppColors.darkGlass.withOpacity(0.2)
                                  : AppColors.lightGlass.withOpacity(0.2),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 14,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: isDark
                                  ? AppColors.darkGlass.withOpacity(0.2)
                                  : AppColors.lightGlass.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Metadata skeleton
                      Row(
                        children: [
                          Container(
                            height: 24,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isDark
                                  ? AppColors.darkGlass.withOpacity(0.3)
                                  : AppColors.lightGlass.withOpacity(0.3),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            height: 24,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isDark
                                  ? AppColors.darkGlass.withOpacity(0.3)
                                  : AppColors.lightGlass.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
