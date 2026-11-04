import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/profile/data/profile_mappers.dart';
import 'package:homefit/features/profile/domain/fitness_assessment.dart';
import 'package:homefit/features/profile/domain/profile_options.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';

import '../../fixtures/profile_fixtures.dart';

void main() {
  group('profile mapping', () {
    test('row round trip preserves every field', () {
      final UserProfile profile = buildTestProfile();
      final UserProfile restored = profileFromRow(profileToRow(profile));

      expect(restored.age, profile.age);
      expect(restored.heightCm, profile.heightCm);
      expect(restored.weightKg, profile.weightKg);
      expect(restored.experience, profile.experience);
      expect(restored.goals, profile.goals);
      expect(restored.priorities, profile.priorities);
      expect(restored.equipment, profile.equipment);
      expect(restored.sessionMinutes, profile.sessionMinutes);
      expect(restored.trainingTime, profile.trainingTime);
      expect(restored.diet, profile.diet);
      expect(restored.restrictions, profile.restrictions);
      expect(restored.sleep, profile.sleep);
      expect(restored.notificationsEnabled, profile.notificationsEnabled);
      expect(restored.createdAt, profile.createdAt);
    });

    test('unknown stored enum names fall back instead of throwing', () {
      final restored = profileFromRow(
        profileToRow(buildTestProfile()).copyWith(
          experienceLevel: 'removed_level',
          sleepPattern: 'removed_sleep',
          goals: '["buildMuscle","removed_goal"]',
        ),
      );

      expect(restored.experience, ExperienceLevel.beginner);
      expect(restored.sleep, SleepPattern.irregular);
      expect(restored.goals, <TrainingGoal>{TrainingGoal.buildMuscle});
    });

    test('corrupt list data yields an empty set', () {
      final restored = profileFromRow(
        profileToRow(buildTestProfile()).copyWith(goals: 'not json'),
      );

      expect(restored.goals, isEmpty);
    });
  });

  group('assessment mapping', () {
    test('round trip keeps optional values and blanks', () {
      final assessment = FitnessAssessment(
        pushUps: 8,
        kneePushUps: 9,
        plankSeconds: 50,
        pullUps: 1,
        recordedAt: DateTime.utc(2026, 2, 3),
      );

      final restored = assessmentFromRow(assessmentToRow(assessment));

      expect(restored.pushUps, 8);
      expect(restored.kneePushUps, 9);
      expect(restored.plankSeconds, 50);
      expect(restored.pullUps, 1);
      expect(restored.squats, isNull);
      expect(restored.recordedAt, DateTime.utc(2026, 2, 3));
    });

    test('zero reps is recorded, not treated as blank', () {
      final assessment = FitnessAssessment(
        pushUps: 0,
        recordedAt: DateTime.utc(2026, 2, 4),
      );

      expect(assessment.isEmpty, isFalse);
      expect(assessmentFromRow(assessmentToRow(assessment)).pushUps, 0);
    });
  });
}
