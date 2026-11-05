import '../../profile/domain/profile_options.dart';

/// Primary muscle groups used to classify and browse exercises.
///
/// Deliberately separate from [MusclePriority]: priorities are what the user
/// wants to emphasise, this is how an exercise is described. A separate enum
/// also lets the library include full-body work without adding a profile option.
enum MuscleGroup {
  chest('Chest'),
  back('Back'),
  shoulders('Shoulders'),
  arms('Arms'),
  legs('Legs'),
  core('Core'),
  fullBody('Full body');

  const MuscleGroup(this.label);

  final String label;
}

/// How demanding an exercise is to perform with good form.
///
/// [rank] is only used for ordering and for comparing against the profile's
/// experience level; it is never shown to the user as a number.
enum ExerciseDifficulty {
  beginner('Beginner', 0),
  intermediate('Intermediate', 1),
  advanced('Advanced', 2);

  const ExerciseDifficulty(this.label, this.rank);

  final String label;
  final int rank;

  /// The hardest difficulty someone at [level] should meet in a suggestion.
  static ExerciseDifficulty fromExperience(ExperienceLevel level) {
    return switch (level) {
      ExperienceLevel.beginner ||
      ExperienceLevel.returning => ExerciseDifficulty.beginner,
      ExperienceLevel.intermediate => ExerciseDifficulty.intermediate,
    };
  }
}

/// One movement in the offline library.
///
/// Instances are immutable and bundled with the app; nothing here depends on
/// the network, the database or Flutter, so the catalogue can be queried and
/// tested as plain Dart.
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscle,
    required this.equipment,
    required this.difficulty,
    required this.steps,
    required this.formCues,
    this.secondaryMuscles = const <MuscleGroup>[],
  });

  /// Stable slug used in routes and in future training plans. Never reuse it
  /// for a different movement.
  final String id;
  final String name;
  final MuscleGroup primaryMuscle;
  final List<MuscleGroup> secondaryMuscles;

  /// What the movement needs. A bodyweight exercise lists
  /// [EquipmentItem.bodyweight] and nothing else.
  final List<EquipmentItem> equipment;
  final ExerciseDifficulty difficulty;

  /// Ordered instructions, one action per step.
  final List<String> steps;

  /// Form and safety guidance for this specific movement.
  final List<String> formCues;

  /// True when the movement needs nothing but the floor.
  bool get isBodyweight =>
      equipment.length == 1 && equipment.first == EquipmentItem.bodyweight;

  /// Whether [owned] covers everything this movement needs.
  ///
  /// Bodyweight work is always possible. Note that the profile stores
  /// [EquipmentItem.bodyweight] to mean "no equipment", so that value must not
  /// be treated as a requirement on other exercises.
  bool canPerformWith(Set<EquipmentItem> owned) {
    if (isBodyweight) return true;
    return equipment.every(owned.contains);
  }

  /// Human-readable requirement, e.g. "Dumbbells, Sturdy chair / table".
  String get equipmentLabel => isBodyweight
      ? 'No equipment'
      : equipment.map((item) => item.label).join(', ');

  /// Equipment the user would need to acquire, in display order.
  List<EquipmentItem> missingFor(Set<EquipmentItem> owned) {
    if (isBodyweight) return const <EquipmentItem>[];
    return equipment.where((item) => !owned.contains(item)).toList();
  }

  /// Whether this movement trains [group] primarily or secondarily.
  bool targets(MuscleGroup group) =>
      primaryMuscle == group || secondaryMuscles.contains(group);

  /// Every muscle this movement involves, primary first.
  List<MuscleGroup> get allMuscles => <MuscleGroup>[
    primaryMuscle,
    ...secondaryMuscles.where((muscle) => muscle != primaryMuscle),
  ];
}
