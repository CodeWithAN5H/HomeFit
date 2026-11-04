import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/onboarding/domain/onboarding_draft.dart';
import 'package:homefit/features/profile/domain/fitness_assessment.dart';
import 'package:homefit/features/profile/domain/profile_options.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';

void main() {
  final DateTime now = DateTime.utc(2026, 5, 1);

  group('basics validation', () {
    test('requires age, height and weight in order', () {
      final draft = OnboardingDraft();

      expect(draft.errorForStep(0), 'Enter your age.');

      draft.age = 18;
      expect(draft.errorForStep(0), 'Enter your height in centimetres.');

      draft.heightCm = 171;
      expect(draft.errorForStep(0), 'Enter your weight in kilograms.');
    });

    test('rejects values outside safe ranges', () {
      final draft = OnboardingDraft()
        ..age = 12
        ..heightCm = 171
        ..weightKg = 47;
      expect(draft.errorForStep(0), contains('13'));

      draft
        ..age = 18
        ..heightCm = 100;
      expect(draft.errorForStep(0), contains('120'));

      draft
        ..heightCm = 171
        ..weightKg = 20;
      expect(draft.errorForStep(0), contains('30'));
    });

    test('accepts realistic values', () {
      final draft = OnboardingDraft()
        ..age = 18
        ..heightCm = 171
        ..weightKg = 47.5;

      expect(draft.errorForStep(0), isNull);
    });
  });

  group('selection validation', () {
    test('goals are required', () {
      final draft = OnboardingDraft();
      expect(draft.errorForStep(1), 'Choose at least one goal.');

      draft.goals.add(TrainingGoal.strength);
      expect(draft.errorForStep(1), isNull);
    });

    test('equipment is required', () {
      final draft = OnboardingDraft();
      expect(draft.errorForStep(2), isNotNull);

      draft.equipment.add(EquipmentItem.bodyweight);
      expect(draft.errorForStep(2), isNull);
    });

    test('negative baseline values are rejected', () {
      final draft = OnboardingDraft()..pushUps = -1;
      expect(draft.errorForStep(4), contains('negative'));

      draft.pushUps = 0;
      expect(draft.errorForStep(4), isNull);
    });
  });

  group('building domain objects', () {
    test('profile carries selections and the fixed vegetarian diet', () {
      final draft = OnboardingDraft()
        ..age = 18
        ..heightCm = 171
        ..weightKg = 47
        ..sessionMinutes = 45
        ..trainingTime = TrainingTimeOfDay.night
        ..sleep = SleepPattern.severelyInsufficient
        ..notificationsEnabled = false;
      draft.goals.add(TrainingGoal.buildMuscle);
      draft.priorities.add(MusclePriority.arms);
      draft.equipment.add(EquipmentItem.bodyweight);
      draft.restrictions.add(DietRestriction.lactoseIntolerant);

      final UserProfile profile = draft.buildProfile(now: now);

      expect(profile.age, 18);
      expect(profile.weightKg, 47);
      expect(profile.goals, <TrainingGoal>{TrainingGoal.buildMuscle});
      expect(profile.priorities, <MusclePriority>{MusclePriority.arms});
      expect(profile.equipment, <EquipmentItem>{EquipmentItem.bodyweight});
      expect(profile.restrictions, <DietRestriction>{
        DietRestriction.lactoseIntolerant,
      });
      expect(profile.diet, DietPattern.vegetarianNoEggs);
      expect(profile.sessionMinutes, 45);
      expect(profile.trainingTime, TrainingTimeOfDay.night);
      expect(profile.notificationsEnabled, isFalse);
      expect(profile.needsRecoveryAttention, isTrue);
      expect(profile.createdAt, now);
      expect(profile.updatedAt, now);
    });

    test('skipping the baseline yields no assessment', () {
      final draft = OnboardingDraft();
      expect(draft.buildAssessment(now: now), isNull);
    });

    test('baseline values produce an assessment', () {
      final draft = OnboardingDraft()
        ..pushUps = 0
        ..plankSeconds = 45;

      final FitnessAssessment? assessment = draft.buildAssessment(now: now);

      expect(assessment, isNotNull);
      expect(assessment!.pushUps, 0);
      expect(assessment.plankSeconds, 45);
      expect(assessment.kneePushUps, isNull);
      expect(assessment.recordedAt, now);
    });
  });
}
