import '../../profile/domain/fitness_assessment.dart';
import '../../profile/domain/profile_options.dart';
import '../../profile/domain/user_profile.dart';

/// Mutable form state for onboarding.
///
/// All rules live here (pure Dart) so they can be unit tested without widgets,
/// and so the widgets stay declarative.
class OnboardingDraft {
  static const int stepCount = 5;

  int? age;
  int? heightCm;
  double? weightKg;
  ExperienceLevel experience = ExperienceLevel.beginner;

  final Set<TrainingGoal> goals = <TrainingGoal>{};
  final Set<MusclePriority> priorities = <MusclePriority>{};

  final Set<EquipmentItem> equipment = <EquipmentItem>{};
  int sessionMinutes = 40;
  TrainingTimeOfDay trainingTime = TrainingTimeOfDay.evening;

  final DietPattern diet = DietPattern.vegetarianNoEggs;
  final Set<DietRestriction> restrictions = <DietRestriction>{};
  SleepPattern sleep = SleepPattern.irregular;
  bool notificationsEnabled = true;

  // Baseline assessment (all optional).
  int? pushUps;
  int? kneePushUps;
  int? plankSeconds;
  int? pullUps;

  /// Returns a user-facing error for [step], or null when it may advance.
  String? errorForStep(int step) {
    switch (step) {
      case 0:
        final int? age = this.age;
        if (age == null) return 'Enter your age.';
        if (age < 13 || age > 99) return 'Age must be between 13 and 99.';
        final int? height = heightCm;
        if (height == null) return 'Enter your height in centimetres.';
        if (height < 120 || height > 220) {
          return 'Height must be between 120 and 220 cm.';
        }
        final double? weight = weightKg;
        if (weight == null) return 'Enter your weight in kilograms.';
        if (weight < 30 || weight > 250) {
          return 'Weight must be between 30 and 250 kg.';
        }
        return null;
      case 1:
        if (goals.isEmpty) return 'Choose at least one goal.';
        return null;
      case 2:
        if (equipment.isEmpty) {
          return 'Select your equipment, or "No equipment".';
        }
        return null;
      case 3:
        return null;
      case 4:
        for (final int? value in <int?>[
          pushUps,
          kneePushUps,
          plankSeconds,
          pullUps,
        ]) {
          if (value != null && value < 0) {
            return 'Numbers cannot be negative. Leave a field blank if unsure.';
          }
        }
        return null;
      default:
        return null;
    }
  }

  UserProfile buildProfile({required DateTime now}) {
    return UserProfile(
      age: age!,
      heightCm: heightCm!,
      weightKg: weightKg!,
      experience: experience,
      goals: Set<TrainingGoal>.unmodifiable(goals),
      priorities: Set<MusclePriority>.unmodifiable(priorities),
      equipment: Set<EquipmentItem>.unmodifiable(equipment),
      sessionMinutes: sessionMinutes,
      trainingTime: trainingTime,
      diet: diet,
      restrictions: Set<DietRestriction>.unmodifiable(restrictions),
      sleep: sleep,
      notificationsEnabled: notificationsEnabled,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Null when the baseline step was skipped or left blank.
  FitnessAssessment? buildAssessment({required DateTime now}) {
    final assessment = FitnessAssessment(
      pushUps: pushUps,
      kneePushUps: kneePushUps,
      plankSeconds: plankSeconds,
      pullUps: pullUps,
      recordedAt: now,
    );
    return assessment.isEmpty ? null : assessment;
  }
}
