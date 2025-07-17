import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme/colors.dart';
import '../../theme/animations.dart';
import '../../pages/information_redesigned.dart';
import '../../model/favorites_database.dart';
import '../../components/buttons/enhanced_favorite_button.dart';
import 'package:provider/provider.dart';

/// Modern iOS 18-inspired featured recipe card with glassmorphic design
class EnhancedFeaturedCard extends StatefulWidget {
  final int id;
  final String title;
  final String image;
  final String? description;
  final String? cookingTime;
  final String? difficulty;
  final double? rating;
  final int index;
  final VoidCallback? onTap;

  const EnhancedFeaturedCard({
    super.key,
    required this.id,
    required this.title,
    required this.image,
    this.description,
    this.cookingTime,
    this.difficulty,
    this.rating,
    required this.index,
    this.onTap,
  });

  @override
  State<EnhancedFeaturedCard> createState() => _EnhancedFeaturedCardState();
}

class _EnhancedFeaturedCardState extends State<EnhancedFeaturedCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _entranceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;
  late Animation<double> _blurAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();

    // Hover animation controller
    _hoverController = AnimationController(
      duration: AppAnimations.cardHover,
      vsync: this,
    );

    // Entrance animation controller
    _entranceController = AnimationController(
      duration: Duration(milliseconds: 800 + (widget.index * 100)),
      vsync: this,
    );

    // Scale animation for hover effect
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _hoverController, curve: AppAnimations.smooth),
    );

    // Shadow animation for depth
    _shadowAnimation = Tween<double>(begin: 8.0, end: 20.0).animate(
      CurvedAnimation(parent: _hoverController, curve: AppAnimations.smooth),
    );

    // Blur animation for glassmorphism
    _blurAnimation = Tween<double>(begin: 20.0, end: 25.0).animate(
      CurvedAnimation(parent: _hoverController, curve: AppAnimations.smooth),
    );

    // Entrance slide animation
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Entrance fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );

    _checkFavoriteStatus();

    // Start entrance animation with delay
    Future.delayed(Duration(milliseconds: widget.index * 150), () {
      if (mounted) {
        _entranceController.forward();
      }
    });
  }

  void _checkFavoriteStatus() {
    _isFavorite = context.read<FavoritesDatabase>().checkIfFav(widget.id);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _hoverController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _hoverController.reverse();
  }

  void _handleTapCancel() {
    _hoverController.reverse();
  }

  void _handleTap() {
    HapticFeedback.mediumImpact();
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
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

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedBuilder(
          animation: Listenable.merge([_hoverController]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                onTap: _handleTap,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? Colors.black : Colors.grey)
                            .withOpacity(isDark ? 0.4 : 0.1),
                        blurRadius: _shadowAnimation.value,
                        offset: Offset(0, _shadowAnimation.value / 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Background Image
                        Positioned.fill(
                          child: Image.network(
                            widget.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        theme.colorScheme.secondary.withOpacity(
                                          0.3,
                                        ),
                                        theme.colorScheme.primary.withOpacity(
                                          0.3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.restaurant_rounded,
                                      size: 48,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                          ),
                        ),

                        // Gradient Overlay
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: const [0.0, 0.6, 1.0],
                              ),
                            ),
                          ),
                        ),

                        // Glassmorphic Content Container
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: _blurAnimation.value,
                                sigmaY: _blurAnimation.value,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Title
                                    Text(
                                      widget.title,
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                            height: 1.2,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    if (widget.description != null) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        widget.description!,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              fontSize: 14,
                                              height: 1.3,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],

                                    const SizedBox(height: 16),

                                    // Metadata Row
                                    Row(
                                      children: [
                                        if (widget.cookingTime != null) ...[
                                          _buildMetaChip(
                                            Icons.schedule_rounded,
                                            widget.cookingTime!,
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                        if (widget.difficulty != null) ...[
                                          _buildMetaChip(
                                            Icons.local_fire_department_rounded,
                                            widget.difficulty!,
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                        if (widget.rating != null) ...[
                                          _buildMetaChip(
                                            Icons.star_rounded,
                                            widget.rating!.toStringAsFixed(1),
                                            iconColor: AppColors.warning,
                                          ),
                                        ],
                                        const Spacer(),

                                        // Favorite Button
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withOpacity(
                                              0.15,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.3,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: EnhancedFavoriteButton(
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String text, {Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: iconColor ?? Colors.white.withOpacity(0.9),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
