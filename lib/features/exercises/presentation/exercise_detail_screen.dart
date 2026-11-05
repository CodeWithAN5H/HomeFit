import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/detail_row.dart';
import '../../profile/application/profile_providers.dart';
import '../../profile/domain/profile_options.dart';
import '../../profile/domain/user_profile.dart';
import '../application/exercise_providers.dart';
import '../domain/exercise.dart';
import '../domain/exercise_query.dart';
import 'exercise_card.dart';
import 'exercise_visual.dart';

/// Everything the library knows about one movement.
class ExerciseDetailScreen extends ConsumerWidget {
  const ExerciseDetailScreen({required this.exerciseId, super.key});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Exercise? exercise = ref.watch(exerciseByIdProvider(exerciseId));
    if (exercise == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Exercise')),
        body: Center(
          child: Padding(
            padding: kPagePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_off,
                  size: 32,
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Exercise not found',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'This movement is not part of the bundled library. It may '
                  'have been renamed in a newer build.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: 220,
                  child: FilledButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go(AppRoutes.workoutExercises),
                    child: const Text('Back to library'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final UserProfile? profile = ref.watch(profileControllerProvider);
    final List<ExerciseAlternative> alternatives = ref.watch(
      exerciseAlternativesProvider(exerciseId),
    );
    final Set<EquipmentItem> owned =
        profile?.equipment ?? const <EquipmentItem>{};
    final List<EquipmentItem> missing = exercise.missingFor(owned);

    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: ListView(
        padding: kPagePadding,
        children: [
          ExerciseVisual(muscle: exercise.primaryMuscle),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Bundled illustration — no demonstration photo is licensed for '
            'this movement yet.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(exercise.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ExerciseTag(label: exercise.primaryMuscle.label),
              ExerciseTag(
                label: exercise.difficulty.label,
                tint: colorForDifficulty(exercise.difficulty),
              ),
              ExerciseTag(
                label: exercise.equipmentLabel,
                icon: exercise.isBodyweight
                    ? Icons.accessibility
                    : Icons.handyman_outlined,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _CompatibilityCard(exercise: exercise, missing: missing),
          const SizedBox(height: AppSpacing.md),
          _OverviewCard(exercise: exercise, profile: profile),
          const SizedBox(height: AppSpacing.md),
          const _SectionTitle('Step by step'),
          const SizedBox(height: AppSpacing.sm),
          AppCard(child: _StepList(steps: exercise.steps)),
          const SizedBox(height: AppSpacing.md),
          const _SectionTitle('Form and safety'),
          const SizedBox(height: AppSpacing.sm),
          AppCard(child: _CueList(cues: exercise.formCues)),
          const SizedBox(height: AppSpacing.md),
          const _SectionTitle('Alternatives'),
          const SizedBox(height: AppSpacing.sm),
          Text(
            profile == null
                ? 'Ranked by shared muscle group. Save a profile to rank them '
                      'for your equipment and level.'
                : 'Ranked for your equipment and experience. Anything needing '
                      'equipment you have not saved is marked.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          if (alternatives.isEmpty)
            AppCard(
              child: Text(
                'No other movement in the library trains this area. This is a '
                'specialist exercise, so it has no close substitute.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textMuted),
              ),
            )
          else
            for (final ExerciseAlternative alternative in alternatives) ...[
              ExerciseCard(
                key: Key('alternative_${alternative.exercise.id}'),
                exercise: alternative.exercise,
                missingEquipment: alternative.equipmentReady
                    ? const <EquipmentItem>[]
                    : alternative.exercise.missingFor(owned),
                onTap: () => context.push(
                  AppRoutes.exerciseDetail(alternative.exercise.id),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
        ],
      ),
    );
  }
}

/// Tells the user whether their saved equipment can do this movement.
class _CompatibilityCard extends StatelessWidget {
  const _CompatibilityCard({required this.exercise, required this.missing});

  final Exercise exercise;
  final List<EquipmentItem> missing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool ready = missing.isEmpty;
    final Color accent = ready ? AppColors.success : AppColors.warning;
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            ready ? Icons.verified_outlined : Icons.handyman_outlined,
            color: accent,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ready
                      ? 'Ready with your equipment'
                      : 'Needs additional equipment',
                  style: theme.textTheme.titleMedium?.copyWith(color: accent),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  ready
                      ? 'Your saved equipment covers everything this movement '
                            'requires.'
                      : 'You would need: '
                            '${missing.map((item) => item.label).join(', ')}. '
                            'The movement is still listed, it is just not '
                            'performable with what you have today.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.exercise, required this.profile});

  final Exercise exercise;
  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    final String secondary = exercise.secondaryMuscles.isEmpty
        ? 'None'
        : exercise.secondaryMuscles.map((muscle) => muscle.label).join(', ');
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          DetailRow(
            label: 'Primary muscle',
            value: exercise.primaryMuscle.label,
          ),
          DetailRow(label: 'Secondary muscles', value: secondary),
          DetailRow(label: 'Equipment', value: exercise.equipmentLabel),
          DetailRow(label: 'Difficulty', value: exercise.difficulty.label),
          if (profile != null)
            DetailRow(
              label: 'Your experience',
              value: profile!.experience.label,
            ),
        ],
      ),
    );
  }
}

class _StepList extends StatelessWidget {
  const _StepList({required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < steps.length; i++)
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryDim,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(steps[i], style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CueList extends StatelessWidget {
  const _CueList({required this.cues});

  final List<String> cues;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < cues.length; i++)
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.health_and_safety_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(cues[i], style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}
