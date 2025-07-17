import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import '../../util/secrets.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';
import '../cards/enhanced_trending_card.dart';
import '../layout/elegant_loading_text.dart';

/// Enhanced Trending This Week section with modern iOS 18 design and API integration
class EnhancedTrendingSection extends StatefulWidget {
  const EnhancedTrendingSection({super.key});

  @override
  State<EnhancedTrendingSection> createState() =>
      _EnhancedTrendingSectionState();
}

class _EnhancedTrendingSectionState extends State<EnhancedTrendingSection>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>> _trendingFuture;
  late PageController _pageController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 0.87);
    _pageController.addListener(_updateCurrentPage);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _trendingFuture = _fetchTrendingRecipes();

    // Start pulse animation
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.removeListener(_updateCurrentPage);
    _pageController.dispose();
    _pulseController.dispose();
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

  Future<Map<String, dynamic>> _fetchTrendingRecipes() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.spoonacular.com/recipes/complexSearch?apiKey=$spoonacularapi&addRecipeInformation=true&fillIngredients=true&number=6&sort=popularity&minHealthScore=70',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['totalResults'] == 0) {
          throw Exception('No trending recipes found');
        }
        return data;
      } else {
        throw Exception('Failed to load trending recipes');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  String _cleanDescription(String? htmlString) {
    if (htmlString == null)
      return 'A delicious recipe waiting to be discovered!';
    final cleanText = htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return cleanText.length > 100
        ? '${cleanText.substring(0, 97)}...'
        : cleanText;
  }

  String _getDifficultyLevel(int? minutes) {
    if (minutes == null) return 'Medium';
    if (minutes <= 20) return 'Easy';
    if (minutes <= 45) return 'Medium';
    return 'Hard';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              // Enhanced Animated trending icon with glassmorphic background
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(
                            0.3 + (_pulseAnimation.value * 0.2),
                          ),
                          blurRadius: 10 + (_pulseAnimation.value * 6),
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orange.withOpacity(0.8),
                                Colors.red.withOpacity(0.9),
                                Colors.pink.withOpacity(0.8),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Transform.scale(
                            scale: 1.0 + (_pulseAnimation.value * 0.1),
                            child: const Icon(
                              Icons.trending_up_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(width: 16),

              // Header Text Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with Hot Badge
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Trending This Week',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkOnSurface
                                  : AppColors.lightOnSurface,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              letterSpacing: -0.4,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Hot Badge with glassmorphic design
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Colors.red, Colors.orange],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'HOT',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Discover the most loved recipes by our community',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            (isDark
                                    ? AppColors.darkOnSurface
                                    : AppColors.lightOnSurface)
                                .withOpacity(0.7),
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Enhanced Recipe Carousel
        SizedBox(
          height: 320,
          child: FutureBuilder<Map<String, dynamic>>(
            future: _trendingFuture,
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
                  return EnhancedTrendingCard(
                    id: recipe['id'] ?? 0,
                    title: recipe['title'] ?? 'Unknown Recipe',
                    image: recipe['image'] ?? '',
                    description: _cleanDescription(recipe['summary']),
                    cookingTime: recipe['readyInMinutes']?.toString(),
                    difficulty: _getDifficultyLevel(recipe['readyInMinutes']),
                    rating: (recipe['aggregateLikes'] ?? 0) / 10.0,
                    healthScore: recipe['healthScore']?.toDouble() ?? 0.0,
                    isVegetarian: recipe['vegetarian'] ?? false,
                    isTrending: index < 3, // Mark first 3 as trending
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
              child: FutureBuilder<Map<String, dynamic>>(
                future: _trendingFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done ||
                      snapshot.hasError) {
                    return const SizedBox.shrink();
                  }

                  final recipes = snapshot.data!['results'] as List;
                  final itemCount = recipes.take(6).length;

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      itemCount,
                      (index) => AnimatedContainer(
                        duration: AppAnimations.fast,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 32 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: _currentPage == index
                              ? LinearGradient(
                                  colors: [
                                    theme.colorScheme.secondary,
                                    theme.colorScheme.secondary.withOpacity(
                                      0.7,
                                    ),
                                  ],
                                )
                              : null,
                          color: _currentPage != index
                              ? (isDark
                                    ? AppColors.darkOnSurface.withOpacity(0.3)
                                    : AppColors.lightOnSurface.withOpacity(0.3))
                              : null,
                          boxShadow: _currentPage == index
                              ? [
                                  BoxShadow(
                                    color: theme.colorScheme.secondary
                                        .withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: ElegantLoadingText(
        message: 'Finding trending recipes',
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
              Icons.trending_down,
              size: 48,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load trending recipes',
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
}
