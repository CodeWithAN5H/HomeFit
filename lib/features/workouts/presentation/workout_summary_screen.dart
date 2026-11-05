import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/workout_providers.dart';
import '../domain/workout_mode.dart';
import '../domain/workout_session.dart';
import 'workout_report.dart';

/// What the user sees the moment a session ends — and later, from history.
class WorkoutSummaryScreen extends ConsumerWidget {
  const WorkoutSummaryScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<WorkoutSession?> async = ref.watch(
      workoutSessionProvider(sessionId),
    );
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Session summary')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stack) => Center(
          child: Padding(
            padding: kPagePadding,
            child: Text(
              'This session could not be loaded: $error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (WorkoutSession? session) {
          if (session == null) {
            return Center(
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
                      'Session not found',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: 240,
                      child: FilledButton(
                        onPressed: () => context.go(AppRoutes.workout),
                        child: const Text('Back to Workout'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final bool completed =
              session.status == WorkoutSessionStatus.completed;
          return ListView(
            padding: kPagePadding,
            children: [
              Text(
                completed ? 'Session complete' : session.status.label,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                completed
                    ? '${session.templateName} · ${formatDuration(session.duration)}'
                    : session.status == WorkoutSessionStatus.interrupted
                    ? 'An earlier session was closed when a new one started. '
                          'Its partial work is kept, but it is not counted as a '
                          'completed workout.'
                    : 'This session was not counted as a completed workout, so '
                          'it will not change your rep targets.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SessionStatusChip(status: session.status),
              const SizedBox(height: AppSpacing.lg),
              WorkoutReport(session: session),
              if (completed) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                _EffortCard(session: session),
              ],
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.health_and_safety_outlined,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Rest and eat before the next session. If anything hurt '
                        'sharply, stop training that area and get advice rather '
                        'than working through it.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                key: const Key('summary_done'),
                onPressed: () => context.go(AppRoutes.workout),
                child: const Text('Done'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => context.push(AppRoutes.workoutHistory),
                child: const Text('View workout history'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EffortCard extends ConsumerWidget {
  const _EffortCard({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How hard did it feel?', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '1 is easy, 5 is everything you had. This is the main signal used to '
            'decide next time’s target — it is not a score.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (int effort = 1; effort <= 5; effort++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      key: Key('effort_$effort'),
                      label: Center(child: Text('$effort')),
                      selected: session.perceivedEffort == effort,
                      onSelected: (_) => ref
                          .read(workoutHistoryControllerProvider)
                          .setEffort(session.id, effort),
                    ),
                  ),
                ),
            ],
          ),
          if (session.perceivedEffort != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Saved: effort ${session.perceivedEffort} of 5.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.success,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
