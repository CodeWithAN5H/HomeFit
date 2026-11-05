import '../../../profile/domain/profile_options.dart';
import '../../domain/exercise.dart';

/// Arm movements for bands, dumbbells and bodyweight.
const List<Exercise> armExercises = <Exercise>[
  Exercise(
    id: 'band-biceps-curl',
    name: 'Band biceps curl',
    primaryMuscle: MuscleGroup.arms,
    equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Stand on the middle of the band and hold both handles with your palms facing forward.',
      'Keep your elbows close to your ribs and curl your hands towards your shoulders.',
      'Lower your hands slowly until your arms are straight again.',
    ],
    formCues: <String>[
      'Keep your elbows pinned to your sides; swinging them forward turns this into a shoulder movement.',
      'Do not lean back to finish the rep.',
      'Control the lowering phase; the band should never pull your arms down.',
    ],
  ),
  Exercise(
    id: 'dumbbell-biceps-curl',
    name: 'Dumbbell biceps curl',
    primaryMuscle: MuscleGroup.arms,
    equipment: <EquipmentItem>[EquipmentItem.dumbbells],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Stand tall with a dumbbell in each hand, arms hanging at your sides and palms forward.',
      'Curl both dumbbells towards your shoulders without moving your upper arms.',
      'Lower them slowly until your arms are straight.',
    ],
    formCues: <String>[
      'Keep your torso upright and your ribs down.',
      'Stop the curl before your elbows drift forward.',
      'Lower for two to three seconds rather than letting the weights drop.',
    ],
  ),
  Exercise(
    id: 'hammer-curl',
    name: 'Hammer curl',
    primaryMuscle: MuscleGroup.arms,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.back],
    equipment: <EquipmentItem>[EquipmentItem.dumbbells],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Stand with a dumbbell in each hand, palms facing your body.',
      'Curl the dumbbells towards your shoulders while keeping your palms facing in.',
      'Lower them slowly to the start position.',
    ],
    formCues: <String>[
      'Keep your wrists straight and your knuckles facing forward.',
      'Do not turn the movement into a row by pulling your elbows back.',
      'Choose a weight that lets you keep both arms moving evenly.',
    ],
  ),
  Exercise(
    id: 'diamond-push-up',
    name: 'Diamond push-up',
    primaryMuscle: MuscleGroup.arms,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.chest, MuscleGroup.core],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.intermediate,
    steps: <String>[
      'Set up in a push-up position with your hands close together under your chest, thumbs and index fingers touching.',
      'Lower your chest towards your hands with your elbows close to your ribs.',
      'Press back up until your arms are straight, keeping your body in one line.',
    ],
    formCues: <String>[
      'If your wrists complain, widen your hands slightly or do the movement on your knees.',
      'Keep your elbows brushing your ribs rather than flaring them out.',
      'Stop the set when your hips start to sag.',
    ],
  ),
  Exercise(
    id: 'chair-triceps-dip',
    name: 'Chair triceps dip',
    primaryMuscle: MuscleGroup.arms,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.chest, MuscleGroup.shoulders],
    equipment: <EquipmentItem>[EquipmentItem.sturdyChair],
    difficulty: ExerciseDifficulty.intermediate,
    steps: <String>[
      'Sit on the edge of a sturdy chair, grip the edge beside your hips, then slide your hips forward off the seat.',
      'Bend your elbows to lower your hips towards the floor, keeping them close to your body.',
      'Press back up until your arms are straight, then repeat.',
    ],
    formCues: <String>[
      'Push the chair against a wall and keep your hips close to it.',
      'Do not let your shoulders shrug up towards your ears at the bottom.',
      'Bend your knees with your feet flat to make the rep easier.',
    ],
  ),
  Exercise(
    id: 'band-triceps-extension',
    name: 'Band triceps extension',
    primaryMuscle: MuscleGroup.arms,
    equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Anchor the band above your head, or stand on it and bring the handles behind your head.',
      'Hold the band behind your head with your elbows pointing up beside your ears.',
      'Straighten your arms overhead, then bend them slowly back to the start.',
    ],
    formCues: <String>[
      'Keep your elbows still and pointing forward, not flaring out to the sides.',
      'Keep your ribs down so your lower back does not arch as you press.',
      'Check the anchor or your footing before every set.',
    ],
  ),
];
