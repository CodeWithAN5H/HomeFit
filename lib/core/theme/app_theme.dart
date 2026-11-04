import 'package:flutter/material.dart';

import 'app_tokens.dart';

/// Builds the single dark theme HomeFit ships with.
///
/// Material 3 is enabled, but the palette is deliberately narrow: deep
/// charcoal surfaces, one blue and one violet accent, and muted text. Nothing
/// here animates continuously.
ThemeData buildAppTheme() {
  const scheme = ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: AppColors.onAccent,
    primaryContainer: AppColors.primaryDim,
    onPrimaryContainer: AppColors.textPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onAccent,
    secondaryContainer: AppColors.secondaryDim,
    onSecondaryContainer: AppColors.textPrimary,
    error: AppColors.danger,
    onError: Color(0xFF1B0A0E),
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textMuted,
    outline: AppColors.outline,
    outlineVariant: AppColors.outline,
    surfaceContainerLowest: AppColors.background,
    surfaceContainerLow: AppColors.surface,
    surfaceContainer: AppColors.surface,
    surfaceContainerHigh: AppColors.surfaceHigh,
    surfaceContainerHighest: AppColors.surfaceHigh,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
  );

  return base.copyWith(
    textTheme: _textTheme(base.textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.primaryDim,
      elevation: 0,
      height: 68,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          size: 22,
          color: states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.textMuted,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 11,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w600
              : FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.textMuted,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: const BorderSide(color: AppColors.outline),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onAccent,
        disabledBackgroundColor: AppColors.surfaceHigh,
        disabledForegroundColor: AppColors.textMuted,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceHigh,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 18,
      ),
      hintStyle: const TextStyle(color: AppColors.textMuted),
      labelStyle: const TextStyle(color: AppColors.textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.field),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.field),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.field),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.field),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.field),
        borderSide: const BorderSide(color: AppColors.danger, width: 1.4),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.outline,
      thickness: 1,
      space: 1,
    ),
    sliderTheme: base.sliderTheme.copyWith(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.surfaceHigh,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withValues(alpha: 0.12),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.onAccent
            : AppColors.textMuted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.primary
            : AppColors.surfaceHigh,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceHigh,
      contentTextStyle: const TextStyle(color: AppColors.textPrimary),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
    ),
  );
}

TextTheme _textTheme(TextTheme base) {
  final text = base.apply(
    bodyColor: AppColors.textPrimary,
    displayColor: AppColors.textPrimary,
  );
  return text.copyWith(
    headlineMedium: text.headlineMedium?.copyWith(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.6,
      height: 1.2,
    ),
    headlineSmall: text.headlineSmall?.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
    ),
    titleLarge: text.titleLarge?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    titleMedium: text.titleMedium?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: text.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
    bodyMedium: text.bodyMedium?.copyWith(fontSize: 14, height: 1.5),
    bodySmall: text.bodySmall?.copyWith(
      fontSize: 12.5,
      height: 1.45,
      color: AppColors.textMuted,
    ),
    labelLarge: text.labelLarge?.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
  );
}
