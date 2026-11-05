import '../../../profile/domain/profile_options.dart';
import '../../domain/exercise.dart';

/// Core and trunk work, mostly anti-extension and rotation control.
const List<Exercise> coreExercises = <Exercise>[
  Exercise(
    id: 'plank',
    name: 'Plank',
    primaryMuscle: MuscleGroup.core,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.shoulders],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Set up on your forearms and toes with your elbows under your shoulders.',
      'Lift your hips until your body forms a straight line from head to heels.',
      'Hold for the target time while breathing steadily, then lower your knees.',
    ],
    formCues: <String>[
      'Squeeze your glutes and brace your abs so your lower back does not sag.',
      'Keep your shoulders away from your ears and your neck long.',
      'End the hold when your hips drop, not when the timer ends.',
    ],
  ),
  Exercise(
    id: 'side-plank',
    name: 'Side plank',
    primaryMuscle: MuscleGroup.core,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.shoulders],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.intermediate,
    steps: <String>[
      'Lie on one side with your elbow under your shoulder and your legs stacked.',
      'Lift your hips until your body is straight from head to feet, balancing on your forearm and the side of your foot.',
      'Hold, then lower with control and repeat on the other side.',
    ],
    formCues: <String>[
      'Keep your top hip from rolling back; stack your shoulders and hips.',
      'Bend your knees and rest them on the floor if the full version is too hard.',
      'Stop when your hips sag rather than pushing through the timer.',
    ],
  ),
  Exercise(
    id: 'dead-bug',
    name: 'Dead bug',
    primaryMuscle: MuscleGroup.core,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.legs],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Lie on your back with your arms pointing at the ceiling and your knees bent over your hips.',
      'Slowly lower one arm overhead and the opposite leg towards the floor, keeping your lower back flat.',
      'Return to the start, then repeat with the other arm and leg.',
    ],
    formCues: <String>[
      'Keep your lower back pressed into the floor throughout; shorten the range if it lifts.',
      'Move slowly and keep breathing rather than rushing the reps.',
      'Exhale as your arm and leg lower.',
    ],
  ),
  Exercise(
    id: 'bicycle-crunch',
    name: 'Bicycle crunch',
    primaryMuscle: MuscleGroup.core,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.legs],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.intermediate,
    steps: <String>[
      'Lie on your back with your hands lightly behind your head and both knees bent over your hips.',
      'Rotate your torso to bring one shoulder towards the opposite knee while extending the other leg.',
      'Switch sides in a slow pedalling rhythm, keeping your lower back close to the floor.',
    ],
    formCues: <String>[
      'Do not pull on your neck; your hands only support the weight of your head.',
      'Rotate from your ribs, not by swinging your elbows.',
      'Slow down if your lower back starts to arch.',
    ],
  ),
  Exercise(
    id: 'mountain-climber',
    name: 'Mountain climber',
    primaryMuscle: MuscleGroup.core,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.legs, MuscleGroup.shoulders],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.intermediate,
    steps: <String>[
      'Start in a high plank with your hands under your shoulders and your body straight.',
      'Drive one knee towards your chest, then return it as the other knee comes forward.',
      'Continue alternating at a steady pace while keeping your hips low.',
    ],
    formCues: <String>[
      'Keep your hips from bouncing up and down; think of sliding your knee forward.',
      'Keep your shoulders over your hands rather than shifting back.',
      'Slow the pace before your form breaks.',
    ],
  ),
  Exercise(
    id: 'hollow-hold',
    name: 'Hollow hold',
    primaryMuscle: MuscleGroup.core,
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.advanced,
    steps: <String>[
      'Lie on your back and press your lower back firmly into the floor.',
      'Lift your shoulders and legs a few centimetres off the floor, arms reaching past your ears.',
      'Hold for the target time, then lower everything with control.',
    ],
    formCues: <String>[
      'Keep your lower back flat; bend your knees or raise your legs if it lifts.',
      'Keep your neck relaxed and your chin slightly tucked.',
      'Build up in short holds rather than chasing long ones with poor position.',
    ],
  ),
  Exercise(
    id: 'band-pallof-press',
    name: 'Band Pallof press',
    primaryMuscle: MuscleGroup.core,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.shoulders],
    equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Anchor the band at chest height and stand side-on to it, holding the band at your chest with both hands.',
      'Press your hands straight out in front of your chest while resisting the pull towards the anchor.',
      'Bring your hands back to your chest slowly, then repeat on the other side.',
    ],
    formCues: <String>[
      'Keep your hips and shoulders square to the front; do not twist towards the band.',
      'Stand far enough away that the band is already tight at your chest.',
      'Keep your ribs down so your lower back does not arch.',
    ],
  ),
];
