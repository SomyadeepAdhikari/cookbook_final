import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../util/secrets.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';
import '../../pages/featured_recipes_page.dart';
import '../cards/enhanced_featured_card.dart';
import '../layout/elegant_loading_text.dart';
import 'dart:ui';

/// Enhanced Featured Recipes section with modern iOS 18 design
class EnhancedFeaturedSection extends StatefulWidget {
  const EnhancedFeaturedSection({super.key});

  @override
  State<EnhancedFeaturedSection> createState() =>
      _EnhancedFeaturedSectionState();
}

class _EnhancedFeaturedSectionState extends State<EnhancedFeaturedSection>
    with TickerProviderStateMixin {
  late Future<Map<String, dynamic>> _recipesFuture;
  late PageController _pageController;
  late AnimationController _sectionController;
  late Animation<double> _headerAnimation;
  late Animation<Offset> _headerSlideAnimation;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 0.85, initialPage: 0);

    _sectionController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sectionController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(-0.3, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _sectionController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _pageController.addListener(_updateCurrentPage);
    _recipesFuture = _fetchFeaturedRecipes();
    _sectionController.forward();
  }

  @override
  void dispose() {
    _pageController.removeListener(_updateCurrentPage);
    _pageController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  void _updateCurrentPage() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  Future<Map<String, dynamic>> _fetchFeaturedRecipes() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.spoonacular.com/recipes/complexSearch?apiKey=$spoonacularapi&addRecipeInformation=true&fillIngredients=true&number=8&sort=popularity',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['totalResults'] == 0) {
          throw Exception('No featured recipes found');
        }
        return data;
      } else {
        throw Exception('Failed to load featured recipes');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  void _navigateToFeaturedPage() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const FeaturedRecipesPage(),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced Section Header
        SlideTransition(
          position: _headerSlideAnimation,
          child: FadeTransition(
            opacity: _headerAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  // Gradient Icon Container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.secondary,
                          theme.colorScheme.secondary.withOpacity(0.7),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.secondary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Featured Recipes',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: isDark
                                ? AppColors.darkOnSurface
                                : AppColors.lightOnSurface,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Handpicked by our culinary experts',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                (isDark
                                        ? AppColors.darkOnSurface
                                        : AppColors.lightOnSurface)
                                    .withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Modern See All Button
                  _buildSeeAllButton(theme, isDark),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Enhanced Recipe Carousel
        SizedBox(
          height: 320,
          child: FutureBuilder<Map<String, dynamic>>(
            future: _recipesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingState();
              }

              if (snapshot.hasError) {
                return _buildErrorState(theme);
              }

              final recipes = snapshot.data!['results'] as List;
              final displayRecipes = recipes.take(6).toList();

              return PageView.builder(
                controller: _pageController,
                itemCount: displayRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = displayRecipes[index];
                  return EnhancedFeaturedCard(
                    id: recipe['id'] ?? 0,
                    title: recipe['title'] ?? 'Unknown Recipe',
                    image: recipe['image'] ?? '',
                    description: _cleanDescription(recipe['summary']),
                    cookingTime: recipe['readyInMinutes']?.toString(),
                    difficulty: _getDifficultyLevel(recipe['readyInMinutes']),
                    rating: (recipe['aggregateLikes'] ?? 0) / 10.0,
                    index: index,
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Enhanced Page Indicator
        AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            return Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 6, // Maximum recipes to show
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                  spacing: 8,
                  activeDotColor: theme.colorScheme.secondary,
                  dotColor: theme.colorScheme.secondary.withOpacity(0.2),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSeeAllButton(ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: _navigateToFeaturedPage,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: (isDark ? AppColors.darkGlass : AppColors.lightGlass)
              .withOpacity(0.8),
          border: Border.all(
            color: isDark
                ? AppColors.darkGlassStroke
                : AppColors.lightGlassStroke,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.secondary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'See All',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: theme.colorScheme.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: ElegantLoadingText(
        message: 'Discovering featured recipes',
        showDots: true,
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.error.withOpacity(0.1),
            ),
            child: Icon(
              Icons.restaurant_outlined,
              size: 48,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load featured recipes',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String? _cleanDescription(String? htmlDescription) {
    if (htmlDescription == null) return null;
    return htmlDescription
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim()
        .split('.')
        .first;
  }

  String? _getDifficultyLevel(int? readyInMinutes) {
    if (readyInMinutes == null) return null;
    if (readyInMinutes <= 15) return 'Easy';
    if (readyInMinutes <= 45) return 'Medium';
    return 'Hard';
  }
}
