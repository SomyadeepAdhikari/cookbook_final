import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/animations.dart';
import '../components/cards/ios_cuisine_list_card.dart';
import '../components/layout/gradient_background.dart';
import '../components/navigation/glassmorphic_app_bar.dart';
import '../globals.dart';
import '../pages/cuisines_page.dart';

class AllCuisinesPage extends StatefulWidget {
  const AllCuisinesPage({super.key});

  @override
  State<AllCuisinesPage> createState() => _AllCuisinesPageState();
}

class _AllCuisinesPageState extends State<AllCuisinesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Enhanced cuisine data with rich descriptions and emojis
  final Map<String, Map<String, String>> cuisineData = {
    'African': {
      'emoji': '🌍',
      'description': 'Rich traditions & bold spices',
      'region': 'Continental',
    },
    'Asian': {
      'emoji': '🥢',
      'description': 'Eastern delights & umami flavors',
      'region': 'Continental',
    },
    'American': {
      'emoji': '🍔',
      'description': 'Classic comfort & BBQ',
      'region': 'North America',
    },
    'British': {
      'emoji': '🇬🇧',
      'description': 'Traditional hearty meals',
      'region': 'Europe',
    },
    'Cajun': {
      'emoji': '🌶️',
      'description': 'Spicy Louisiana soul food',
      'region': 'North America',
    },
    'Caribbean': {
      'emoji': '🏖️',
      'description': 'Tropical island flavors',
      'region': 'Caribbean',
    },
    'Chinese': {
      'emoji': '🥡',
      'description': 'Ancient culinary artistry',
      'region': 'East Asia',
    },
    'Eastern European': {
      'emoji': '🥟',
      'description': 'Hearty comfort foods',
      'region': 'Europe',
    },
    'European': {
      'emoji': '🍷',
      'description': 'Refined continental cuisine',
      'region': 'Europe',
    },
    'French': {
      'emoji': '🥐',
      'description': 'Elegant culinary mastery',
      'region': 'Europe',
    },
    'German': {
      'emoji': '🍺',
      'description': 'Robust & traditional flavors',
      'region': 'Europe',
    },
    'Greek': {
      'emoji': '🫒',
      'description': 'Mediterranean freshness',
      'region': 'Europe',
    },
    'Indian': {
      'emoji': '🍛',
      'description': 'Aromatic spice symphony',
      'region': 'South Asia',
    },
    'Irish': {
      'emoji': '☘️',
      'description': 'Wholesome farmhouse fare',
      'region': 'Europe',
    },
    'Italian': {
      'emoji': '🍝',
      'description': 'Timeless pasta perfection',
      'region': 'Europe',
    },
    'Japanese': {
      'emoji': '🍣',
      'description': 'Precise & artful dishes',
      'region': 'East Asia',
    },
    'Jewish': {
      'emoji': '🕊️',
      'description': 'Traditional kosher cuisine',
      'region': 'Cultural',
    },
    'Korean': {
      'emoji': '🥢',
      'description': 'Fermented & fiery flavors',
      'region': 'East Asia',
    },
    'Latin American': {
      'emoji': '🌮',
      'description': 'Vibrant & zesty dishes',
      'region': 'Americas',
    },
    'Mediterranean': {
      'emoji': '🫒',
      'description': 'Sun-kissed healthy eating',
      'region': 'Mediterranean',
    },
    'Mexican': {
      'emoji': '🌮',
      'description': 'Bold & colorful traditions',
      'region': 'North America',
    },
    'Middle Eastern': {
      'emoji': '🥙',
      'description': 'Ancient spice routes',
      'region': 'Middle East',
    },
    'Nordic': {
      'emoji': '🐟',
      'description': 'Clean & minimalist cooking',
      'region': 'Europe',
    },
    'Southern': {
      'emoji': '🍑',
      'description': 'Soul food & hospitality',
      'region': 'North America',
    },
    'Spanish': {
      'emoji': '🥘',
      'description': 'Passionate & diverse plates',
      'region': 'Europe',
    },
    'Thai': {
      'emoji': '🌶️',
      'description': 'Sweet, sour & spicy harmony',
      'region': 'Southeast Asia',
    },
    'Turkish': {
      'emoji': '🥙',
      'description': 'Ottoman culinary heritage',
      'region': 'Middle East',
    },
    'Vietnamese': {
      'emoji': '🍜',
      'description': 'Fresh herbs & balance',
      'region': 'Southeast Asia',
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.pageTransition,
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<String> get filteredCuisines {
    if (_searchQuery.isEmpty) {
      return cuisines.where((cuisine) => cuisine != 'All').toList();
    }
    return cuisines
        .where(
          (cuisine) =>
              cuisine != 'All' &&
              (cuisine.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  (cuisineData[cuisine]?['description']?.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      ) ??
                      false)),
        )
        .toList();
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
          title: 'World Cuisines',
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
                  Icons.shuffle_rounded,
                  color: isDark
                      ? AppColors.darkOnSurface
                      : AppColors.lightOnSurface,
                  size: 20,
                ),
                onPressed: () {
                  // Shuffle and navigate to a random cuisine
                  final randomCuisine = (filteredCuisines..shuffle()).first;
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          CuisinesPage(cuisineSearch: randomCuisine),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                      transitionDuration: AppAnimations.pageTransition,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _animationController,
            child: CustomScrollView(
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
                          'Explore Global Flavors',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Discover authentic recipes from ${filteredCuisines.length} different cuisines around the world',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Search Bar
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: isDark
                                  ? AppColors.darkCardGradient
                                  : AppColors.cardGradient,
                            ),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkGlassStroke
                                  : AppColors.lightGlassStroke,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Search cuisines...',
                              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.5,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: theme.colorScheme.secondary,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear_rounded,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.5),
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchQuery = '';
                                        });
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Results count
                if (_searchQuery.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        '${filteredCuisines.length} cuisines found',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Cuisines List
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final cuisine = filteredCuisines[index];
                    final data =
                        cuisineData[cuisine] ??
                        {
                          'emoji': '🍽️',
                          'description': 'Delicious cuisine',
                          'region': 'Global',
                        };

                    return Padding(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        bottom: index == filteredCuisines.length - 1
                            ? 100.0
                            : 16.0,
                      ),
                      child: IOSCuisineListCard(
                        name: cuisine,
                        emoji: data['emoji']!,
                        description: data['description']!,
                        region: data['region']!,
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      CuisinesPage(cuisineSearch: cuisine),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
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
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                              transitionDuration: AppAnimations.pageTransition,
                            ),
                          );
                        },
                      ),
                    );
                  }, childCount: filteredCuisines.length),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
