import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/core/database/app_database.dart';
import 'package:homefit/core/services/clock.dart';
import 'package:homefit/features/exercises/domain/exercise.dart';
import 'package:homefit/features/profile/application/profile_providers.dart';
import 'package:homefit/features/workouts/domain/planned_workout.dart';
import 'package:homefit/features/workouts/application/workout_providers.dart';
import 'package:homefit/features/workouts/data/workout_repository.dart';
import 'package:homefit/features/workouts/domain/workout_mode.dart';
import 'package:homefit/features/workouts/domain/workout_session.dart';

import '../../fixtures/profile_fixtures.dart';
import '../../fixtures/workout_fixtures.dart';

late AppDatabase database;
late TestClock clock;
late ProviderContainer container;
late DriftWorkoutRepository repository;

WorkoutRunnerController get controller =>
    container.read(workoutRunnerProvider.notifier);

RunnerState get state => container.read(workoutRunnerProvider).value!;

Future<String> start() async {
  await container.read(workoutRunnerProvider.future);
  final String? id = await controller.start(buildTestPlan());
  expect(id, isNotNull);
  return id!;
}

void main() {
  setUp(() {
    database = AppDatabase.memory();
    repository = DriftWorkoutRepository(database);
    clock = TestClock(DateTime(2026, 11, 5, 18));
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        initialProfileProvider.overrideWithValue(buildTestProfile()),
        clockProvider.overrideWithValue(clock),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  test('starting a session persists the planned exercises', () async {
    final String id = await start();
    expect(state.isActive, isTrue);
    expect(state.session!.id, id);
    expect(state.session!.status, WorkoutSessionStatus.inProgress);
    expect(state.session!.exercises, hasLength(6));
    expect(state.currentExercise!.exerciseId, 'bodyweight-squat');
    expect((await repository.readOpenSession())?.id, id);
  });

  test('completing a set logs it and starts rest from the target', () async {
    await start();
    await controller.completeSet();

    final RunnerState after = state;
    expect(after.session!.loggedSets, 1);
    expect(after.setIndex, 1);
    expect(after.session!.sets.single.actualReps, 8);
    expect(
      after.session!.restEndsAt!.difference(clock.now()).inSeconds,
      inInclusiveRange(58, 60),
    );
    expect(after.hasRest, isTrue);
  });

  test('an edited rep count is stored as the actual value', () async {
    await start();
    await controller.completeSet(actualReps: 5);
    expect(state.session!.sets.single.actualReps, 5);
    expect(state.session!.completedSets, 0);
  });

  test('rest only clears once the stored end time has passed', () async {
    await start();
    await controller.completeSet();

    clock.advance(const Duration(seconds: 30));
    await controller.tickRest();
    expect(state.hasRest, isTrue);
    expect(state.remainingRestSeconds(clock.now()), greaterThan(0));

    clock.advance(const Duration(seconds: 31));
    await controller.tickRest();
    expect(state.hasRest, isFalse);
    expect(state.session!.restEndsAt, isNull);
  });

  test('skipping rest clears it immediately', () async {
    await start();
    await controller.completeSet();
    await controller.skipRest();
    expect(state.hasRest, isFalse);
    expect(state.session!.sets, hasLength(1));
  });

  test('finishing an exercise advances to the next one', () async {
    await start();
    await controller.completeSet();
    await controller.completeSet();
    await controller.completeSet();

    expect(state.exerciseIndex, 1);
    expect(state.currentExercise!.exerciseId, 'push-up');
    expect(state.setIndex, 0);
  });

  test('skipping a set records it without adding rest', () async {
    await start();
    await controller.skipSet();

    expect(state.session!.sets.single.skipped, isTrue);
    expect(state.session!.skippedSets, 1);
    expect(state.hasRest, isFalse);
    expect(state.setIndex, 1);
  });

  test(
    'skipping an exercise records its remaining sets and moves on',
    () async {
      await start();
      await controller.skipExercise();

      final SessionExercise first = state.session!.exercises.first;
      expect(first.skipped, isTrue);
      expect(first.completedAt, isNotNull);
      expect(
        state.session!.sets
            .where((SetLog log) => log.sessionExerciseId == first.id)
            .length,
        3,
      );
      expect(state.exerciseIndex, 1);
    },
  );

  test('pause holds the remaining rest for resume', () async {
    await start();
    await controller.completeSet();
    await controller.pause();

    expect(state.session!.isPaused, isTrue);
    expect(state.session!.restEndsAt, isNull);
    expect(state.session!.restRemainingSeconds, inInclusiveRange(58, 60));

    clock.advance(const Duration(minutes: 5));
    await controller.resume();
    expect(state.session!.isPaused, isFalse);
    expect(
      state.session!.restEndsAt!.difference(clock.now()).inSeconds,
      inInclusiveRange(58, 60),
    );
  });

  test('pause blocks nothing in storage but stops the countdown', () async {
    await start();
    await controller.completeSet();
    await controller.pause();
    clock.advance(const Duration(minutes: 10));
    await controller.tickRest();
    expect(state.hasRest, isTrue);
    expect(state.remainingRestSeconds(clock.now()), inInclusiveRange(58, 60));
  });

  test('finishing after work marks the session completed', () async {
    await start();
    await controller.completeSet();
    await controller.finish();

    expect(state.session!.status, WorkoutSessionStatus.completed);
    expect(state.session!.endedAt, isNotNull);
    expect(state.isActive, isFalse);

    final List<WorkoutSession> stored = await repository.readSessions();
    expect(stored.single.status, WorkoutSessionStatus.completed);
    expect(await repository.readOpenSession(), isNull);
  });

  test('discarding without work records it as abandoned', () async {
    await start();
    await controller.discard();

    expect(state.session!.status, WorkoutSessionStatus.abandoned);
    final List<WorkoutSession> stored = await repository.readSessions();
    expect(stored.single.status, WorkoutSessionStatus.abandoned);
    expect(stored.single.status.countsAsWorkout, isFalse);
  });

  test('an interrupted runner restores its position from storage', () async {
    await start();
    await controller.completeSet();
    await controller.completeSet();

    container.invalidate(workoutRunnerProvider);
    final RunnerState restored = await container.read(
      workoutRunnerProvider.future,
    );
    expect(restored.session, isNotNull);
    expect(restored.exerciseIndex, 0);
    expect(restored.setIndex, 2);
    expect(restored.session!.loggedSets, 2);
  });

  test('starting a new session interrupts the unfinished one', () async {
    final String firstId = await start();
    clock.advance(const Duration(seconds: 1));
    await controller.start(buildTestPlan());
    final String secondId = state.session!.id;
    expect(secondId, isNot(firstId));

    final WorkoutSession first = (await repository.readSession(firstId))!;
    expect(first.status, WorkoutSessionStatus.interrupted);
    expect((await repository.readOpenSession())?.id, secondId);
  });

  test(
    'completing every planned set finishes the session automatically',
    () async {
      await start();
      final int totalSets = state.session!.totalSets;
      expect(totalSets, 17);

      for (int index = 0; index < totalSets; index++) {
        await controller.completeSet();
      }

      expect(state.session!.status, WorkoutSessionStatus.completed);
      expect(state.session!.loggedSets, totalSets);
      expect(await repository.readOpenSession(), isNull);
    },
  );

  test('perceived effort is stored for progression', () async {
    final String id = await start();
    await controller.completeSet();
    await controller.finish();
    await controller.setEffort(4);

    final WorkoutSession stored = (await repository.readSession(id))!;
    expect(stored.perceivedEffort, 4);
  });

  test(
    'starting with an empty plan fails loudly instead of selling it',
    () async {
      await container.read(workoutRunnerProvider.future);
      const PlannedWorkout empty = PlannedWorkout(
        templateId: 'empty',
        name: 'Empty',
        description: 'Nothing performable',
        mode: WorkoutMode.normal,
        difficulty: ExerciseDifficulty.beginner,
        focus: <MuscleGroup>{},
        exercises: <PlannedExercise>[],
        restSeconds: 60,
        safetyNotes: <String>['none'],
      );
      final String? id = await controller.start(empty);
      expect(id, isNull);
      expect(state.error, contains('performable'));
    },
  );
}
