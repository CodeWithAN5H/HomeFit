import 'package:homefit/features/profile/domain/profile_options.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';

/// Neutral fixture values — deliberately not the real user's numbers.
UserProfile buildTestProfile({int age = 30}) {
  return UserProfile(
    age: age,
    heightCm: 175,
    weightKg: 70,
    experience: ExperienceLevel.beginner,
    goals: <TrainingGoal>{TrainingGoal.buildMuscle, TrainingGoal.consistency},
    priorities: <MusclePriority>{MusclePriority.arms, MusclePriority.core},
    equipment: <EquipmentItem>{EquipmentItem.bodyweight},
    sessionMinutes: 40,
    trainingTime: TrainingTimeOfDay.evening,
    diet: DietPattern.vegetarianNoEggs,
    restrictions: <DietRestriction>{DietRestriction.lactoseIntolerant},
    sleep: SleepPattern.irregular,
    notificationsEnabled: true,
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );
}
