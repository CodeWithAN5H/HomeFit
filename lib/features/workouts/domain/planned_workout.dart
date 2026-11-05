import '../../exercises/domain/exercise.dart';
import 'workout_mode.dart';

/// One exercise resolved and personalised for the user who is about to train.
class PlannedExercise {
  const PlannedExercise({
    required this.exercise,
    required this.sets,
    required this.restSeconds,
    this.targetReps,
    this.targetSeconds,
    this.note,
    this.progressionReason,
  }) : assert(
         (targetReps == null) != (targetSeconds == null),
         'A planned exercise is either rep-based or time-based',
       );

  final Exercise exercise;
  final int sets;
  final int? targetReps;
  final int? targetSeconds;
  final int restSeconds;
  final String? note;

  /// Why this target differs from the template's starting point, if it does.
  final String? progressionReason;

  bool get isTimed => targetSeconds != null;

  String get targetLabel =>
      isTimed ? '${targetSeconds}s' : '${targetReps ?? 0} reps';

  PlannedExercise copyWith({
    int? sets,
    int? targetReps,
    int? targetSeconds,
    String? progressionReason,
  }) {
    return PlannedExercise(
      exercise: exercise,
      sets: sets ?? this.sets,
      restSeconds: restSeconds,
      targetReps: targetSeconds != null
          ? null
          : (targetReps ?? this.targetReps),
      targetSeconds: targetSeconds ?? this.targetSeconds,
      note: note,
      progressionReason: progressionReason ?? this.progressionReason,
    );
  }
}

/// A template resolved against the profile: the exact exercises, sets, reps and
/// rest the runner will use.
class PlannedWorkout {
  const PlannedWorkout({
    required this.templateId,
    required this.name,
    required this.description,
    required this.mode,
    required this.difficulty,
    required this.focus,
    required this.exercises,
    required this.restSeconds,
    required this.safetyNotes,
    this.guidance = const <String>[],
    this.reason,
  });

  final String templateId;
  final String name;
  final String description;
  final WorkoutMode mode;
  final ExerciseDifficulty difficulty;
  final Set<MuscleGroup> focus;
  final List<PlannedExercise> exercises;
  final int restSeconds;
  final List<String> safetyNotes;
  final List<String> guidance;

  /// Why this session was suggested, shown on the preview when it came from the
  /// dashboard recommendation.
  final String? reason;

  bool get isEmpty => exercises.isEmpty;

  int get totalSets =>
      exercises.fold(0, (int total, PlannedExercise item) => total + item.sets);

  /// Kept in step with [WorkoutTemplate.estimatedMinutes] so a personalised plan
  /// is not quoted a different duration from the template card.
  int get estimatedMinutes {
    int seconds = 0;
    for (final PlannedExercise item in exercises) {
      final int work = item.targetSeconds ?? 40;
      seconds += (work + item.restSeconds) * item.sets;
      seconds += 20;
    }
    final int minutes = (seconds / 60).ceil();
    if (minutes < 5) return 5;
    if (minutes > 120) return 120;
    return minutes;
  }

  /// How many exercises the catalogue could not supply for this profile.
  ///
  /// The planner drops slots it cannot fill with performable equipment rather
  /// than prescribing something impossible; this lets the preview say so.
  bool get isShortened => exercises.length < 3;
}
