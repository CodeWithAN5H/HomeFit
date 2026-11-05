import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/workout_history.dart';
import '../domain/workout_mode.dart';
import '../domain/workout_session.dart';
import 'workout_mappers.dart';

/// Storage contract for workout history.
///
/// Application code depends on this interface, so the runner and the progression
/// engine can be tested with an in-memory database (or a fake) without touching
/// the UI.
abstract interface class WorkoutRepository {
  /// Inserts the session and its planned exercises in one transaction.
  Future<void> createSession(WorkoutSession session);

  /// Writes the mutable session fields (status, pause, rest, effort, activity).
  Future<void> updateSession(WorkoutSession session);

  Future<void> markExerciseSkipped(
    String sessionExerciseId, {
    required bool skipped,
    DateTime? completedAt,
  });

  Future<void> saveSet(SetLog log);

  Future<WorkoutSession?> readSession(String id);

  /// The single unfinished session, or null.
  Future<WorkoutSession?> readOpenSession();

  /// History, newest first.
  Future<List<WorkoutSession>> readSessions({int limit = 40});

  /// Closes any other open session as interrupted, keeping its partial data.
  Future<void> closeOpenSessions({
    required String exceptId,
    required DateTime at,
  });

  /// Previous performance per exercise, newest session per exercise.
  Future<Map<String, ExerciseHistory>> readHistory(List<String> exerciseIds);
}

class DriftWorkoutRepository implements WorkoutRepository {
  DriftWorkoutRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> createSession(WorkoutSession session) async {
    await _database.transaction(() async {
      await _database
          .into(_database.workoutSessionRows)
          .insert(sessionToRow(session));
      for (final SessionExercise exercise in session.exercises) {
        await _database
            .into(_database.workoutSessionExerciseRows)
            .insert(sessionExerciseToRow(exercise));
      }
      // A session may arrive with sets already recorded (restore/import paths),
      // so they are written in the same transaction rather than dropped.
      for (final SetLog log in session.sets) {
        await _database.into(_database.workoutSetRows).insert(setToRow(log));
      }
    });
  }

  @override
  Future<void> updateSession(WorkoutSession session) async {
    await (_database.update(
      _database.workoutSessionRows,
    )..where((t) => t.id.equals(session.id))).write(
      WorkoutSessionRowsCompanion(
        status: Value<String>(session.status.name),
        endedAt: Value<DateTime?>(session.endedAt?.toUtc()),
        perceivedEffort: Value<int?>(session.perceivedEffort),
        isPaused: Value<bool>(session.isPaused),
        restEndsAt: Value<DateTime?>(session.restEndsAt?.toUtc()),
        restRemainingSeconds: Value<int?>(session.restRemainingSeconds),
        lastActivityAt: Value<DateTime>(session.lastActivityAt.toUtc()),
      ),
    );
  }

  @override
  Future<void> markExerciseSkipped(
    String sessionExerciseId, {
    required bool skipped,
    DateTime? completedAt,
  }) async {
    await (_database.update(
      _database.workoutSessionExerciseRows,
    )..where((t) => t.id.equals(sessionExerciseId))).write(
      WorkoutSessionExerciseRowsCompanion(
        skipped: Value<bool>(skipped),
        completedAt: Value<DateTime?>(completedAt?.toUtc()),
      ),
    );
  }

  @override
  Future<void> saveSet(SetLog log) async {
    await _database.into(_database.workoutSetRows).insert(setToRow(log));
  }

