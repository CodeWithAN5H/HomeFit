import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/exercises/data/exercise_catalog.dart';
import 'package:homefit/features/exercises/domain/exercise.dart';
import 'package:homefit/features/exercises/domain/exercise_query.dart';
import 'package:homefit/features/profile/domain/profile_options.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';

import '../../fixtures/profile_fixtures.dart';

Exercise buildExercise({
  required String id,
  required String name,
  required MuscleGroup primary,
  List<MuscleGroup> secondary = const <MuscleGroup>[],
  List<EquipmentItem> equipment = const <EquipmentItem>[
    EquipmentItem.bodyweight,
  ],
  ExerciseDifficulty difficulty = ExerciseDifficulty.beginner,
}) {
  return Exercise(
    id: id,
    name: name,
    primaryMuscle: primary,
    secondaryMuscles: secondary,
    equipment: equipment,
    difficulty: difficulty,
    steps: const <String>['Step one.', 'Step two.', 'Step three.'],
    formCues: const <String>['Cue one.', 'Cue two.'],
  );
}

List<String> idsOf(List<ExerciseAlternative> alternatives) =>
    alternatives.map((ExerciseAlternative entry) => entry.exercise.id).toList();

Exercise catalogExercise(String id) =>
    exerciseCatalog.firstWhere((Exercise exercise) => exercise.id == id);

