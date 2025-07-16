import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

/// Modern category card with iOS 18-inspired design
class CategoryCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color? accentColor;

  const CategoryCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.imageUrl,
    this.onTap,
    this.isSelected = false,
    this.accentColor,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.cardTap,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
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

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = widget.accentColor ?? theme.colorScheme.secondary;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: AppAnimations.medium,
                curve: AppAnimations.smooth,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: widget.isSelected
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            accentColor.withValues(alpha: 0.2),
                            accentColor.withValues(alpha: 0.1),
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? AppColors.darkCardGradient
                              : AppColors.cardGradient,
                        ),
                  border: widget.isSelected
                      ? Border.all(
                          color: accentColor.withValues(alpha: 0.5),
                          width: 2,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? AppColors.darkShadow
                          : AppColors.lightShadow,
                      blurRadius: _isPressed ? 8 : 16,
                      offset: Offset(0, _isPressed ? 4 : 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Icon or Image section
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: widget.isSelected
                                  ? [accentColor.withValues(alpha: 0.8), accentColor]
                                  : [
                                      accentColor.withValues(alpha: 0.2),
                                      accentColor.withValues(alpha: 0.4),
                                    ],
                            ),
                          ),
                          child: widget.imageUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    widget.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        widget.icon ?? Icons.restaurant,
                                        color: Colors.white,
                                        size: 30,
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  widget.icon ?? Icons.restaurant,
                                  color: Colors.white,
                                  size: 30,
                                ),
                        ),

                        const SizedBox(width: 16),

                        // Text content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: widget.isSelected
                                      ? accentColor
                                      : (isDark
                                            ? AppColors.darkOnSurface
                                            : AppColors.lightOnSurface),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (widget.subtitle != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  widget.subtitle!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color:
                                        (isDark
                                                ? AppColors.darkOnSurface
                                                : AppColors.lightOnSurface)
                                            .withValues(alpha: 0.7),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Arrow indicator
                        AnimatedRotation(
                          turns: widget.isSelected ? 0.25 : 0,
                          duration: AppAnimations.medium,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: widget.isSelected
                                ? accentColor
                                : (isDark
                                          ? AppColors.darkOnSurface
                                          : AppColors.lightOnSurface)
                                      .withValues(alpha: 0.5),
                            size: 16,
                          ),
                        ),
                      ],
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
