import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookbook_final/util/secrets.dart';
import 'package:http/http.dart' as http;
import '../components/inputs/enhanced_ios_search_bar.dart';
import '../components/cards/ios_recipe_list_card.dart';
import '../components/layout/skeleton_loading.dart';
import '../components/layout/enhanced_empty_state.dart';
import '../components/layout/gradient_background.dart';
import '../components/navigation/glassmorphic_app_bar.dart';
import '../theme/colors.dart';
import '../theme/animations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController textEditingController = TextEditingController();
  late Future<Map<String, dynamic>> recipes;
  late AnimationController _animationController;
  late AnimationController _searchResultsController;
  late Animation<double> _fadeAnimation;
  bool _isSearching = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    recipes = Future.value({'totalResults': 0, 'results': []});

    _animationController = AnimationController(
      duration: AppAnimations.pageTransition,
      vsync: this,
    );

    _searchResultsController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
    _searchResultsController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        recipes = Future.value({'totalResults': 0, 'results': []});
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    // Add haptic feedback
    HapticFeedback.selectionClick();

    try {
      recipes = getSearchRecipe(query);
      await recipes; // Wait for completion
      _searchResultsController.forward();
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>> getSearchRecipe(String? search) async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.spoonacular.com/recipes/complexSearch?apiKey=$spoonacularapi&query=$search',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['totalresults'] == 0) {
        throw 'No Results Found';
      }
      return data;
    } catch (e) {
      throw 'Connection Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GradientBackground(
      isDark: isDark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_animationController),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),

                      // Enhanced Search Bar Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Search prompt text
                            if (!_hasSearched)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  'What would you like to cook today?',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: isDark
                                        ? AppColors.darkOnSurface.withOpacity(
                                            0.7,
                                          )
                                        : AppColors.lightOnSurface.withOpacity(
                                            0.7,
                                          ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                            // Enhanced search bar
                            EnhancedIOSSearchBar(
                              controller: textEditingController,
                              hintText: 'Search for delicious recipes...',
                              onChanged: (value) {
                                // Debounced search - implement if needed
                              },
                              onSubmitted: _performSearch,
                              autofocus: false,
                              showClearButton: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Search Results Section
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: _buildSearchResults(context, isDark, theme),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(
    BuildContext context,
    bool isDark,
    ThemeData theme,
  ) {
    if (!_hasSearched) {
      return _buildInitialState(isDark, theme);
    }

    if (_isSearching) {
      return _buildLoadingState();
    }

    return FutureBuilder(
      future: recipes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState(isDark, theme);
        }

        final data = snapshot.data!;
        if (data['totalResults'] == 0 ||
            data['results'] == null ||
            data['results'].isEmpty) {
          return _buildEmptyState(isDark, theme);
        }

        return _buildResultsList(data, isDark, theme);
      },
    );
  }

  Widget _buildInitialState(bool isDark, ThemeData theme) {
    return EnhancedEmptyState(
      icon: Icons.restaurant_menu_rounded,
      title: 'Ready to Cook?',
      subtitle:
          'Search for your favorite recipes and discover new culinary adventures.',
      iconColor: isDark ? AppColors.darkAccent : AppColors.lightAccent,
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        // Show skeleton cards while loading
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return SkeletonLoading(
                isLoading: true,
                child: const SkeletonRecipeCard(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(bool isDark, ThemeData theme) {
    return EnhancedEmptyState(
      icon: Icons.wifi_off_rounded,
      title: 'Connection Error',
      subtitle: 'Please check your internet connection and try again.',
      iconColor: AppColors.error,
    );
  }

  Widget _buildEmptyState(bool isDark, ThemeData theme) {
    return EnhancedEmptyState(
      icon: Icons.search_off_rounded,
      title: 'No Recipes Found',
      subtitle: 'Try searching with different keywords or check your spelling.',
      iconColor: isDark
          ? AppColors.darkOnSurface.withOpacity(0.4)
          : AppColors.lightOnSurface.withOpacity(0.4),
    );
  }

  Widget _buildResultsList(
    Map<String, dynamic> data,
    bool isDark,
    ThemeData theme,
  ) {
    final results = data['results'] as List;
    final totalResults = data['totalResults'] as int;
    final itemCount = totalResults < 20 ? totalResults : 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results count
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Found ${totalResults > 0 ? totalResults : results.length} recipe${totalResults == 1 ? '' : 's'}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkOnSurface.withOpacity(0.6)
                  : AppColors.lightOnSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Results list
        Expanded(
          child: AnimatedBuilder(
            animation: _searchResultsController,
            builder: (context, child) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _searchResultsController,
                    curve: AppAnimations.smooth,
                  ),
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    final result = results[index];
                    final resultId = result['id'];
                    final name = result['title'];
                    final image = result['image'];

                    return AnimatedContainer(
                      duration: Duration(milliseconds: 100 + (index * 50)),
                      curve: AppAnimations.smooth,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8,
                        ),
                        child: IOSRecipeListCard(
                          id: resultId,
                          image: image,
                          title: name,
                          description:
                              'Discover this amazing recipe and add it to your favorites',
                          cookingTime: '25',
                          servings: '4',
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
