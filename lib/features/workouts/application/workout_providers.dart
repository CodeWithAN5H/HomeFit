import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/clock.dart';
import '../../exercises/application/exercise_providers.dart';
import '../../exercises/domain/exercise.dart';
import '../../profile/application/profile_providers.dart';
import '../../profile/domain/user_profile.dart';
import '../data/workout_repository.dart';
import '../data/workout_templates.dart';
import '../domain/planned_workout.dart';
import '../domain/progression.dart';
import '../domain/workout_history.dart';
import '../domain/workout_mode.dart';
import '../domain/workout_planner.dart';
import '../domain/workout_schedule.dart';
import '../domain/workout_session.dart';
import '../domain/workout_template.dart';

/// Local storage for sessions and set logs.
final workoutRepositoryProvider = Provider<WorkoutRepository>(
  (ref) => DriftWorkoutRepository(ref.watch(appDatabaseProvider)),
);

/// Pure planner over the bundled catalogue.
final workoutPlannerProvider = Provider<WorkoutPlanner>(
  (ref) => WorkoutPlanner(ref.watch(exerciseRepositoryProvider)),
);

final workoutTemplatesProvider = Provider<List<WorkoutTemplate>>(
  (ref) => kWorkoutTemplates,
);

/// Stored history, newest first. Invalidated when a session ends.
final workoutSessionsProvider = FutureProvider<List<WorkoutSession>>((ref) {
  return ref.watch(workoutRepositoryProvider).readSessions();
});

/// The unfinished session, if any, so the dashboard can offer to resume.
final openSessionProvider = FutureProvider<WorkoutSession?>((ref) {
  return ref.watch(workoutRepositoryProvider).readOpenSession();
});

/// Today's recommendation from the pure schedule.
final todayRecommendationProvider = Provider<TodayRecommendation>((ref) {
  final UserProfile? profile = ref.watch(profileControllerProvider);
  final List<WorkoutTemplate> templates = ref.watch(workoutTemplatesProvider);
  final List<WorkoutSession> sessions =
      ref.watch(workoutSessionsProvider).value ?? const <WorkoutSession>[];
  final DateTime now = ref.watch(clockProvider).now();

  if (profile == null) {
    // Only reachable before onboarding; keep the card renderable.
    return TodayRecommendation(
      kind: ScheduleKind.train,
      mode: WorkoutMode.normal,
      headline: templates.first.name,
      reason: 'Save your profile to personalise this session.',
      nextTrainingDay: now,
      templateId: templates.first.id,
    );
  }

  return WorkoutSchedule.recommend(
    profile: profile,
    now: now,
    sessions: sessions,
    templates: templates,
  );
});

/// Identifies a preview request so it can be a provider family key.
class WorkoutPreviewRequest {
  const WorkoutPreviewRequest({
    required this.mode,
    this.templateId,
    this.muscle,
  });

  final WorkoutMode mode;
  final String? templateId;
  final MuscleGroup? muscle;

  @override
  bool operator ==(Object other) =>
      other is WorkoutPreviewRequest &&
      other.mode == mode &&
      other.templateId == templateId &&
      other.muscle == muscle;

  @override
  int get hashCode => Object.hash(mode, templateId, muscle);

  @override
  String toString() =>
      'WorkoutPreviewRequest(${mode.name}, $templateId, $muscle)';
}

/// A plan resolved for the saved profile, including this session's targets.
///
/// Progression is read from the last completed strength session per exercise,
/// then applied by replanning once, so the preview and the runner always show
/// the same numbers.
final workoutPreviewProvider =
    FutureProvider.family<PlannedWorkout?, WorkoutPreviewRequest>((
      ref,
      WorkoutPreviewRequest request,
    ) async {
      final UserProfile? profile = ref.watch(profileControllerProvider);
      if (profile == null) return null;

      final WorkoutPlanner planner = ref.watch(workoutPlannerProvider);
      final WorkoutRepository repository = ref.watch(workoutRepositoryProvider);

      PlannedWorkout base;
      if (request.mode == WorkoutMode.targeted) {
        final MuscleGroup muscle = request.muscle ?? MuscleGroup.chest;
        base = planner.targeted(muscle: muscle, profile: profile);
        final Map<String, ExerciseHistory> history = await repository
            .readHistory(
              base.exercises
                  .map((PlannedExercise item) => item.exercise.id)
                  .toList(),
            );
        final Map<String, ProgressionDecision> decisions = _decisions(
          history,
          profile,
        );
        return planner.targeted(
          muscle: muscle,
          profile: profile,
          progression: decisions,
        );
      }

      final WorkoutTemplate? template =
          planner.templateById(request.templateId) ??
          _firstTemplateFor(planner, request.mode);
      if (template == null) return null;

      base = planner.plan(template: template, profile: profile);
      final Map<String, ExerciseHistory> history = await repository.readHistory(
        base.exercises.map((PlannedExercise item) => item.exercise.id).toList(),
      );
      final Map<String, ProgressionDecision> decisions = _decisions(
        history,
        profile,
      );
      return planner.plan(
        template: template,
        profile: profile,
        progression: decisions,
      );
    });

