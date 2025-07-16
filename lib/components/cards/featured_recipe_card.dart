import 'package:flutter/material.dart';
import 'package:cookbook_final/pages/information_redesigned.dart';
import 'package:cookbook_final/model/favorites_database.dart';
import 'package:provider/provider.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';
import '../buttons/animated_favorite_button.dart';

/// Featured recipe card with larger format and more details
class FeaturedRecipeCard extends StatefulWidget {
  final int id;
  final String image;
  final String title;
  final String? description;
  final String? cookingTime;
  final String? difficulty;
  final double? rating;
  final VoidCallback? onTap;

  const FeaturedRecipeCard({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    this.description,
    this.cookingTime,
    this.difficulty,
    this.rating,
    this.onTap,
  });

  @override
  State<FeaturedRecipeCard> createState() => _FeaturedRecipeCardState();
}

class _FeaturedRecipeCardState extends State<FeaturedRecipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.cardHover,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
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
              child: child,
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
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: _onTap,
              onTapDown: (_) => _animationController.forward(),
              onTapUp: (_) => _animationController.reverse(),
              onTapCancel: () => _animationController.reverse(),
              child: Container(
                width: screenWidth * 0.85,
                height: 240,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? AppColors.darkShadow
                          : AppColors.lightShadow,
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Background image
                      Positioned.fill(
                        child: Image.network(
                          widget.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isDark
                                      ? AppColors.darkCardGradient
                                      : AppColors.cardGradient,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.restaurant,
                                  size: 48,
                                  color: isDark
                                      ? AppColors.darkOnSurface.withValues(alpha: 0.5)
                                      : AppColors.lightOnSurface.withValues(alpha: 
                                          0.5,
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.3),
                                Colors.black.withValues(alpha: 0.8),
                              ],
                              stops: const [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Content
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title
                            Text(
                              widget.title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            if (widget.description != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                widget.description!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                      color: Colors.black.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],

                            const SizedBox(height: 12),

                            // Details row
                            Row(
                              children: [
                                if (widget.cookingTime != null) ...[
                                  _buildDetailChip(
                                    icon: Icons.access_time,
                                    text: widget.cookingTime!,
                                    context: context,
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                if (widget.difficulty != null) ...[
                                  _buildDetailChip(
                                    icon: Icons.local_fire_department,
                                    text: widget.difficulty!,
                                    context: context,
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                if (widget.rating != null) ...[
                                  _buildDetailChip(
                                    icon: Icons.star,
                                    text: widget.rating!.toStringAsFixed(1),
                                    context: context,
                                    iconColor: AppColors.warning,
                                  ),
                                ],
                                const Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                  child: AnimatedFavoriteButton(
                                    isFavorite: _isFavorite,
                                    size: 20,
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

  Widget _buildDetailChip({
    required IconData icon,
    required String text,
    required BuildContext context,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: iconColor ?? Colors.white.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
