import 'package:flutter/material.dart';
import 'package:cookbook_final/pages/information.dart';
import 'package:cookbook_final/model/favorites_database.dart';
import 'package:provider/provider.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';
import '../buttons/animated_favorite_button.dart';

/// Modern, iOS 18-inspired recipe card with glassmorphic design
class ModernRecipeCard extends StatefulWidget {
  final int id;
  final String image;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showFavoriteButton;

  const ModernRecipeCard({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    this.subtitle,
    this.onTap,
    this.showFavoriteButton = true,
  });

  @override
  State<ModernRecipeCard> createState() => _ModernRecipeCardState();
}

class _ModernRecipeCardState extends State<ModernRecipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.cardTap,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    // Check if this recipe is already favorited
    // You'll need to implement a method to check if a recipe is favorited
    // For now, we'll set it to false
    _isFavorite = false;
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
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Information(
            name: widget.title,
            id: widget.id,
            image: widget.image,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: AppAnimations.smooth,
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

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: _onTap,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? AppColors.darkShadow
                        : AppColors.lightShadow,
                    blurRadius: _isPressed ? 8 : 16,
                    offset: Offset(0, _isPressed ? 4 : 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 260,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? AppColors.darkCardGradient
                          : AppColors.cardGradient,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image section with overlay
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                                child: Image.network(
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
                                        Icons.restaurant,
                                        size: 40,
                                        color: isDark
                                            ? AppColors.darkOnSurface
                                            : AppColors.lightOnSurface,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // Gradient overlay for text readability
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Favorite button
                            if (widget.showFavoriteButton)
                              Positioned(
                                top: 12,
                                right: 12,
                                child: AnimatedFavoriteButton(
                                  isFavorite: _isFavorite,
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
                      ),

                      // Content section
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.title,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: isDark
                                                ? AppColors.darkOnSurface
                                                : AppColors.lightOnSurface,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (widget.subtitle != null) ...[
                                      const SizedBox(height: 1),
                                      Text(
                                        widget.subtitle!,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color:
                                                  (isDark
                                                          ? AppColors
                                                                .darkOnSurface
                                                          : AppColors
                                                                .lightOnSurface)
                                                      .withOpacity(0.7),
                                              fontSize: 11,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: theme.colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '25 min', // You can make this dynamic
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.secondary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: AppColors.warning,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '4.5', // You can make this dynamic
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isDark
                                          ? AppColors.darkOnSurface
                                          : AppColors.lightOnSurface,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