Map<String, ProgressionDecision> _decisions(
  Map<String, ExerciseHistory> history,
  UserProfile profile,
) {
  return <String, ProgressionDecision>{
    for (final MapEntry<String, ExerciseHistory> entry in history.entries)
      entry.key: ProgressionEngine.decide(
        entry.value.toInput(sleepPattern: profile.sleep),
      ),
  };
}

WorkoutTemplate? _firstTemplateFor(WorkoutPlanner planner, WorkoutMode mode) {
  final List<WorkoutTemplate> matches = planner.templatesFor(mode);
  return matches.isEmpty ? null : matches.first;
}

/// A single stored session for the summary and history detail screens.
final workoutSessionProvider = FutureProvider.family<WorkoutSession?, String>((
  ref,
  String id,
) {
  return ref.watch(workoutRepositoryProvider).readSession(id);
});

/// What the runner is currently doing.
class RunnerState {
  const RunnerState({
    this.session,
    this.exerciseIndex = 0,
    this.setIndex = 0,
    this.error,
  });

  final WorkoutSession? session;
  final int exerciseIndex;
  final int setIndex;
  final String? error;

  bool get isActive => session != null && session!.isOpen;

  SessionExercise? get currentExercise {
    final WorkoutSession? value = session;
    if (value == null || value.exercises.isEmpty) return null;
    if (exerciseIndex < 0 || exerciseIndex >= value.exercises.length) {
      return value.exercises.last;
    }
    return value.exercises[exerciseIndex];
  }

  int get currentSetNumber => setIndex + 1;

  /// True when nothing is left to log in this session.
  bool get allSetsLogged {
    final WorkoutSession? value = session;
    if (value == null) return false;
    for (final SessionExercise exercise in value.exercises) {
      final int logged = value.sets
          .where((SetLog log) => log.sessionExerciseId == exercise.id)
          .length;
      if (!exercise.skipped && logged < exercise.plannedSets) return false;
    }
    return true;
  }

  /// Remaining rest, computed from the stored instant so backgrounding and a
  /// process restart cannot make it drift.
  int remainingRestSeconds(DateTime now) {
    final WorkoutSession? value = session;
    if (value == null) return 0;
    if (value.isPaused) return max(0, value.restRemainingSeconds ?? 0);
    final DateTime? endsAt = value.restEndsAt;
    if (endsAt == null) return 0;
    final int seconds = endsAt.difference(now).inSeconds;
    return seconds < 0 ? 0 : seconds;
  }

  bool get hasRest {
    final WorkoutSession? value = session;
    if (value == null) return false;
    if (value.isPaused) return (value.restRemainingSeconds ?? 0) > 0;
    return value.restEndsAt != null;
  }
}

final workoutRunnerProvider =
    AsyncNotifierProvider<WorkoutRunnerController, RunnerState>(
      WorkoutRunnerController.new,
    );

/// Drives one session at a time and persists every change immediately.
class WorkoutRunnerController extends AsyncNotifier<RunnerState> {
  WorkoutRepository get _repository => ref.read(workoutRepositoryProvider);
  Clock get _clock => ref.read(clockProvider);

  @override
  Future<RunnerState> build() async {
    final WorkoutSession? open = await _repository.readOpenSession();
    if (open == null) return const RunnerState();
    return _position(open);
  }

