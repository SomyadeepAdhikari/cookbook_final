import 'package:flutter/material.dart';
import '../cards/featured_recipe_card.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

class EnhancedPopularSection extends StatefulWidget {
  const EnhancedPopularSection({super.key});

  @override
  State<EnhancedPopularSection> createState() => _EnhancedPopularSectionState();
}

class _EnhancedPopularSectionState extends State<EnhancedPopularSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );
    _animationController.repeat();

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Mock popular recipes data
    final popularRecipes = [
      {
        'id': 1,
        'title': 'Creamy Pasta Carbonara',
        'image':
            'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=400',
        'cookTime': '20 min',
        'difficulty': 'Easy',
        'rating': 4.8,
        'trending': true,
      },
      {
        'id': 2,
        'title': 'Spicy Korean Bibimbap',
        'image':
            'https://images.unsplash.com/photo-1553909489-cd47e0ef937f?w=400',
        'cookTime': '35 min',
        'difficulty': 'Medium',
        'rating': 4.7,
        'trending': true,
      },
      {
        'id': 3,
        'title': 'Classic Beef Tacos',
        'image':
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
        'cookTime': '15 min',
        'difficulty': 'Easy',
        'rating': 4.9,
        'trending': false,
      },
      {
        'id': 4,
        'title': 'Thai Green Curry',
        'image':
            'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=400',
        'cookTime': '30 min',
        'difficulty': 'Medium',
        'rating': 4.6,
        'trending': true,
      },
      {
        'id': 5,
        'title': 'Japanese Ramen Bowl',
        'image':
            'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400',
        'cookTime': '45 min',
        'difficulty': 'Hard',
        'rating': 4.8,
        'trending': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              // Animated trending icon
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale:
                        1.0 + (0.1 * (0.5 + 0.5 * _animationController.value)),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange, Colors.red, Colors.pink],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.trending_up,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Trending This Week',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: isDark
                                ? AppColors.darkOnSurface
                                : AppColors.lightOnSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'HOT',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Most loved recipes by our community',
                      style: theme.textTheme.bodySmall?.copyWith(
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
              TextButton(
                onPressed: () {
                  // Navigate to trending page
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See All',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: theme.colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Popular Recipes Carousel
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: popularRecipes.length,
            itemBuilder: (context, index) {
              final recipe = popularRecipes[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FeaturedRecipeCard(
                  id: recipe['id'] as int,
                  title: recipe['title'] as String,
                  image: recipe['image'] as String,
                  cookingTime: recipe['cookTime'] as String,
                  difficulty: recipe['difficulty'] as String,
                  rating: recipe['rating'] as double,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Page Indicator
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              popularRecipes.length,
              (index) => AnimatedContainer(
                duration: AppAnimations.fast,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: _currentPage == index
                      ? LinearGradient(
                          colors: [
                            theme.colorScheme.secondary,
                            theme.colorScheme.secondary.withValues(alpha: 0.7),
                          ],
                        )
                      : null,
                  color: _currentPage != index
                      ? (isDark
                            ? AppColors.darkOnSurface.withValues(alpha: 0.3)
                            : AppColors.lightOnSurface.withValues(alpha: 0.3))
                      : null,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Quick Stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.favorite,
                  label: 'Loved',
                  value: '12.5K',
                  color: Colors.red,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.visibility,
                  label: 'Views',
                  value: '45.2K',
                  color: Colors.blue,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.star,
                  label: 'Rating',
                  value: '4.8',
                  color: Colors.amber,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark ? AppColors.darkCardGradient : AppColors.cardGradient,
        ),
        border: Border.all(
          color: isDark
              ? AppColors.darkGlassStroke
              : AppColors.lightGlassStroke,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkOnSurface
                  : AppColors.lightOnSurface,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  (isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface)
                      .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
