import '../../../profile/domain/profile_options.dart';
import '../../domain/exercise.dart';

/// Chest movements, bodyweight and home equipment.
const List<Exercise> chestExercises = <Exercise>[
  Exercise(
    id: 'push-up',
    name: 'Push-up',
    primaryMuscle: MuscleGroup.chest,
    secondaryMuscles: <MuscleGroup>[
      MuscleGroup.arms,
      MuscleGroup.shoulders,
      MuscleGroup.core,
    ],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Start in a high plank with your hands slightly wider than your shoulders and your body in one straight line.',
      'Bend your elbows to lower your chest towards the floor, keeping them tucked at roughly 45 degrees from your ribs.',
      'Stop when your chest is about a fist away from the floor, then press back up without letting your hips sag.',
    ],
    formCues: <String>[
      'Keep your neck long: look at the floor slightly ahead of your hands, not at your toes.',
      'If your hips drop or your lower back arches, switch to knee push-ups rather than forcing more reps.',
      'End the set when you can no longer hold the straight line, not when you reach a number.',
    ],
  ),
  Exercise(
    id: 'knee-push-up',
    name: 'Knee push-up',
    primaryMuscle: MuscleGroup.chest,
    secondaryMuscles: <MuscleGroup>[
      MuscleGroup.arms,
      MuscleGroup.shoulders,
      MuscleGroup.core,
    ],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Kneel and place your hands slightly wider than your shoulders, then walk your hips forward until your body is straight from knees to head.',
      'Lower your chest between your hands with your elbows tucked, keeping your hips in line with your shoulders.',
      'Press back up until your arms are straight, then repeat without resting on the floor.',
    ],
    formCues: <String>[
      'Do not hinge at the hips: your bottom should not push back as you lower.',
      'A cushion under the knees is fine; this is a strength builder, not a test of pain tolerance.',
      'When 12 controlled reps feel easy, move to full push-ups.',
    ],
  ),
  Exercise(
    id: 'incline-push-up',
    name: 'Incline push-up',
    primaryMuscle: MuscleGroup.chest,
    secondaryMuscles: <MuscleGroup>[
      MuscleGroup.arms,
      MuscleGroup.shoulders,
      MuscleGroup.core,
    ],
    equipment: <EquipmentItem>[EquipmentItem.sturdyChair],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Place both hands on the seat of a sturdy chair that cannot slide, and step your feet back until your body is straight.',
      'Lower your chest towards the chair edge with your elbows tucked, keeping your body in one line.',
      'Press away until your arms are straight, then repeat.',
    ],
    formCues: <String>[
      'Push the chair against a wall before you start, and check it does not move.',
      'The higher the hands, the easier the rep; lower the surface as you get stronger.',
      'Keep your ribs down so your lower back does not sag.',
    ],
  ),
  Exercise(
    id: 'decline-push-up',
    name: 'Decline push-up',
    primaryMuscle: MuscleGroup.chest,
    secondaryMuscles: <MuscleGroup>[
      MuscleGroup.shoulders,
      MuscleGroup.arms,
      MuscleGroup.core,
    ],
    equipment: <EquipmentItem>[EquipmentItem.sturdyChair],
    difficulty: ExerciseDifficulty.intermediate,
    steps: <String>[
      'Place your feet on the seat of a sturdy chair and your hands on the floor, slightly wider than your shoulders.',
      'Lower your chest towards the floor with your elbows tucked and your body straight.',
      'Press back up until your arms are straight, keeping your hips in line.',
    ],
    formCues: <String>[
      'Only use this once standard push-ups are controlled for 10 or more reps.',
      'Keep your hips from sagging; the added height makes that harder, so fewer reps is normal.',
      'Step down if the front of your shoulder feels pinched.',
    ],
  ),
  Exercise(
    id: 'band-chest-press',
    name: 'Band chest press',
    primaryMuscle: MuscleGroup.chest,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.arms, MuscleGroup.shoulders],
    equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Anchor the band behind you at chest height, or loop it around a sturdy post at the same height.',
      'Hold the handles at chest level with your elbows bent and your feet planted.',
      'Press both hands forward until your arms are straight, then return slowly to the start.',
    ],
    formCues: <String>[
      'Check the anchor and the band for wear before every set.',
      'Keep your wrists straight and your ribs down rather than leaning into the press.',
      'Control the return; do not let the band snap your arms back.',
    ],
  ),
  Exercise(
    id: 'dumbbell-floor-press',
    name: 'Dumbbell floor press',
    primaryMuscle: MuscleGroup.chest,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.arms, MuscleGroup.shoulders],
    equipment: <EquipmentItem>[EquipmentItem.dumbbells],
    difficulty: ExerciseDifficulty.intermediate,
    steps: <String>[
      'Lie on your back with your knees bent and a dumbbell in each hand, held at chest level with your elbows on the floor.',
      'Press both dumbbells up over your chest until your arms are straight.',
      'Lower them slowly until your upper arms rest on the floor, then press again.',
    ],
    formCues: <String>[
      'The floor limits your range, which protects the shoulders; do not force extra depth.',
      'Keep your ribs down and avoid arching your lower back to press more weight.',
      'Choose a weight you can lower for two to three seconds under control.',
    ],
  ),
];
