import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/milestone_notice.dart';
import '../../exercises/application/exercise_providers.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int exerciseCount = ref.watch(exerciseCountProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: ListView(
        padding: kPagePadding,
        children: [
          _LibraryEntry(exerciseCount: exerciseCount),
          const SizedBox(height: AppSpacing.md),
          const MilestoneNotice(
            icon: Icons.fitness_center,
            title: 'Guided training arrives in M4',
            body:
                'The exercise library is complete and offline, but this build '
                'has no plan generator, session runner or set logging yet, so '
                'nothing here starts a workout.',
            planned: [
              'Full-body beginner plan built from your profile',
              'Quick, recovery, targeted and skill sessions',
              'Recorded reps, rest timer and honest progression',
            ],
          ),
        ],
      ),
    );
  }
}

/// The one fully working entry point in the Workout tab.
class _LibraryEntry extends StatelessWidget {
  const _LibraryEntry({required this.exerciseCount});

  final int exerciseCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      key: const Key('exercise_library_entry'),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: const BorderSide(color: AppColors.outline),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: () => context.push(AppRoutes.workoutExercises),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryDim,
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                ),
                child: const Icon(
                  Icons.menu_book_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exercise library',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$exerciseCount movements with steps, form cues and '
                      'alternatives. Works offline.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
