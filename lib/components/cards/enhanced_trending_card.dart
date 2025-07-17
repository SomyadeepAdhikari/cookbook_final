import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';
import '../buttons/enhanced_favorite_button.dart';
import '../../pages/information_redesigned.dart';

/// A sophisticated trending recipe card with overflow protection
class EnhancedTrendingCard extends StatefulWidget {
  final int id;
  final String title;
  final String image;
  final String description;
  final String? cookingTime;
  final String? difficulty;
  final double? rating;
  final double healthScore;
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
    required this.healthScore,
    required this.isVegetarian,
    required this.isTrending,
    required this.index,
  });

  @override
  State<EnhancedTrendingCard> createState() => _EnhancedTrendingCardState();
}

class _EnhancedTrendingCardState extends State<EnhancedTrendingCard> {
  bool _isFavorite = false;

  void _onTap() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return InformationRedesigned(
            name: widget.title,
            id: widget.id,
            image: widget.image,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: AppAnimations.pageTransition,
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 350, // Fixed width to prevent overflow
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey.shade300)
                .withOpacity(isDark ? 0.6 : 0.3),
            blurRadius: 20.0,
            offset: const Offset(0, 10.0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Image
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
                    )
                  : _buildFallbackBackground(theme, isDark),
            ),

            // Content Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title and Favorite Button Row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
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
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
}
