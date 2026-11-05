import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/nutrition/domain/nutrition_targets.dart';
import 'package:homefit/features/profile/domain/profile_options.dart';

import '../../fixtures/profile_fixtures.dart';

void main() {
  group('estimated targets from the saved profile', () {
    test('a muscle-gain goal adds a modest surplus only', () {
      final NutritionTargets targets = NutritionTargets.estimate(
        buildTestProfile(),
      );

      expect(targets.isAvailable, isTrue);
      expect(targets.kcalLow, 2300, reason: '70 kg x 30 + 200');
      expect(targets.kcalHigh, 2750, reason: '70 kg x 35 + 300');
      expect(targets.proteinLowG, closeTo(84, 0.001));
      expect(targets.proteinHighG, closeTo(112, 0.001));
      expect(targets.kcalMid, closeTo(2525, 0.001));
      expect(
        targets.kcalHigh - targets.kcalLow,
        lessThanOrEqualTo(700),
        reason: 'a wide range is safer than a precise prescription',
      );
    });

    test('without a gain goal the range stays at maintenance', () {
      final NutritionTargets targets = NutritionTargets.estimate(
        buildTestProfile().copyWith(
          goals: <TrainingGoal>{TrainingGoal.consistency},
        ),
      );
      expect(targets.kcalLow, 2100);
      expect(targets.kcalHigh, 2450);
    });

    test('a light weight still gets a safe calorie floor', () {
      final NutritionTargets targets = NutritionTargets.estimate(
        buildTestProfile().copyWith(
          weightKg: 40,
          goals: <TrainingGoal>{TrainingGoal.consistency},
        ),
      );
      expect(targets.kcalLow, 1600);
      expect(targets.kcalHigh, greaterThanOrEqualTo(targets.kcalLow));
      expect(targets.proteinLowG, 48);
      expect(targets.proteinHighG, 64);
    });

    test('a minor gets no target and a referral instead', () {
      final NutritionTargets targets = NutritionTargets.estimate(
        buildTestProfile(age: 17),
      );
      expect(targets.isAvailable, isFalse);
      expect(targets.kcalLow, 0);
      expect(targets.unavailableReason, contains('doctor'));
      expect(targets.unavailableReason, contains('dietitian'));
      expect(targets.assumptions, isEmpty);
    });

    test('assumptions are explicit about uncertainty and diet', () {
      final NutritionTargets targets = NutritionTargets.estimate(
        buildTestProfile(),
      );
      final String text = targets.assumptions.join(' ');
      expect(text, contains('30–35 kcal per kg'));
      expect(text, contains('Sex is not recorded'));
      expect(text, contains('self-reported'));
      expect(text, contains('lactose'));
      expect(text, contains('not medical'));
      expect(text, isNot(contains('guarantee')));
      expect(text, isNot(contains('diagnos')));
    });

    test('no gain goal means no surplus wording', () {
      final NutritionTargets targets = NutritionTargets.estimate(
        buildTestProfile().copyWith(
          goals: <TrainingGoal>{TrainingGoal.consistency},
        ),
      );
      expect(targets.assumptions.join(' '), isNot(contains('modest 200–300')));
    });
  });
}
