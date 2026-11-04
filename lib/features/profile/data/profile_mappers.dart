import '../../../core/database/app_database.dart';
import '../../../core/utilities/enum_codec.dart';
import '../domain/fitness_assessment.dart';
import '../domain/profile_options.dart';
import '../domain/user_profile.dart';

/// Row ↔ domain conversion. Kept free of database access so it stays unit
/// testable and tolerant of unknown stored values.

ProfileRow profileToRow(UserProfile profile) => ProfileRow(
  id: UserProfile.primaryId,
  age: profile.age,
  heightCm: profile.heightCm,
  weightKg: profile.weightKg,
  experienceLevel: profile.experience.name,
  goals: encodeEnumList(profile.goals),
  priorities: encodeEnumList(profile.priorities),
  equipment: encodeEnumList(profile.equipment),
  sessionMinutes: profile.sessionMinutes,
  trainingTime: profile.trainingTime.name,
  dietPattern: profile.diet.name,
  dietRestrictions: encodeEnumList(profile.restrictions),
  sleepPattern: profile.sleep.name,
  notificationsEnabled: profile.notificationsEnabled,
  createdAt: profile.createdAt.toUtc(),
  updatedAt: profile.updatedAt.toUtc(),
);

UserProfile profileFromRow(ProfileRow row) => UserProfile(
  age: row.age,
  heightCm: row.heightCm,
  weightKg: row.weightKg,
  experience:
      matchEnum(ExperienceLevel.values, row.experienceLevel) ??
      ExperienceLevel.beginner,
  goals: decodeEnumList(TrainingGoal.values, row.goals).toSet(),
  priorities: decodeEnumList(MusclePriority.values, row.priorities).toSet(),
  equipment: decodeEnumList(EquipmentItem.values, row.equipment).toSet(),
  sessionMinutes: row.sessionMinutes,
  trainingTime:
      matchEnum(TrainingTimeOfDay.values, row.trainingTime) ??
      TrainingTimeOfDay.evening,
  diet:
      matchEnum(DietPattern.values, row.dietPattern) ??
      DietPattern.vegetarianNoEggs,
  restrictions: decodeEnumList(
    DietRestriction.values,
    row.dietRestrictions,
  ).toSet(),
  sleep:
      matchEnum(SleepPattern.values, row.sleepPattern) ??
      SleepPattern.irregular,
  notificationsEnabled: row.notificationsEnabled,
  createdAt: row.createdAt.toUtc(),
  updatedAt: row.updatedAt.toUtc(),
);

AssessmentRow assessmentToRow(FitnessAssessment assessment) => AssessmentRow(
  id: 'assessment-${assessment.recordedAt.microsecondsSinceEpoch}',
  profileId: UserProfile.primaryId,
  pushUps: assessment.pushUps,
  kneePushUps: assessment.kneePushUps,
  plankSeconds: assessment.plankSeconds,
  pullUps: assessment.pullUps,
  squats: assessment.squats,
  notes: assessment.notes,
  recordedAt: assessment.recordedAt.toUtc(),
);

FitnessAssessment assessmentFromRow(AssessmentRow row) => FitnessAssessment(
  pushUps: row.pushUps,
  kneePushUps: row.kneePushUps,
  plankSeconds: row.plankSeconds,
  pullUps: row.pullUps,
  squats: row.squats,
  notes: row.notes,
  recordedAt: row.recordedAt.toUtc(),
);
