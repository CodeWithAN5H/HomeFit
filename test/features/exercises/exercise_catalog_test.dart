import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/exercises/data/exercise_catalog.dart';
import 'package:homefit/features/exercises/data/exercise_repository.dart';
import 'package:homefit/features/exercises/domain/exercise.dart';
import 'package:homefit/features/profile/domain/profile_options.dart';

/// Guards the bundled library: every movement must be complete, addressable
/// and honest about what it needs before it can appear in the app.
void main() {
  group('dataset integrity', () {
    test('ids are unique, stable slugs', () {
      final List<String> ids = exerciseCatalog
          .map((Exercise exercise) => exercise.id)
          .toList();
      expect(ids.toSet().length, ids.length, reason: 'duplicate exercise id');

      final RegExp slug = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$');
      for (final Exercise exercise in exerciseCatalog) {
        expect(
          slug.hasMatch(exercise.id),
          isTrue,
          reason: '"${exercise.id}" is not a lowercase hyphenated slug',
        );
      }
    });

    test('every exercise carries usable instructions', () {
      for (final Exercise exercise in exerciseCatalog) {
        expect(exercise.name.trim(), isNotEmpty, reason: exercise.id);
        expect(
          exercise.steps.length,
          greaterThanOrEqualTo(3),
          reason: '${exercise.id} needs at least three steps',
        );
        expect(
          exercise.formCues.length,
          greaterThanOrEqualTo(2),
          reason: '${exercise.id} needs at least two form cues',
        );
        for (final String text in <String>[
          ...exercise.steps,
          ...exercise.formCues,
        ]) {
          expect(text.trim(), isNotEmpty, reason: exercise.id);
        }
      }
    });

    test('equipment is declared honestly', () {
      for (final Exercise exercise in exerciseCatalog) {
        expect(exercise.equipment, isNotEmpty, reason: exercise.id);
        if (exercise.isBodyweight) {
          expect(exercise.equipment, <EquipmentItem>[
            EquipmentItem.bodyweight,
          ], reason: exercise.id);
          expect(exercise.canPerformWith(<EquipmentItem>{}), isTrue);
          expect(exercise.equipmentLabel, 'No equipment');
        } else {
          expect(
            exercise.equipment,
            isNot(contains(EquipmentItem.bodyweight)),
            reason: '${exercise.id} mixes bodyweight into a real requirement',
          );
          expect(
            exercise.canPerformWith(<EquipmentItem>{}),
            isFalse,
            reason: '${exercise.id} claims to need nothing but lists equipment',
          );
        }
      }
    });

    test('primary muscle never repeats in secondary muscles', () {
      for (final Exercise exercise in exerciseCatalog) {
        expect(
          exercise.secondaryMuscles,
          isNot(contains(exercise.primaryMuscle)),
          reason: exercise.id,
        );
        expect(
          exercise.secondaryMuscles.toSet().length,
          exercise.secondaryMuscles.length,
          reason: exercise.id,
        );
      }
    });

    test('covers every muscle group with a useful number of movements', () {
      for (final MuscleGroup group in MuscleGroup.values) {
        final int count = exerciseCatalog
            .where((Exercise exercise) => exercise.primaryMuscle == group)
            .length;
        expect(
          count,
          greaterThanOrEqualTo(4),
          reason: '${group.label} has only $count exercises',
        );
      }
      expect(exerciseCatalog.length, greaterThanOrEqualTo(40));
    });

    test('bodyweight and resistance-band work are well represented', () {
      final int bodyweight = exerciseCatalog
          .where((Exercise exercise) => exercise.isBodyweight)
          .length;
      final int band = exerciseCatalog
          .where(
            (Exercise exercise) =>
                exercise.equipment.contains(EquipmentItem.resistanceBand),
          )
          .length;
      expect(bodyweight, greaterThanOrEqualTo(10));
      expect(band, greaterThanOrEqualTo(6));
    });
  });

  group('repository', () {
    test('serves every bundled exercise by id', () {
      final BundledExerciseRepository repository = BundledExerciseRepository();
      expect(repository.all().length, exerciseCatalog.length);
      for (final Exercise exercise in exerciseCatalog) {
        expect(repository.byId(exercise.id)?.name, exercise.name);
      }
    });

    test('unknown id returns null instead of throwing', () {
      final BundledExerciseRepository repository = BundledExerciseRepository();
      expect(repository.byId('not-a-real-exercise'), isNull);
    });

    test('the bundled catalogue cannot be mutated at runtime', () {
      expect(
        () => exerciseCatalog.add(exerciseCatalog.first),
        throwsUnsupportedError,
      );
    });
  });

  group('difficulty', () {
    test('maps experience levels to the hardest sensible difficulty', () {
      expect(
        ExerciseDifficulty.fromExperience(ExperienceLevel.beginner),
        ExerciseDifficulty.beginner,
      );
      expect(
        ExerciseDifficulty.fromExperience(ExperienceLevel.returning),
        ExerciseDifficulty.beginner,
      );
      expect(
        ExerciseDifficulty.fromExperience(ExperienceLevel.intermediate),
        ExerciseDifficulty.intermediate,
      );
    });

    test('ranks difficulty in ascending order', () {
      expect(
        ExerciseDifficulty.beginner.rank,
        lessThan(ExerciseDifficulty.intermediate.rank),
      );
      expect(
        ExerciseDifficulty.intermediate.rank,
        lessThan(ExerciseDifficulty.advanced.rank),
      );
    });
  });
}
