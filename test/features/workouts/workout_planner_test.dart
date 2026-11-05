import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/exercises/data/exercise_repository.dart';
import 'package:homefit/features/exercises/domain/exercise.dart';
import 'package:homefit/features/profile/domain/profile_options.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';
import 'package:homefit/features/workouts/data/workout_templates.dart';
import 'package:homefit/features/workouts/domain/planned_workout.dart';
import 'package:homefit/features/workouts/domain/progression.dart';
import 'package:homefit/features/workouts/domain/workout_mode.dart';
import 'package:homefit/features/workouts/domain/workout_planner.dart';
import 'package:homefit/features/workouts/domain/workout_template.dart';

import '../../fixtures/profile_fixtures.dart';

void main() {
  final WorkoutPlanner planner = WorkoutPlanner(BundledExerciseRepository());
  final WorkoutTemplate fullBodyA = templateById('full-body-a')!;

  PlannedWorkout planFor(UserProfile profile) =>
      planner.plan(template: fullBodyA, profile: profile);

  test('a no-equipment beginner gets a complete bodyweight session', () {
    final PlannedWorkout plan = planFor(buildTestProfile());
    expect(plan.exercises, isNotEmpty);
    expect(
      plan.exercises.every(
        (PlannedExercise item) => item.exercise.canPerformWith(<EquipmentItem>{
          EquipmentItem.bodyweight,
        }),
      ),
      isTrue,
    );
    expect(
      plan.exercises.every(
        (PlannedExercise item) =>
            item.exercise.difficulty.rank <= ExerciseDifficulty.beginner.rank,
      ),
      isTrue,
    );
    expect(plan.totalSets, greaterThanOrEqualTo(10));
    expect(plan.estimatedMinutes, greaterThan(0));
  });

  test('owned equipment is preferred over the bodyweight fallback', () {
    final PlannedWorkout plan = planFor(
      buildTestProfile().copyWith(
        equipment: <EquipmentItem>{
          EquipmentItem.bodyweight,
          EquipmentItem.resistanceBand,
        },
      ),
    );
    final List<String> ids = plan.exercises
        .map((PlannedExercise item) => item.exercise.id)
        .toList();
    expect(ids, contains('band-row'));
    expect(ids, isNot(contains('superman')));
  });

  test('slots above the experience level are dropped, not downgraded', () {
    const WorkoutTemplate template = WorkoutTemplate(
      id: 'level-test',
      name: 'Level test',
      description: 'only an intermediate movement',
      mode: WorkoutMode.normal,
      difficulty: ExerciseDifficulty.beginner,
      focus: <MuscleGroup>{MuscleGroup.arms},
      restSeconds: 60,
      safetyNotes: <String>['Stop if it hurts.'],
      exercises: <TemplateExercise>[
        TemplateExercise(
          exerciseIds: <String>['diamond-push-up'],
          sets: 3,
          repsMin: 6,
        ),
      ],
    );

    final PlannedWorkout beginner = planner.plan(
      template: template,
      profile: buildTestProfile(),
    );
    expect(beginner.exercises, isEmpty);
    expect(beginner.isEmpty, isTrue);

    final PlannedWorkout intermediate = planner.plan(
      template: template,
      profile: buildTestProfile().copyWith(
        experience: ExperienceLevel.intermediate,
      ),
    );
    expect(intermediate.exercises, hasLength(1));
    expect(intermediate.exercises.single.exercise.id, 'diamond-push-up');
  });

  test('a plan never contains an exercise requiring missing equipment', () {
    for (final WorkoutTemplate template in kWorkoutTemplates) {
      final PlannedWorkout plan = planFor(buildTestProfile());
      for (final PlannedExercise item in plan.exercises) {
        expect(
          item.exercise.canPerformWith(<EquipmentItem>{
            EquipmentItem.bodyweight,
          }),
          isTrue,
          reason: '${template.id} selected ${item.exercise.id}',
        );
      }
    }
  });

  test('timed slots carry seconds instead of reps', () {
    final PlannedWorkout plan = planFor(buildTestProfile());
    final PlannedExercise plank = plan.exercises.firstWhere(
      (PlannedExercise item) => item.exercise.id == 'plank',
    );
    expect(plank.isTimed, isTrue);
    expect(plank.targetSeconds, 30);
    expect(plank.targetReps, isNull);
  });

  test('manual rep adjustment overrides the template target', () {
    final PlannedWorkout plan = planner.plan(
      template: fullBodyA,
      profile: buildTestProfile(),
      targetRepOverrides: <String, int>{'bodyweight-squat': 12},
    );
    final PlannedExercise squat = plan.exercises.firstWhere(
      (PlannedExercise item) => item.exercise.id == 'bodyweight-squat',
    );
    expect(squat.targetReps, 12);
    expect(squat.note, 'Adjusted for this session.');
  });

  test('progression decisions replace the starting target and explain why', () {
    final PlannedWorkout plan = planner.plan(
      template: fullBodyA,
      profile: buildTestProfile(),
      progression: const <String, ProgressionDecision>{
        'bodyweight-squat': ProgressionDecision(
          action: ProgressionAction.increase,
          targetReps: 10,
          reason: 'Two comfortable sessions in a row.',
        ),
      },
    );
    final PlannedExercise squat = plan.exercises.firstWhere(
      (PlannedExercise item) => item.exercise.id == 'bodyweight-squat',
    );
    expect(squat.targetReps, 10);
    expect(squat.progressionReason, contains('comfortable'));
  });

  test('a manual adjustment wins over a progression decision', () {
    final PlannedWorkout plan = planner.plan(
      template: fullBodyA,
      profile: buildTestProfile(),
      targetRepOverrides: <String, int>{'bodyweight-squat': 6},
      progression: const <String, ProgressionDecision>{
        'bodyweight-squat': ProgressionDecision(
          action: ProgressionAction.increase,
          targetReps: 10,
          reason: 'increase',
        ),
      },
    );
    final PlannedExercise squat = plan.exercises.firstWhere(
      (PlannedExercise item) => item.exercise.id == 'bodyweight-squat',
    );
    expect(squat.targetReps, 6);
  });

  group('targeted sessions', () {
    test('are deterministic and limited to the chosen muscle', () {
      final PlannedWorkout first = planner.targeted(
        muscle: MuscleGroup.chest,
        profile: buildTestProfile(),
      );
      final PlannedWorkout second = planner.targeted(
        muscle: MuscleGroup.chest,
        profile: buildTestProfile(),
      );
      expect(
        first.exercises.map((PlannedExercise item) => item.exercise.id),
        second.exercises.map((PlannedExercise item) => item.exercise.id),
      );
      expect(first.exercises, isNotEmpty);
      expect(
        first.exercises.every(
          (PlannedExercise item) =>
              item.exercise.primaryMuscle == MuscleGroup.chest,
        ),
        isTrue,
      );
      expect(first.mode, WorkoutMode.targeted);
      expect(first.exercises.length, lessThanOrEqualTo(4));
    });

    test('respect equipment and level', () {
      final PlannedWorkout plan = planner.targeted(
        muscle: MuscleGroup.arms,
        profile: buildTestProfile(),
      );
      expect(plan.exercises, isEmpty);

      final PlannedWorkout band = planner.targeted(
        muscle: MuscleGroup.arms,
        profile: buildTestProfile().copyWith(
          equipment: <EquipmentItem>{
            EquipmentItem.bodyweight,
            EquipmentItem.resistanceBand,
          },
        ),
      );
      expect(band.exercises, isNotEmpty);
      expect(
        band.exercises.every(
          (PlannedExercise item) =>
              item.exercise.canPerformWith(<EquipmentItem>{
                EquipmentItem.bodyweight,
                EquipmentItem.resistanceBand,
              }),
        ),
        isTrue,
      );
    });

    test('hold-based movements become timed targets', () {
      final PlannedWorkout plan = planner.targeted(
        muscle: MuscleGroup.core,
        profile: buildTestProfile(),
      );
      final PlannedExercise plank = plan.exercises.firstWhere(
        (PlannedExercise item) => item.exercise.id == 'plank',
      );
      expect(plank.isTimed, isTrue);
      expect(plank.targetSeconds, WorkoutPlanner.targetedHoldSeconds);
    });
  });

  test('unknown template ids resolve to null without throwing', () {
    expect(planner.templateById('nope'), isNull);
    expect(planner.templateById(null), isNull);
  });
}
