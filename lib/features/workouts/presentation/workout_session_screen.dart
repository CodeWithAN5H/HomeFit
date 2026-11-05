import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/services/clock.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_card.dart';
import '../../exercises/application/exercise_providers.dart';
import '../../exercises/domain/exercise.dart';
import '../application/workout_providers.dart';
import '../domain/workout_session.dart';

/// The guided runner: one exercise, one set at a time.
///
/// Rest is displayed from an absolute end time held in the session row, so
/// leaving the app, locking the screen or a process restart cannot make the
/// countdown lie. Every set is written to SQLite as it is completed.
class WorkoutSessionScreen extends ConsumerStatefulWidget {
  const WorkoutSessionScreen({super.key});

  @override
  ConsumerState<WorkoutSessionScreen> createState() =>
      _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  bool _navigated = false;
  final TextEditingController _repsController = TextEditingController();
  String? _repsKey;

  @override
  void dispose() {
    _repsController.dispose();
    super.dispose();
  }

  void _goToSummary(String sessionId) {
    if (_navigated) return;
    _navigated = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.pushReplacement(AppRoutes.workoutSummary(sessionId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<RunnerState> async = ref.watch(workoutRunnerProvider);
    final ThemeData theme = Theme.of(context);

    return async.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (Object error, StackTrace stack) => Scaffold(
        appBar: AppBar(title: const Text('Workout')),
        body: Center(
          child: Padding(
            padding: kPagePadding,
            child: Text(
              'The session could not be loaded: $error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      data: (RunnerState state) {
        final WorkoutSession? session = state.session;
        if (session == null) {
          return _NoSession();
        }
        if (!session.isOpen) {
          _goToSummary(session.id);
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final SessionExercise? exercise = state.currentExercise;
        if (exercise == null) return _NoSession();

        final String repsKey = '${exercise.id}-${state.setIndex}';
        if (_repsKey != repsKey) {
          _repsKey = repsKey;
          final String value =
              (exercise.targetReps ?? exercise.targetSeconds)?.toString() ?? '';
          _repsController.value = TextEditingValue(
            text: value,
            selection: TextSelection.collapsed(offset: value.length),
          );
        }

        final int remaining = state.remainingRestSeconds(
          ref.watch(clockProvider).now(),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(session.templateName),
            actions: [
              IconButton(
                key: const Key('toggle_pause'),
                onPressed: () => session.isPaused
                    ? ref.read(workoutRunnerProvider.notifier).resume()
                    : ref.read(workoutRunnerProvider.notifier).pause(),
                icon: Icon(session.isPaused ? Icons.play_arrow : Icons.pause),
                tooltip: session.isPaused ? 'Resume' : 'Pause',
              ),
              IconButton(
                key: const Key('end_workout'),
                onPressed: () => _confirmEnd(session),
                icon: const Icon(Icons.stop_circle_outlined),
                tooltip: 'End workout',
              ),
            ],
          ),
          body: ListView(
            padding: kPagePadding,
            children: [
              _ProgressCard(session: session, state: state),
              if (session.isPaused) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  key: const Key('paused_banner'),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.pause_circle_outline,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Paused. Sets and rest are held until you resume.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      TextButton(
                        key: const Key('resume_workout'),
                        onPressed: () =>
                            ref.read(workoutRunnerProvider.notifier).resume(),
                        child: const Text('Resume'),
                      ),
                    ],
                  ),
                ),
              ],
              if (state.hasRest && !session.isPaused) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                _RestCard(
                  remaining: remaining,
                  paused: session.isPaused,
                  clock: ref.watch(clockProvider),
                  endsAt: session.restEndsAt,
                  pausedRemaining: session.restRemainingSeconds,
                  onElapsed: () =>
                      ref.read(workoutRunnerProvider.notifier).tickRest(),
                  onSkip: () =>
                      ref.read(workoutRunnerProvider.notifier).skipRest(),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              _CurrentExerciseCard(exercise: exercise, state: state),
              const SizedBox(height: AppSpacing.md),
              _LogSetCard(
                exercise: exercise,
                controller: _repsController,
                enabled: !session.isPaused,
                onComplete: () => _completeSet(exercise),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('skip_set'),
                      onPressed: session.isPaused
                          ? null
                          : () => ref
                                .read(workoutRunnerProvider.notifier)
                                .skipSet(),
                      child: const Text('Skip set'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('skip_exercise'),
                      onPressed: session.isPaused
                          ? null
                          : () => ref
                                .read(workoutRunnerProvider.notifier)
                                .skipExercise(),
                      child: const Text('Skip exercise'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _Instructions(exerciseId: exercise.exerciseId),
            ],
          ),
        );
      },
    );
  }

  Future<void> _completeSet(SessionExercise exercise) async {
    final int? typed = int.tryParse(_repsController.text.trim());
    await ref
        .read(workoutRunnerProvider.notifier)
        .completeSet(
          actualReps: exercise.isTimed ? null : typed,
          actualSeconds: exercise.isTimed ? typed : null,
        );
    if (!mounted) return;
    setState(() => _repsKey = null);
  }

  Future<void> _confirmEnd(WorkoutSession session) async {
    final bool? finish = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('End this workout?'),
        content: Text(
          session.loggedSets == 0
              ? 'No sets are logged yet, so this session will be recorded as '
                    'abandoned rather than completed.'
              : 'Your logged sets are already saved. Ending now records the '
                    'session as completed with the work you actually did.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Keep training'),
          ),
          TextButton(
            key: const Key('confirm_discard'),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Discard'),
          ),
          FilledButton(
            key: const Key('confirm_finish'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
    if (finish == null || !mounted) return;
    if (finish) {
      await ref.read(workoutRunnerProvider.notifier).finish();
    } else {
      // Discarding ends on the dashboard, so suppress the summary redirect
      // that an ended session would otherwise trigger during the rebuild.
      _navigated = true;
      await ref.read(workoutRunnerProvider.notifier).discard();
      if (!mounted) return;
      context.go(AppRoutes.workout);
    }
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.session, required this.state});

  final WorkoutSession session;
  final RunnerState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double progress = session.totalSets == 0
        ? 0
        : (session.loggedSets / session.totalSets).clamp(0.0, 1.0);
    return Column(
      key: const Key('session_progress'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.surfaceHigh,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Text(
                '${session.loggedSets} of ${session.totalSets} sets logged',
                style: theme.textTheme.bodySmall,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CurrentExerciseCard extends StatelessWidget {
  const _CurrentExerciseCard({required this.exercise, required this.state});

  final SessionExercise exercise;
  final RunnerState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Exercise? details = ProviderScope.containerOf(context)
        .read(exerciseByIdProvider(exercise.exerciseId));
    return AppCard(
      key: const Key('current_exercise_card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Current exercise', style: theme.textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            details?.name ?? exercise.exerciseId,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _Tag('Set ${state.currentSetNumber} of ${exercise.plannedSets}'),
              if (details != null) _Tag(details.primaryMuscle.label),
              if (details != null) _Tag(details.equipmentLabel),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            exercise.isTimed
                ? 'Target: hold for ${exercise.targetSeconds} seconds'
                : 'Target: ${exercise.targetReps} reps',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Rest ${exercise.restSeconds}s between sets. Stop the set if form '
            'breaks down.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _LogSetCard extends StatelessWidget {
  const _LogSetCard({
    required this.exercise,
    required this.controller,
    required this.enabled,
    required this.onComplete,
  });

  final SessionExercise exercise;
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.isTimed ? 'Seconds held' : 'Reps completed',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            key: const Key('actual_reps'),
            enabled: enabled,
            keyboardType: TextInputType.number,
            controller: controller,
            decoration: InputDecoration(
              hintText: exercise.isTimed
                  ? '${exercise.targetSeconds}'
                  : '${exercise.targetReps}',
              helperText: 'Record what you actually did, not what was planned.',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            key: const Key('complete_set'),
            onPressed: enabled ? onComplete : null,
            child: const Text('Complete set'),
          ),
        ],
      ),
    );
  }
}

class _RestCard extends StatelessWidget {
  const _RestCard({
    required this.remaining,
    required this.paused,
    required this.clock,
    required this.endsAt,
    required this.pausedRemaining,
    required this.onElapsed,
    required this.onSkip,
  });

  final int remaining;
  final bool paused;
  final Clock clock;
  final DateTime? endsAt;
  final int? pausedRemaining;
  final VoidCallback onElapsed;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: const Key('rest_card'),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _RestCountdown(
              key: const Key('rest_countdown'),
              seconds: remaining,
              endsAt: endsAt,
              clock: clock,
              paused: paused,
              pausedRemaining: pausedRemaining ?? remaining,
              onElapsed: onElapsed,
            ),
          ),
          TextButton(
            key: const Key('skip_rest'),
            onPressed: onSkip,
            child: const Text('Skip rest'),
          ),
        ],
      ),
    );
  }
}

/// Counts down from the stored end instant, not from a local tally.
class _RestCountdown extends StatefulWidget {
  const _RestCountdown({
    required this.seconds,
    required this.endsAt,
    required this.clock,
    required this.paused,
    required this.pausedRemaining,
    required this.onElapsed,
    super.key,
  });

