import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/colors.dart';
import '../../theme/animations.dart';

/// iOS 18-inspired search bar with glassmorphism effects
class IOSSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool autofocus;

  const IOSSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search recipes...',
    this.onChanged,
    this.onTap,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.autofocus = false,
  });

  @override
  State<IOSSearchBar> createState() => _IOSSearchBarState();
}

class _IOSSearchBarState extends State<IOSSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isFocused = false;
  bool _hasText = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _focusNode.addListener(_onFocusChange);
    widget.controller?.addListener(_onTextChange);

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTextChange() {
    setState(() {
      _hasText = widget.controller?.text.isNotEmpty ?? false;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller?.removeListener(_onTextChange);
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
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (_isFocused)
                  BoxShadow(
                    color: theme.colorScheme.secondary.withOpacity(
                      0.3 * _glowAnimation.value,
                    ),
                    blurRadius: 20 * _glowAnimation.value,
                    spreadRadius: 2 * _glowAnimation.value,
                  ),
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.grey.shade300)
                      .withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
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
                      color: _isFocused
                          ? theme.colorScheme.secondary.withOpacity(0.6)
                          : (isDark
                                ? AppColors.darkGlassStroke
                                : AppColors.lightGlassStroke),
                      width: _isFocused ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        // Search Icon
                        AnimatedContainer(
                          duration: AppAnimations.fast,
                          margin: const EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.search_rounded,
                            size: 24,
                            color: _isFocused
                                ? theme.colorScheme.secondary
                                : (isDark
                                      ? AppColors.darkOnSurface.withOpacity(0.6)
                                      : AppColors.lightOnSurface.withOpacity(
                                          0.6,
                                        )),
                          ),
                        ),

                        // Text Field
                        Expanded(
                          child: TextField(
                            controller: widget.controller,
                            focusNode: _focusNode,
                            enabled: widget.enabled,
                            onChanged: widget.onChanged,
                            onTap: widget.onTap,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: isDark
                                  ? AppColors.darkOnSurface
                                  : AppColors.lightOnSurface,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: widget.hintText,
                              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                                color:
                                    (isDark
                                            ? AppColors.darkOnSurface
                                            : AppColors.lightOnSurface)
                                        .withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),

                        // Clear Button or Suffix Icon
                        if (_hasText && widget.enabled) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              widget.controller?.clear();
                              widget.onChanged?.call('');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    (isDark
                                            ? AppColors.darkOnSurface
                                            : AppColors.lightOnSurface)
                                        .withOpacity(0.2),
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: isDark
                                    ? AppColors.darkOnSurface
                                    : AppColors.lightOnSurface,
                              ),
                            ),
                          ),
                        ] else if (widget.suffixIcon != null) ...[
                          const SizedBox(width: 8),
                          widget.suffixIcon!,
                        ],
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
