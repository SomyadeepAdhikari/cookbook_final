import 'package:flutter/material.dart';
import 'package:cookbook_final/pages/information_redesigned.dart';
import 'package:cookbook_final/model/favorites_database.dart';
import 'package:provider/provider.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';
import '../buttons/enhanced_favorite_button.dart';

/// iOS 18-inspired recipe list card with advanced visual hierarchy
class IOSRecipeListCard extends StatefulWidget {
  final int id;
  final String image;
  final String title;
  final String? description;
  final String? cookingTime;
  final String? servings;
  final double? rating;
  final double? healthScore;
  final bool isVegetarian;
  final bool isGlutenFree;
  final bool isVegan;
  final VoidCallback? onTap;

  const IOSRecipeListCard({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    this.description,
    this.cookingTime,
    this.servings,
    this.rating,
    this.healthScore,
    this.isVegetarian = false,
    this.isGlutenFree = false,
    this.isVegan = false,
    this.onTap,
  });

  @override
  State<IOSRecipeListCard> createState() => _IOSRecipeListCardState();
}

class _IOSRecipeListCardState extends State<IOSRecipeListCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;
  bool _isFavorite = false;

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

    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    // Check if this recipe is already favorited
    _isFavorite = context.read<FavoritesDatabase>().checkIfFav(widget.id);
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

  void _onTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => InformationRedesigned(
            name: widget.title,
            id: widget.id,
            image: widget.image,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          transitionDuration: AppAnimations.pageTransition,
        ),
      );
    }
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
            onTap: _onTap,
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: isDark
                    ? [
                        BoxShadow(
                          color: AppColors.darkShadow.withValues(alpha: 
                            _shadowAnimation.value,
                          ),
                          blurRadius: 16 * _shadowAnimation.value,
                          offset: Offset(0, 8 * _shadowAnimation.value),
                        ),
                      ]
                    : [
                        // Very subtle shadow for light mode
                        BoxShadow(
                          color: AppColors.lightShadow.withValues(alpha: 
                            _shadowAnimation.value * 0.5,
                          ),
                          blurRadius: 8 * _shadowAnimation.value,
                          offset: Offset(0, 4 * _shadowAnimation.value),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 180),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
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
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Row(
                      children: [
                        // Image Section with padding
                        Container(
                          width: 140,
                          height: 140,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isDark
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [
                                    // Very subtle shadow for light mode
                                    BoxShadow(
                                      color: Colors.grey.withValues(alpha: 0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Image.network(
                                  widget.image,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: isDark
                                          ? AppColors.darkSurface
                                          : AppColors.lightSurface,
                                      child: Icon(
                                        Icons.restaurant_rounded,
                                        size: 40,
                                        color: isDark
                                            ? AppColors.darkOnSurface
                                                  .withValues(alpha: 0.5)
                                            : AppColors.lightOnSurface
                                                  .withValues(alpha: 0.5),
                                      ),
                                    );
                                  },
                                ),

                                // Health/Diet badges
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (widget.isVegan)
                                        _buildDietBadge(
                                          '🌱',
                                          AppColors.success,
                                        ),
                                      if (widget.isVegetarian &&
                                          !widget.isVegan)
                                        _buildDietBadge('🥬', AppColors.info),
                                      if (widget.isGlutenFree)
                                        _buildDietBadge(
                                          '🚫',
                                          AppColors.warning,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Content Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Title and Favorite Button
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.title,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                            color: isDark
                                                ? AppColors.darkOnSurface
                                                : AppColors.lightOnSurface,
                                            height: 1.3,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  EnhancedFavoriteButton(
                                    isFavorite: _isFavorite,
                                    size: 24,
                                    onTap: () {
                                      setState(() {
                                        _isFavorite = !_isFavorite;
                                      });

                                      if (_isFavorite) {
                                        context
                                            .read<FavoritesDatabase>()
                                            .addFavorite(
                                              widget.title,
                                              widget.id,
                                              widget.image,
                                            );
                                      } else {
                                        context
                                            .read<FavoritesDatabase>()
                                            .deleteId(widget.id);
                                      }
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Description
                              if (widget.description != null &&
                                  widget.description!.isNotEmpty)
                                Text(
                                  widget.description!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color:
                                        (isDark
                                                ? AppColors.darkOnSurface
                                                : AppColors.lightOnSurface)
                                            .withValues(alpha: 0.7),
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),

                              const SizedBox(height: 16),

                              // Metadata Row
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  if (widget.cookingTime != null)
                                    _buildMetadataChip(
                                      Icons.schedule_rounded,
                                      '${widget.cookingTime} min',
                                      theme,
                                      isDark,
                                    ),
                                  if (widget.servings != null)
                                    _buildMetadataChip(
                                      Icons.people_outline_rounded,
                                      '${widget.servings} servings',
                                      theme,
                                      isDark,
                                    ),
                                  if (widget.rating != null &&
                                      widget.rating! > 0)
                                    _buildMetadataChip(
                                      Icons.star_rounded,
                                      widget.rating!.toStringAsFixed(1),
                                      theme,
                                      isDark,
                                      iconColor: AppColors.warning,
                                    ),
                                  if (widget.healthScore != null &&
                                      widget.healthScore! > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getHealthScoreColor(
                                          widget.healthScore!,
                                        ).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: _getHealthScoreColor(
                                            widget.healthScore!,
                                          ).withValues(alpha: 0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        '${widget.healthScore!.toInt()}% healthy',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: _getHealthScoreColor(
                                                widget.healthScore!,
                                              ),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
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
          ),
        );
      },
    );
  }

  Widget _buildDietBadge(String emoji, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        // Remove shadows from badges for cleaner look
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildMetadataChip(
    IconData icon,
    String text,
    ThemeData theme,
    bool isDark, {
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkGlass.withValues(alpha: 0.3)
            : AppColors.lightGlass.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppColors.darkGlassStroke.withValues(alpha: 0.5)
              : AppColors.lightGlassStroke.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor ?? theme.colorScheme.secondary),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkOnSurface.withValues(alpha: 0.9)
                  : AppColors.lightOnSurface.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthScoreColor(double healthScore) {
    if (healthScore >= 80) return AppColors.success;
    if (healthScore >= 60) return AppColors.warning;
    return AppColors.error;
  }
}
