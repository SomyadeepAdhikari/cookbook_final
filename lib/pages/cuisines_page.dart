import 'dart:convert';

import 'package:cookbook_final/components/chips/modern_category_chip.dart';
import 'package:cookbook_final/components/cards/ios_recipe_list_card.dart';
import 'package:cookbook_final/components/inputs/ios_sort_dropdown.dart';
import 'package:cookbook_final/components/layout/elegant_loading_text.dart';
import 'package:flutter/material.dart';
import 'package:cookbook_final/util/secrets.dart';
import 'package:http/http.dart' as http;
import '../theme/colors.dart';
import '../theme/animations.dart';
import '../components/layout/gradient_background.dart';
import '../components/navigation/glassmorphic_app_bar.dart';
import '../globals.dart';

class CuisinesPage extends StatefulWidget {
  final String cuisineSearch;
  const CuisinesPage({super.key, required this.cuisineSearch});

  @override
  State<CuisinesPage> createState() => _CuisinesPageState();
}

class _CuisinesPageState extends State<CuisinesPage>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>> recipes;
  late String searchRecipe = '';
  String selectedCuisine = '';
  int _currentOffset = 0;
  final int _itemsPerPage = 20;
  List<dynamic> _allRecipes = [];
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  SortOption _selectedSort = SortOption.alphabetical;

  // Cuisine data with emojis
  final Map<String, String> cuisineEmojis = {
    'African': '🌍',
    'Asian': '🥢',
    'American': '🍔',
    'British': '🇬🇧',
    'Cajun': '🌶️',
    'Caribbean': '🏖️',
    'Chinese': '🥡',
    'Eastern European': '🥟',
    'European': '🍷',
    'French': '🥐',
    'German': '🍺',
    'Greek': '🫒',
    'Indian': '🍛',
    'Irish': '☘️',
    'Italian': '🍝',
    'Japanese': '🍣',
    'Jewish': '🕊️',
    'Korean': '🥢',
    'Latin American': '🌮',
    'Mediterranean': '🫒',
    'Mexican': '🌮',
    'Middle Eastern': '🥙',
    'Nordic': '🐟',
    'Southern': '🍑',
    'Spanish': '🥘',
    'Thai': '🌶️',
    'Turkish': '🥙',
    'Vietnamese': '🍜',
  };

  @override
  void initState() {
    searchRecipe = widget.cuisineSearch;
    selectedCuisine = widget.cuisineSearch;

    _animationController = AnimationController(
      duration: AppAnimations.pageTransition,
      vsync: this,
    );
    _animationController.forward();

    recipes = getSearchRecipe(searchRecipe);
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMoreRecipes();
    }
  }

  Future<void> _loadMoreRecipes() async {
    if (_isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
    });

    try {
      final newRecipes = await getSearchRecipe(
        searchRecipe,
        offset: _currentOffset + _itemsPerPage,
      );
      final newRecipesList = newRecipes['results'] as List;
      setState(() {
        _allRecipes.addAll(newRecipesList);
        _currentOffset += _itemsPerPage;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<Map<String, dynamic>> getSearchRecipe(
    String? search, {
    int offset = 0,
  }) async {
    final searchQuery = search == 'All' ? '' : search;
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.spoonacular.com/recipes/complexSearch?apiKey=$spoonacularapi&cuisine=$searchQuery&addRecipeInformation=true&number=$_itemsPerPage&offset=$offset',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['totalResults'] == 0) {
        throw 'No Results Found';
      }
      if (offset == 0) {
        setState(() {
          _allRecipes = List.from(data['results']);
        });
      }
      return data;
    } catch (e) {
      throw 'Connection Error';
    }
  }

  void _sortRecipes() {
    setState(() {
      switch (_selectedSort) {
        case SortOption.alphabetical:
          _allRecipes.sort(
            (a, b) => (a['title'] ?? '').compareTo(b['title'] ?? ''),
          );
          break;
        case SortOption.reverseAlphabetical:
          _allRecipes.sort(
            (a, b) => (b['title'] ?? '').compareTo(a['title'] ?? ''),
          );
          break;
        case SortOption.rating:
          _allRecipes.sort(
            (a, b) =>
                (b['aggregateLikes'] ?? 0).compareTo(a['aggregateLikes'] ?? 0),
          );
          break;
        case SortOption.newest:
          // Keep original order for newest
          break;
      }
    });
  }

  void _onSortChanged(SortOption newSort) {
    setState(() {
      _selectedSort = newSort;
    });
    _sortRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GradientBackground(
      isDark: isDark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: GlassmorphicAppBar(
          title: '$searchRecipe Cuisine',
          leading: Container(
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.darkGlass : AppColors.lightGlass,
              border: Border.all(
                color: isDark
                    ? AppColors.darkGlassStroke
                    : AppColors.lightGlassStroke,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDark
                    ? AppColors.darkOnSurface
                    : AppColors.lightOnSurface,
                size: 20,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _animationController,
            child: Column(
              children: [
                // Category Chips Section
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: cuisines.length,
                    itemBuilder: (context, index) {
                      final cuisine = cuisines[index];
                      if (cuisine == 'All') return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ModernCategoryChip(
                          label: cuisine,
                          emoji: cuisineEmojis[cuisine] ?? '🍽️',
                          isSelected: selectedCuisine == cuisine,
                          onTap: () {
                            setState(() {
                              selectedCuisine = cuisine;
                              searchRecipe = cuisine;
                              _currentOffset = 0;
                              _allRecipes.clear();
                            });
                            recipes = getSearchRecipe(searchRecipe);
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Recipe Results
                Expanded(
                  child: FutureBuilder(
                    future: recipes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingState(context);
                      }
                      if (snapshot.hasError) {
                        return _buildErrorState(context);
                      }
                      return _buildRecipesList(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: ElegantLoadingText(
        message: 'Finding $searchRecipe recipes',
        showDots: true,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
            const SizedBox(height: 24),
            Text(
              'No $searchRecipe recipes found',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try exploring other cuisines or check back later for new recipes.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipesList(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.secondary,
                        theme.colorScheme.secondary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    cuisineEmojis[searchRecipe] ?? '🍽️',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$searchRecipe Recipes',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        '${_allRecipes.length}+ delicious recipes to explore',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                // Sort Dropdown
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: IOSSortDropdown(
                    selectedOption: _selectedSort,
                    onChanged: _onSortChanged,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Recipes List
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= _allRecipes.length) {
              return _isLoadingMore
                  ? const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: SimpleLoadingText(
                          message: 'Loading more recipes...',
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }

            final recipe = _allRecipes[index];
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: index == _allRecipes.length - 1 ? 100.0 : 16.0,
              ),
              child: IOSRecipeListCard(
                id: recipe['id'] ?? 0,
                title: recipe['title'] ?? 'Unknown Recipe',
                image: recipe['image'] ?? '',
                description:
                    recipe['summary']?.toString().replaceAll(
                      RegExp(r'<[^>]*>'),
                      '',
                    ) ??
                    '',
                cookingTime: recipe['readyInMinutes']?.toString() ?? '30',
                servings: recipe['servings']?.toString() ?? '4',
                rating: (recipe['aggregateLikes'] ?? 0) / 10.0,
                healthScore: recipe['healthScore']?.toDouble() ?? 0.0,
                isVegetarian: recipe['vegetarian'] ?? false,
                isGlutenFree: recipe['glutenFree'] ?? false,
                isVegan: recipe['vegan'] ?? false,
              ),
            );
          }, childCount: _allRecipes.length + (_isLoadingMore ? 1 : 0)),
        ),
      ],
    );
  }
}