  Future<String?> start(
    PlannedWorkout plan, {
    Map<String, int> targetRepOverrides = const <String, int>{},
  }) async {
    if (plan.exercises.isEmpty) {
      state = AsyncData(
        RunnerState(
          session: state.value?.session,
          error: 'Nothing in this session is performable with your equipment.',
        ),
      );
      return null;
    }

    final DateTime now = _clock.now();
    final String id = 'session-${now.microsecondsSinceEpoch}';
    await _repository.closeOpenSessions(exceptId: id, at: now);

    final List<SessionExercise> exercises = <SessionExercise>[];
    for (int index = 0; index < plan.exercises.length; index++) {
      final PlannedExercise item = plan.exercises[index];
      exercises.add(
        SessionExercise(
          id: '$id-ex-$index',
          sessionId: id,
          exerciseId: item.exercise.id,
          orderIndex: index,
          plannedSets: item.sets,
          restSeconds: item.restSeconds,
          targetReps: targetRepOverrides[item.exercise.id] ?? item.targetReps,
          targetSeconds: item.targetSeconds,
        ),
      );
    }

    final WorkoutSession session = WorkoutSession(
      id: id,
      templateId: plan.templateId,
      templateName: plan.name,
      mode: plan.mode,
      status: WorkoutSessionStatus.inProgress,
      startedAt: now,
      plannedMinutes: plan.estimatedMinutes,
      lastActivityAt: now,
      exercises: exercises,
    );

    await _repository.createSession(session);
    state = AsyncData(_position(session));
    ref.invalidate(openSessionProvider);
    return id;
  }

  /// Logs the current set. [actualReps] defaults to the target, so "complete"
  /// is one tap unless the user edits the number first.
  Future<void> completeSet({int? actualReps, int? actualSeconds}) async {
    final RunnerState? current = state.value;
    final WorkoutSession? session = current?.session;
    final SessionExercise? exercise = current?.currentExercise;
    if (current == null || session == null || exercise == null) return;
    if (!session.isOpen) return;

    final DateTime now = _clock.now();
    final int setIndex = _loggedCount(session, exercise);
    if (setIndex >= exercise.plannedSets) return;

    final int? targetReps = exercise.targetReps;
    final int? targetSeconds = exercise.targetSeconds;
    final int? reps = exercise.isTimed ? null : (actualReps ?? targetReps ?? 0);
    final int? seconds = exercise.isTimed
        ? (actualSeconds ?? targetSeconds ?? 0)
        : null;

    final SetLog log = SetLog(
      id: '${session.id}-${exercise.exerciseId}-$setIndex',
      sessionId: session.id,
      sessionExerciseId: exercise.id,
      exerciseId: exercise.exerciseId,
      setIndex: setIndex,
      targetReps: targetReps,
      actualReps: reps,
      targetSeconds: targetSeconds,
      actualSeconds: seconds,
      completedAt: now,
    );

    final List<SetLog> sets = <SetLog>[...session.sets, log];
    final List<SessionExercise> exercises = _updateExercise(
      session.exercises,
      exercise,
      completedAt: setIndex + 1 >= exercise.plannedSets ? now : null,
    );

    final bool moreSetsInExercise = setIndex + 1 < exercise.plannedSets;
    final WorkoutSession updated = session.copyWith(
      sets: sets,
      exercises: exercises,
      // A set is the unit of progress; rest starts immediately after it.
      restEndsAt: moreSetsInExercise || exercise.plannedSets > 1
          ? now.add(Duration(seconds: exercise.restSeconds))
          : null,
      restRemainingSeconds: null,
      lastActivityAt: now,
    );

    await _repository.saveSet(log);
    await _repository.updateSession(updated);
    await _apply(updated);
  }

  Future<void> skipSet() async {
    final RunnerState? current = state.value;
    final WorkoutSession? session = current?.session;
    final SessionExercise? exercise = current?.currentExercise;
    if (current == null || session == null || exercise == null) return;
    if (!session.isOpen) return;

    final DateTime now = _clock.now();
    final int setIndex = _loggedCount(session, exercise);
    if (setIndex >= exercise.plannedSets) return;

    final SetLog log = SetLog(
      id: '${session.id}-${exercise.exerciseId}-$setIndex',
      sessionId: session.id,
      sessionExerciseId: exercise.id,
      exerciseId: exercise.exerciseId,
      setIndex: setIndex,
      targetReps: exercise.targetReps,
      targetSeconds: exercise.targetSeconds,
      completedAt: now,
      skipped: true,
    );

    final WorkoutSession updated = session.copyWith(
      sets: <SetLog>[...session.sets, log],
      lastActivityAt: now,
      clearRest: true,
    );
    await _repository.saveSet(log);
    await _repository.updateSession(updated);
    await _apply(updated);
  }

