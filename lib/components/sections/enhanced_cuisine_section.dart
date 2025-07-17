import 'package:flutter/material.dart';
import '../cards/cuisine_category_card.dart';
import '../../pages/cuisines_page.dart';
import '../../pages/all_cuisines_page.dart';
import '../../globals.dart';
import '../../theme/colors.dart';
import '../buttons/glassmorphic_see_all_button.dart';

class EnhancedCuisineSection extends StatefulWidget {
  const EnhancedCuisineSection({super.key});

  @override
  State<EnhancedCuisineSection> createState() => _EnhancedCuisineSectionState();
}

class _EnhancedCuisineSectionState extends State<EnhancedCuisineSection> {
  String selectedCuisine = cuisines[0];
  final PageController _pageController = PageController(viewportFraction: 0.45);

  // Cuisine data with emojis and descriptions
  final Map<String, Map<String, String>> cuisineData = {
    'All': {'emoji': '🌍', 'description': 'Global flavors'},
    'African': {'emoji': '🌍', 'description': 'Rich traditions'},
    'Asian': {'emoji': '🥢', 'description': 'Eastern delights'},
    'American': {'emoji': '🍔', 'description': 'Classic comfort'},
    'British': {'emoji': '🇬🇧', 'description': 'Traditional fare'},
    'Cajun': {'emoji': '🌶️', 'description': 'Spicy southern'},
    'Caribbean': {'emoji': '🏝️', 'description': 'Island vibes'},
    'Chinese': {'emoji': '🥡', 'description': 'Ancient wisdom'},
    'Eastern European': {'emoji': '🥟', 'description': 'Hearty dishes'},
    'European': {'emoji': '🍷', 'description': 'Continental style'},
    'French': {'emoji': '🥐', 'description': 'Culinary art'},
    'German': {'emoji': '🍺', 'description': 'Robust flavors'},
    'Greek': {'emoji': '🫒', 'description': 'Mediterranean'},
    'Indian': {'emoji': '🍛', 'description': 'Spice paradise'},
    'Irish': {'emoji': '☘️', 'description': 'Cozy comfort'},
    'Italian': {'emoji': '🍝', 'description': 'La dolce vita'},
    'Japanese': {'emoji': '🍣', 'description': 'Zen perfection'},
    'Jewish': {'emoji': '🕯️', 'description': 'Sacred traditions'},
    'Korean': {'emoji': '🥢', 'description': 'K-food culture'},
    'Latin American': {'emoji': '🌮', 'description': 'Vibrant tastes'},
    'Mediterranean': {'emoji': '🫒', 'description': 'Healthy living'},
    'Mexican': {'emoji': '🌯', 'description': 'Fiesta flavors'},
    'Middle Eastern': {'emoji': '🧿', 'description': 'Ancient spices'},
    'Nordic': {'emoji': '❄️', 'description': 'Clean & fresh'},
    'Southern': {'emoji': '🍑', 'description': 'Soul food'},
    'Spanish': {'emoji': '🥘', 'description': 'Passionate plates'},
    'Thai': {'emoji': '🌶️', 'description': 'Sweet & spicy'},
    'Vietnamese': {'emoji': '🍜', 'description': 'Fresh herbs'},
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with enhanced styling
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.secondary,
                      theme.colorScheme.secondary.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.explore, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Browse by Cuisine',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: isDark
                            ? AppColors.darkOnSurface
                            : AppColors.lightOnSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Discover flavors from around the world',
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
              GlassmorphicSeeAllButton(
                text: 'View All',
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const AllCuisinesPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOutCubic;

                            var tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Featured Cuisines Carousel
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            itemCount: cuisines.length,
            itemBuilder: (context, index) {
              final cuisine = cuisines[index];
              final data =
                  cuisineData[cuisine] ??
                  {'emoji': '🍽️', 'description': 'Delicious food'};

              return CuisineCategoryCard(
                cuisineName: cuisine,
                emoji: data['emoji']!,
                description: data['description']!,
                isSelected: selectedCuisine == cuisine,
                onTap: () {
                  setState(() {
                    selectedCuisine = cuisine;
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CuisinesPage(cuisineSearch: selectedCuisine),
                    ),
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // Quick Access Popular Cuisines
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Popular Choices',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkOnSurface
                      : AppColors.lightOnSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Quick access grid for popular cuisines
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      [
                        'Italian',
                        'Chinese',
                        'Mexican',
                        'Indian',
                        'Japanese',
                        'French',
                      ].map((cuisine) {
                        final data =
                            cuisineData[cuisine] ??
                            {'emoji': '🍽️', 'description': 'Delicious'};
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCuisine = cuisine;
                                });
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CuisinesPage(
                                      cuisineSearch: selectedCuisine,
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
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
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      data['emoji']!,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      cuisine,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: isDark
                                                ? AppColors.darkOnSurface
                                                : AppColors.lightOnSurface,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
