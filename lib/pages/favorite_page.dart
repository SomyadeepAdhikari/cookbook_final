import 'package:cookbook_final/model/favorite.dart';
import 'package:cookbook_final/model/favorites_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../theme/animations.dart';
import '../components/cards/ios_favorite_card.dart';
import '../components/layout/gradient_background.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    readFavorites();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void readFavorites() {
    context.read<FavoritesDatabase>().fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final favoriteDatabase = context.watch<FavoritesDatabase>();
    List<Favorite> currentFavorites = favoriteDatabase.currentFavorites;

    return GradientBackground(
      isDark: isDark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: currentFavorites.isEmpty
                ? _buildEmptyState(context)
                : _buildFavoritesList(context, currentFavorites),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? AppColors.darkCardGradient
                      : AppColors.cardGradient,
                ),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkGlassStroke
                      : AppColors.lightGlassStroke,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? AppColors.darkShadow
                        : AppColors.lightShadow,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 48,
                color: theme.colorScheme.secondary.withValues(alpha: 0.7),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              'No Favorites Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppColors.darkOnSurface
                    : AppColors.lightOnSurface,
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              'Discover amazing recipes and save them here by tapping the heart icon. Your favorite recipes will appear in this space.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color:
                    (isDark
                            ? AppColors.darkOnSurface
                            : AppColors.lightOnSurface)
                        .withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Action button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.secondary,
                    theme.colorScheme.secondary.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigate to home page (you might want to implement navigation to search)
                    // For now, just show a snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Explore recipes in the Home tab!'),
                        backgroundColor: theme.colorScheme.secondary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.explore_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Explore Recipes',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
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
    );
  }

  Widget _buildFavoritesList(BuildContext context, List<Favorite> favorites) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.error,
                            AppColors.error.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Favorites',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              color: isDark
                                  ? AppColors.darkOnSurface
                                  : AppColors.lightOnSurface,
                            ),
                          ),
                          Text(
                            '${favorites.length} saved ${favorites.length == 1 ? 'recipe' : 'recipes'}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  (isDark
                                          ? AppColors.darkOnSurface
                                          : AppColors.lightOnSurface)
                                      .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Swipe left on any recipe to remove it from your favorites',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Favorites List
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final currentFavorite = favorites[index];
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: index == favorites.length - 1 ? 100.0 : 0.0,
              ),
              child: IOSFavoriteCard(
                realId: currentFavorite.realid,
                id: currentFavorite.id,
                title: currentFavorite.name,
                image: currentFavorite.image,
                onDelete: () {
                  // Refresh the favorites list
                  readFavorites();
                },
              ),
            );
          }, childCount: favorites.length),
        ),
      ],
    );
  }
}
