import '../../exercises/domain/exercise.dart';
import 'workout_mode.dart';

/// One exercise slot inside a template.
///
/// A slot lists exercise ids in order of preference, so the same template works
/// for a user with no equipment and for one with a band: the planner picks the
/// first id the profile can actually perform. Every id is still validated
/// against the bundled catalogue by tests.
class TemplateExercise {
  const TemplateExercise({
    required this.exerciseIds,
    required this.sets,
    this.repsMin,
    this.repsMax,
    this.seconds,
    this.restSeconds,
    this.note,
  }) : assert(
         (repsMin == null) != (seconds == null),
         'A slot is either rep-based or time-based, never both',
       );

  final List<String> exerciseIds;
  final int sets;

  /// Prescribed reps. [repsMax] is the ceiling the plan starts below; the
  /// planner starts at [repsMin] and progression moves one rep at a time.
  final int? repsMin;
  final int? repsMax;

  /// Prescribed hold, for movements where time is the target.
  final int? seconds;

  /// Overrides the template's default rest for this slot.
  final int? restSeconds;

  /// Short cue shown in the runner, e.g. "each side".
  final String? note;

  bool get isTimed => seconds != null;

  String targetLabel(int targetReps, int? targetSeconds) {
    if (isTimed) return '${targetSeconds ?? seconds}s';
    return '$targetReps reps';
  }
}

/// A curated, deterministic routine.
///
/// Templates are data, not algorithms: nothing here is randomly generated, so
/// the plan a user sees today can be reasoned about and tested.
class WorkoutTemplate {
  const WorkoutTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.mode,
    required this.difficulty,
    required this.focus,
    required this.exercises,
    required this.restSeconds,
    required this.safetyNotes,
    this.guidance = const <String>[],
  });

  final String id;
  final String name;
  final String description;
  final WorkoutMode mode;

  /// The hardest experience level this routine is intended for. The planner
  /// additionally filters each slot by the user's own level.
  final ExerciseDifficulty difficulty;
  final Set<MuscleGroup> focus;
  final List<TemplateExercise> exercises;
  final int restSeconds;

  /// Non-negotiable safety line shown on the preview and in the runner.
  final List<String> safetyNotes;

  /// Optional coaching reminders ("stop two reps short of failure").
  final List<String> guidance;

  int get totalSets => exercises.fold(
    0,
    (int total, TemplateExercise slot) => total + slot.sets,
  );

  /// Deterministic estimate, used on cards and for profile-aware scheduling.
  ///
  /// One rep-based set is costed at 40 seconds of work, a timed set at its
  /// hold, plus the slot's rest and 20 seconds to change exercise. It is an
  /// estimate for planning, never a promise.
  int get estimatedMinutes {
    int seconds = 0;
    for (final TemplateExercise slot in exercises) {
      final int work = slot.seconds ?? 40;
      final int rest = slot.restSeconds ?? restSeconds;
      seconds += (work + rest) * slot.sets;
      seconds += 20;
    }
    final int minutes = (seconds / 60).ceil();
    if (minutes < 5) return 5;
    if (minutes > 120) return 120;
    return minutes;
  }

  /// Every catalogue id this template can reference, for integrity checks.
  Iterable<String> get allExerciseIds =>
      exercises.expand((TemplateExercise slot) => slot.exerciseIds);
}
