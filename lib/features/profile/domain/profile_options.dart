/// Profile options used across onboarding, the profile and (later) the
/// training engine.
///
/// Stored values are the enum `name`s, so re-ordering or relabelling an option
/// never corrupts stored data. Labels are user-facing copy only.
library;

enum ExperienceLevel {
  beginner('Beginner', 'New to training, or starting again'),
  returning('Returning', 'Trained before and rebuilding the habit'),
  intermediate('Intermediate', 'Training consistently for six months or more');

  const ExperienceLevel(this.label, this.description);

  final String label;
  final String description;
}

enum TrainingGoal {
  buildMuscle('Build muscle'),
  healthyWeightGain('Gain weight healthily'),
  strength('Get stronger'),
  calisthenics('Calisthenics skills'),
  consistency('Stay consistent');

  const TrainingGoal(this.label);

  final String label;
}

enum MusclePriority {
  arms('Arms'),
  chest('Chest'),
  core('Core / abs'),
  back('Back'),
  legs('Legs'),
  shoulders('Shoulders');

  const MusclePriority(this.label);

  final String label;
}

enum EquipmentItem {
  bodyweight('No equipment'),
  dumbbells('Dumbbells'),
  resistanceBand('Resistance band'),
  pullUpBar('Pull-up bar'),
  sturdyChair('Sturdy chair / table');

  const EquipmentItem(this.label);

  final String label;
}

enum DietPattern {
  vegetarianNoEggs('Vegetarian, no eggs');

  const DietPattern(this.label);

  final String label;
}

enum DietRestriction {
  lactoseIntolerant('Lactose intolerance'),
  nutAllergy('Nut allergy'),
  glutenSensitive('Gluten sensitivity');

  const DietRestriction(this.label);

  final String label;
}

enum TrainingTimeOfDay {
  morning('Morning'),
  afternoon('Afternoon'),
  evening('Evening'),
  night('Late night');

  const TrainingTimeOfDay(this.label);

  final String label;
}

enum SleepPattern {
  regular('Fairly regular', 'About the same bedtime most nights'),
  irregular('Irregular', 'Bedtime moves around a lot'),
  severelyInsufficient('Often very short', 'Frequently under 6 hours');

  const SleepPattern(this.label, this.description);

  final String label;
  final String description;
}
