import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../util/secrets.dart';
import '../theme/colors.dart';
import '../theme/animations.dart';
import '../components/cards/ios_recipe_list_card.dart';
import '../components/layout/gradient_background.dart';
import '../components/layout/elegant_loading_text.dart';
import '../components/navigation/glassmorphic_app_bar.dart';

class FeaturedRecipesPage extends StatefulWidget {
  const FeaturedRecipesPage({super.key});

  @override
  State<FeaturedRecipesPage> createState() => _FeaturedRecipesPageState();
}

class _FeaturedRecipesPageState extends State<FeaturedRecipesPage>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>> recipes;
  int _currentOffset = 0;
  final int _itemsPerPage = 20;
  List<dynamic> _allRecipes = [];
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.pageTransition,
      vsync: this,
    );
    _animationController.forward();

    recipes = getRecipes(offset: 0);
    _scrollController.addListener(_onScroll);
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
      final newRecipes = await getRecipes(
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

  Future<Map<String, dynamic>> getRecipes({int offset = 0}) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.spoonacular.com/recipes/complexSearch?apiKey=$spoonacularapi&addRecipeInformation=true&fillIngredients=true&number=$_itemsPerPage&offset=$offset',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (offset == 0) {
          setState(() {
            _allRecipes = List.from(data['results']);
          });
        }
        return data;
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
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
        extendBodyBehindAppBar: true,
        appBar: GlassmorphicAppBar(
          title: 'Featured Recipes',
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
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
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
                  Icons.filter_list_rounded,
                  color: isDark
                      ? AppColors.darkOnSurface
                      : AppColors.lightOnSurface,
                  size: 20,
                ),
                onPressed: () {
                  // TODO: Implement filter functionality
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _animationController,
            child: FutureBuilder<Map<String, dynamic>>(
              future: recipes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingState(context);
                }

                if (snapshot.hasError) {
                  return _buildErrorState(context, snapshot.error.toString());
                }

                return _buildRecipesList(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: ElegantLoadingText(
        message: 'Finding featured recipes',
        showDots: true,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                gradient: LinearGradient(
                  colors: isDark
                      ? AppColors.darkCardGradient
                      : AppColors.cardGradient,
                ),
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                setState(() {
                  recipes = getRecipes(offset: 0);
                });
              },
              child: const Text('Try Again'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Handpicked for You',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover ${_allRecipes.length}+ carefully curated recipes by our culinary experts',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
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
