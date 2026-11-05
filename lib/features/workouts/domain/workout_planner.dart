import '../../exercises/data/exercise_repository.dart';
import '../../exercises/domain/exercise.dart';
import '../../profile/domain/user_profile.dart';
import '../data/workout_templates.dart';
import 'planned_workout.dart';
import 'progression.dart';
import 'workout_mode.dart';
import 'workout_template.dart';

/// Turns a curated template into the exact session a profile can perform.
///
/// The planner is pure: it reads the bundled catalogue and the saved profile,
/// never the database or the UI. That is what makes equipment handling,
/// level filtering and progression testable without a device.
class WorkoutPlanner {
  const WorkoutPlanner(this._exercises);

  final ExerciseRepository _exercises;

  /// Ids where the target is a hold rather than a rep count.
  static const Set<String> _holdExerciseIds = <String>{
    'plank',
    'side-plank',
    'wall-sit',
    'hollow-hold',
    'wall-handstand-hold',
  };

  /// Default targets for a generated targeted session.
  static const int targetedSets = 3;
  static const int targetedReps = 8;
  static const int targetedHoldSeconds = 20;
  static const int targetedExerciseCount = 4;

  List<WorkoutTemplate> get templates => kWorkoutTemplates;

  List<WorkoutTemplate> templatesFor(WorkoutMode mode) =>
      templatesForMode(mode);

  WorkoutTemplate? templateById(String? id) => id == null ? null : _byId(id);

  WorkoutTemplate? _byId(String id) {
    for (final WorkoutTemplate template in kWorkoutTemplates) {
      if (template.id == id) return template;
    }
    return null;
  }

  /// Resolves [template] for [profile].
  ///
  /// [targetRepOverrides] is the manual adjustment made on the preview, keyed by
  /// exercise id; it always wins over progressive adjustments. [progression] is
  /// keyed by exercise id and only moves a target by the rep count the engine
  /// decided.
  PlannedWorkout plan({
    required WorkoutTemplate template,
    required UserProfile profile,
    Map<String, int> targetRepOverrides = const <String, int>{},
    Map<String, ProgressionDecision> progression =
        const <String, ProgressionDecision>{},
    String? reason,
  }) {
    final ExerciseDifficulty ceiling = ExerciseDifficulty.fromExperience(
      profile.experience,
    );
    final List<PlannedExercise> planned = <PlannedExercise>[];

    for (final TemplateExercise slot in template.exercises) {
      final Exercise? exercise = _resolve(slot, profile, ceiling);
      if (exercise == null) continue;

      final int rest = slot.restSeconds ?? template.restSeconds;
      if (slot.isTimed) {
        planned.add(
          PlannedExercise(
            exercise: exercise,
            sets: slot.sets,
            targetSeconds: slot.seconds,
            restSeconds: rest,
            note: slot.note,
          ),
        );
        continue;
      }

      final int base = slot.repsMin ?? 5;
      final int? override = targetRepOverrides[exercise.id];
      final ProgressionDecision? decision = progression[exercise.id];
      final int target = override ?? decision?.targetReps ?? base;
      final String? note = override != null
          ? 'Adjusted for this session.'
          : (decision != null && decision.targetReps != base)
          ? decision.reason
          : slot.note;

      planned.add(
        PlannedExercise(
          exercise: exercise,
          sets: slot.sets,
          targetReps: target,
          restSeconds: rest,
          note: note,
          progressionReason: decision != null && decision.targetReps != base
              ? decision.reason
              : null,
        ),
      );
    }

    return PlannedWorkout(
      templateId: template.id,
      name: template.name,
      description: template.description,
      mode: template.mode,
      difficulty: _hardest(planned, template.difficulty),
      focus: template.focus,
      exercises: planned,
      restSeconds: template.restSeconds,
      safetyNotes: template.safetyNotes,
      guidance: template.guidance,
      reason: reason,
    );
  }

  /// A deterministic session for one muscle group.
  ///
  /// Selection is by difficulty then name — never random — and only movements
  /// the profile can perform at its experience level are included. Fewer than
  /// four matches is acceptable; an empty result is surfaced by the UI.
  PlannedWorkout targeted({
    required MuscleGroup muscle,
    required UserProfile profile,
    Map<String, int> targetRepOverrides = const <String, int>{},
    Map<String, ProgressionDecision> progression =
        const <String, ProgressionDecision>{},
  }) {
    final ExerciseDifficulty ceiling = ExerciseDifficulty.fromExperience(
      profile.experience,
    );
    final List<Exercise> candidates =
        _exercises
            .all()
            .where(
              (Exercise exercise) =>
                  exercise.primaryMuscle == muscle &&
                  exercise.difficulty.rank <= ceiling.rank &&
                  exercise.canPerformWith(profile.equipment),
            )
            .toList()
          ..sort((Exercise a, Exercise b) {
            final int byDifficulty = a.difficulty.rank.compareTo(
              b.difficulty.rank,
            );
            if (byDifficulty != 0) return byDifficulty;
            return a.name.compareTo(b.name);
          });

    final List<PlannedExercise> planned = <PlannedExercise>[];
    for (final Exercise exercise in candidates.take(targetedExerciseCount)) {
      final bool isHold = _holdExerciseIds.contains(exercise.id);
      final ProgressionDecision? decision = isHold
          ? null
          : progression[exercise.id];
      const int base = targetedReps;
      final int target =
          targetRepOverrides[exercise.id] ?? decision?.targetReps ?? base;

      planned.add(
        PlannedExercise(
          exercise: exercise,
          sets: targetedSets,
          targetReps: isHold ? null : target,
          targetSeconds: isHold ? targetedHoldSeconds : null,
          restSeconds: 60,
          progressionReason: decision != null && decision.targetReps != base
              ? decision.reason
              : null,
        ),
      );
    }

    return PlannedWorkout(
      templateId: 'targeted-${muscle.name}',
      name: '${muscle.label} focus',
      description:
          'A focused session for ${muscle.label.toLowerCase()}. Keep it '
          'alongside balanced full-body training, not instead of it.',
      mode: WorkoutMode.targeted,
      difficulty: _hardest(planned, ExerciseDifficulty.beginner),
      focus: <MuscleGroup>{muscle},
      exercises: planned,
      restSeconds: 60,
      safetyNotes: <String>[
        'Stop if the movement causes sharp or unusual pain.',
        'Do not train the same area hard on consecutive days.',
      ],
      guidance: <String>['Leave one or two reps in reserve on every set.'],
      reason: 'You chose ${muscle.label.toLowerCase()}.',
    );
  }

  Exercise? _resolve(
    TemplateExercise slot,
    UserProfile profile,
    ExerciseDifficulty ceiling,
  ) {
    for (final String id in slot.exerciseIds) {
      final Exercise? exercise = _exercises.byId(id);
      if (exercise == null) continue;
      if (exercise.difficulty.rank > ceiling.rank) continue;
      if (!exercise.canPerformWith(profile.equipment)) continue;
      return exercise;
    }
    return null;
  }

  ExerciseDifficulty _hardest(
    List<PlannedExercise> planned,
    ExerciseDifficulty fallback,
  ) {
    ExerciseDifficulty hardest = planned.isEmpty
        ? fallback
        : planned.first.exercise.difficulty;
    for (final PlannedExercise item in planned) {
      if (item.exercise.difficulty.rank > hardest.rank) {
        hardest = item.exercise.difficulty;
      }
    }
    return hardest;
  }
}
