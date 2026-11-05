import '../../../profile/domain/profile_options.dart';
import '../../domain/exercise.dart';

/// Whole-body movements that train several areas at once.
const List<Exercise> fullBodyExercises = <Exercise>[
  Exercise(
    id: 'jumping-jack',
    name: 'Jumping jack',
    primaryMuscle: MuscleGroup.fullBody,
    secondaryMuscles: <MuscleGroup>[
      MuscleGroup.shoulders,
      MuscleGroup.legs,
      MuscleGroup.core,
    ],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Stand tall with your feet together and your arms at your sides.',
      'Jump your feet out wider than your shoulders while sweeping your arms overhead.',
      'Jump back to the start and repeat at a steady rhythm.',
    ],
    formCues: <String>[
      'Land softly with your knees slightly bent.',
      'Step out and in instead of jumping if your joints or neighbours prefer it.',
      'Keep breathing; this is a warm-up pace, not a sprint.',
    ],
  ),
  Exercise(
    id: 'inchworm',
    name: 'Inchworm',
    primaryMuscle: MuscleGroup.fullBody,
    secondaryMuscles: <MuscleGroup>[
      MuscleGroup.core,
      MuscleGroup.shoulders,
      MuscleGroup.legs,
    ],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Stand tall, then hinge forward and place your hands on the floor, bending your knees as needed.',
      'Walk your hands forward until you are in a high plank.',
      'Walk your hands back towards your feet and stand up tall again.',
    ],
    formCues: <String>[
      'Bend your knees rather than straining your lower back to reach the floor.',
      'Keep your hips level while walking your hands out.',
      'Move slowly and breathe out as you fold forward.',
    ],
  ),
  Exercise(
    id: 'bear-crawl',
    name: 'Bear crawl',
    primaryMuscle: MuscleGroup.fullBody,
    secondaryMuscles: <MuscleGroup>[
      MuscleGroup.core,
      MuscleGroup.shoulders,
      MuscleGroup.legs,
    ],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.intermediate,
    steps: <String>[
      'Start on your hands and knees, then lift your knees a few centimetres off the floor.',
      'Move your opposite hand and foot forward together, keeping your knees low.',
      'Continue for the target distance or time, then rest.',
    ],
    formCues: <String>[
      'Keep your hips low and your back flat; do not let them rock side to side.',
      'Take small steps rather than reaching far forward.',
      'Keep your shoulders over your hands.',
    ],
  ),
  Exercise(
    id: 'burpee',
    name: 'Burpee',
    primaryMuscle: MuscleGroup.fullBody,
    secondaryMuscles: <MuscleGroup>[
      MuscleGroup.chest,
      MuscleGroup.legs,
      MuscleGroup.core,
    ],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.advanced,
    steps: <String>[
      'From standing, squat down and place your hands on the floor.',
      'Step or jump your feet back into a plank, then step or jump them back towards your hands.',
      'Stand up and finish with a small jump, then repeat.',
    ],
    formCues: <String>[
      'Step back and forward instead of jumping if you are new to the movement.',
      'Keep your core braced in the plank so your lower back does not sag.',
      'Land softly and keep the pace sustainable rather than maximal.',
    ],
  ),
  Exercise(
    id: 'band-squat-to-press',
    name: 'Band squat to press',
    primaryMuscle: MuscleGroup.fullBody,
    secondaryMuscles: <MuscleGroup>[
      MuscleGroup.legs,
      MuscleGroup.shoulders,
      MuscleGroup.core,
    ],
    equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    difficulty: ExerciseDifficulty.intermediate,
    steps: <String>[
      'Stand on the middle of the band and hold the handles at shoulder height.',
      'Squat down, keeping your chest up and your knees over your toes.',
      'Stand up and press the handles overhead in one smooth movement, then lower them as you squat again.',
    ],
    formCues: <String>[
      'Check the band is secure under both feet before each set.',
      'Keep your ribs down as you press so your lower back does not arch.',
      'Lower the handles before starting the next squat, rather than holding them overhead.',
    ],
  ),
];
