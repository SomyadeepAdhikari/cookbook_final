import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme/colors.dart';
import '../../theme/animations.dart';
import '../grids/enhanced_cuisine_grid.dart';
import '../chips/glassmorphic_category_chip.dart';
import '../buttons/glassmorphic_see_all_button.dart';

/// Enhanced Browse by Cuisine section with adaptive grid and glassmorphic chips
class EnhancedCuisineSection extends StatefulWidget {
  const EnhancedCuisineSection({super.key});

  @override
  State<EnhancedCuisineSection> createState() => _EnhancedCuisineSectionState();
}

class _EnhancedCuisineSectionState extends State<EnhancedCuisineSection>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _gridController;
  late Animation<double> _headerSlideAnimation;
  late Animation<double> _headerFadeAnimation;

  String _selectedCuisine = 'All';
  String _selectedCategory = 'All';

  // Enhanced cuisine data with better descriptions
  final Map<String, Map<String, String>> _cuisineData = {
    'Italian': {
      'emoji': '🇮🇹',
      'description': 'Pasta, pizza & classic flavors',
    },
    'Chinese': {
      'emoji': '🇨🇳',
      'description': 'Authentic stir-fries & dim sum',
    },
    'Mexican': {'emoji': '🇲🇽', 'description': 'Spicy tacos & vibrant dishes'},
    'Indian': {
      'emoji': '🇮🇳',
      'description': 'Rich curries & aromatic spices',
    },
    'French': {'emoji': '🇫🇷', 'description': 'Elegant cuisine & fine dining'},
    'Japanese': {
      'emoji': '🇯🇵',
      'description': 'Fresh sushi & delicate flavors',
    },
    'Thai': {'emoji': '🇹🇭', 'description': 'Balance of sweet & spicy'},
    'Korean': {'emoji': '🇰🇷', 'description': 'Fermented & umami-rich'},
  };

  final List<String> _cuisines = [
    'All',
    'Italian',
    'Chinese',
    'Mexican',
    'Indian',
    'French',
    'Japanese',
    'Thai',
    'Korean',
  ];

  // Category filters
  final List<Map<String, String>> _categories = [
    {'name': 'All', 'emoji': '🍽️'},
    {'name': 'Popular', 'emoji': '⭐'},
    {'name': 'Quick', 'emoji': '⚡'},
    {'name': 'Healthy', 'emoji': '🥗'},
    {'name': 'Comfort', 'emoji': '🏠'},
    {'name': 'Festive', 'emoji': '🎉'},
  ];

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );

    _gridController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _headerSlideAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(parent: _headerController, curve: AppAnimations.smooth),
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: AppAnimations.smooth),
    );

    // Start animations
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _headerController.forward();
        _gridController.forward();
      }
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _gridController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    HapticFeedback.selectionClick();

    // Restart grid animation for filter change
    _gridController.reset();
    _gridController.forward();
  }

  void _onCuisineSelected(String cuisine) {
    setState(() {
      _selectedCuisine = cuisine;
    });
  }

  String? get _filterQuery {
    if (_selectedCategory == 'All') return null;

    // Map categories to search terms that would appear in cuisine descriptions
    final categoryFilters = {
      'Popular': 'classic|traditional|authentic',
      'Quick': 'quick|fast|easy',
      'Healthy': 'fresh|light|healthy',
      'Comfort': 'rich|comfort|hearty',
      'Festive': 'celebration|festive|special',
    };

    return categoryFilters[_selectedCategory];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 32),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _headerController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _headerSlideAnimation.value),
                  child: Opacity(
                    opacity: _headerFadeAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Main header with see all button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Browse by Cuisine',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 24,
                                            color: isDark
                                                ? AppColors.darkOnSurface
                                                : AppColors.lightOnSurface,
                                            letterSpacing: -0.5,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Discover authentic flavors from around the world',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color:
                                                (isDark
                                                        ? AppColors
                                                              .darkOnSurface
                                                        : AppColors
                                                              .lightOnSurface)
                                                    .withOpacity(0.7),
                                            fontSize: 14,
                                            height: 1.3,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              GlassmorphicSeeAllButton(
                                onTap: () {
                                  // TODO: Navigate to all cuisines page
                                  HapticFeedback.lightImpact();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Category Chips Section
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _headerController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _headerSlideAnimation.value * 0.5),
                  child: Opacity(
                    opacity: _headerFadeAnimation.value,
                    child: Container(
                      margin: const EdgeInsets.only(top: 24, bottom: 20),
                      child: GlassmorphicChipSection(
                        categories: _categories,
                        selectedCategory: _selectedCategory,
                        onCategoryChanged: _onCategoryChanged,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Enhanced Cuisine Grid
          EnhancedCuisineGrid(
            cuisines: _cuisines,
            cuisineData: _cuisineData,
            selectedCuisine: _selectedCuisine,
            onCuisineSelected: _onCuisineSelected,
            filterQuery: _filterQuery,
          ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

/// Enhanced cuisine category card for the grid
class CuisineCategoryCard extends StatefulWidget {
  final String cuisine;
  final String emoji;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const CuisineCategoryCard({
    super.key,
    required this.cuisine,
    required this.emoji,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<CuisineCategoryCard> createState() => _CuisineCategoryCardState();
}

class _CuisineCategoryCardState extends State<CuisineCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.cardHover,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _elevationAnimation = Tween<double>(begin: 8.0, end: 16.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? Colors.black : Colors.grey.shade300)
                        .withOpacity(isDark ? 0.5 : 0.2),
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value / 2),
                  ),
                  if (widget.isSelected)
                    BoxShadow(
                      color: theme.colorScheme.secondary.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 0),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isSelected
                            ? [
                                theme.colorScheme.secondary.withOpacity(0.9),
                                theme.colorScheme.secondary.withOpacity(0.7),
                              ]
                            : isDark
                            ? [
                                AppColors.darkCardGradient[0].withOpacity(0.9),
                                AppColors.darkCardGradient[1].withOpacity(0.7),
                              ]
                            : [
                                AppColors.cardGradient[0].withOpacity(0.9),
                                AppColors.cardGradient[1].withOpacity(0.7),
                              ],
                      ),
                      border: Border.all(
                        color: widget.isSelected
                            ? theme.colorScheme.secondary.withOpacity(0.6)
                            : (isDark
                                  ? AppColors.darkGlassStroke
                                  : AppColors.lightGlassStroke),
                        width: widget.isSelected ? 2 : 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Emoji
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.isSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : theme.colorScheme.secondary.withOpacity(
                                      0.1,
                                    ),
                            ),
                            child: Center(
                              child: Text(
                                widget.emoji,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Cuisine name
                          Text(
                            widget.cuisine,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: widget.isSelected
                                  ? Colors.white
                                  : (isDark
                                        ? AppColors.darkOnSurface
                                        : AppColors.lightOnSurface),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),

                          // Description
                          Text(
                            widget.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: widget.isSelected
                                  ? Colors.white.withOpacity(0.9)
                                  : (isDark
                                            ? AppColors.darkOnSurface
                                            : AppColors.lightOnSurface)
                                        .withOpacity(0.7),
                              fontSize: 11,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
