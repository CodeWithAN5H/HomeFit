import 'workout_mode.dart';

/// One exercise as stored for a session.
///
/// Targets are copied into the session when it starts, so history keeps the plan
/// the user actually followed even if a template is edited later.
class SessionExercise {
  const SessionExercise({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.orderIndex,
    required this.plannedSets,
    required this.restSeconds,
    this.targetReps,
    this.targetSeconds,
    this.skipped = false,
    this.completedAt,
  });

  final String id;
  final String sessionId;
  final String exerciseId;
  final int orderIndex;
  final int plannedSets;
  final int restSeconds;
  final int? targetReps;
  final int? targetSeconds;
  final bool skipped;
  final DateTime? completedAt;

  bool get isTimed => targetSeconds != null;

  SessionExercise copyWith({bool? skipped, DateTime? completedAt}) {
    return SessionExercise(
      id: id,
      sessionId: sessionId,
      exerciseId: exerciseId,
      orderIndex: orderIndex,
      plannedSets: plannedSets,
      restSeconds: restSeconds,
      targetReps: targetReps,
      targetSeconds: targetSeconds,
      skipped: skipped ?? this.skipped,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

/// One logged set. Skipped sets are stored too, so a session is never silently
/// missing work the user chose to skip.
class SetLog {
  const SetLog({
    required this.id,
    required this.sessionId,
    required this.sessionExerciseId,
    required this.exerciseId,
    required this.setIndex,
    required this.completedAt,
    this.targetReps,
    this.actualReps,
    this.targetSeconds,
    this.actualSeconds,
    this.restSecondsTaken,
    this.skipped = false,
  });

  final String id;
  final String sessionId;
  final String sessionExerciseId;
  final String exerciseId;

  /// Zero-based position within the exercise.
  final int setIndex;
  final int? targetReps;
  final int? actualReps;
  final int? targetSeconds;
  final int? actualSeconds;
  final int? restSecondsTaken;
  final bool skipped;
  final DateTime completedAt;

  bool get isTimed => targetSeconds != null;

  bool get hitTarget {
    if (skipped) return false;
    if (isTimed) return (actualSeconds ?? 0) >= (targetSeconds ?? 0);
    return (actualReps ?? 0) >= (targetReps ?? 0);
  }
}

/// A stored workout with its planned exercises and logged sets.
class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.templateId,
    required this.templateName,
    required this.mode,
    required this.status,
    required this.startedAt,
    required this.plannedMinutes,
    required this.lastActivityAt,
    this.endedAt,
    this.perceivedEffort,
    this.isPaused = false,
    this.restEndsAt,
    this.restRemainingSeconds,
    this.exercises = const <SessionExercise>[],
    this.sets = const <SetLog>[],
  });

  final String id;
  final String templateId;
  final String templateName;
  final WorkoutMode mode;
  final WorkoutSessionStatus status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int plannedMinutes;

  /// When the user last touched the session; a long gap is what "interrupted"
  /// is about, and it is recorded rather than guessed.
  final DateTime lastActivityAt;

  final int? perceivedEffort;
  final bool isPaused;

  /// Absolute end of the current rest. Storing the instant, not a countdown, is
  /// what keeps rest accurate across a backgrounded app or a process restart.
  final DateTime? restEndsAt;

  /// Remaining rest while paused, so pausing cannot consume rest time.
  final int? restRemainingSeconds;

  final List<SessionExercise> exercises;
  final List<SetLog> sets;

  bool get isOpen => status.isOpen;

  int get completedSets =>
      sets.where((SetLog set) => !set.skipped && set.hitTarget).length;

  int get loggedSets => sets.where((SetLog set) => !set.skipped).length;

  int get skippedSets => sets.where((SetLog set) => set.skipped).length;

  int get totalSets => exercises.fold(
    0,
    (int total, SessionExercise item) => total + item.plannedSets,
  );

  int get totalReps => sets
      .where((SetLog set) => !set.skipped)
      .fold(0, (int total, SetLog set) => total + (set.actualReps ?? 0));

  int get totalSeconds => sets
      .where((SetLog set) => !set.skipped)
      .fold(0, (int total, SetLog set) => total + (set.actualSeconds ?? 0));

  /// Completed sets over planned sets, clamped to 0..1.
  double get completionRatio {
    final int planned = totalSets;
    if (planned == 0) return 0;
    final double ratio = loggedSets / planned;
    return ratio > 1 ? 1 : ratio;
  }

  Duration get duration {
    final DateTime end = endedAt ?? lastActivityAt;
    final Duration span = end.difference(startedAt);
    return span.isNegative ? Duration.zero : span;
  }

  SessionExercise? get currentExercise =>
      exercises.isEmpty ? null : exercises.first;

  WorkoutSession copyWith({
    WorkoutSessionStatus? status,
    DateTime? endedAt,
    int? perceivedEffort,
    bool? isPaused,
    DateTime? restEndsAt,
    int? restRemainingSeconds,
    bool clearRest = false,
    bool clearRestRemaining = false,
    DateTime? lastActivityAt,
    List<SessionExercise>? exercises,
    List<SetLog>? sets,
  }) {
    return WorkoutSession(
      id: id,
      templateId: templateId,
      templateName: templateName,
      mode: mode,
      status: status ?? this.status,
      startedAt: startedAt,
      endedAt: endedAt ?? this.endedAt,
      plannedMinutes: plannedMinutes,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      perceivedEffort: perceivedEffort ?? this.perceivedEffort,
      isPaused: isPaused ?? this.isPaused,
      restEndsAt: clearRest ? null : (restEndsAt ?? this.restEndsAt),
      restRemainingSeconds: clearRestRemaining
          ? null
          : (restRemainingSeconds ?? this.restRemainingSeconds),
      exercises: exercises ?? this.exercises,
      sets: sets ?? this.sets,
    );
  }
}
