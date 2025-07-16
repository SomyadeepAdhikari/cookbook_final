import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

enum SortOption {
  alphabetical('A-Z', Icons.sort_by_alpha),
  reverseAlphabetical('Z-A', Icons.sort_by_alpha),
  newest('Newest', Icons.new_releases),
  rating('Rating', Icons.star);

  const SortOption(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// iOS 18-inspired sort dropdown with glassmorphism
class IOSSortDropdown extends StatefulWidget {
  final SortOption selectedOption;
  final ValueChanged<SortOption> onChanged;
  final List<SortOption> options;

  const IOSSortDropdown({
    super.key,
    required this.selectedOption,
    required this.onChanged,
    this.options = SortOption.values,
  });

  @override
  State<IOSSortDropdown> createState() => _IOSSortDropdownState();
}

class _IOSSortDropdownState extends State<IOSSortDropdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
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

  void _toggleDropdown() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
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
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              AppColors.darkGlass.withOpacity(0.9),
                              AppColors.darkGlass.withOpacity(0.7),
                            ]
                          : [
                              AppColors.lightGlass.withOpacity(0.9),
                              AppColors.lightGlass.withOpacity(0.7),
                            ],
                    ),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkGlassStroke
                          : AppColors.lightGlassStroke,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? Colors.black : Colors.grey.shade300)
                            .withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _toggleDropdown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sort_rounded,
                              size: 20,
                              color: theme.colorScheme.secondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Sort: ${widget.selectedOption.label}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? AppColors.darkOnSurface
                                    : AppColors.lightOnSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            AnimatedRotation(
                              turns: _isExpanded ? 0.5 : 0.0,
                              duration: AppAnimations.medium,
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: isDark
                                    ? AppColors.darkOnSurface.withOpacity(0.7)
                                    : AppColors.lightOnSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
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

/// Sort dropdown menu overlay
class IOSSortDropdownMenu extends StatelessWidget {
  final List<SortOption> options;
  final SortOption selectedOption;
  final ValueChanged<SortOption> onSelected;

  const IOSSortDropdownMenu({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey.shade400).withOpacity(
              0.3,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        AppColors.darkGlass.withOpacity(0.95),
                        AppColors.darkGlass.withOpacity(0.85),
                      ]
                    : [
                        AppColors.lightGlass.withOpacity(0.95),
                        AppColors.lightGlass.withOpacity(0.85),
                      ],
              ),
              border: Border.all(
                color: isDark
                    ? AppColors.darkGlassStroke
                    : AppColors.lightGlassStroke,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) {
                final isSelected = option == selectedOption;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onSelected(option),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.secondary.withOpacity(0.1)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            option.icon,
                            size: 20,
                            color: isSelected
                                ? theme.colorScheme.secondary
                                : (isDark
                                      ? AppColors.darkOnSurface.withOpacity(0.7)
                                      : AppColors.lightOnSurface.withOpacity(
                                          0.7,
                                        )),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option.label,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isSelected
                                    ? theme.colorScheme.secondary
                                    : (isDark
                                          ? AppColors.darkOnSurface
                                          : AppColors.lightOnSurface),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_rounded,
                              size: 20,
                              color: theme.colorScheme.secondary,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
