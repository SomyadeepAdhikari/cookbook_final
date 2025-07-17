import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../theme/colors.dart';
import '../../theme/animations.dart';
import '../../model/favorites_database.dart';
import '../../pages/information_redesigned.dart';
import '../buttons/enhanced_favorite_button.dart';

/// Enhanced trending recipe card with modern iOS 18 design and trending indicators
class EnhancedTrendingCard extends StatefulWidget {
  final int id;
  final String title;
  final String image;
  final String description;
  final String? cookingTime;
  final String? difficulty;
  final double? rating;
  final double? healthScore;
  final bool isVegetarian;
  final bool isTrending;
  final int index;

  const EnhancedTrendingCard({
    super.key,
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    this.cookingTime,
    this.difficulty,
    this.rating,
    this.healthScore,
    this.isVegetarian = false,
    this.isTrending = false,
    required this.index,
  });

  @override
  State<EnhancedTrendingCard> createState() => _EnhancedTrendingCardState();
}

class _EnhancedTrendingCardState extends State<EnhancedTrendingCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    
    // Check if this recipe is favorited
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() async {
    final database = Provider.of<FavoritesDatabase>(context, listen: false);
    final isFav = database.checkIfFav(widget.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  void _toggleFavorite() async {
    final database = Provider.of<FavoritesDatabase>(context, listen: false);
    
    if (_isFavorite) {
      await database.deleteId(widget.id);
    } else {
      await database.addFavorite(widget.title, widget.id, widget.image);
    }
    
    setState(() {
      _isFavorite = !_isFavorite;
    });
    
    HapticFeedback.lightImpact();
  }

  void _onTap() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            InformationRedesigned(
              name: widget.title,
              id: widget.id,
              image: widget.image,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: AppAnimations.smooth,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: AppAnimations.pageTransition,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(maxWidth: 350), // Add width constraint
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey.shade300)
                .withOpacity(isDark ? 0.6 : 0.3),
            blurRadius: 20.0,
            offset: const Offset(0, 10.0),
          ),
          if (widget.isTrending)
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 30.0,
              offset: const Offset(0, 0),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
                      // Background Image with Error Handling
                      SizedBox(
                        height: 320,
                        width: double.infinity,
                        child: widget.image.isNotEmpty
                            ? Image.network(
                                widget.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildFallbackBackground(theme, isDark);
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return _buildFallbackBackground(theme, isDark);
                                },
                              )
                            : _buildFallbackBackground(theme, isDark),
                      ),

                      // Trending Indicator Badge
                      if (widget.isTrending)
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.orange,
                                  Colors.red,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'TRENDING',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Health Score Badge
                      if (widget.healthScore != null && widget.healthScore! > 70)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.green.withOpacity(0.9),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.healthScore!.round()}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Gradient Overlay
                      Container(
                        height: 320,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.8),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),

                      // Glassmorphic Content Container
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Title and Favorite Button Row
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.title,
                                          style: theme.textTheme.titleLarge?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20,
                                            height: 1.2,
                                            letterSpacing: -0.3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      EnhancedFavoriteButton(
                                        isFavorite: _isFavorite,
                                        onTap: _toggleFavorite,
                                        size: 24,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  // Description
                                  Text(
                                    widget.description,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 16),

                                  // Details Row - Overflow resistant
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (widget.cookingTime != null) ...[
                                            _buildDetailChip(
                                              icon: Icons.access_time,
                                              text: '${widget.cookingTime}m',
                                              context: context,
                                            ),
                                            const SizedBox(width: 8),
                                          ],
                                          if (widget.difficulty != null) ...[
                                            _buildDetailChip(
                                              icon: Icons.local_fire_department,
                                              text: widget.difficulty!,
                                              context: context,
                                            ),
                                            const SizedBox(width: 8),
                                          ],
                                          if (widget.rating != null)
                                            _buildDetailChip(
                                              icon: Icons.star,
                                              text: widget.rating!.toStringAsFixed(1),
                                              context: context,
                                              iconColor: Colors.amber,
                                            ),
                                        ],
                                      ),
                                      if (widget.isVegetarian)
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green.withOpacity(0.2),
                                            border: Border.all(
                                              color: Colors.green.withOpacity(0.5),
                                              width: 1,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.eco,
                                            color: Colors.green,
                                            size: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Tap Area
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: _onTap,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackBackground(ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkCardGradient[0],
                  AppColors.darkCardGradient[1],
                ]
              : [
                  AppColors.cardGradient[0],
                  AppColors.cardGradient[1],
                ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_menu,
          size: 64,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String text,
    required BuildContext context,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.2),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: iconColor ?? Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
