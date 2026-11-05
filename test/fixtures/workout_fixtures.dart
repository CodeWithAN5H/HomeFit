import 'package:homefit/core/services/clock.dart';
import 'package:homefit/features/exercises/data/exercise_repository.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';
import 'package:homefit/features/workouts/data/workout_templates.dart';
import 'package:homefit/features/workouts/domain/planned_workout.dart';
import 'package:homefit/features/workouts/domain/workout_mode.dart';
import 'package:homefit/features/workouts/domain/workout_planner.dart';
import 'package:homefit/features/workouts/domain/workout_session.dart';

import 'profile_fixtures.dart';

/// A clock the test moves by hand, so rest, schedule and recovery rules can be
/// checked without sleeping.
class TestClock implements Clock {
  TestClock(this._now);

  DateTime _now;

  void advance(Duration duration) => _now = _now.add(duration);

  void set(DateTime value) => _now = value;

  @override
  DateTime now() => _now;
}

/// The canonical beginner plan used across runner and widget tests.
PlannedWorkout buildTestPlan({
  UserProfile? profile,
  String templateId = 'full-body-a',
}) {
  final WorkoutPlanner planner = WorkoutPlanner(BundledExerciseRepository());
  return planner.plan(
    template: templateById(templateId)!,
    profile: profile ?? buildTestProfile(),
  );
}

/// A stored session shaped like a finished workout, without any sets.
WorkoutSession buildTestSession({
  required String id,
  required DateTime startedAt,
  WorkoutSessionStatus status = WorkoutSessionStatus.completed,
  WorkoutMode mode = WorkoutMode.normal,
  String templateId = 'full-body-a',
  String templateName = 'Full body A',
  int? perceivedEffort,
  List<SessionExercise> exercises = const <SessionExercise>[],
  List<SetLog> sets = const <SetLog>[],
}) {
  final DateTime ended = startedAt.add(const Duration(minutes: 28));
  return WorkoutSession(
    id: id,
    templateId: templateId,
    templateName: templateName,
    mode: mode,
    status: status,
    startedAt: startedAt,
    endedAt: status == WorkoutSessionStatus.inProgress ? null : ended,
    plannedMinutes: 30,
    lastActivityAt: ended,
    perceivedEffort: perceivedEffort,
    exercises: exercises,
    sets: sets,
  );
}

/// Two-exercise session with targets, used by the repository tests.
WorkoutSession buildStoredSession({
  String id = 'session-test',
  DateTime? startedAt,
  WorkoutSessionStatus status = WorkoutSessionStatus.inProgress,
  WorkoutMode mode = WorkoutMode.normal,
  List<int> reps = const <int>[8, 8, 6],
  int? effort,
}) {
  final DateTime start = startedAt ?? DateTime.utc(2026, 11, 1, 10);
  final List<SessionExercise> exercises = <SessionExercise>[
    SessionExercise(
      id: '$id-ex-0',
      sessionId: id,
      exerciseId: 'bodyweight-squat',
      orderIndex: 0,
      plannedSets: 3,
      restSeconds: 60,
      targetReps: 8,
    ),
    SessionExercise(
      id: '$id-ex-1',
      sessionId: id,
      exerciseId: 'push-up',
      orderIndex: 1,
      plannedSets: 2,
      restSeconds: 60,
      targetReps: 5,
    ),
  ];
  final List<SetLog> sets = <SetLog>[
    for (int index = 0; index < reps.length; index++)
      SetLog(
        id: '$id-set-0-$index',
        sessionId: id,
        sessionExerciseId: '$id-ex-0',
        exerciseId: 'bodyweight-squat',
        setIndex: index,
        targetReps: 8,
        actualReps: reps[index],
        completedAt: start.add(Duration(minutes: index * 3)),
      ),
  ];
  final WorkoutSession session = buildTestSession(
    id: id,
    startedAt: start,
    status: status,
    mode: mode,
    perceivedEffort: effort,
    exercises: exercises,
    sets: sets,
  );
  return session;
}
