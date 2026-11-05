import '../../../profile/domain/profile_options.dart';
import '../../domain/exercise.dart';

/// Back movements, from band rows to a pull-up bar.
const List<Exercise> backExercises = <Exercise>[
  Exercise(
    id: 'band-row',
    name: 'Band row',
    primaryMuscle: MuscleGroup.back,
    secondaryMuscles: <MuscleGroup>[
      MuscleGroup.arms,
      MuscleGroup.shoulders,
      MuscleGroup.core,
    ],
    equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Anchor the band at waist height, or sit with it looped around your feet.',
      'Hold both handles with straight arms and sit or stand tall.',
      'Pull your elbows back past your ribs and squeeze your shoulder blades together, then return slowly.',
    ],
    formCues: <String>[
      'Keep your torso still; leaning back adds range without working the back harder.',
      'Keep your elbows close to your body rather than flaring them out.',
      'Squeeze for a moment at the end of each rep instead of rushing.',
    ],
  ),
  Exercise(
    id: 'dumbbell-row',
    name: 'Dumbbell row',
    primaryMuscle: MuscleGroup.back,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.arms, MuscleGroup.core],
    equipment: <EquipmentItem>[EquipmentItem.dumbbells],
    difficulty: ExerciseDifficulty.intermediate,
    steps: <String>[
      'Place one hand on a sturdy chair and hinge forward until your back is flat, holding a dumbbell in the other hand.',
      'Pull the dumbbell towards your hip, keeping your elbow close to your side.',
      'Lower it with control until your arm is straight, then repeat and switch sides.',
    ],
    formCues: <String>[
      'Do not twist your torso to lift the weight; keep your hips square.',
      'Pull with your back, not by curling the dumbbell with your hand.',
      'Keep your neck neutral and your back flat throughout.',
    ],
  ),
  Exercise(
    id: 'inverted-row',
    name: 'Inverted row',
    primaryMuscle: MuscleGroup.back,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.arms, MuscleGroup.core],
    equipment: <EquipmentItem>[EquipmentItem.sturdyChair],
    difficulty: ExerciseDifficulty.intermediate,
    steps: <String>[
      'Lie on your back under a sturdy table and grip the edge with both hands, slightly wider than your shoulders.',
      'Hang with your body straight and your heels on the floor.',
      'Pull your chest towards the table edge, squeeze your shoulder blades, then lower slowly.',
    ],
    formCues: <String>[
      'Check the table cannot tip or slide before you start; a heavy, fixed table only.',
      'Keep your hips up so your body stays in a straight line.',
      'Bend your knees to make the rep easier if you cannot keep your hips up.',
    ],
  ),
  Exercise(
    id: 'pull-up',
    name: 'Pull-up',
    primaryMuscle: MuscleGroup.back,
    secondaryMuscles: <MuscleGroup>[
      MuscleGroup.arms,
      MuscleGroup.core,
      MuscleGroup.shoulders,
    ],
    equipment: <EquipmentItem>[EquipmentItem.pullUpBar],
    difficulty: ExerciseDifficulty.advanced,
    steps: <String>[
      'Hang from the bar with an overhand grip slightly wider than your shoulders.',
      'Pull until your chin clears the bar, driving your elbows down towards your ribs.',
      'Lower yourself with control until your arms are straight, then repeat.',
    ],
    formCues: <String>[
      'No swinging or kicking: if you need momentum, the set is over.',
      'If you cannot do one yet, use negatives: jump or step up, then lower as slowly as you can.',
      'Stop if the front of your shoulder or your elbow hurts.',
    ],
  ),
  Exercise(
    id: 'superman',
    name: 'Superman',
    primaryMuscle: MuscleGroup.back,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.core, MuscleGroup.shoulders],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Lie face down with your arms extended in front of you and your legs straight.',
      'Lift your chest, arms and legs a few centimetres off the floor.',
      'Hold for two seconds, then lower everything with control.',
    ],
    formCues: <String>[
      'A small lift is enough; this is not a back-bending contest.',
      'Keep your neck neutral by looking at the floor rather than lifting your chin.',
      'Lower slowly instead of dropping, and stop if your lower back feels strained.',
    ],
  ),
  Exercise(
    id: 'band-pull-apart',
    name: 'Band pull-apart',
    primaryMuscle: MuscleGroup.back,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.shoulders, MuscleGroup.arms],
    equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Hold the band in front of your chest with both hands and straight arms.',
      'Pull your hands apart until the band touches your chest, keeping your arms at shoulder height.',
      'Return to the start slowly, keeping tension the whole way.',
    ],
    formCues: <String>[
      'Keep your shoulders down; do not shrug towards your ears.',
      'Use a lighter band rather than shortening the range.',
      'Keep your ribs down so your lower back does not arch.',
    ],
  ),
];
