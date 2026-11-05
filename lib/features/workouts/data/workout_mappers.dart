import '../../../core/database/app_database.dart';
import '../domain/workout_mode.dart';
import '../domain/workout_session.dart';

/// Row ↔ domain conversion for workout history.
///
/// Session timestamps are stored UTC and read back local, because every one of
/// them is a user-facing wall-clock event (started at, finished at, rest ends
/// at). The profile mappers keep UTC for the same reason in reverse: they carry
/// audit instants.
WorkoutSessionRow sessionToRow(WorkoutSession session) => WorkoutSessionRow(
  id: session.id,
  templateId: session.templateId,
  templateName: session.templateName,
  mode: session.mode.name,
  status: session.status.name,
  startedAt: session.startedAt.toUtc(),
  endedAt: session.endedAt?.toUtc(),
  plannedMinutes: session.plannedMinutes,
  perceivedEffort: session.perceivedEffort,
  isPaused: session.isPaused,
  restEndsAt: session.restEndsAt?.toUtc(),
  restRemainingSeconds: session.restRemainingSeconds,
  lastActivityAt: session.lastActivityAt.toUtc(),
);

WorkoutSession sessionFromRow(
  WorkoutSessionRow row, {
  List<SessionExercise> exercises = const <SessionExercise>[],
  List<SetLog> sets = const <SetLog>[],
}) {
  return WorkoutSession(
    id: row.id,
    templateId: row.templateId,
    templateName: row.templateName,
    mode: WorkoutMode.fromName(row.mode),
    status: WorkoutSessionStatus.fromName(row.status),
    startedAt: row.startedAt.toLocal(),
    endedAt: row.endedAt?.toLocal(),
    plannedMinutes: row.plannedMinutes,
    lastActivityAt: row.lastActivityAt.toLocal(),
    perceivedEffort: row.perceivedEffort,
    isPaused: row.isPaused,
    restEndsAt: row.restEndsAt?.toLocal(),
    restRemainingSeconds: row.restRemainingSeconds,
    exercises: exercises,
    sets: sets,
  );
}

WorkoutSessionExerciseRow sessionExerciseToRow(SessionExercise exercise) =>
    WorkoutSessionExerciseRow(
      id: exercise.id,
      sessionId: exercise.sessionId,
      exerciseId: exercise.exerciseId,
      orderIndex: exercise.orderIndex,
      plannedSets: exercise.plannedSets,
      targetReps: exercise.targetReps,
      targetSeconds: exercise.targetSeconds,
      restSeconds: exercise.restSeconds,
      skipped: exercise.skipped,
      completedAt: exercise.completedAt?.toUtc(),
    );

SessionExercise sessionExerciseFromRow(WorkoutSessionExerciseRow row) =>
    SessionExercise(
      id: row.id,
      sessionId: row.sessionId,
      exerciseId: row.exerciseId,
      orderIndex: row.orderIndex,
      plannedSets: row.plannedSets,
      targetReps: row.targetReps,
      targetSeconds: row.targetSeconds,
      restSeconds: row.restSeconds,
      skipped: row.skipped,
      completedAt: row.completedAt?.toLocal(),
    );

WorkoutSetRow setToRow(SetLog log) => WorkoutSetRow(
  id: log.id,
  sessionId: log.sessionId,
  sessionExerciseId: log.sessionExerciseId,
  exerciseId: log.exerciseId,
  setIndex: log.setIndex,
  targetReps: log.targetReps,
  actualReps: log.actualReps,
  targetSeconds: log.targetSeconds,
  actualSeconds: log.actualSeconds,
  restSecondsTaken: log.restSecondsTaken,
  skipped: log.skipped,
  completedAt: log.completedAt.toUtc(),
);

SetLog setFromRow(WorkoutSetRow row) => SetLog(
  id: row.id,
  sessionId: row.sessionId,
  sessionExerciseId: row.sessionExerciseId,
  exerciseId: row.exerciseId,
  setIndex: row.setIndex,
  targetReps: row.targetReps,
  actualReps: row.actualReps,
  targetSeconds: row.targetSeconds,
  actualSeconds: row.actualSeconds,
  restSecondsTaken: row.restSecondsTaken,
  skipped: row.skipped,
  completedAt: row.completedAt.toLocal(),
);
