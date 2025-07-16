import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

/// Enhanced iOS 18-style search bar with advanced features and animations
class EnhancedIOSSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool autofocus;
  final bool showClearButton;
  final Duration animationDuration;

  const EnhancedIOSSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search recipes...',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.autofocus = false,
    this.showClearButton = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<EnhancedIOSSearchBar> createState() => _EnhancedIOSSearchBarState();
}

class _EnhancedIOSSearchBarState extends State<EnhancedIOSSearchBar>
    with TickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _focusAnimationController;
  late AnimationController _glowAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<Color?> _borderColorAnimation;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusAnimationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _glowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _focusAnimationController,
        curve: AppAnimations.smooth,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _glowAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _focusNode.addListener(_onFocusChange);
    widget.controller?.addListener(_onTextChange);

    // Start subtle glow animation
    _glowAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller?.removeListener(_onTextChange);
    _focusNode.dispose();
    _focusAnimationController.dispose();
    _glowAnimationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _focusAnimationController.forward();
    } else {
      _focusAnimationController.reverse();
    }
  }

  void _onTextChange() {
    final hasText = widget.controller?.text.isNotEmpty ?? false;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _clearText() {
    widget.controller?.clear();
    widget.onChanged?.call('');
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dynamic border color based on focus state
    _borderColorAnimation = ColorTween(
      begin: isDark
          ? AppColors.darkGlassStroke.withValues(alpha: 0.3)
          : AppColors.lightGlassStroke.withValues(alpha: 0.3),
      end: isDark ? AppColors.darkAccent : AppColors.lightAccent,
    ).animate(_focusAnimationController);

    return AnimatedBuilder(
      animation: Listenable.merge([
        _focusAnimationController,
        _glowAnimationController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                // Outer glow effect when focused
                if (_isFocused)
                  BoxShadow(
                    color:
                        (isDark ? AppColors.darkAccent : AppColors.lightAccent)
                            .withValues(alpha: 0.3 * _glowAnimation.value),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                // Standard shadow
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.grey.shade400)
                      .withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
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
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.darkGlass.withValues(alpha: 0.8),
                              AppColors.darkGlass.withValues(alpha: 0.6),
                            ]
                          : [
                              AppColors.lightGlass.withValues(alpha: 0.8),
                              AppColors.lightGlass.withValues(alpha: 0.6),
                            ],
                    ),
                    border: Border.all(
                      color: _borderColorAnimation.value ?? Colors.transparent,
                      width: _isFocused ? 1.5 : 0.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // Search icon
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: AnimatedContainer(
                          duration: widget.animationDuration,
                          child: Icon(
                            Icons.search_rounded,
                            color: _isFocused
                                ? (isDark
                                      ? AppColors.darkAccent
                                      : AppColors.lightAccent)
                                : (isDark
                                      ? AppColors.darkOnSurface.withValues(alpha: 0.6)
                                      : AppColors.lightOnSurface.withValues(alpha: 
                                          0.6,
                                        )),
                            size: 22,
                          ),
                        ),
                      ),

                      // Text field
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          focusNode: _focusNode,
                          enabled: widget.enabled,
                          autofocus: widget.autofocus,
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                          onTap: () {
                            widget.onTap?.call();
                            HapticFeedback.selectionClick();
                          },
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isDark
                                ? AppColors.darkOnSurface
                                : AppColors.lightOnSurface,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: theme.textTheme.bodyLarge?.copyWith(
                              color: isDark
                                  ? AppColors.darkOnSurface.withValues(alpha: 0.5)
                                  : AppColors.lightOnSurface.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 0,
                            ),
                          ),
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.text,
                        ),
                      ),

                      // Clear button
                      if (widget.showClearButton && _hasText)
                        AnimatedScale(
                          scale: _hasText ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: GestureDetector(
                            onTap: _clearText,
                            child: Container(
                              margin: const EdgeInsets.only(right: 16, left: 8),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? AppColors.darkOnSurface.withValues(alpha: 0.1)
                                    : AppColors.lightOnSurface.withValues(alpha: 0.1),
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: isDark
                                    ? AppColors.darkOnSurface.withValues(alpha: 0.7)
                                    : AppColors.lightOnSurface.withValues(alpha: 0.7),
                                size: 16,
                              ),
                            ),
                          ),
                        ),

                      // Custom suffix icon
                      if (widget.suffixIcon != null &&
                          (!_hasText || !widget.showClearButton))
                        Padding(
                          padding: const EdgeInsets.only(right: 16, left: 8),
                          child: widget.suffixIcon!,
                        ),
                    ],
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
