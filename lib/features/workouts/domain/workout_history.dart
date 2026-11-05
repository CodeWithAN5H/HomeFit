import '../../profile/domain/profile_options.dart';
import 'progression.dart';

/// What the last completed session says about one exercise.
///
/// Built by the repository from stored sets, so progression never has to query
/// the database itself. The fields mirror [ProgressionInput] on purpose, with
/// the sleep pattern supplied by the caller because it comes from the profile.
class ExerciseHistory {
  const ExerciseHistory({
    required this.exerciseId,
    required this.targetReps,
    required this.prescribedSets,
    required this.completedReps,
    required this.effort,
    this.comfortableStreak = 0,
  });

  final String exerciseId;
  final int targetReps;
  final int prescribedSets;
  final List<int?> completedReps;
  final int? effort;

  /// Consecutive earlier sessions where every set hit the target comfortably.
  final int comfortableStreak;

  ProgressionInput toInput({SleepPattern? sleepPattern}) => ProgressionInput(
    exerciseId: exerciseId,
    prescribedSets: prescribedSets,
    targetReps: targetReps,
    completedReps: completedReps,
    effort: effort,
    sleepPattern: sleepPattern,
    comfortableStreak: comfortableStreak,
  );

  static bool isComfortable({
    required List<int?> completedReps,
    required int targetReps,
    required int prescribedSets,
    required int? effort,
  }) {
    if (effort == null || effort > 2) return false;
    final List<int> reps = completedReps.whereType<int>().toList();
    if (reps.length < prescribedSets) return false;
    return reps.every((int value) => value >= targetReps);
  }
}
