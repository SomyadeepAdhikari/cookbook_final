import 'dart:convert';
import 'package:cookbook_final/util/secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../theme/colors.dart';
import '../theme/animations.dart';
import '../components/layout/gradient_background.dart';
import '../components/cards/ios_info_card.dart';
import '../components/buttons/animated_favorite_button.dart';
import '../model/favorites_database.dart';
import 'package:provider/provider.dart';

class InformationRedesigned extends StatefulWidget {
  final String name;
  final int id;
  final String image;
  const InformationRedesigned({
    super.key,
    required this.name,
    required this.id,
    required this.image,
  });

  @override
  State<InformationRedesigned> createState() => _InformationRedesignedState();
}

class _InformationRedesignedState extends State<InformationRedesigned>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? data;
  late Future<Map<String, dynamic>> recipes;
  late AnimationController _animationController;
  late Animation<double> _headerAnimation;
  late Animation<Offset> _contentAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    recipes = getRecipes();
    _animationController = AnimationController(
      duration: AppAnimations.pageTransition,
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: AppAnimations.smooth),
      ),
    );

    _contentAnimation =
        Tween<Offset>(begin: const Offset(0, 1.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: AppAnimations.smooth),
          ),
        );

    _animationController.forward();
    _checkFavoriteStatus();
    super.initState();
  }

  void _checkFavoriteStatus() {
    _isFavorite = context.read<FavoritesDatabase>().checkIfFav(widget.id);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> getRecipes() async {
    final newId = widget.id;
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.spoonacular.com/recipes/$newId/information?apiKey=$spoonacularapi',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['totalResults'] == 0) {
        throw 'No result Found';
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
        extendBodyBehindAppBar: true,
        body: FutureBuilder(
          future: recipes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState(context);
            }
            if (snapshot.hasError) {
              return _buildErrorState(context, snapshot.error.toString());
            }
            data = snapshot.data!;
            return _buildRecipeContent(context);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              ),
              child: CircularProgressIndicator(
                color: theme.colorScheme.secondary,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading recipe details...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Recipe not found',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We couldn\'t load this recipe. Please try again.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeContent(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Hero Header with Image
            SliverAppBar(
              expandedHeight: 400,
              pinned: true,
              stretch: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedFavoriteButton(
                    isFavorite: _isFavorite,
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });

                      if (_isFavorite) {
                        context.read<FavoritesDatabase>().addFavorite(
                          widget.name,
                          widget.id,
                          widget.image,
                        );
                      } else {
                        context.read<FavoritesDatabase>().deleteId(widget.id);
                      }
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                ],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    FadeTransition(
                      opacity: _headerAnimation,
                      child: Image.network(
                        widget.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface,
                            child: Icon(
                              Icons.restaurant_rounded,
                              size: 64,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                    // Recipe title at bottom
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 40,
                      child: FadeTransition(
                        opacity: _headerAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildQuickStats(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content Section
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _contentAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? [AppColors.darkBackground, AppColors.darkSurface]
                          : [AppColors.lightBackground, AppColors.lightSurface],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Content cards
                        _buildSummaryCard(),
                        _buildIngredientsCard(),
                        _buildInstructionsCard(),
                        _buildNutritionCard(),
                        const SizedBox(height: 100), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickStats() {
    return Wrap(
      spacing: 12,
      children: [
        if (data?['readyInMinutes'] != null)
          _buildStatChip(
            Icons.schedule_rounded,
            '${data!['readyInMinutes']} min',
          ),
        if (data?['servings'] != null)
          _buildStatChip(
            Icons.people_outline_rounded,
            '${data!['servings']} servings',
          ),
        if (data?['aggregateLikes'] != null)
          _buildStatChip(
            Icons.favorite_rounded,
            '${data!['aggregateLikes']} likes',
          ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    if (data?['summary'] == null) return const SizedBox.shrink();

    final summary = data!['summary']
        .toString()
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();

    if (summary.isEmpty) return const SizedBox.shrink();

    return IOSInfoCard(
      title: 'About This Recipe',
      icon: Icons.info_outline_rounded,
      content: Text(
        summary,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(height: 1.5, fontSize: 15),
      ),
    );
  }

  Widget _buildIngredientsCard() {
    final ingredients = data?['extendedIngredients'] as List?;
    if (ingredients == null || ingredients.isEmpty) {
      return const SizedBox.shrink();
    }

    return IOSInfoCard(
      title: 'Ingredients',
      icon: Icons.shopping_cart_rounded,
      iconColor: AppColors.success,
      content: Column(
        children: ingredients.map<Widget>((ingredient) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.1),
                width: 0.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://spoonacular.com/cdn/ingredients_100x100/${ingredient['image']}',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.restaurant_rounded,
                          size: 20,
                          color: Theme.of(context).colorScheme.secondary,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ingredient['original'] ??
                            ingredient['name'] ??
                            'Unknown ingredient',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      if (ingredient['measures']?['metric'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${ingredient['measures']['metric']['amount']} ${ingredient['measures']['metric']['unitShort']}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    final instructions = data?['analyzedInstructions'] as List?;
    if (instructions == null || instructions.isEmpty) {
      return const SizedBox.shrink();
    }

    final steps = instructions[0]['steps'] as List?;
    if (steps == null || steps.isEmpty) {
      return const SizedBox.shrink();
    }

    return IOSInfoCard(
      title: 'Instructions',
      icon: Icons.list_alt_rounded,
      iconColor: AppColors.info,
      content: Column(
        children: steps.asMap().entries.map<Widget>((entry) {
          final index = entry.key;
          final step = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    step['step'] ?? 'Step description not available',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.5, fontSize: 15),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNutritionCard() {
    final nutrition = data?['nutrition']?['nutrients'] as List?;
    if (nutrition == null || nutrition.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get key nutrients
    final calories = nutrition.firstWhere(
      (n) => n['name'] == 'Calories',
      orElse: () => null,
    );
    final protein = nutrition.firstWhere(
      (n) => n['name'] == 'Protein',
      orElse: () => null,
    );
    final carbs = nutrition.firstWhere(
      (n) => n['name'] == 'Carbohydrates',
      orElse: () => null,
    );
    final fat = nutrition.firstWhere(
      (n) => n['name'] == 'Fat',
      orElse: () => null,
    );

    return IOSInfoCard(
      title: 'Nutrition Facts',
      icon: Icons.bar_chart_rounded,
      iconColor: AppColors.warning,
      content: Row(
        children: [
          if (calories != null)
            Expanded(
              child: _buildNutritionItem(
                'Calories',
                '${calories['amount']?.toInt()}',
                'kcal',
                AppColors.error,
              ),
            ),
          if (protein != null)
            Expanded(
              child: _buildNutritionItem(
                'Protein',
                '${protein['amount']?.toInt()}',
                'g',
                AppColors.success,
              ),
            ),
          if (carbs != null)
            Expanded(
              child: _buildNutritionItem(
                'Carbs',
                '${carbs['amount']?.toInt()}',
                'g',
                AppColors.warning,
              ),
            ),
          if (fat != null)
            Expanded(
              child: _buildNutritionItem(
                'Fat',
                '${fat['amount']?.toInt()}',
                'g',
                AppColors.info,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(
    String name,
    String value,
    String unit,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            unit,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
