import '../../../profile/domain/profile_options.dart';
import '../../domain/exercise.dart';

/// Leg movements: squats, hinges, lunges and calf work.
const List<Exercise> legExercises = <Exercise>[
  Exercise(
    id: 'bodyweight-squat',
    name: 'Bodyweight squat',
    primaryMuscle: MuscleGroup.legs,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.core],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Stand with your feet about shoulder-width apart and your toes pointing slightly out.',
      'Push your hips back and bend your knees, lowering until your thighs are roughly parallel to the floor.',
      'Drive through your whole foot to stand back up, finishing tall.',
    ],
    formCues: <String>[
      'Keep your knees tracking over your toes rather than collapsing inward.',
      'Keep your heels down; if they lift, widen your stance or sit back less far.',
      'Only go as deep as you can while keeping your back neutral.',
    ],
  ),
  Exercise(
    id: 'chair-sit-to-stand',
    name: 'Chair sit-to-stand',
    primaryMuscle: MuscleGroup.legs,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.core],
    equipment: <EquipmentItem>[EquipmentItem.sturdyChair],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Sit towards the front of a sturdy chair with your feet flat and your shins roughly vertical.',
      'Lean forward slightly and stand up without using your hands.',
      'Lower yourself back to the seat with control and repeat.',
    ],
    formCues: <String>[
      'Push the chair against a wall so it cannot slide.',
      'Lower slowly; do not drop onto the seat.',
      'Use the armrests only if you cannot stand without them, and aim to need them less over time.',
    ],
  ),
  Exercise(
    id: 'reverse-lunge',
    name: 'Reverse lunge',
    primaryMuscle: MuscleGroup.legs,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.core],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Stand tall with your feet hip-width apart.',
      'Step one foot back and lower your knee towards the floor until both knees are bent about 90 degrees.',
      'Push through your front foot to return to standing, then repeat on the other side.',
    ],
    formCues: <String>[
      'Keep your front knee over your ankle rather than letting it drift inward.',
      'Stay tall; do not lean your torso forward to reach the floor.',
      'Hold a wall or chair for balance if you need to.',
    ],
  ),
  Exercise(
    id: 'bulgarian-split-squat',
    name: 'Bulgarian split squat',
    primaryMuscle: MuscleGroup.legs,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.core],
    equipment: <EquipmentItem>[EquipmentItem.sturdyChair],
    difficulty: ExerciseDifficulty.advanced,
    steps: <String>[
      'Stand about a step in front of a sturdy chair and place the top of one foot on the seat behind you.',
      'Lower your back knee towards the floor, keeping most of your weight over the front foot.',
      'Press through your front foot to stand back up, then repeat and switch sides.',
    ],
    formCues: <String>[
      'Use a chair against a wall and start with a low step if balance is uncertain.',
      'Keep your hips square and your front knee tracking over your toes.',
      'Stop when balance fails; quality reps on each side beat extra reps on one.',
    ],
  ),
  Exercise(
    id: 'glute-bridge',
    name: 'Glute bridge',
    primaryMuscle: MuscleGroup.legs,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.core],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Lie on your back with your knees bent and your feet flat, about a hand-width from your hips.',
      'Press through your heels and lift your hips until your body forms a straight line from knees to shoulders.',
      'Lower your hips slowly until they are just above the floor, then repeat.',
    ],
    formCues: <String>[
      'Squeeze your glutes at the top rather than arching your lower back.',
      'Keep your ribs down and your chin relaxed.',
      'If you feel this in your hamstrings, bring your feet slightly closer to your hips.',
    ],
  ),
  Exercise(
    id: 'band-glute-kickback',
    name: 'Band glute kickback',
    primaryMuscle: MuscleGroup.legs,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.core],
    equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Loop the band around both ankles, or anchor it low and around one ankle.',
      'Stand tall holding a wall or chair for balance with a slight bend in your knees.',
      'Kick one leg back and up, squeezing your glute, then return slowly and switch sides.',
    ],
    formCues: <String>[
      'Keep your torso still; do not arch your lower back to gain height.',
      'Keep the working knee pointing at the floor rather than turning out.',
      'Move slowly enough that the band stays under tension.',
    ],
  ),
  Exercise(
    id: 'wall-sit',
    name: 'Wall sit',
    primaryMuscle: MuscleGroup.legs,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.core],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Stand with your back against a wall and walk your feet about half a metre forward.',
      'Slide down until your knees are bent about 90 degrees, with your back flat on the wall.',
      'Hold for the target time, then slide back up and shake your legs out.',
    ],
    formCues: <String>[
      'Keep your knees over your ankles; move your feet further forward if they pass your toes.',
      'Keep breathing steadily instead of holding your breath.',
      'Come up early if your knees or lower back complain.',
    ],
  ),
  Exercise(
    id: 'calf-raise',
    name: 'Calf raise',
    primaryMuscle: MuscleGroup.legs,
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Stand tall with your feet hip-width apart, holding a wall or chair for balance.',
      'Rise onto the balls of your feet as high as you can.',
      'Lower your heels slowly until they touch the floor, then repeat.',
    ],
    formCues: <String>[
      'Keep your weight over your big toe rather than rolling to the outside of the foot.',
      'Pause at the top for a second instead of bouncing.',
      'Stand on a step only if you have something solid to hold.',
    ],
  ),
];
