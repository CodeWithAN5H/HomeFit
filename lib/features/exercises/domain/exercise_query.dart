import '../../profile/domain/profile_options.dart';
import '../../profile/domain/user_profile.dart';
import 'exercise.dart';

/// What the library screen is currently showing.
class ExerciseFilter {
  const ExerciseFilter({
    this.search = '',
    this.muscle,
    this.equipment,
    this.difficulty,
    this.onlyMyEquipment = false,
  });

  final String search;
  final MuscleGroup? muscle;
  final EquipmentItem? equipment;
  final ExerciseDifficulty? difficulty;

  /// Restrict to movements the saved profile can actually perform.
  final bool onlyMyEquipment;

  bool get hasAnyFilter =>
      search.trim().isNotEmpty ||
      muscle != null ||
      equipment != null ||
      difficulty != null ||
      onlyMyEquipment;

  /// Only the controls that narrow the list, used for the "clear" affordance.
  bool get hasChipFilter =>
      muscle != null ||
      equipment != null ||
      difficulty != null ||
      onlyMyEquipment;

  static const Object _unchanged = Object();

  /// Copies the filter. Passing null to a nullable field clears it; the
  /// sentinel default is what distinguishes "leave alone" from "clear".
  ExerciseFilter copyWith({
    String? search,
    Object? muscle = _unchanged,
    Object? equipment = _unchanged,
    Object? difficulty = _unchanged,
    bool? onlyMyEquipment,
  }) {
    return ExerciseFilter(
      search: search ?? this.search,
      muscle: identical(muscle, _unchanged)
          ? this.muscle
          : muscle as MuscleGroup?,
      equipment: identical(equipment, _unchanged)
          ? this.equipment
          : equipment as EquipmentItem?,
      difficulty: identical(difficulty, _unchanged)
          ? this.difficulty
          : difficulty as ExerciseDifficulty?,
      onlyMyEquipment: onlyMyEquipment ?? this.onlyMyEquipment,
    );
  }
}

/// Why a suggested movement is offered.
class ExerciseAlternative {
  const ExerciseAlternative({
    required this.exercise,
    required this.equipmentReady,
  });

  final Exercise exercise;

  /// True when the saved profile already has everything it needs.
  final bool equipmentReady;
}

/// Pure query engine for the bundled library.
///
/// Kept free of Flutter and Riverpod so every rule here is unit tested directly.
abstract final class ExerciseQuery {
  /// Applies search and filters, returning matches sorted by name.
  ///
  /// Name order is intentional: a library that reorders itself around the
  /// profile is hard to scan and impossible to discuss. Profile-aware
  /// ordering belongs to suggestions, which [alternativesFor] handles.
  static List<Exercise> apply(
    List<Exercise> exercises,
    ExerciseFilter filter, {
    UserProfile? profile,
  }) {
    final String needle = filter.search.trim().toLowerCase();
    final List<Exercise> matches = exercises.where((exercise) {
      if (needle.isNotEmpty && !exercise.name.toLowerCase().contains(needle)) {
        return false;
      }
      if (filter.muscle != null && !exercise.targets(filter.muscle!)) {
        return false;
      }
      if (filter.equipment != null &&
          !exercise.equipment.contains(filter.equipment)) {
        return false;
      }
      if (filter.difficulty != null &&
          exercise.difficulty != filter.difficulty) {
        return false;
      }
      if (filter.onlyMyEquipment &&
          profile != null &&
          !exercise.canPerformWith(profile.equipment)) {
        return false;
      }
      return true;
    }).toList();

    matches.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return matches;
  }

  /// Suggests movements for [target], best first.
  ///
  /// Candidates must share at least one muscle with [target], so a suggestion
  /// is always a substitute for the same area. Equipment the profile owns, a
  /// difficulty within the profile's level and the user's focus areas all raise
  /// the score; movements that need missing equipment are still returned (the
  /// UI marks them) but rank below equipment-ready ones.
  static List<ExerciseAlternative> alternativesFor({
    required Exercise target,
    required List<Exercise> all,
    required Set<EquipmentItem> ownedEquipment,
    required ExerciseDifficulty maxDifficulty,
    Set<MuscleGroup> focusMuscles = const <MuscleGroup>{},
    Set<TrainingGoal> goals = const <TrainingGoal>{},
    int limit = 4,
  }) {
    final Set<MuscleGroup> targetMuscles = target.allMuscles.toSet();
    final List<_ScoredAlternative> scored = <_ScoredAlternative>[];

    for (final Exercise candidate in all) {
      if (candidate.id == target.id) continue;
      if (candidate.allMuscles.toSet().intersection(targetMuscles).isEmpty) {
        continue;
      }

      final bool equipmentReady = candidate.canPerformWith(ownedEquipment);
      int score = candidate.primaryMuscle == target.primaryMuscle ? 6 : 1;
      if (candidate.secondaryMuscles.contains(target.primaryMuscle)) score += 2;
      if (equipmentReady) score += 4;
      if (candidate.difficulty.rank <= maxDifficulty.rank) score += 2;
      if (focusMuscles.any(candidate.targets)) score += 1;
      if (goals.contains(TrainingGoal.calisthenics) && candidate.isBodyweight) {
        score += 1;
      }

      scored.add(
        _ScoredAlternative(
          alternative: ExerciseAlternative(
            exercise: candidate,
            equipmentReady: equipmentReady,
          ),
          score: score,
        ),
      );
    }

    scored.sort((a, b) {
      final int byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      final int byDifficulty = a.alternative.exercise.difficulty.rank.compareTo(
        b.alternative.exercise.difficulty.rank,
      );
      if (byDifficulty != 0) return byDifficulty;
      return a.alternative.exercise.name.compareTo(b.alternative.exercise.name);
    });

    return scored
        .take(limit)
        .map((entry) => entry.alternative)
        .toList(growable: false);
  }

  /// Profile priorities expressed as library muscle groups.
  static Set<MuscleGroup> focusFromProfile(UserProfile profile) {
    return profile.priorities
        .map((priority) => MuscleGroup.values.byName(priority.name))
        .toSet();
  }
}

class _ScoredAlternative {
  const _ScoredAlternative({required this.alternative, required this.score});

  final ExerciseAlternative alternative;
  final int score;
}
