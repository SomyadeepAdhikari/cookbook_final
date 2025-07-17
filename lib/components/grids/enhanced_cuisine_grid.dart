import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme/colors.dart';
import '../../theme/animations.dart';
import '../../pages/cuisines_page.dart';

/// Enhanced adaptive grid layout for cuisine cards with modern iOS 18 design
class EnhancedCuisineGrid extends StatefulWidget {
  final List<String> cuisines;
  final Map<String, Map<String, String>> cuisineData;
  final String selectedCuisine;
  final Function(String) onCuisineSelected;
  final String? filterQuery;

  const EnhancedCuisineGrid({
    super.key,
    required this.cuisines,
    required this.cuisineData,
    required this.selectedCuisine,
    required this.onCuisineSelected,
    this.filterQuery,
  });

  @override
  State<EnhancedCuisineGrid> createState() => _EnhancedCuisineGridState();
}

class _EnhancedCuisineGridState extends State<EnhancedCuisineGrid>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  List<String> get filteredCuisines {
    if (widget.filterQuery == null || widget.filterQuery!.isEmpty) {
      return widget.cuisines.where((cuisine) => cuisine != 'All').toList();
    }

    return widget.cuisines.where((cuisine) {
      if (cuisine == 'All') return false;

      final data = widget.cuisineData[cuisine];
      final query = widget.filterQuery!.toLowerCase();

      return cuisine.toLowerCase().contains(query) ||
          (data?['description']?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Adaptive column count based on screen width
    int crossAxisCount = 2;
    if (screenWidth > 600) {
      crossAxisCount = 3;
    } else if (screenWidth > 900) {
      crossAxisCount = 4;
    }

    final filteredList = filteredCuisines;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= filteredList.length) return null;

          final cuisine = filteredList[index];
          final data =
              widget.cuisineData[cuisine] ??
              {'emoji': '🍽️', 'description': 'Delicious cuisine'};

          return AnimatedBuilder(
            animation: _staggerController,
            builder: (context, child) {
              final animationProgress = Curves.easeOutCubic.transform(
                (_staggerController.value - (index * 0.05)).clamp(0.0, 1.0),
              );

              return Transform.translate(
                offset: Offset(0, 50 * (1 - animationProgress)),
                child: Opacity(
                  opacity: animationProgress,
                  child: EnhancedCuisineCard(
                    cuisine: cuisine,
                    emoji: data['emoji']!,
                    description: data['description']!,
                    isSelected: widget.selectedCuisine == cuisine,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onCuisineSelected(cuisine);
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  CuisinesPage(cuisineSearch: cuisine),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return SlideTransition(
                                  position:
                                      Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(
                                        CurvedAnimation(
                                          parent: animation,
                                          curve: AppAnimations.smooth,
                                        ),
                                      ),
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                          transitionDuration: AppAnimations.pageTransition,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }, childCount: filteredList.length),
      ),
    );
  }
}

/// Individual enhanced cuisine card with glassmorphic design
class EnhancedCuisineCard extends StatefulWidget {
  final String cuisine;
  final String emoji;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const EnhancedCuisineCard({
    super.key,
    required this.cuisine,
    required this.emoji,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<EnhancedCuisineCard> createState() => _EnhancedCuisineCardState();
}

class _EnhancedCuisineCardState extends State<EnhancedCuisineCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.cardHover,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _shadowAnimation = Tween<double>(begin: 8.0, end: 20.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  // Base shadow
                  BoxShadow(
                    color: (isDark ? Colors.black : Colors.grey.shade300)
                        .withOpacity(isDark ? 0.5 : 0.2),
                    blurRadius: _shadowAnimation.value,
                    offset: Offset(0, _shadowAnimation.value / 2),
                  ),
                  // Glow effect when selected
                  if (widget.isSelected)
                    BoxShadow(
                      color: theme.colorScheme.secondary.withOpacity(0.4),
                      blurRadius: 20 + (_glowAnimation.value * 10),
                      offset: const Offset(0, 0),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isSelected
                            ? [
                                theme.colorScheme.secondary.withOpacity(0.9),
                                theme.colorScheme.secondary.withOpacity(0.7),
                              ]
                            : isDark
                            ? [
                                AppColors.darkCardGradient[0].withOpacity(0.9),
                                AppColors.darkCardGradient[1].withOpacity(0.7),
                              ]
                            : [
                                AppColors.cardGradient[0].withOpacity(0.9),
                                AppColors.cardGradient[1].withOpacity(0.7),
                              ],
                      ),
                      border: Border.all(
                        color: widget.isSelected
                            ? theme.colorScheme.secondary.withOpacity(0.6)
                            : (isDark
                                  ? AppColors.darkGlassStroke
                                  : AppColors.lightGlassStroke),
                        width: widget.isSelected ? 2 : 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Emoji with background
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.isSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : theme.colorScheme.secondary.withOpacity(
                                      0.1,
                                    ),
                              border: Border.all(
                                color: widget.isSelected
                                    ? Colors.white.withOpacity(0.3)
                                    : theme.colorScheme.secondary.withOpacity(
                                        0.2,
                                      ),
                                width: 1,
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

                          const SizedBox(height: 16),

                          // Cuisine name
                          Text(
                            widget.cuisine,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: widget.isSelected
                                  ? Colors.white
                                  : (isDark
                                        ? AppColors.darkOnSurface
                                        : AppColors.lightOnSurface),
                              letterSpacing: -0.3,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 6),

                          // Description
                          Text(
                            widget.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: widget.isSelected
                                  ? Colors.white.withOpacity(0.9)
                                  : (isDark
                                            ? AppColors.darkOnSurface
                                            : AppColors.lightOnSurface)
                                        .withOpacity(0.7),
                              fontSize: 12,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Selection indicator
                          if (widget.isSelected) ...[
                            const SizedBox(height: 12),
                            Container(
                              width: 24,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
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
    );
  }
}
