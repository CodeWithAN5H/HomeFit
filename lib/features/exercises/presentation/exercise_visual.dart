import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../domain/exercise.dart';

/// Icon used for a muscle group across the library.
IconData iconForMuscle(MuscleGroup muscle) {
  return switch (muscle) {
    MuscleGroup.chest => Icons.accessibility_new,
    MuscleGroup.back => Icons.airline_seat_recline_normal,
    MuscleGroup.shoulders => Icons.sports_gymnastics,
    MuscleGroup.arms => Icons.fitness_center,
    MuscleGroup.legs => Icons.directions_walk,
    MuscleGroup.core => Icons.center_focus_strong,
    MuscleGroup.fullBody => Icons.person_outline,
  };
}

/// Colour used for a difficulty badge.
Color colorForDifficulty(ExerciseDifficulty difficulty) {
  return switch (difficulty) {
    ExerciseDifficulty.beginner => AppColors.success,
    ExerciseDifficulty.intermediate => AppColors.warning,
    ExerciseDifficulty.advanced => AppColors.danger,
  };
}

/// Stand-in for a demonstration photo.
///
/// HomeFit ships no licensed exercise photography, so rather than borrowing
/// images it cannot legally distribute, the library uses one consistent panel
/// per muscle group. It is deliberately labelled as an illustration in the UI.
class ExerciseVisual extends StatelessWidget {
  const ExerciseVisual({required this.muscle, this.height = 168, super.key});

  final MuscleGroup muscle;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outline),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.primaryDim, AppColors.surfaceHigh],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconForMuscle(muscle), size: 52, color: AppColors.primary),
          const SizedBox(height: AppSpacing.md),
          Text(
            muscle.label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
