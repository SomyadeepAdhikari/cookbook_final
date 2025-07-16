import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme/colors.dart';

/// Modern glassmorphic app bar with iOS 18-inspired design
class GlassmorphicAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final double elevation;
  final Color? backgroundColor;
  final bool centerTitle;
  final double? leadingWidth;
  final double toolbarHeight;

  const GlassmorphicAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.elevation = 0,
    this.backgroundColor,
    this.centerTitle = true,
    this.leadingWidth,
    this.toolbarHeight = 90,
  });

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final canPop = Navigator.of(context).canPop();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  (isDark
                      ? AppColors.darkSurface.withValues(alpha: 0.9)
                      : AppColors.lightSurface.withValues(alpha: 0.9)),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? AppColors.darkGlassStroke
                      : AppColors.lightGlassStroke,
                  width: 1,
                ),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: isDark ? 0.1 : 0.2),
                  Colors.white.withValues(alpha: isDark ? 0.05 : 0.1),
                ],
              ),
              boxShadow: elevation > 0
                  ? [
                      BoxShadow(
                        color: isDark
                            ? AppColors.darkShadow
                            : AppColors.lightShadow,
                        blurRadius: elevation * 2,
                        offset: Offset(0, elevation),
                      ),
                    ]
                  : null,
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: centerTitle,
              leadingWidth: leadingWidth,
              toolbarHeight: toolbarHeight,
              systemOverlayStyle: isDark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
              leading: _buildLeading(context, canPop, isDark),
              title:
                  titleWidget ??
                  (title != null
                      ? Text(
                          title!,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: isDark
                                ? AppColors.darkOnSurface
                                : AppColors.lightOnSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null),
              actions: actions
                  ?.map((action) => _wrapAction(action, isDark))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, bool canPop, bool isDark) {
    if (leading != null) {
      return _wrapAction(leading!, isDark);
    }

    if (showBackButton && canPop) {
      return Container(
        margin: const EdgeInsets.only(left: 15, right: 5),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onBackPressed ?? () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark
                    ? AppColors.darkSurface.withValues(alpha: 0.5)
                    : AppColors.lightSurface.withValues(alpha: 0.8),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkGlassStroke
                      : AppColors.lightGlassStroke,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: isDark
                    ? AppColors.darkOnSurface
                    : AppColors.lightOnSurface,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }

    return null;
  }

  Widget _wrapAction(Widget action, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: action,
    );
  }
}
