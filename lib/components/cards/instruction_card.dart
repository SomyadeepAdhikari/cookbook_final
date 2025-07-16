import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/colors.dart';

/// Individual instruction card with modern iOS 18 styling
class InstructionCard extends StatefulWidget {
  final int stepNumber;
  final String instruction;
  final bool isCompleted;
  final VoidCallback? onTap;

  const InstructionCard({
    super.key,
    required this.stepNumber,
    required this.instruction,
    this.isCompleted = false,
    this.onTap,
  });

  @override
  State<InstructionCard> createState() => _InstructionCardState();
}

class _InstructionCardState extends State<InstructionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _shadowAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _animationController.reverse();
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
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.grey.shade300)
                      .withOpacity(0.3 * _shadowAnimation.value),
                  blurRadius: 20 * _shadowAnimation.value,
                  offset: Offset(0, 8 * _shadowAnimation.value),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: GestureDetector(
                  onTapDown: widget.onTap != null ? _onTapDown : null,
                  onTapUp: widget.onTap != null ? _onTapUp : null,
                  onTapCancel: widget.onTap != null ? _onTapCancel : null,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isCompleted
                            ? [
                                AppColors.success.withOpacity(0.1),
                                AppColors.success.withOpacity(0.05),
                              ]
                            : isDark
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
                        color: widget.isCompleted
                            ? AppColors.success.withOpacity(0.4)
                            : isDark
                            ? AppColors.darkGlassStroke
                            : AppColors.lightGlassStroke,
                        width: widget.isCompleted ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Step number circle
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: widget.isCompleted
                                    ? [
                                        AppColors.success,
                                        AppColors.success.withOpacity(0.8),
                                      ]
                                    : [
                                        theme.colorScheme.secondary,
                                        theme.colorScheme.secondary.withOpacity(
                                          0.8,
                                        ),
                                      ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (widget.isCompleted
                                              ? AppColors.success
                                              : theme.colorScheme.secondary)
                                          .withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: widget.isCompleted
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    )
                                  : Text(
                                      '${widget.stepNumber}',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                    ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Instruction text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Step ${widget.stepNumber}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.instruction,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: isDark
                                        ? AppColors.darkOnSurface
                                        : AppColors.lightOnSurface,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Completion indicator
                          if (widget.onTap != null)
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: widget.isCompleted
                                      ? AppColors.success
                                      : theme.colorScheme.secondary.withOpacity(
                                          0.5,
                                        ),
                                  width: 2,
                                ),
                                color: widget.isCompleted
                                    ? AppColors.success
                                    : Colors.transparent,
                              ),
                              child: widget.isCompleted
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
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
