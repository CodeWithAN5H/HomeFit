import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/exercises/data/exercise_catalog.dart';
import 'package:homefit/features/exercises/domain/exercise.dart';
import 'package:homefit/features/exercises/domain/exercise_query.dart';
import 'package:homefit/features/profile/domain/profile_options.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';

import '../../fixtures/profile_fixtures.dart';

List<Exercise> query(ExerciseFilter filter, {UserProfile? profile}) {
  return ExerciseQuery.apply(exerciseCatalog, filter, profile: profile);
}

List<String> idsOf(List<Exercise> exercises) =>
    exercises.map((Exercise exercise) => exercise.id).toList();

void main() {
  group('searching', () {
    test('matches part of a name, ignoring case', () {
      final List<Exercise> results = query(
        const ExerciseFilter(search: 'PUSH'),
      );
      expect(idsOf(results), contains('push-up'));
      expect(idsOf(results), contains('knee-push-up'));
      expect(idsOf(results), contains('diamond-push-up'));
      expect(idsOf(results), isNot(contains('band-row')));
    });

    test('ignores surrounding whitespace', () {
      expect(
        idsOf(query(const ExerciseFilter(search: '  pull-up  '))),
        <String>['pull-up'],
      );
    });

    test('an unmatched search returns nothing', () {
      expect(query(const ExerciseFilter(search: 'zzzzzz')), isEmpty);
    });
  });

  group('filtering', () {
    test('muscle filter includes movements where it is secondary', () {
      final List<Exercise> results = query(
        const ExerciseFilter(muscle: MuscleGroup.chest),
      );
      expect(idsOf(results), contains('push-up'));
      expect(
        idsOf(results),
        contains('diamond-push-up'),
        reason: 'the triceps push-up variation also trains the chest',
      );
      expect(
        results.every(
          (Exercise exercise) => exercise.targets(MuscleGroup.chest),
        ),
        isTrue,
      );
      expect(idsOf(results), isNot(contains('calf-raise')));
    });

    test('equipment filter returns only movements that require it', () {
      final List<Exercise> results = query(
        const ExerciseFilter(equipment: EquipmentItem.resistanceBand),
      );
      expect(results, isNotEmpty);
      expect(
        results.every(
          (Exercise exercise) =>
              exercise.equipment.contains(EquipmentItem.resistanceBand),
        ),
        isTrue,
      );
      expect(idsOf(results), isNot(contains('push-up')));
    });

    test('difficulty filter is exact', () {
      final List<Exercise> results = query(
        const ExerciseFilter(difficulty: ExerciseDifficulty.advanced),
      );
      expect(results, isNotEmpty);
      expect(
        results.every(
          (Exercise exercise) =>
              exercise.difficulty == ExerciseDifficulty.advanced,
        ),
        isTrue,
      );
    });

    test('filters combine', () {
      final List<Exercise> results = query(
        const ExerciseFilter(
          muscle: MuscleGroup.legs,
          equipment: EquipmentItem.resistanceBand,
        ),
      );
      expect(idsOf(results), <String>[
        'band-glute-kickback',
        'band-squat-to-press',
      ]);
    });

    test('"my equipment only" hides movements needing what is not owned', () {
      final UserProfile profile = buildTestProfile().copyWith(
        equipment: <EquipmentItem>{
          EquipmentItem.bodyweight,
          EquipmentItem.resistanceBand,
        },
      );
      final List<Exercise> results = query(
        const ExerciseFilter(onlyMyEquipment: true),
        profile: profile,
      );
      expect(results, isNotEmpty);
      expect(
        results.every(
          (Exercise exercise) => exercise.canPerformWith(profile.equipment),
        ),
        isTrue,
      );
      expect(idsOf(results), isNot(contains('pull-up')));
      expect(idsOf(results), isNot(contains('dumbbell-row')));
    });

    test('"my equipment only" without a profile does nothing', () {
      final List<Exercise> results = query(
        const ExerciseFilter(onlyMyEquipment: true),
      );
      expect(results.length, exerciseCatalog.length);
    });

    test('no filter returns the whole library', () {
      expect(query(const ExerciseFilter()).length, exerciseCatalog.length);
    });
  });

  group('ordering', () {
    test('results are alphabetical, independent of catalogue order', () {
      final List<Exercise> results = query(const ExerciseFilter());
      final List<String> names = results
          .map((Exercise exercise) => exercise.name.toLowerCase())
          .toList();
      final List<String> sorted = <String>[...names]..sort();
      expect(names, sorted);
    });

    test('filtering does not reorder around the profile', () {
      final UserProfile beginner = buildTestProfile();
      expect(
        idsOf(query(const ExerciseFilter(muscle: MuscleGroup.core))),
        idsOf(
          query(
            const ExerciseFilter(muscle: MuscleGroup.core),
            profile: beginner,
          ),
        ),
      );
    });
  });

  group('filter model', () {
    test('copyWith keeps untouched fields', () {
      const ExerciseFilter filter = ExerciseFilter(
        search: 'press',
        muscle: MuscleGroup.chest,
        difficulty: ExerciseDifficulty.beginner,
      );
      final ExerciseFilter next = filter.copyWith(search: 'row');
      expect(next.search, 'row');
      expect(next.muscle, MuscleGroup.chest);
      expect(next.difficulty, ExerciseDifficulty.beginner);
    });

    test('copyWith can clear a nullable field', () {
      const ExerciseFilter filter = ExerciseFilter(muscle: MuscleGroup.back);
      expect(filter.copyWith(muscle: null).muscle, isNull);
    });

    test('reports whether anything is filtering the list', () {
      expect(const ExerciseFilter().hasAnyFilter, isFalse);
      expect(const ExerciseFilter().hasChipFilter, isFalse);
      expect(const ExerciseFilter(search: 'press').hasAnyFilter, isTrue);
      expect(
        const ExerciseFilter(search: 'press').hasChipFilter,
        isFalse,
        reason: 'a text search is not a chip filter',
      );
      expect(const ExerciseFilter(onlyMyEquipment: true).hasChipFilter, isTrue);
    });
  });
}
