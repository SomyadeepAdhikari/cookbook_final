import 'package:flutter/material.dart';
import 'package:cookbook_final/pages/information_redesigned.dart';
import 'package:cookbook_final/model/favorites_database.dart';
import 'package:provider/provider.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

/// iOS 18-inspired favorite card with swipe actions
class IOSFavoriteCard extends StatefulWidget {
  final int realId;
  final int id;
  final String title;
  final String image;
  final VoidCallback? onDelete;

  const IOSFavoriteCard({
    super.key,
    required this.realId,
    required this.id,
    required this.title,
    required this.image,
    this.onDelete,
  });

  @override
  State<IOSFavoriteCard> createState() => _IOSFavoriteCardState();
}

class _IOSFavoriteCardState extends State<IOSFavoriteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: AppAnimations.smooth,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            InformationRedesigned(
              name: widget.title,
              id: widget.realId,
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

  Future<void> _deleteItem() async {
    if (_isDeleting) return;

    setState(() {
      _isDeleting = true;
    });

    // Store context before async gap
    final database = context.read<FavoritesDatabase>();

    // Animate out
    await _animationController.reverse();

    // Delete from database
    database.deleteId(widget.realId);

    // Call onDelete callback
    if (widget.onDelete != null) {
      widget.onDelete!();
    }
  }

  void _showDeleteConfirmation() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Remove from Favorites',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to remove "${widget.title}" from your favorites?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteItem();
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Dismissible(
                key: Key('favorite_${widget.id}'),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  _showDeleteConfirmation();
                  return false; // Don't auto-dismiss, we handle it manually
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.error.withValues(alpha: 0.8),
                        AppColors.error,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_rounded, color: Colors.white, size: 28),
                      SizedBox(height: 4),
                      Text(
                        'Remove',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                child: GestureDetector(
                  onTap: _onTap,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? AppColors.darkShadow
                              : AppColors.lightShadow,
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
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
                        child: Row(
                          children: [
                            // Image Section
                            SizedBox(
                              width: 100,
                              height: double.infinity,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      widget.image,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: isDark
                                                  ? AppColors.darkSurface
                                                  : AppColors.lightSurface,
                                              child: Icon(
                                                Icons.restaurant_rounded,
                                                size: 32,
                                                color: isDark
                                                    ? AppColors.darkOnSurface
                                                          .withValues(
                                                            alpha: 0.5,
                                                          )
                                                    : AppColors.lightOnSurface
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                              ),
                                            );
                                          },
                                    ),
                                    // Favorite indicator
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: AppColors.error.withValues(
                                            alpha: 0.9,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.error.withValues(
                                                alpha: 0.3,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.favorite_rounded,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Content Section
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Title
                                    Text(
                                      widget.title,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: isDark
                                                ? AppColors.darkOnSurface
                                                : AppColors.lightOnSurface,
                                            height: 1.2,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 8),

                                    // Subtitle
                                    Text(
                                      'Tap to view recipe details',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color:
                                                (isDark
                                                        ? AppColors
                                                              .darkOnSurface
                                                        : AppColors
                                                              .lightOnSurface)
                                                    .withValues(alpha: 0.6),
                                            fontSize: 12,
                                          ),
                                    ),

                                    const Spacer(),

                                    // Action row
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.swipe_left_rounded,
                                          size: 16,
                                          color: theme.colorScheme.secondary
                                              .withValues(alpha: 0.7),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Swipe to remove',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .secondary
                                                    .withValues(alpha: 0.7),
                                                fontSize: 11,
                                              ),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 16,
                                          color: theme.colorScheme.secondary,
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
              ),
            ),
          ),
        );
      },
    );
  }
}