  Future<void> skipExercise() async {
    final RunnerState? current = state.value;
    final WorkoutSession? session = current?.session;
    final SessionExercise? exercise = current?.currentExercise;
    if (current == null || session == null || exercise == null) return;
    if (!session.isOpen) return;

    final DateTime now = _clock.now();
    final List<SetLog> newLogs = <SetLog>[];
    final int logged = _loggedCount(session, exercise);
    for (int index = logged; index < exercise.plannedSets; index++) {
      newLogs.add(
        SetLog(
          id: '${session.id}-${exercise.exerciseId}-$index',
          sessionId: session.id,
          sessionExerciseId: exercise.id,
          exerciseId: exercise.exerciseId,
          setIndex: index,
          targetReps: exercise.targetReps,
          targetSeconds: exercise.targetSeconds,
          completedAt: now,
          skipped: true,
        ),
      );
    }

    final List<SessionExercise> exercises = _updateExercise(
      session.exercises,
      exercise,
      skipped: true,
      completedAt: now,
    );
    final WorkoutSession updated = session.copyWith(
      sets: <SetLog>[...session.sets, ...newLogs],
      exercises: exercises,
      lastActivityAt: now,
      clearRest: true,
    );

    for (final SetLog log in newLogs) {
      await _repository.saveSet(log);
    }
    await _repository.markExerciseSkipped(
      exercise.id,
      skipped: true,
      completedAt: now,
    );
    await _repository.updateSession(updated);
    await _apply(updated);
  }

  Future<void> pause() async {
    final RunnerState? current = state.value;
    final WorkoutSession? session = current?.session;
    if (session == null || !session.isOpen || session.isPaused) return;

    final DateTime now = _clock.now();
    final int remaining = current!.remainingRestSeconds(now);
    final WorkoutSession updated = session.copyWith(
      isPaused: true,
      restRemainingSeconds: remaining,
      lastActivityAt: now,
      clearRest: true,
    );
    await _repository.updateSession(updated);
    state = AsyncData(_position(updated));
  }

  Future<void> resume() async {
    final RunnerState? current = state.value;
    final WorkoutSession? session = current?.session;
    if (session == null || !session.isOpen || !session.isPaused) return;

    final DateTime now = _clock.now();
    final int remaining = max(0, session.restRemainingSeconds ?? 0);
    final WorkoutSession updated = session.copyWith(
      isPaused: false,
      restEndsAt: remaining > 0 ? now.add(Duration(seconds: remaining)) : null,
      clearRestRemaining: true,
      lastActivityAt: now,
    );
    await _repository.updateSession(updated);
    state = AsyncData(_position(updated));
  }

  /// Ends the current rest early.
  Future<void> skipRest() async {
    final RunnerState? current = state.value;
    final WorkoutSession? session = current?.session;
    if (session == null || !session.isOpen) return;
    if (!current!.hasRest) return;

    final DateTime now = _clock.now();
    final WorkoutSession updated = session.copyWith(
      clearRest: true,
      clearRestRemaining: true,
      lastActivityAt: now,
    );
    await _repository.updateSession(updated);
    state = AsyncData(_position(updated));
  }

  /// Called by the rest timer. Only clears rest that has actually elapsed, and
  /// never runs while paused.
  Future<void> tickRest() async {
    final RunnerState? current = state.value;
    final WorkoutSession? session = current?.session;
    if (current == null || session == null || !session.isOpen) return;
    if (session.isPaused) return;
    if (session.restEndsAt == null) return;
    if (current.remainingRestSeconds(_clock.now()) > 0) return;

    final WorkoutSession updated = session.copyWith(
      clearRest: true,
      clearRestRemaining: true,
    );
    await _repository.updateSession(updated);
    state = AsyncData(_position(updated));
  }

  /// Finishes the session. No completed set means it is recorded as abandoned
  /// rather than inflating the history.
  Future<void> finish() async {
    final RunnerState? current = state.value;
    final WorkoutSession? session = current?.session;
    if (session == null || !session.isOpen) return;

    final DateTime now = _clock.now();
    final WorkoutSessionStatus status = session.loggedSets > 0
        ? WorkoutSessionStatus.completed
        : WorkoutSessionStatus.abandoned;
    final WorkoutSession updated = session.copyWith(
      status: status,
      endedAt: now,
      lastActivityAt: now,
      isPaused: false,
      clearRest: true,
      clearRestRemaining: true,
    );
    await _repository.updateSession(updated);
    state = AsyncData(_position(updated));
    ref.invalidate(workoutSessionsProvider);
    ref.invalidate(openSessionProvider);
  }

