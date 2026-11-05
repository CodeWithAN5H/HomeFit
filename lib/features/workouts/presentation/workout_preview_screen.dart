import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/detail_row.dart';
import '../../exercises/domain/exercise.dart';
import '../application/workout_providers.dart';
import '../domain/planned_workout.dart';
import '../domain/workout_mode.dart';

/// What the user sees before committing to a session.
///
/// The preview is where manual adjustment lives: reps can be nudged per
/// exercise, and the runner stores exactly what was started.
class WorkoutPreviewScreen extends ConsumerStatefulWidget {
  const WorkoutPreviewScreen({
    required this.mode,
    this.templateId,
    this.muscle,
    super.key,
  });

  final String mode;
  final String? templateId;
  final String? muscle;

  @override
  ConsumerState<WorkoutPreviewScreen> createState() =>
      _WorkoutPreviewScreenState();
}

class _WorkoutPreviewScreenState extends ConsumerState<WorkoutPreviewScreen> {
  final Map<String, int> _overrides = <String, int>{};
  bool _starting = false;

  MuscleGroup? get _muscle {
    final String? name = widget.muscle;
    if (name == null) return null;
    for (final MuscleGroup muscle in MuscleGroup.values) {
      if (muscle.name == name) return muscle;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutMode mode = WorkoutMode.fromName(widget.mode);
    final WorkoutPreviewRequest request = WorkoutPreviewRequest(
      mode: mode,
      templateId: widget.templateId,
      muscle: _muscle,
    );
    final AsyncValue<PlannedWorkout?> async = ref.watch(
      workoutPreviewProvider(request),
    );
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(mode.label)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stack) => _Message(
          title: 'Could not build this session',
          body: 'Nothing was saved. Try again, or start from the Workout tab.',
          action: 'Back to Workout',
          onPressed: () => context.go(AppRoutes.workout),
        ),
        data: (PlannedWorkout? plan) {
          if (plan == null || plan.isEmpty) {
            return _Message(
              key: const Key('preview_empty'),
              title: 'Nothing available for this session',
              body:
                  'None of the movements in this session can be performed with '
                  'your saved equipment and experience level. Update your '
                  'profile or pick another mode.',
              action: 'Back to Workout',
              onPressed: () => context.go(AppRoutes.workout),
            );
          }
          return ListView(
            padding: kPagePadding,
            children: [
              Text(plan.name, style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                plan.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                key: const Key('mode_explanation'),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        mode.explanation,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  children: [
                    DetailRow(label: 'Mode', value: plan.mode.label),
                    DetailRow(
                      label: 'Estimated time',
                      value: '≈ ${plan.estimatedMinutes} min',
                    ),
                    DetailRow(label: 'Sets', value: '${plan.totalSets}'),
                    DetailRow(
                      label: 'Difficulty',
                      value: plan.difficulty.label,
                    ),
                    DetailRow(
                      label: 'Focus',
                      value: plan.focus
                          .map((MuscleGroup muscle) => muscle.label)
                          .join(', '),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _SafetyCard(notes: plan.safetyNotes, guidance: plan.guidance),
              const SizedBox(height: AppSpacing.lg),
              Text('Exercises', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              for (final PlannedExercise item in plan.exercises) ...<Widget>[
                _ExerciseRow(
                  key: Key('preview_exercise_${item.exercise.id}'),
                  item: item,
                  target: _overrides[item.exercise.id] ?? item.targetReps,
                  onAdjust: item.isTimed
                      ? null
                      : (int delta) => _adjust(item, delta),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Targets start conservatively. Adjust a rep count here if today '
                'feels different; nothing is saved until you start.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                key: const Key('start_workout'),
                onPressed: _starting ? null : () => _start(plan),
                child: _starting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Start workout'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => context.go(AppRoutes.workout),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _adjust(PlannedExercise item, int delta) {
    final int current = _overrides[item.exercise.id] ?? item.targetReps ?? 0;
    final int next = (current + delta).clamp(1, 30);
    setState(() => _overrides[item.exercise.id] = next);
  }

  Future<void> _start(PlannedWorkout plan) async {
    setState(() => _starting = true);
    final String? id = await ref
        .read(workoutRunnerProvider.notifier)
        .start(plan, targetRepOverrides: _overrides);
    if (!mounted) return;
    setState(() => _starting = false);
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This session has no performable exercises.'),
        ),
      );
      return;
    }
    context.push(AppRoutes.workoutSession);
  }
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.item,
    required this.target,
    this.onAdjust,
    super.key,
  });

  final PlannedExercise item;
  final int? target;
  final ValueChanged<int>? onAdjust;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int? value = target;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.exercise.name,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                item.isTimed ? '${item.targetSeconds}s' : '$value reps',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${item.sets} sets · ${item.exercise.primaryMuscle.label} · rest '
            '${item.restSeconds}s',
            style: theme.textTheme.bodySmall,
          ),
          if (item.note != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Text(item.note!, style: theme.textTheme.bodySmall),
          ],
          if (onAdjust != null && value != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                IconButton(
                  key: Key('target_minus_${item.exercise.id}'),
                  visualDensity: VisualDensity.compact,
                  onPressed: value > 1 ? () => onAdjust!(-1) : null,
                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                  tooltip: 'Fewer reps',
                ),
                IconButton(
                  key: Key('target_plus_${item.exercise.id}'),
                  visualDensity: VisualDensity.compact,
                  onPressed: value < 30 ? () => onAdjust!(1) : null,
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  tooltip: 'More reps',
                ),
                const SizedBox(width: AppSpacing.xs),
                Text('Adjust target', style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SafetyCard extends StatelessWidget {
  const _SafetyCard({required this.notes, required this.guidance});

  final List<String> notes;
  final List<String> guidance;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.health_and_safety_outlined,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('Before you start', style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final String note in <String>[...notes, ...guidance])
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.circle,
                      size: 4,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(note, style: theme.textTheme.bodySmall)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.title,
    required this.body,
    required this.action,
    required this.onPressed,
    super.key,
  });

  final String title;
  final String body;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: kPagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 32,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: 240,
              child: FilledButton(onPressed: onPressed, child: Text(action)),
            ),
          ],
        ),
      ),
    );
  }
}
