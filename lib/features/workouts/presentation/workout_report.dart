import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/detail_row.dart';
import '../../exercises/application/exercise_providers.dart';
import '../../exercises/domain/exercise.dart';
import '../domain/workout_mode.dart';
import '../domain/workout_session.dart';

/// Read-only breakdown of one session.
///
/// Shared by the post-workout summary and the history detail screen so both show
/// exactly the same numbers, including skipped sets.
class WorkoutReport extends ConsumerWidget {
  const WorkoutReport({required this.session, super.key});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final String duration = formatDuration(session.duration);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            children: [
              DetailRow(label: 'Status', value: session.status.label),
              DetailRow(label: 'Mode', value: session.mode.label),
              DetailRow(
                label: 'Started',
                value: DateFormat('EEE d MMM · HH:mm')
                    .format(session.startedAt),
              ),
              DetailRow(label: 'Duration', value: duration),
              DetailRow(
                label: 'Sets logged',
                value: '${session.loggedSets} of ${session.totalSets}',
              ),
              DetailRow(label: 'Reps completed', value: '${session.totalReps}'),
              if (session.perceivedEffort != null)
                DetailRow(
                  label: 'Effort',
                  value: '${session.perceivedEffort} of 5',
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What you did', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              for (final SessionExercise exercise in session.exercises)
                _ExerciseResult(exercise: exercise, session: session),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExerciseResult extends ConsumerWidget {
  const _ExerciseResult({required this.exercise, required this.session});

  final SessionExercise exercise;
  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final Exercise? details = ref.watch(
      exerciseByIdProvider(exercise.exerciseId),
    );
    final List<SetLog> logs =
        session.sets
            .where((SetLog log) => log.sessionExerciseId == exercise.id)
            .toList()
          ..sort((SetLog a, SetLog b) => a.setIndex.compareTo(b.setIndex));
    final String target = exercise.isTimed
        ? '${exercise.targetSeconds}s'
        : '${exercise.targetReps} reps';
    final String actual = logs.isEmpty
        ? 'not started'
        : logs
              .map(
                (SetLog log) => log.skipped
                    ? 'skip'
                    : exercise.isTimed
                    ? '${log.actualSeconds ?? 0}s'
                    : '${log.actualReps ?? 0}',
              )
              .join(', ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details?.name ?? exercise.exerciseId,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${exercise.plannedSets} × $target',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            actual,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

String formatDuration(Duration duration) {
  final int minutes = duration.inMinutes;
  if (minutes < 1) return '${duration.inSeconds}s';
  if (minutes < 60) return '$minutes min';
  final int hours = minutes ~/ 60;
  final int rest = minutes % 60;
  return rest == 0 ? '$hours h' : '$hours h $rest min';
}

/// Colour-coded status badge shared by the screens.
class SessionStatusChip extends StatelessWidget {
  const SessionStatusChip({required this.status, super.key});

  final WorkoutSessionStatus status;

  @override
  Widget build(BuildContext context) {
    final Color tint = switch (status) {
      WorkoutSessionStatus.completed => AppColors.success,
      WorkoutSessionStatus.inProgress => AppColors.warning,
      WorkoutSessionStatus.abandoned => AppColors.danger,
      WorkoutSessionStatus.interrupted => AppColors.textMuted,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: tint.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: tint, fontWeight: FontWeight.w600),
      ),
    );
  }
}