  final int seconds;
  final DateTime? endsAt;
  final Clock clock;
  final bool paused;
  final int pausedRemaining;
  final VoidCallback onElapsed;

  @override
  State<_RestCountdown> createState() => _RestCountdownState();
}

class _RestCountdownState extends State<_RestCountdown> {
  Timer? _timer;
  late int _remaining;
  bool _reported = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _start();
  }

  @override
  void didUpdateWidget(covariant _RestCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seconds != widget.seconds ||
        oldWidget.paused != widget.paused) {
      _remaining = widget.seconds;
      _reported = false;
      _start();
    }
  }

  void _start() {
    _timer?.cancel();
    if (widget.paused) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) return;
      final DateTime? endsAt = widget.endsAt;
      final int next = endsAt == null
          ? 0
          : max(0, endsAt.difference(widget.clock.now()).inSeconds);
      setState(() => _remaining = next);
      if (next <= 0 && !_reported) {
        _reported = true;
        timer.cancel();
        widget.onElapsed();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int minutes = _remaining ~/ 60;
    final int seconds = _remaining % 60;
    final String label = '$minutes:${seconds.toString().padLeft(2, '0')}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rest', style: theme.textTheme.titleMedium),
        Text(
          widget.paused ? 'Paused at $label' : label,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
          ),
        ),
        Text(
          'Next set starts when the timer ends or you skip.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _Instructions extends ConsumerWidget {
  const _Instructions({required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Exercise? exercise = ref.watch(exerciseByIdProvider(exerciseId));
    if (exercise == null) return const SizedBox.shrink();
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How to do it', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < exercise.steps.length; i++)
                Padding(
                  padding: EdgeInsets.only(top: i == 0 ? 0 : AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${i + 1}.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          exercise.steps[i],
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(height: AppSpacing.xl),
              for (final String cue in exercise.formCues)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.health_and_safety_outlined,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(cue, style: theme.textTheme.bodySmall),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: AppColors.outline),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _NoSession extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: Center(
        key: const Key('no_active_session'),
        child: Padding(
          padding: kPagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.fitness_center,
                size: 32,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'No workout in progress',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Start a session from the Workout tab and it will appear here.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textMuted),
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
      ),
    );
  }
}
