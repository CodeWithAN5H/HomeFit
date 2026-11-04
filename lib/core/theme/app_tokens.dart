import 'package:flutter/widgets.dart';

/// Building blocks of the HomeFit visual system.
///
/// Values live here rather than inside widgets so that spacing, radii and
/// colours stay consistent and can be adjusted in one place.
abstract final class AppColors {
  static const Color background = Color(0xFF070A11);
  static const Color surface = Color(0xFF111826);
  static const Color surfaceHigh = Color(0xFF182133);
  static const Color primary = Color(0xFF7B93FF);
  static const Color primaryDim = Color(0xFF1E2A4A);
  static const Color secondary = Color(0xFFA98BFF);
  static const Color secondaryDim = Color(0xFF251C3B);
  static const Color textPrimary = Color(0xFFE9EEF9);
  static const Color textMuted = Color(0xFF949FB6);
  static const Color outline = Color(0xFF222D42);
  static const Color success = Color(0xFF4CD3A5);
  static const Color warning = Color(0xFFF5C06B);
  static const Color danger = Color(0xFFFF6B81);
  static const Color onAccent = Color(0xFF07101F);
}

abstract final class AppRadius {
  static const double card = 20;
  static const double field = 14;
  static const double chip = 12;
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Horizontal page padding for scrollable screens.
const EdgeInsets kPagePadding = EdgeInsets.fromLTRB(
  AppSpacing.xl,
  AppSpacing.sm,
  AppSpacing.xl,
  AppSpacing.xxl,
);
