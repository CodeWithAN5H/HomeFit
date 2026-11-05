import '../../../profile/domain/profile_options.dart';
import '../../domain/exercise.dart';

/// Shoulder movements, mostly band and dumbbell work.
const List<Exercise> shoulderExercises = <Exercise>[
  Exercise(
    id: 'pike-push-up',
    name: 'Pike push-up',
    primaryMuscle: MuscleGroup.shoulders,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.arms, MuscleGroup.core],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.intermediate,
    steps: <String>[
      'Start in a push-up position, then walk your feet towards your hands and lift your hips into an inverted V.',
      'Bend your elbows to lower the top of your head towards the floor just in front of your hands.',
      'Press back up until your arms are straight, keeping your hips high.',
    ],
    formCues: <String>[
      'Keep your head between your hands rather than letting it travel forward.',
      'Your hips stay high; this is a shoulder press, not a push-up.',
      'Stop if the front of your shoulder pinches.',
    ],
  ),
  Exercise(
    id: 'band-overhead-press',
    name: 'Band overhead press',
    primaryMuscle: MuscleGroup.shoulders,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.arms, MuscleGroup.core],
    equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Stand on the middle of the band, or anchor it low, and hold the handles at shoulder height.',
      'Press both hands overhead until your arms are straight.',
      'Lower back to shoulder height with control, keeping tension in the band.',
    ],
    formCues: <String>[
      'Brace your abs so your lower back does not arch as you press.',
      'Keep your wrists stacked over your elbows rather than bending back.',
      'Check the band is secure under your feet before each set.',
    ],
  ),
  Exercise(
    id: 'dumbbell-lateral-raise',
    name: 'Dumbbell lateral raise',
    primaryMuscle: MuscleGroup.shoulders,
    equipment: <EquipmentItem>[EquipmentItem.dumbbells],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Stand tall with a dumbbell in each hand at your sides, elbows slightly bent.',
      'Raise your arms out to the sides until your hands reach shoulder height.',
      'Lower them slowly back to your sides.',
    ],
    formCues: <String>[
      'Lead with your elbows rather than your hands.',
      'Stop at shoulder height; going higher shifts the work to your neck.',
      'Use light weight; swinging means the weight is too heavy.',
    ],
  ),
  Exercise(
    id: 'dumbbell-shoulder-press',
    name: 'Dumbbell shoulder press',
    primaryMuscle: MuscleGroup.shoulders,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.arms, MuscleGroup.core],
    equipment: <EquipmentItem>[EquipmentItem.dumbbells],
    difficulty: ExerciseDifficulty.intermediate,
    steps: <String>[
      'Sit or stand with a dumbbell in each hand at shoulder height, palms facing forward.',
      'Press both dumbbells overhead until your arms are straight.',
      'Lower them back to shoulder height with control.',
    ],
    formCues: <String>[
      'Keep your ribs down and your back neutral; do not lean back to finish a rep.',
      'Do not lock your knees if you are standing.',
      'Lower slowly rather than dropping the weights.',
    ],
  ),
  Exercise(
    id: 'band-face-pull',
    name: 'Band face pull',
    primaryMuscle: MuscleGroup.shoulders,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.back, MuscleGroup.arms],
    equipment: <EquipmentItem>[EquipmentItem.resistanceBand],
    difficulty: ExerciseDifficulty.beginner,
    steps: <String>[
      'Anchor the band at face height and hold it with both hands, arms straight.',
      'Pull the band towards your face, keeping your elbows high and wide.',
      'Return slowly until your arms are straight again.',
    ],
    formCues: <String>[
      'Finish with your shoulder blades squeezed and your hands beside your ears.',
      'Keep your neck relaxed; do not push your head forward.',
      'Light tension is enough; this is control work, not a max effort.',
    ],
  ),
  Exercise(
    id: 'wall-handstand-hold',
    name: 'Wall handstand hold',
    primaryMuscle: MuscleGroup.shoulders,
    secondaryMuscles: <MuscleGroup>[MuscleGroup.core, MuscleGroup.arms],
    equipment: <EquipmentItem>[EquipmentItem.bodyweight],
    difficulty: ExerciseDifficulty.advanced,
    steps: <String>[
      'Face a wall and place your hands shoulder-width apart about 15 centimetres from it.',
      'Walk your feet up the wall until your body is close to vertical, then hold.',
      'Come down one foot at a time, under control.',
    ],
    formCues: <String>[
      'Only attempt this with confident shoulder strength and a clear space around you.',
      'Squeeze your glutes and keep your ribs down so your back does not arch.',
      'End the hold before your form breaks; never hold to failure.',
    ],
  ),
];
