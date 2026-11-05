import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/core/database/app_database.dart';
import 'package:homefit/features/profile/data/profile_repository.dart';
import 'package:homefit/features/workouts/data/workout_repository.dart';
import 'package:homefit/features/workouts/domain/workout_history.dart';
import 'package:homefit/features/workouts/domain/workout_mode.dart';
import 'package:homefit/features/workouts/domain/workout_session.dart';
import 'package:path/path.dart' as p;

import '../../fixtures/profile_fixtures.dart';
import '../../fixtures/workout_fixtures.dart';

void main() {
  late AppDatabase database;
  late DriftWorkoutRepository repository;

  setUp(() {
    database = AppDatabase.memory();
    repository = DriftWorkoutRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('a session round-trips with its exercises and targets', () async {
    final WorkoutSession draft = buildStoredSession();
    await repository.createSession(draft);

    final WorkoutSession? loaded = await repository.readSession(draft.id);
    expect(loaded, isNotNull);
    expect(loaded!.templateName, 'Full body A');
    expect(loaded.mode, WorkoutMode.normal);
    expect(loaded.status, WorkoutSessionStatus.inProgress);
    expect(loaded.exercises, hasLength(2));
    expect(loaded.exercises.first.exerciseId, 'bodyweight-squat');
    expect(loaded.exercises.first.targetReps, 8);
    expect(loaded.exercises.last.orderIndex, 1);
  });

  test('logged sets are stored and counted', () async {
    final WorkoutSession draft = buildStoredSession(reps: const <int>[]);
    await repository.createSession(draft);
    await repository.saveSet(
      SetLog(
        id: 'set-1',
        sessionId: draft.id,
        sessionExerciseId: draft.exercises.first.id,
        exerciseId: 'bodyweight-squat',
        setIndex: 0,
        targetReps: 8,
        actualReps: 7,
        completedAt: DateTime.utc(2026, 11, 1, 10, 5),
      ),
    );

    final WorkoutSession loaded = (await repository.readSession(draft.id))!;
    expect(loaded.sets, hasLength(1));
    expect(loaded.sets.single.actualReps, 7);
    expect(loaded.loggedSets, 1);
    expect(
      loaded.completedSets,
      0,
      reason: 'seven reps missed a target of eight',
    );
  });

  test('status, effort and rest are written back', () async {
    final WorkoutSession draft = buildStoredSession();
    await repository.createSession(draft);

    final DateTime endsAt = DateTime.utc(2026, 11, 1, 10, 3);
    await repository.updateSession(
      draft.copyWith(
        status: WorkoutSessionStatus.completed,
        endedAt: DateTime.utc(2026, 11, 1, 10, 30),
        perceivedEffort: 3,
        restEndsAt: endsAt,
        lastActivityAt: DateTime.utc(2026, 11, 1, 10, 30),
      ),
    );

    final WorkoutSession loaded = (await repository.readSession(draft.id))!;
    expect(loaded.status, WorkoutSessionStatus.completed);
    expect(loaded.perceivedEffort, 3);
    expect(loaded.endedAt, isNotNull);
    expect(
      loaded.restEndsAt!.toUtc().difference(endsAt).inSeconds.abs(),
      lessThanOrEqualTo(1),
    );
  });

  test('only an unfinished session is reported as open', () async {
    expect(await repository.readOpenSession(), isNull);

    final WorkoutSession draft = buildStoredSession(id: 'open');
    await repository.createSession(draft);
    expect((await repository.readOpenSession())?.id, 'open');

    await repository.updateSession(
      draft.copyWith(status: WorkoutSessionStatus.abandoned),
    );
    expect(await repository.readOpenSession(), isNull);
  });
  test(
    'a new session closes the old one as interrupted and keeps its sets',
    () async {
      final WorkoutSession old = buildStoredSession(
        id: 'old',
        reps: const <int>[],
      );
      await repository.createSession(old);
      await repository.saveSet(
        SetLog(
          id: 'old-set',
          sessionId: old.id,
          sessionExerciseId: old.exercises.first.id,
          exerciseId: 'bodyweight-squat',
          setIndex: 0,
          targetReps: 8,
          actualReps: 8,
          completedAt: DateTime.utc(2026, 11, 1, 10, 5),
        ),
      );

      await repository.closeOpenSessions(
        exceptId: 'new',
        at: DateTime.utc(2026, 11, 2, 9),
      );

      final WorkoutSession stored = (await repository.readSession('old'))!;
      expect(stored.status, WorkoutSessionStatus.interrupted);
      expect(stored.status.countsAsWorkout, isFalse);
      expect(stored.sets, hasLength(1));
      expect(stored.endedAt, isNotNull);
    },
  );

  test('history is returned newest first', () async {
    await repository.createSession(
      buildStoredSession(id: 'first', startedAt: DateTime.utc(2026, 11, 1, 10)),
    );
    await repository.createSession(
      buildStoredSession(
        id: 'second',
        startedAt: DateTime.utc(2026, 11, 3, 10),
      ),
    );

    final List<WorkoutSession> sessions = await repository.readSessions();
    expect(sessions.map((WorkoutSession s) => s.id), <String>[
      'second',
      'first',
    ]);
  });

  test('deleting a session cascades to its exercises and sets', () async {
    final WorkoutSession draft = buildStoredSession();
    await repository.createSession(draft);
    await repository.saveSet(
      SetLog(
        id: 'set',
        sessionId: draft.id,
        sessionExerciseId: draft.exercises.first.id,
        exerciseId: 'bodyweight-squat',
        setIndex: 0,
        targetReps: 8,
        actualReps: 8,
        completedAt: DateTime.utc(2026, 11, 1, 10, 5),
      ),
    );

    await (database.delete(
      database.workoutSessionRows,
    )..where((t) => t.id.equals(draft.id))).go();

    expect(
      await database.select(database.workoutSessionExerciseRows).get(),
      isEmpty,
    );
    expect(await database.select(database.workoutSetRows).get(), isEmpty);
  });

  test(
    'a set cannot reference a session exercise that does not exist',
    () async {
      final WorkoutSession draft = buildStoredSession();
      await repository.createSession(draft);

      await expectLater(
        repository.saveSet(
          SetLog(
            id: 'orphan',
            sessionId: draft.id,
            sessionExerciseId: 'missing-exercise',
            exerciseId: 'bodyweight-squat',
            setIndex: 0,
            targetReps: 8,
            actualReps: 8,
            completedAt: DateTime.utc(2026, 11, 1, 10, 5),
          ),
        ),
        throwsA(anything),
      );
    },
  );

  group('progression history', () {
    test('reports the last completed performance per exercise', () async {
      await repository.createSession(
        buildStoredSession(
          id: 'done',
          startedAt: DateTime.utc(2026, 11, 1, 10),
          status: WorkoutSessionStatus.completed,
          effort: 3,
        ),
      );

      final Map<String, ExerciseHistory> history = await repository.readHistory(
        <String>['bodyweight-squat'],
      );
      final ExerciseHistory entry = history['bodyweight-squat']!;
      expect(entry.targetReps, 8);
      expect(entry.prescribedSets, 3);
      expect(entry.completedReps, <int>[8, 8, 6]);
      expect(entry.effort, 3);
      expect(entry.comfortableStreak, 0);
    });

    test('counts consecutive earlier comfortable sessions', () async {
      await repository.createSession(
        buildStoredSession(
          id: 'comfortable-1',
          startedAt: DateTime.utc(2026, 11, 1, 10),
          status: WorkoutSessionStatus.completed,
          reps: <int>[8, 8, 8],
          effort: 2,
        ),
      );
      await repository.createSession(
        buildStoredSession(
          id: 'comfortable-2',
          startedAt: DateTime.utc(2026, 11, 3, 10),
          status: WorkoutSessionStatus.completed,
          reps: <int>[8, 8, 8],
          effort: 2,
        ),
      );

      final ExerciseHistory entry = (await repository.readHistory(<String>[
        'bodyweight-squat',
      ]))['bodyweight-squat']!;
      expect(entry.comfortableStreak, 1);
      expect(
        ExerciseHistory.isComfortable(
          completedReps: entry.completedReps,
          targetReps: entry.targetReps,
          prescribedSets: entry.prescribedSets,
          effort: entry.effort,
        ),
        isTrue,
      );
    });

    test(
      'quick, recovery, abandoned and open sessions are not evidence',
      () async {
        await repository.createSession(
          buildStoredSession(
            id: 'normal',
            startedAt: DateTime.utc(2026, 11, 1, 10),
            status: WorkoutSessionStatus.completed,
            reps: <int>[8, 8, 8],
            effort: 2,
          ),
        );
        await repository.createSession(
          buildStoredSession(
            id: 'quick',
            startedAt: DateTime.utc(2026, 11, 3, 10),
            status: WorkoutSessionStatus.completed,
            mode: WorkoutMode.quick,
            reps: <int>[12, 12, 12],
            effort: 1,
          ),
        );
        await repository.createSession(
          buildStoredSession(
            id: 'abandoned',
            startedAt: DateTime.utc(2026, 11, 4, 10),
            status: WorkoutSessionStatus.abandoned,
            reps: <int>[2, 1, 0],
            effort: 1,
          ),
        );
        await repository.createSession(
          buildStoredSession(
            id: 'open',
            startedAt: DateTime.utc(2026, 11, 5, 10),
            reps: <int>[1, 1, 1],
            effort: 1,
          ),
        );

        final ExerciseHistory entry = (await repository.readHistory(<String>[
          'bodyweight-squat',
        ]))['bodyweight-squat']!;
        expect(entry.completedReps, <int>[8, 8, 8]);
        expect(entry.comfortableStreak, 0);
      },
    );
  });

  test('schema v1 data survives the upgrade to v2', () async {
    final Directory directory = Directory.systemTemp.createTempSync(
      'homefit_m4_migration',
    );
    addTearDown(() {
      if (directory.existsSync()) directory.deleteSync(recursive: true);
    });
    final File file = File(p.join(directory.path, 'homefit.sqlite'));

    final AppDatabase first = AppDatabase(NativeDatabase(file));
    await DriftProfileRepository(first).saveProfile(buildTestProfile());
    // Simulate a database written by the previous schema: only the M4 tables
    // are missing and user_version says v1. The migration must add them without
    // touching the profile.
    await first.customStatement('DROP TABLE workout_set_rows');
    await first.customStatement('DROP TABLE workout_session_exercise_rows');
    await first.customStatement('DROP TABLE workout_session_rows');
    await first.customStatement('PRAGMA user_version = 1');
    await first.close();

    final AppDatabase second = AppDatabase(NativeDatabase(file));
    addTearDown(second.close);

    final profile = await DriftProfileRepository(second).readProfile();
    expect(profile, isNotNull);
    expect(profile!.age, buildTestProfile().age);

    final DriftWorkoutRepository upgraded = DriftWorkoutRepository(second);
    final WorkoutSession draft = buildStoredSession(id: 'after-migration');
    await upgraded.createSession(draft);
    expect(
      (await upgraded.readSession('after-migration'))?.id,
      'after-migration',
    );
    expect(await upgraded.readSessions(), hasLength(1));
  });
}
