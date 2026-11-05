import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_card.dart';
import '../../exercises/application/exercise_providers.dart';
import '../../exercises/domain/exercise.dart';
import '../application/workout_providers.dart';
import '../domain/workout_mode.dart';
import '../domain/workout_schedule.dart';
import '../domain/workout_session.dart';
import '../domain/workout_template.dart';

/// The workout dashboard: today's recommendation, every mode, and history.
///
/// Everything here is derived from the saved profile and stored sessions, so the
/// card never claims a workout that the schedule would not actually recommend.
class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TodayRecommendation recommendation = ref.watch(
      todayRecommendationProvider,
    );
    final List<WorkoutSession> sessions =
        ref.watch(workoutSessionsProvider).value ?? const <WorkoutSession>[];
    final WorkoutSession? open = ref.watch(openSessionProvider).value;
    final WorkoutTemplate? template = ref
        .watch(workoutPlannerProvider)
        .templateById(recommendation.templateId);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: ListView(
        padding: kPagePadding,
        children: [
          if (open != null) ...<Widget>[
            _ResumeCard(session: open),
            const SizedBox(height: AppSpacing.md),
          ],
          _TodayCard(
            recommendation: recommendation,
            estimatedMinutes: template?.estimatedMinutes,
          ),
          const SizedBox(height: AppSpacing.md),
          _QuickActions(),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent sessions',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              TextButton(
                key: const Key('workout_history_link'),
                onPressed: () => context.push(AppRoutes.workoutHistory),
                child: const Text('History'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (sessions.isEmpty)
            AppCard(
              key: const Key('no_sessions'),
              child: Text(
                'No sessions yet. Your first completed workout appears here '
                'with its sets and reps.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            for (final WorkoutSession session in sessions.take(3)) ...<Widget>[
              _SessionTile(session: session),
              const SizedBox(height: AppSpacing.sm),
            ],
          const SizedBox(height: AppSpacing.lg),
          Text('Exercise library', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          _LibraryEntry(count: ref.watch(exerciseCountProvider)),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.recommendation, this.estimatedMinutes});

  final TodayRecommendation recommendation;
  final int? estimatedMinutes;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool train = recommendation.recommendsStrength;
    final Color accent = train ? AppColors.primary : AppColors.success;
    return AppCard(
      key: const Key('today_card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                train ? Icons.fitness_center : Icons.self_improvement,
                color: accent,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  train ? 'Today · training day' : 'Today · recovery',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (estimatedMinutes != null)
                Text(
                  '≈ $estimatedMinutes min',
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(recommendation.headline, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            recommendation.reason,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            key: const Key('start_today'),
            onPressed: () => context.push(
              AppRoutes.workoutPreview(
                mode: recommendation.mode.name,
                templateId: recommendation.templateId,
              ),
            ),
            child: Text(train ? 'Start today’s session' : 'Open recovery'),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose another session', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        _ModeTile(
          key: const Key('mode_quick'),
          icon: Icons.bolt_outlined,
          title: WorkoutMode.quick.label,
          subtitle: '${WorkoutMode.quick.summary} About ten minutes.',
          onTap: () => context.push(
            AppRoutes.workoutPreview(mode: WorkoutMode.quick.name),
          ),
        ),
        _ModeTile(
          key: const Key('mode_recovery'),
          icon: Icons.self_improvement,
          title: WorkoutMode.recovery.label,
          subtitle: WorkoutMode.recovery.summary,
          onTap: () => context.push(
            AppRoutes.workoutPreview(mode: WorkoutMode.recovery.name),
          ),
        ),
        _ModeTile(
          key: const Key('mode_skill'),
          icon: Icons.school_outlined,
          title: WorkoutMode.skill.label,
          subtitle: WorkoutMode.skill.summary,
          onTap: () => context.push(
            AppRoutes.workoutPreview(mode: WorkoutMode.skill.name),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Targeted session', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: <Widget>[
            for (final MuscleGroup muscle in MuscleGroup.values)
              ActionChip(
                key: Key('targeted_${muscle.name}'),
                label: Text(muscle.label),
                onPressed: () => context.push(
                  AppRoutes.workoutPreview(
                    mode: WorkoutMode.targeted.name,
                    muscle: muscle.name,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.outline),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(subtitle, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResumeCard extends StatelessWidget {
  const _ResumeCard({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppCard(
      key: const Key('resume_session'),
      child: Row(
        children: [
          const Icon(Icons.play_circle_outline, color: AppColors.warning),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Session in progress', style: theme.textTheme.titleMedium),
                Text(
                  '${session.templateName} · ${session.loggedSets} of '
                  '${session.totalSets} sets logged',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          TextButton(
            key: const Key('resume_session_button'),
            onPressed: () => context.push(AppRoutes.workoutSession),
            child: const Text('Resume'),
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color tint = switch (session.status) {
      WorkoutSessionStatus.completed => AppColors.success,
      WorkoutSessionStatus.inProgress => AppColors.warning,
      WorkoutSessionStatus.abandoned => AppColors.danger,
      WorkoutSessionStatus.interrupted => AppColors.textMuted,
    };
    return Material(
      key: Key('recent_session_${session.id}'),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: const BorderSide(color: AppColors.outline),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: () => context.push(AppRoutes.workoutSummary(session.id)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.templateName,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${DateFormat('EEE d MMM · HH:mm').format(session.startedAt)}'
                      ' · ${session.mode.label}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    session.status.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: tint,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${session.loggedSets}/${session.totalSets} sets',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// M3 entry point, kept on the dashboard.
class _LibraryEntry extends StatelessWidget {
  const _LibraryEntry({required this.count});

  final int count;

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
                    const SizedBox(height: 2),
                    Text(
                      '$count movements with steps, form cues and alternatives. '
                      'Works offline.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
