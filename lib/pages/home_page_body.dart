import 'package:cookbook_final/components/sections/enhanced_featured_section.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../components/inputs/glassmorphic_search_bar.dart';
import '../components/sections/enhanced_cuisine_section.dart';
import '../components/sections/enhanced_trending_section.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // App Logo and Welcome Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                // App Logo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.secondary.withValues(
                          alpha: 0.3,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/app_Logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.secondary,
                                theme.colorScheme.secondary.withValues(
                                  alpha: 0.7,
                                ),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.restaurant_menu,
                            color: Colors.white,
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning! 👋',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: isDark
                              ? AppColors.darkOnSurface
                              : AppColors.lightOnSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'What would you like to cook today?',
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
                // Notification Bell
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? AppColors.darkSurface.withValues(alpha: 0.5)
                        : AppColors.lightSurface.withValues(alpha: 0.5),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkGlassStroke
                          : AppColors.lightGlassStroke,
                    ),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: isDark
                        ? AppColors.darkOnSurface
                        : AppColors.lightOnSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Search Bar
          GlassmorphicSearchBar(
            controller: _searchController,
            hintText: 'Search for recipes...',
            onSubmitted: (value) {
              // Navigate to search page with the query
              // You can implement navigation logic here
              if (value.isNotEmpty) {
                // For now, just clear the search
                _searchController.clear();
              }
            },
          ),

          const SizedBox(height: 30),

          // Enhanced Featured Recipes Section
          const EnhancedFeaturedSection(),

          const SizedBox(height: 32),

          // Enhanced Categories Section
          const EnhancedCuisineSection(),

          const SizedBox(height: 32),

          // Enhanced Trending Section
          const EnhancedTrendingSection(),

          const SizedBox(height: 100), // Bottom padding for navigation
        ],
      ),
    );
  }
}
