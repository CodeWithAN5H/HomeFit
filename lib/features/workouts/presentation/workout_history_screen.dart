import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_tokens.dart';
import '../application/workout_providers.dart';
import '../domain/workout_mode.dart';
import '../domain/workout_session.dart';
import 'workout_report.dart';

/// Every stored session, including abandoned and interrupted ones.
///
/// Showing them is deliberate: hiding unfinished work would make the history
/// flatter than the training actually was.
class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<WorkoutSession>> async = ref.watch(
      workoutSessionsProvider,
    );
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Workout history')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stack) => Center(
          child: Padding(
            padding: kPagePadding,
            child: Text(
              'History could not be loaded: $error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (List<WorkoutSession> sessions) {
          if (sessions.isEmpty) {
            return Center(
              key: const Key('history_empty'),
              child: Padding(
                padding: kPagePadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.history,
                      size: 32,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('No sessions yet', style: theme.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Finish a workout and it appears here with the sets and '
                      'reps you actually completed.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: 240,
                      child: FilledButton(
                        onPressed: () => context.go(AppRoutes.workout),
                        child: const Text('Start a workout'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final int completed = sessions
              .where((WorkoutSession session) => session.status.countsAsWorkout)
              .length;

          return ListView(
            padding: kPagePadding,
            children: [
              Text(
                '$completed completed · ${sessions.length} total',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              for (final WorkoutSession session in sessions) ...<Widget>[
                _HistoryTile(session: session),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      key: Key('history_session_${session.id}'),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: const BorderSide(color: AppColors.outline),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: () => context.push(AppRoutes.workoutSessionDetail(session.id)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      session.templateName,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  SessionStatusChip(status: session.status),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${DateFormat('EEE d MMM · HH:mm').format(session.startedAt)}'
                ' · ${session.mode.label}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${session.loggedSets} of ${session.totalSets} sets · '
                '${session.totalReps} reps · '
                '${formatDuration(session.duration)}',
                style: theme.textTheme.bodySmall,
              ),
              if (session.mode == WorkoutMode.recovery)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Recovery sessions do not count as strength training.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One session read back from the database.
class WorkoutSessionDetailScreen extends ConsumerWidget {
  const WorkoutSessionDetailScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<WorkoutSession?> async = ref.watch(
      workoutSessionProvider(sessionId),
    );
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Session')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stack) => Center(
          child: Padding(
            padding: kPagePadding,
            child: Text('Session could not be loaded: $error'),
          ),
        ),
        data: (WorkoutSession? session) {
          if (session == null) {
            return Center(
              child: Padding(
                padding: kPagePadding,
                child: Text(
                  'This session is no longer stored.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            );
          }
          return ListView(
            padding: kPagePadding,
            children: [
              Text(session.templateName, style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              SessionStatusChip(status: session.status),
              const SizedBox(height: AppSpacing.md),
              WorkoutReport(session: session),
            ],
          );
        },
      ),
    );
  }
}
