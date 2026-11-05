import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/application/profile_providers.dart';
import '../../profile/domain/profile_options.dart';
import '../../profile/domain/user_profile.dart';
import '../data/exercise_catalog.dart';
import '../data/exercise_repository.dart';
import '../domain/exercise.dart';
import '../domain/exercise_query.dart';

/// The bundled, offline library.
final exerciseRepositoryProvider = Provider<ExerciseRepository>(
  (ref) => BundledExerciseRepository(),
);

/// Current search text and filters for the library screen.
final exerciseFilterProvider =
    NotifierProvider<ExerciseFilterController, ExerciseFilter>(
      ExerciseFilterController.new,
    );

class ExerciseFilterController extends Notifier<ExerciseFilter> {
  @override
  ExerciseFilter build() => const ExerciseFilter();

  void setSearch(String value) => state = state.copyWith(search: value);

  void setMuscle(MuscleGroup? muscle) => state = state.copyWith(muscle: muscle);

  /// Selects [muscle], or clears it when it is already selected.
  void toggleMuscle(MuscleGroup muscle) =>
      setMuscle(state.muscle == muscle ? null : muscle);

  void setEquipment(EquipmentItem? equipment) =>
      state = state.copyWith(equipment: equipment);

  void setDifficulty(ExerciseDifficulty? difficulty) =>
      state = state.copyWith(difficulty: difficulty);

  void toggleOnlyMyEquipment() =>
      state = state.copyWith(onlyMyEquipment: !state.onlyMyEquipment);

  /// Clears filters but keeps the typed search, for the chip row.
  void clearFilters() => state = state.copyWith(
    muscle: null,
    equipment: null,
    difficulty: null,
    onlyMyEquipment: false,
  );

  /// Returns the library to its default, unfiltered state.
  void clearAll() => state = const ExerciseFilter();
}

/// Exercises matching the current filter, sorted by name.
///
/// The saved profile is only consulted for the "my equipment only" switch, so
/// browsing does not reshuffle as the user edits their profile.
final exerciseListProvider = Provider<List<Exercise>>((ref) {
  final ExerciseFilter filter = ref.watch(exerciseFilterProvider);
  final UserProfile? profile = ref.watch(profileControllerProvider);
  return ExerciseQuery.apply(
    ref.watch(exerciseRepositoryProvider).all(),
    filter,
    profile: profile,
  );
});

/// One exercise for the detail screen, or null when the id is unknown.
final exerciseByIdProvider = Provider.family<Exercise?, String>((ref, id) {
  return ref.watch(exerciseRepositoryProvider).byId(id);
});

/// Altogether [exerciseCatalog] size, for empty-state copy and diagnostics.
final exerciseCountProvider = Provider<int>(
  (ref) => ref.watch(exerciseRepositoryProvider).all().length,
);

/// Ranked alternatives for one exercise, using the saved profile when present.
///
/// Without a profile the library still works: nothing is owned, so movements
/// needing equipment are returned marked as unavailable rather than hidden.
final exerciseAlternativesProvider =
    Provider.family<List<ExerciseAlternative>, String>((ref, id) {
      final Exercise? exercise = ref.watch(exerciseByIdProvider(id));
      if (exercise == null) return const <ExerciseAlternative>[];

      final UserProfile? profile = ref.watch(profileControllerProvider);
      return ExerciseQuery.alternativesFor(
        target: exercise,
        all: ref.watch(exerciseRepositoryProvider).all(),
        ownedEquipment: profile?.equipment ?? const <EquipmentItem>{},
        maxDifficulty: profile == null
            ? ExerciseDifficulty.advanced
            : ExerciseDifficulty.fromExperience(profile.experience),
        focusMuscles: profile == null
            ? const <MuscleGroup>{}
            : ExerciseQuery.focusFromProfile(profile),
        goals: profile?.goals ?? const <TrainingGoal>{},
      );
    });