void main() {
  group('candidate selection', () {
    final Exercise target = buildExercise(
      id: 'target',
      name: 'Target press',
      primary: MuscleGroup.chest,
      secondary: <MuscleGroup>[MuscleGroup.arms],
      equipment: <EquipmentItem>[EquipmentItem.dumbbells],
    );
    final Exercise sharedPrimary = buildExercise(
      id: 'shared-primary',
      name: 'Band press',
      primary: MuscleGroup.chest,
      equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    );
    final Exercise sharedSecondary = buildExercise(
      id: 'shared-secondary',
      name: 'Band curl',
      primary: MuscleGroup.arms,
      equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    );
    final Exercise unrelated = buildExercise(
      id: 'unrelated',
      name: 'Calf raise',
      primary: MuscleGroup.legs,
    );

    List<ExerciseAlternative> suggest(
      List<Exercise> all, {
      Set<EquipmentItem> owned = const <EquipmentItem>{
        EquipmentItem.resistanceBand,
      },
      ExerciseDifficulty maxDifficulty = ExerciseDifficulty.intermediate,
      Set<MuscleGroup> focus = const <MuscleGroup>{},
      Set<TrainingGoal> goals = const <TrainingGoal>{},
      int limit = 4,
    }) {
      return ExerciseQuery.alternativesFor(
        target: target,
        all: <Exercise>[target, ...all],
        ownedEquipment: owned,
        maxDifficulty: maxDifficulty,
        focusMuscles: focus,
        goals: goals,
        limit: limit,
      );
    }

    test('never suggests the exercise itself', () {
      expect(
        idsOf(suggest(<Exercise>[sharedPrimary])),
        isNot(contains('target')),
      );
    });

    test('skips movements that share no muscle with the target', () {
      expect(idsOf(suggest(<Exercise>[unrelated])), isEmpty);
      expect(idsOf(suggest(<Exercise>[sharedPrimary, unrelated])), <String>[
        'shared-primary',
      ]);
    });

    test('includes both primary and secondary matches', () {
      expect(
        idsOf(suggest(<Exercise>[sharedPrimary, sharedSecondary])),
        containsAll(<String>['shared-primary', 'shared-secondary']),
      );
    });

    test('respects the limit', () {
      expect(
        suggest(<Exercise>[sharedPrimary, sharedSecondary], limit: 1).length,
        1,
      );
    });
  });

  group('equipment compatibility', () {
    final Exercise target = buildExercise(
      id: 'target',
      name: 'Band chest press',
      primary: MuscleGroup.chest,
      equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    );
    final Exercise needsBar = buildExercise(
      id: 'needs-bar',
      name: 'Bar press',
      primary: MuscleGroup.chest,
      equipment: <EquipmentItem>[EquipmentItem.pullUpBar],
    );
    final Exercise ready = buildExercise(
      id: 'ready',
      name: 'Push-up',
      primary: MuscleGroup.chest,
    );

    test('flags what the profile cannot perform instead of hiding it', () {
      final List<ExerciseAlternative> alternatives =
          ExerciseQuery.alternativesFor(
            target: target,
            all: <Exercise>[target, needsBar, ready],
            ownedEquipment: <EquipmentItem>{EquipmentItem.bodyweight},
            maxDifficulty: ExerciseDifficulty.beginner,
          );
      final Map<String, bool> readyById = <String, bool>{
        for (final ExerciseAlternative entry in alternatives)
          entry.exercise.id: entry.equipmentReady,
      };
      expect(readyById['needs-bar'], isFalse);
      expect(readyById['ready'], isTrue);
    });

    test('prefers equipment the profile already owns', () {
      final List<String> ordered = idsOf(
        ExerciseQuery.alternativesFor(
          target: target,
          all: <Exercise>[target, needsBar, ready],
          ownedEquipment: <EquipmentItem>{EquipmentItem.bodyweight},
          maxDifficulty: ExerciseDifficulty.beginner,
        ),
      );
      // Alphabetically "Bar press" would lead, but it is not performable.
      expect(ordered, <String>['ready', 'needs-bar']);
    });

    test('bodyweight work is always performable', () {
      final List<ExerciseAlternative> alternatives =
          ExerciseQuery.alternativesFor(
            target: target,
            all: <Exercise>[target, ready],
            ownedEquipment: <EquipmentItem>{},
            maxDifficulty: ExerciseDifficulty.beginner,
          );
      expect(alternatives.single.equipmentReady, isTrue);
    });
  });

  group('ranking', () {
    final Exercise target = buildExercise(
      id: 'target',
      name: 'Target press',
      primary: MuscleGroup.chest,
      equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    );

    test('prefers a difficulty within the profile level', () {
      final Exercise advanced = buildExercise(
        id: 'advanced',
        name: 'A advanced push-up',
        primary: MuscleGroup.chest,
        difficulty: ExerciseDifficulty.advanced,
      );
      final Exercise beginner = buildExercise(
        id: 'beginner',
        name: 'Z beginner push-up',
        primary: MuscleGroup.chest,
      );
      final List<String> ordered = idsOf(
        ExerciseQuery.alternativesFor(
          target: target,
          all: <Exercise>[target, advanced, beginner],
          ownedEquipment: <EquipmentItem>{EquipmentItem.bodyweight},
          maxDifficulty: ExerciseDifficulty.beginner,
        ),
      );
      expect(ordered.first, 'beginner');
    });

    test('an intermediate profile still sees advanced work', () {
      final Exercise advanced = buildExercise(
        id: 'advanced',
        name: 'Advanced push-up',
        primary: MuscleGroup.chest,
        difficulty: ExerciseDifficulty.advanced,
      );
      final Exercise beginner = buildExercise(
        id: 'beginner',
        name: 'Beginner push-up',
        primary: MuscleGroup.chest,
      );
      final List<String> ordered = idsOf(
        ExerciseQuery.alternativesFor(
          target: target,
          all: <Exercise>[target, advanced, beginner],
          ownedEquipment: <EquipmentItem>{EquipmentItem.bodyweight},
          maxDifficulty: ExerciseDifficulty.intermediate,
        ),
      );
      // Both are equipment-ready, so difficulty ascending breaks the tie.
      expect(ordered, <String>['beginner', 'advanced']);
    });

    test('raises movements that train a saved focus area', () {
      final Exercise plain = buildExercise(
        id: 'plain',
        name: 'A push-up',
        primary: MuscleGroup.chest,
      );
      final Exercise focused = buildExercise(
        id: 'focused',
        name: 'Z push-up',
        primary: MuscleGroup.chest,
        secondary: <MuscleGroup>[MuscleGroup.core],
      );
      List<String> order(Set<MuscleGroup> focus) => idsOf(
        ExerciseQuery.alternativesFor(
          target: target,
          all: <Exercise>[target, plain, focused],
          ownedEquipment: <EquipmentItem>{EquipmentItem.bodyweight},
          maxDifficulty: ExerciseDifficulty.beginner,
          focusMuscles: focus,
        ),
      );

      expect(order(const <MuscleGroup>{}).first, 'plain');
      expect(order(<MuscleGroup>{MuscleGroup.core}).first, 'focused');
    });

    test('raises bodyweight work for a calisthenics goal', () {
      final Exercise weighted = buildExercise(
        id: 'weighted',
        name: 'A dumbbell press',
        primary: MuscleGroup.chest,
        equipment: <EquipmentItem>[EquipmentItem.dumbbells],
      );
      final Exercise calisthenics = buildExercise(
        id: 'calisthenics',
        name: 'Z push-up',
        primary: MuscleGroup.chest,
      );
      List<String> order(Set<TrainingGoal> goals) => idsOf(
        ExerciseQuery.alternativesFor(
          target: target,
          all: <Exercise>[target, weighted, calisthenics],
          ownedEquipment: <EquipmentItem>{EquipmentItem.dumbbells},
          maxDifficulty: ExerciseDifficulty.beginner,
          goals: goals,
        ),
      );

      expect(order(const <TrainingGoal>{}).first, 'weighted');
      expect(
        order(<TrainingGoal>{TrainingGoal.calisthenics}).first,
        'calisthenics',
      );
    });

    test('breaks ties by difficulty, then by name', () {
      final Exercise hard = buildExercise(
        id: 'hard',
        name: 'A hard push-up',
        primary: MuscleGroup.chest,
        difficulty: ExerciseDifficulty.advanced,
      );
      final Exercise easy = buildExercise(
        id: 'easy',
        name: 'Z easy push-up',
        primary: MuscleGroup.chest,
      );
      final List<String> ordered = idsOf(
        ExerciseQuery.alternativesFor(
          target: target,
          all: <Exercise>[target, hard, easy],
          ownedEquipment: <EquipmentItem>{EquipmentItem.bodyweight},
          maxDifficulty: ExerciseDifficulty.beginner,
        ),
      );
      // The beginner movement also earns the within-level bonus.
      expect(ordered, <String>['easy', 'hard']);
    });
  });

  group('profile integration', () {
    test('focus comes from saved priorities, including core', () {
      final UserProfile profile = buildTestProfile().copyWith(
        priorities: <MusclePriority>{MusclePriority.core, MusclePriority.back},
      );
      expect(ExerciseQuery.focusFromProfile(profile), <MuscleGroup>{
        MuscleGroup.core,
        MuscleGroup.back,
      });
    });

    test('a beginner profile is steered towards beginner alternatives', () {
      final UserProfile beginner = buildTestProfile();
      final List<ExerciseAlternative> alternatives =
          ExerciseQuery.alternativesFor(
            target: catalogExercise('pull-up'),
            all: exerciseCatalog,
            ownedEquipment: <EquipmentItem>{
              EquipmentItem.bodyweight,
              EquipmentItem.pullUpBar,
            },
            maxDifficulty: ExerciseDifficulty.fromExperience(
              beginner.experience,
            ),
            focusMuscles: ExerciseQuery.focusFromProfile(beginner),
            goals: beginner.goals,
          );
      expect(alternatives, isNotEmpty);
      expect(
        alternatives.first.exercise.difficulty,
        ExerciseDifficulty.beginner,
        reason: 'the best beginner suggestion should come first',
      );
      expect(
        idsOf(alternatives),
        isNot(contains('pull-up')),
        reason: 'never suggest the exercise itself',
      );
    });

    test('real alternatives always share a muscle with the target', () {
      for (final Exercise exercise in exerciseCatalog) {
        final List<ExerciseAlternative> alternatives =
            ExerciseQuery.alternativesFor(
              target: exercise,
              all: exerciseCatalog,
              ownedEquipment: <EquipmentItem>{EquipmentItem.bodyweight},
              maxDifficulty: ExerciseDifficulty.beginner,
            );
        expect(alternatives.length, lessThanOrEqualTo(4), reason: exercise.id);
        for (final ExerciseAlternative entry in alternatives) {
          expect(
            entry.exercise.allMuscles.toSet().intersection(
              exercise.allMuscles.toSet(),
            ),
            isNotEmpty,
            reason: '${entry.exercise.id} suggested for ${exercise.id}',
          );
        }
      }
    });
  });
}
