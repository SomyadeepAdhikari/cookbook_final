import 'package:flutter/material.dart';

/// Animation curves and durations for the cookbook app
class AppAnimations {
  // Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration extraSlow = Duration(milliseconds: 800);

  // Curves - iOS-inspired easing
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticOut = Curves.elasticOut;

  // Custom curves for iOS-like feel
  static const Curve smooth = Cubic(0.25, 0.1, 0.25, 1);
  static const Curve spring = Cubic(0.175, 0.885, 0.32, 1.275);

  // Hero animation
  static const Duration heroAnimation = Duration(milliseconds: 400);

  // Page transitions
  static const Duration pageTransition = Duration(milliseconds: 300);

  // Favorite button animation
  static const Duration favoriteAnimation = Duration(milliseconds: 250);

  // Search animation
  static const Duration searchAnimation = Duration(milliseconds: 200);

  // Card hover/tap animations
  static const Duration cardHover = Duration(milliseconds: 150);
  static const Duration cardTap = Duration(milliseconds: 100);
}