  /// Ends an unfinished session without claiming any work.
  Future<void> discard() async {
    final RunnerState? current = state.value;
    final WorkoutSession? session = current?.session;
    if (session == null || !session.isOpen) return;

    final DateTime now = _clock.now();
    final WorkoutSession updated = session.copyWith(
      status: WorkoutSessionStatus.abandoned,
      endedAt: now,
      lastActivityAt: now,
      isPaused: false,
      clearRest: true,
      clearRestRemaining: true,
    );
    await _repository.updateSession(updated);
    state = AsyncData(_position(updated));
    ref.invalidate(workoutSessionsProvider);
    ref.invalidate(openSessionProvider);
  }

  /// Records how hard the session felt, used by progression next time.
  Future<void> setEffort(int effort) async {
    final WorkoutSession? session = state.value?.session;
    if (session == null) return;
    final int clamped = effort.clamp(1, 5);
    final WorkoutSession updated = session.copyWith(
      perceivedEffort: clamped,
      lastActivityAt: _clock.now(),
    );
    await _repository.updateSession(updated);
    state = AsyncData(_position(updated));
    ref.invalidate(workoutSessionsProvider);
    ref.invalidate(workoutSessionProvider(session.id));
  }

  Future<void> _apply(WorkoutSession session) async {
    state = AsyncData(_position(session));
    if (session.allSetsLogged && session.isOpen) {
      await finish();
      return;
    }
    ref.invalidate(openSessionProvider);
  }

  List<SessionExercise> _updateExercise(
    List<SessionExercise> exercises,
    SessionExercise target, {
    bool? skipped,
    DateTime? completedAt,
  }) {
    return <SessionExercise>[
      for (final SessionExercise exercise in exercises)
        if (exercise.id == target.id)
          exercise.copyWith(skipped: skipped, completedAt: completedAt)
        else
          exercise,
    ];
  }

  int _loggedCount(WorkoutSession session, SessionExercise exercise) {
    return session.sets
        .where((SetLog log) => log.sessionExerciseId == exercise.id)
        .length;
  }

  /// Recomputes the cursor from what is actually stored.
  RunnerState _position(WorkoutSession session) {
    for (int index = 0; index < session.exercises.length; index++) {
      final SessionExercise exercise = session.exercises[index];
      if (exercise.skipped) continue;
      final int logged = _loggedCount(session, exercise);
      if (logged < exercise.plannedSets) {
        return RunnerState(
          session: session,
          exerciseIndex: index,
          setIndex: logged,
        );
      }
    }
    return RunnerState(
      session: session,
      exerciseIndex: session.exercises.isEmpty
          ? 0
          : session.exercises.length - 1,
      setIndex: 0,
    );
  }
}

/// Applies history-only edits (perceived effort) from the summary screen.
final workoutHistoryControllerProvider = Provider<WorkoutHistoryController>(
  (ref) => WorkoutHistoryController(ref),
);

class WorkoutHistoryController {
  WorkoutHistoryController(this._ref);

  final Ref _ref;

  /// Records how hard a finished session felt, which is the signal progression
  /// uses next time. Works for sessions restored after a restart too, because it
  /// reads the stored row instead of trusting the runner's memory.
  Future<void> setEffort(String sessionId, int effort) async {
    final WorkoutRepository repository = _ref.read(workoutRepositoryProvider);
    final WorkoutSession? session = await repository.readSession(sessionId);
    if (session == null) return;
    await repository.updateSession(
      session.copyWith(
        perceivedEffort: effort.clamp(1, 5),
        lastActivityAt: _ref.read(clockProvider).now(),
      ),
    );
    _ref.invalidate(workoutSessionProvider(sessionId));
    _ref.invalidate(workoutSessionsProvider);
  }
}

extension on WorkoutSession {
  bool get allSetsLogged {
    for (final SessionExercise exercise in exercises) {
      final int logged = sets
          .where((SetLog log) => log.sessionExerciseId == exercise.id)
          .length;
      if (!exercise.skipped && logged < exercise.plannedSets) return false;
    }
    return true;
  }
}
