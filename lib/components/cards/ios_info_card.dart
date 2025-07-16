import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

/// iOS 18-inspired information card with glassmorphic design
class IOSInfoCard extends StatefulWidget {
  final String title;
  final Widget content;
  final IconData? icon;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  const IOSInfoCard({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.iconColor,
    this.padding,
    this.elevation,
  });

  @override
  State<IOSInfoCard> createState() => _IOSInfoCardState();
}

class _IOSInfoCardState extends State<IOSInfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? AppColors.darkShadow
                        : AppColors.lightShadow,
                    blurRadius: widget.elevation ?? 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? AppColors.darkCardGradient
                          : AppColors.cardGradient,
                    ),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkGlassStroke
                          : AppColors.lightGlassStroke,
                      width: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: widget.padding ?? const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with icon and title
                        Row(
                          children: [
                            if (widget.icon != null) ...[
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      (widget.iconColor ??
                                              theme.colorScheme.secondary)
                                          .withOpacity(0.2),
                                      (widget.iconColor ??
                                              theme.colorScheme.secondary)
                                          .withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  widget.icon,
                                  color:
                                      widget.iconColor ??
                                      theme.colorScheme.secondary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: Text(
                                widget.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.darkOnSurface
                                      : AppColors.lightOnSurface,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Content
                        widget.content,
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