  @override
  Future<WorkoutSession?> readSession(String id) async {
    final WorkoutSessionRow? row = await (_database.select(
      _database.workoutSessionRows,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final List<WorkoutSession> assembled = await _assemble(<WorkoutSessionRow>[
      row,
    ]);
    return assembled.isEmpty ? null : assembled.single;
  }

  @override
  Future<WorkoutSession?> readOpenSession() async {
    final WorkoutSessionRow? row =
        await (_database.select(_database.workoutSessionRows)
              ..where(
                (t) => t.status.equals(WorkoutSessionStatus.inProgress.name),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    final List<WorkoutSession> assembled = await _assemble(<WorkoutSessionRow>[
      row,
    ]);
    return assembled.isEmpty ? null : assembled.single;
  }

  @override
  Future<List<WorkoutSession>> readSessions({int limit = 40}) async {
    final List<WorkoutSessionRow> rows =
        await (_database.select(_database.workoutSessionRows)
              ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
              ..limit(limit))
            .get();
    return _assemble(rows);
  }

  @override
  Future<void> closeOpenSessions({
    required String exceptId,
    required DateTime at,
  }) async {
    await (_database.update(_database.workoutSessionRows)..where(
          (t) =>
              t.status.equals(WorkoutSessionStatus.inProgress.name) &
              t.id.equals(exceptId).not(),
        ))
        .write(
          WorkoutSessionRowsCompanion(
            status: Value<String>(WorkoutSessionStatus.interrupted.name),
            endedAt: Value<DateTime?>(at.toUtc()),
            isPaused: const Value<bool>(false),
            restEndsAt: const Value<DateTime?>(null),
            restRemainingSeconds: const Value<int?>(null),
            lastActivityAt: Value<DateTime>(at.toUtc()),
          ),
        );
  }

  @override
  Future<Map<String, ExerciseHistory>> readHistory(
    List<String> exerciseIds,
  ) async {
    if (exerciseIds.isEmpty) return <String, ExerciseHistory>{};

    // Only completed strength sessions are evidence. Quick, recovery and skill
    // sessions are excluded on purpose, so they can never raise a target.
    final List<WorkoutSessionRow> sessionRows =
        await (_database.select(_database.workoutSessionRows)
              ..where(
                (t) =>
                    t.status.equals(WorkoutSessionStatus.completed.name) &
                    t.mode.isIn(<String>[
                      WorkoutMode.normal.name,
                      WorkoutMode.targeted.name,
                    ]),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
              ..limit(12))
            .get();
    if (sessionRows.isEmpty) return <String, ExerciseHistory>{};
    final List<WorkoutSession> sessions = await _assemble(sessionRows);
    if (sessions.isEmpty) return <String, ExerciseHistory>{};

    final Map<String, ExerciseHistory> history = <String, ExerciseHistory>{};
    for (final String exerciseId in exerciseIds) {
      ExerciseHistory? built;
      int comfortableStreak = 0;
      bool counting = true;

      for (final WorkoutSession session in sessions) {
        final SessionExercise? planned = _plannedFor(session, exerciseId);
        if (planned == null) continue;

        final List<SetLog> logs =
            session.sets
                .where((SetLog log) => log.exerciseId == exerciseId)
                .toList()
              ..sort((SetLog a, SetLog b) => a.setIndex.compareTo(b.setIndex));
        if (logs.isEmpty) continue;

        final List<int?> reps = logs
            .map<int?>((SetLog log) => log.skipped ? null : log.actualReps)
            .toList();

        if (built == null) {
          built = ExerciseHistory(
            exerciseId: exerciseId,
            targetReps: planned.targetReps ?? 0,
            prescribedSets: planned.plannedSets,
            completedReps: reps,
            effort: session.perceivedEffort,
          );
          continue;
        }

        final bool comfortable = ExerciseHistory.isComfortable(
          completedReps: reps,
          targetReps: planned.targetReps ?? 0,
          prescribedSets: planned.plannedSets,
          effort: session.perceivedEffort,
        );
        if (counting && comfortable) {
          comfortableStreak++;
        } else {
          counting = false;
        }
      }

      if (built != null) {
        history[exerciseId] = ExerciseHistory(
          exerciseId: built.exerciseId,
          targetReps: built.targetReps,
          prescribedSets: built.prescribedSets,
          completedReps: built.completedReps,
          effort: built.effort,
          comfortableStreak: comfortableStreak,
        );
      }
    }
    return history;
  }

  SessionExercise? _plannedFor(WorkoutSession session, String exerciseId) {
    for (final SessionExercise exercise in session.exercises) {
      if (exercise.exerciseId == exerciseId) return exercise;
    }
    return null;
  }

  Future<List<WorkoutSession>> _assemble(List<WorkoutSessionRow> rows) async {
    if (rows.isEmpty) return const <WorkoutSession>[];

    final List<String> ids = rows
        .map((WorkoutSessionRow row) => row.id)
        .toList(growable: false);

    final List<WorkoutSessionExerciseRow> exerciseRows =
        await (_database.select(_database.workoutSessionExerciseRows)
              ..where((t) => t.sessionId.isIn(ids))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .get();

    final List<WorkoutSetRow> setRows =
        await (_database.select(_database.workoutSetRows)
              ..where((t) => t.sessionId.isIn(ids))
              ..orderBy([(t) => OrderingTerm.asc(t.completedAt)]))
            .get();

    final Map<String, List<SessionExercise>> exercisesBySession =
        <String, List<SessionExercise>>{};
    for (final WorkoutSessionExerciseRow row in exerciseRows) {
      exercisesBySession
          .putIfAbsent(row.sessionId, () => <SessionExercise>[])
          .add(sessionExerciseFromRow(row));
    }

    final Map<String, List<SetLog>> setsBySession = <String, List<SetLog>>{};
    for (final WorkoutSetRow row in setRows) {
      setsBySession
          .putIfAbsent(row.sessionId, () => <SetLog>[])
          .add(setFromRow(row));
    }

    return rows
        .map(
          (WorkoutSessionRow row) => sessionFromRow(
            row,
            exercises: exercisesBySession[row.id] ?? const <SessionExercise>[],
            sets: setsBySession[row.id] ?? const <SetLog>[],
          ),
        )
        .toList(growable: false);
  }
}
