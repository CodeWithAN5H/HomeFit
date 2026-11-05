import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/exercises/data/exercise_catalog.dart';
import 'package:homefit/features/exercises/data/exercise_repository.dart';
import 'package:homefit/features/exercises/domain/exercise.dart';
import 'package:homefit/features/workouts/data/workout_templates.dart';
import 'package:homefit/features/workouts/domain/workout_mode.dart';
import 'package:homefit/features/workouts/domain/workout_template.dart';

void main() {
  final BundledExerciseRepository repository = BundledExerciseRepository();

  test('template ids are unique', () {
    final Set<String> ids = kWorkoutTemplates
        .map((WorkoutTemplate template) => template.id)
        .toSet();
    expect(ids.length, kWorkoutTemplates.length);
  });

  test('every referenced exercise id exists in the catalogue', () {
    for (final WorkoutTemplate template in kWorkoutTemplates) {
      for (final String id in template.allExerciseIds) {
        expect(
          repository.byId(id),
          isNotNull,
          reason: '${template.id} references unknown exercise "$id"',
        );
      }
    }
  });

  test('every slot has one target type and a conservative volume', () {
    for (final WorkoutTemplate template in kWorkoutTemplates) {
      for (final TemplateExercise slot in template.exercises) {
        expect(slot.exerciseIds, isNotEmpty, reason: template.id);
        expect(slot.sets, inInclusiveRange(2, 4), reason: template.id);
        expect(
          (slot.repsMin == null) != (slot.seconds == null),
          isTrue,
          reason: '${template.id} mixes reps and holds in one slot',
        );
        if (slot.isTimed) {
          expect(slot.seconds, inInclusiveRange(15, 45));
        } else {
          expect(slot.repsMin, inInclusiveRange(3, 15));
          final int? max = slot.repsMax;
          if (max != null) {
            expect(max, greaterThanOrEqualTo(slot.repsMin!));
            expect(max, lessThanOrEqualTo(20));
          }
        }
      }
    }
  });

  test('the programme covers every fixed mode at least once', () {
    for (final WorkoutMode mode in WorkoutMode.values) {
      // Targeted sessions are generated per muscle group by the planner rather
      // than bundled as templates, so they have no entry here.
      if (mode == WorkoutMode.targeted) continue;
      expect(
        templatesForMode(mode),
        isNotEmpty,
        reason: 'no template for ${mode.name}',
      );
    }
    expect(
      templatesForMode(WorkoutMode.normal).length,
      greaterThanOrEqualTo(3),
    );
  });

  test('no normal session prescribes an advanced movement', () {
    for (final WorkoutTemplate template in templatesForMode(
      WorkoutMode.normal,
    )) {
      for (final String id in template.allExerciseIds) {
        expect(
          repository.byId(id)!.difficulty,
          isNot(ExerciseDifficulty.advanced),
          reason: '${template.id} lists advanced "$id"',
        );
      }
    }
  });

  test('the full-body rotation covers the major areas without repeats', () {
    final Set<MuscleGroup> covered = <MuscleGroup>{};
    for (final WorkoutTemplate template in templatesForMode(
      WorkoutMode.normal,
    )) {
      for (final TemplateExercise slot in template.exercises) {
        covered.add(repository.byId(slot.exerciseIds.first)!.primaryMuscle);
      }
      // No exercise appears twice inside one session.
      final List<String> firstChoices = template.exercises
          .map((TemplateExercise slot) => slot.exerciseIds.first)
          .toList();
      expect(firstChoices.toSet().length, firstChoices.length);
    }
    expect(
      covered,
      containsAll(<MuscleGroup>[
        MuscleGroup.chest,
        MuscleGroup.back,
        MuscleGroup.legs,
        MuscleGroup.core,
      ]),
    );
  });

  test('duration estimates are plausible and mode-appropriate', () {
    for (final WorkoutTemplate template in kWorkoutTemplates) {
      expect(template.estimatedMinutes, inInclusiveRange(5, 60));
      expect(template.totalSets, greaterThan(0));
    }
    for (final WorkoutTemplate quick in templatesForMode(WorkoutMode.quick)) {
      expect(quick.estimatedMinutes, lessThanOrEqualTo(12));
    }
  });

  test('every session carries safety guidance and coaching notes', () {
    for (final WorkoutTemplate template in kWorkoutTemplates) {
      expect(template.safetyNotes, isNotEmpty, reason: template.id);
      expect(
        template.safetyNotes.every((String note) => note.trim().isNotEmpty),
        isTrue,
      );
      expect(template.description.trim(), isNotEmpty);
      expect(template.guidance, isNotEmpty);
    }
  });

  test('lookups are safe for unknown and missing ids', () {
    expect(templateById('full-body-a')?.name, 'Full body A');
    expect(templateById('missing'), isNull);
    expect(templateById(null), isNull);
    expect(
      kWorkoutTemplates.every(
        (WorkoutTemplate template) => exerciseCatalog.isNotEmpty,
      ),
      isTrue,
    );
  });
}
