import '../../exercises/domain/exercise.dart';
import '../domain/workout_mode.dart';
import '../domain/workout_template.dart';

/// The curated, bundled training programme.
///
/// Every slot lists ids in preference order. The planner picks the first one the
/// profile can perform with its own equipment and experience level, so a user
/// with nothing but a floor and a user with a band and dumbbells both get a
/// complete session from the same template.
///
/// Volumes are conservative on purpose: two to four sets, eight to twelve reps,
/// nothing to failure, and no movement above the profile's level. Templates are
/// const data so the plan is identical every time it is requested.
const List<WorkoutTemplate> kWorkoutTemplates = <WorkoutTemplate>[
  WorkoutTemplate(
    id: 'full-body-a',
    name: 'Full body A',
    description:
        'The starting session: squat, push, pull and core with bodyweight '
        'movements. Three non-consecutive days a week is plenty.',
    mode: WorkoutMode.normal,
    difficulty: ExerciseDifficulty.beginner,
    focus: <MuscleGroup>{
      MuscleGroup.legs,
      MuscleGroup.chest,
      MuscleGroup.back,
      MuscleGroup.core,
    },
    restSeconds: 60,
    safetyNotes: <String>[
      'Stop the set if you feel sharp or unusual pain, and do not train '
          'through joint pain.',
      'Keep two reps in reserve: the last rep should still look controlled.',
      'Rest at least one full day between full-body strength sessions.',
    ],
    guidance: <String>[
      'Warm up for three to five minutes before the first set.',
      'Breathe out as you push or stand up; never hold your breath.',
    ],
    exercises: <TemplateExercise>[
      TemplateExercise(
        exerciseIds: <String>['bodyweight-squat'],
        sets: 3,
        repsMin: 8,
        repsMax: 12,
      ),
      TemplateExercise(
        exerciseIds: <String>['push-up', 'knee-push-up'],
        sets: 3,
        repsMin: 5,
        repsMax: 10,
        note: 'Knee push-ups if full reps lose form.',
      ),
      TemplateExercise(
        exerciseIds: <String>['band-row', 'superman'],
        sets: 3,
        repsMin: 8,
        repsMax: 12,
      ),
      TemplateExercise(
        exerciseIds: <String>['glute-bridge'],
        sets: 3,
        repsMin: 10,
        repsMax: 15,
      ),
      TemplateExercise(
        exerciseIds: <String>['dead-bug'],
        sets: 3,
        repsMin: 6,
        repsMax: 10,
        note: 'Each side counts as one rep.',
      ),
      TemplateExercise(
        exerciseIds: <String>['plank'],
        sets: 2,
        seconds: 30,
        restSeconds: 45,
      ),
    ],
  ),
  WorkoutTemplate(
    id: 'full-body-b',
    name: 'Full body B',
    description:
        'The second rotation: lunges, a different push variation and calf work. '
        'Same rules, different emphasis.',
    mode: WorkoutMode.normal,
    difficulty: ExerciseDifficulty.beginner,
    focus: <MuscleGroup>{
      MuscleGroup.legs,
      MuscleGroup.chest,
      MuscleGroup.back,
      MuscleGroup.core,
    },
    restSeconds: 60,
    safetyNotes: <String>[
      'Use a wall or chair for balance on lunges if you need it.',
      'Stop if a knee or shoulder hurts rather than working through it.',
      'Leave at least one full day between strength sessions.',
    ],
    guidance: <String>[
      'Move slowly on the lowering phase; that is where most of the work is.',
      'If a set turns into momentum, end it there.',
    ],
    exercises: <TemplateExercise>[
      TemplateExercise(
        exerciseIds: <String>['reverse-lunge'],
        sets: 3,
        repsMin: 6,
        repsMax: 10,
        note: 'Each side; alternate legs.',
      ),
      TemplateExercise(
        exerciseIds: <String>['knee-push-up', 'push-up'],
        sets: 3,
        repsMin: 6,
        repsMax: 12,
      ),
      TemplateExercise(
        exerciseIds: <String>['band-row', 'superman'],
        sets: 3,
        repsMin: 8,
        repsMax: 12,
      ),
      TemplateExercise(
        exerciseIds: <String>['chair-sit-to-stand', 'bodyweight-squat'],
        sets: 3,
        repsMin: 8,
        repsMax: 12,
      ),
      TemplateExercise(
        exerciseIds: <String>['dead-bug'],
        sets: 3,
        repsMin: 8,
        repsMax: 10,
        note: 'Each side counts as one rep.',
      ),
      TemplateExercise(
        exerciseIds: <String>['calf-raise'],
        sets: 3,
        repsMin: 12,
        repsMax: 15,
      ),
    ],
  ),
  WorkoutTemplate(
    id: 'full-body-c',
    name: 'Full body C',
    description:
        'The band rotation: press, pull and squat patterns with a resistance '
        'band, with bodyweight fallbacks for every slot.',
    mode: WorkoutMode.normal,
    difficulty: ExerciseDifficulty.beginner,
    focus: <MuscleGroup>{
      MuscleGroup.legs,
      MuscleGroup.chest,
      MuscleGroup.back,
      MuscleGroup.core,
    },
    restSeconds: 75,
    safetyNotes: <String>[
      'Check the band and its anchor for wear before every set.',
      'Never let a band snap back towards your face.',
      'Stop if you feel sharp pain in a joint, and rest a full day between '
          'sessions.',
    ],
    guidance: <String>[
      'Choose a band tension that lets you finish every rep with control.',
      'Keep your ribs down instead of arching your lower back.',
    ],
    exercises: <TemplateExercise>[
      TemplateExercise(
        exerciseIds: <String>['band-squat-to-press', 'bodyweight-squat'],
        sets: 3,
        repsMin: 8,
        repsMax: 10,
      ),
      TemplateExercise(
        exerciseIds: <String>['band-chest-press', 'push-up', 'knee-push-up'],
        sets: 3,
        repsMin: 8,
        repsMax: 12,
      ),
      TemplateExercise(
        exerciseIds: <String>['band-pull-apart', 'superman'],
        sets: 3,
        repsMin: 10,
        repsMax: 15,
      ),
      TemplateExercise(
        exerciseIds: <String>['band-glute-kickback', 'glute-bridge'],
        sets: 3,
        repsMin: 8,
        repsMax: 12,
        note: 'Each side.',
      ),
      TemplateExercise(
        exerciseIds: <String>['band-pallof-press', 'dead-bug'],
        sets: 3,
        repsMin: 6,
        repsMax: 10,
        note: 'Each side counts as one rep.',
      ),
    ],
  ),
  WorkoutTemplate(
    id: 'quick-full-body',
    name: 'Quick full-body circuit',
    description:
        'Ten minutes, one round of the basics. For a busy day, not a '
        'replacement for the full sessions.',
    mode: WorkoutMode.quick,
    difficulty: ExerciseDifficulty.beginner,
    focus: <MuscleGroup>{
      MuscleGroup.fullBody,
      MuscleGroup.legs,
      MuscleGroup.chest,
      MuscleGroup.core,
    },
    restSeconds: 20,
    safetyNotes: <String>[
      'Keep the pace controlled; this is not a race.',
      'Stop if anything hurts, and do not add sets to make up for a missed '
          'session.',
    ],
    guidance: <String>[
      'Move straight through the circuit, resting only as '
          'prescribed.',
    ],
    exercises: <TemplateExercise>[
      TemplateExercise(
        exerciseIds: <String>['jumping-jack'],
        sets: 2,
        repsMin: 15,
        repsMax: 20,
      ),
      TemplateExercise(
        exerciseIds: <String>['bodyweight-squat'],
        sets: 2,
        repsMin: 10,
        repsMax: 12,
      ),
      TemplateExercise(
        exerciseIds: <String>['knee-push-up', 'push-up'],
        sets: 2,
        repsMin: 5,
        repsMax: 8,
      ),
      TemplateExercise(
        exerciseIds: <String>['dead-bug'],
        sets: 2,
        repsMin: 6,
        repsMax: 8,
      ),
      TemplateExercise(exerciseIds: <String>['plank'], sets: 2, seconds: 20),
    ],
  ),
  WorkoutTemplate(
    id: 'recovery-reset',
    name: 'Recovery reset',
    description:
        'Gentle movement for a rest day: easy bridges, core control, calves and '
        'a short walk-style circuit.',
    mode: WorkoutMode.recovery,
    difficulty: ExerciseDifficulty.beginner,
    focus: <MuscleGroup>{MuscleGroup.fullBody, MuscleGroup.legs},
    restSeconds: 20,
    safetyNotes: <String>[
      'This should feel easy. If it does not, stop and rest instead.',
      'Never stretch into pain, and skip anything that feels unstable.',
    ],
    guidance: <String>[
      'Breathe slowly and keep every repetition small and controlled.',
    ],
    exercises: <TemplateExercise>[
      TemplateExercise(
        exerciseIds: <String>['glute-bridge'],
        sets: 2,
        repsMin: 8,
        repsMax: 10,
      ),
      TemplateExercise(
        exerciseIds: <String>['dead-bug'],
        sets: 2,
        repsMin: 4,
        repsMax: 6,
      ),
      TemplateExercise(
        exerciseIds: <String>['calf-raise'],
        sets: 2,
        repsMin: 10,
        repsMax: 12,
      ),
      TemplateExercise(exerciseIds: <String>['plank'], sets: 2, seconds: 20),
    ],
  ),
  WorkoutTemplate(
    id: 'skill-push-progress',
    name: 'Push-up skill practice',
    description:
        'Low-volume practice towards a stronger push-up: clean reps, a hold and '
        'core control.',
    mode: WorkoutMode.skill,
    difficulty: ExerciseDifficulty.beginner,
    focus: <MuscleGroup>{MuscleGroup.chest, MuscleGroup.core},
    restSeconds: 60,
    safetyNotes: <String>[
      'Practise quality, not quantity. Stop while every rep still looks the '
          'same.',
      'Wrist or shoulder pain means stopping, not pushing through.',
    ],
    guidance: <String>[
      'Film or mirror a set occasionally to check your hips stay in line.',
    ],
    exercises: <TemplateExercise>[
      TemplateExercise(
        exerciseIds: <String>['knee-push-up', 'push-up'],
        sets: 3,
        repsMin: 4,
        repsMax: 6,
      ),
      TemplateExercise(
        exerciseIds: <String>['incline-push-up', 'knee-push-up'],
        sets: 3,
        repsMin: 4,
        repsMax: 6,
      ),
      TemplateExercise(exerciseIds: <String>['plank'], sets: 3, seconds: 20),
      TemplateExercise(
        exerciseIds: <String>['dead-bug'],
        sets: 2,
        repsMin: 6,
        repsMax: 8,
      ),
    ],
  ),
  WorkoutTemplate(
    id: 'skill-pull-prep',
    name: 'Pull-up preparation',
    description:
        'Beginner pulling practice: band rows, pull-aparts and back control that '
        'build towards a first pull-up.',
    mode: WorkoutMode.skill,
    difficulty: ExerciseDifficulty.beginner,
    focus: <MuscleGroup>{MuscleGroup.back, MuscleGroup.shoulders},
    restSeconds: 60,
    safetyNotes: <String>[
      'Do not hang from a bar you have not checked is secure.',
      'Stop if your shoulders or elbows hurt.',
    ],
    guidance: <String>[
      'Start each pull by setting your shoulder blades down and back.',
    ],
    exercises: <TemplateExercise>[
      TemplateExercise(
        exerciseIds: <String>['band-row', 'superman'],
        sets: 3,
        repsMin: 8,
        repsMax: 10,
      ),
      TemplateExercise(
        exerciseIds: <String>['band-pull-apart', 'superman'],
        sets: 3,
        repsMin: 10,
        repsMax: 12,
      ),
      TemplateExercise(
        exerciseIds: <String>['superman'],
        sets: 3,
        repsMin: 8,
        repsMax: 10,
      ),
      TemplateExercise(exerciseIds: <String>['plank'], sets: 2, seconds: 25),
    ],
  ),
];

/// Templates grouped by mode, in the order they appear in the programme.
List<WorkoutTemplate> templatesForMode(WorkoutMode mode) => kWorkoutTemplates
    .where((WorkoutTemplate template) => template.mode == mode)
    .toList(growable: false);

WorkoutTemplate? templateById(String? id) {
  for (final WorkoutTemplate template in kWorkoutTemplates) {
    if (template.id == id) return template;
  }
  return null;
}
