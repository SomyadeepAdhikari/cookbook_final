import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

/// Modern glassmorphic search bar with iOS 18-inspired design
class GlassmorphicSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const GlassmorphicSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search recipes...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  State<GlassmorphicSearchBar> createState() => _GlassmorphicSearchBarState();
}

class _GlassmorphicSearchBarState extends State<GlassmorphicSearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;

    _animationController = AnimationController(
      duration: AppAnimations.searchAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });

      if (hasText) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }

    widget.onChanged?.call(_controller.text);
  }

  void _onFocusChanged(bool focused) {
    setState(() {
      _isFocused = focused;
    });
  }

  void _clearText() {
    _controller.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.darkShadow : AppColors.lightShadow,
            blurRadius: _isFocused ? 20 : 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: AppAnimations.searchAnimation,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkGlass.withValues(alpha: 0.9)
                  : AppColors.lightGlass.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: _isFocused
                    ? theme.colorScheme.secondary.withValues(alpha: 0.5)
                    : (isDark
                          ? AppColors.darkGlassStroke
                          : AppColors.lightGlassStroke),
                width: _isFocused ? 2 : 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: isDark ? 0.1 : 0.3),
                  Colors.white.withValues(alpha: isDark ? 0.05 : 0.1),
                ],
              ),
            ),
            child: Focus(
              onFocusChange: _onFocusChanged,
              child: TextField(
                controller: _controller,
                autofocus: widget.autofocus,
                onSubmitted: widget.onSubmitted,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkOnSurface
                      : AppColors.lightOnSurface,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        (isDark
                                ? AppColors.darkOnSurface
                                : AppColors.lightOnSurface)
                            .withValues(alpha: 0.6),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  prefixIcon:
                      widget.leadingIcon ??
                      Icon(
                        Icons.search,
                        color: theme.colorScheme.secondary,
                        size: 24,
                      ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_hasText)
                        AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Opacity(
                                opacity: _opacityAnimation.value,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: isDark
                                        ? AppColors.darkOnSurface.withValues(alpha: 
                                            0.7,
                                          )
                                        : AppColors.lightOnSurface.withValues(alpha: 
                                            0.7,
                                          ),
                                    size: 20,
                                  ),
                                  onPressed: _clearText,
                                ),
                              ),
                            );
                          },
                        ),
                      if (widget.trailingIcon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: widget.trailingIcon!,
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
  }
}
