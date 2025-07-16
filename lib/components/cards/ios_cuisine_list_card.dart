import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

/// iOS 18-inspired cuisine list card with enhanced visual design
class IOSCuisineListCard extends StatefulWidget {
  final String name;
  final String emoji;
  final String description;
  final String region;
  final VoidCallback? onTap;

  const IOSCuisineListCard({
    super.key,
    required this.name,
    required this.emoji,
    required this.description,
    required this.region,
    this.onTap,
  });

  @override
  State<IOSCuisineListCard> createState() => _IOSCuisineListCardState();
}

class _IOSCuisineListCardState extends State<IOSCuisineListCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.cardTap,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _shadowAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.onTap,
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isDark ? AppColors.darkShadow : AppColors.lightShadow)
                            .withOpacity(_shadowAnimation.value),
                    blurRadius: 16 * _shadowAnimation.value,
                    offset: Offset(0, 8 * _shadowAnimation.value),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? AppColors.darkCardGradient
                          : AppColors.cardGradient,
                    ),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkGlassStroke
                          : AppColors.lightGlassStroke,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Emoji Section with Background
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.secondary.withOpacity(0.1),
                              theme.colorScheme.secondary.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.secondary.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.emoji,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Content Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cuisine Name and Region Badge
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.name,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: isDark
                                              ? AppColors.darkOnSurface
                                              : AppColors.lightOnSurface,
                                          letterSpacing: -0.3,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: theme.colorScheme.secondary
                                          .withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    widget.region,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.secondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Description
                            Text(
                              widget.description,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color:
                                    (isDark
                                            ? AppColors.darkOnSurface
                                            : AppColors.lightOnSurface)
                                        .withOpacity(0.7),
                                fontSize: 14,
                                height: 1.3,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Explore Button
                            Row(
                              children: [
                                Icon(
                                  Icons.explore_rounded,
                                  size: 16,
                                  color: theme.colorScheme.secondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Explore Recipes',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: theme.colorScheme.secondary,
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
          ),
        );
      },
    );
  }
}
