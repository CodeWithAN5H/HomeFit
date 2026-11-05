import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/nutrition/domain/food_item.dart';
import 'package:homefit/features/nutrition/domain/nutrition_totals.dart';
import 'package:homefit/features/nutrition/domain/nutrition_units.dart';

import '../../fixtures/nutrition_fixtures.dart';

void main() {
  group('per-serving and quantity maths', () {
    test('per 100 values scale linearly', () {
      final FoodItem rice = testFood('rice-white-cooked');
      final NutritionTotals oneKatori = rice.totalsFor(150);
      expect(oneKatori.kcal, closeTo(195, 0.01));
      expect(oneKatori.proteinG, closeTo(4.05, 0.01));
      expect(oneKatori.carbsG, closeTo(42, 0.01));
      expect(oneKatori.fatG, closeTo(0.45, 0.01));
    });

    test('serving presets resolve to the same maths', () {
      final FoodItem roti = testFood('roti-whole-wheat');
      final ServingPreset twoRotis = roti.servings[1];
      expect(twoRotis.label, '2 rotis');
      final NutritionTotals viaServing = roti.totalsForServing(twoRotis);
      final NutritionTotals viaAmount = roti.totalsFor(80);
      expect(viaServing.kcal, viaAmount.kcal);
      expect(viaServing.proteinG, viaAmount.proteinG);
    });

    test('changing the quantity changes totals proportionally', () {
      final FoodItem paneer = testFood('paneer');
      final double one = paneer.totalsFor(50).kcal;
      final double two = paneer.totalsFor(100).kcal;
      expect(two, closeTo(one * 2, 0.001));
      expect(paneer.totalsFor(0).isEmpty, isTrue);
    });

    test('liquids use millilitres', () {
      final FoodItem milk = testFood('milk-toned');
      expect(milk.unit, 'ml');
      expect(milk.baseLabel, 'per 100 ml');
      expect(milk.totalsFor(200).kcal, closeTo(116, 0.01));
    });

    test('totals accumulate without rounding away small portions', () {
      NutritionTotals total = NutritionTotals.zero;
      for (int i = 0; i < 10; i++) {
        total =
            total +
            const NutritionTotals(
              kcal: 1.04,
              proteinG: 0.04,
              carbsG: 0.1,
              fatG: 0.02,
            );
      }
      expect(total.kcal, closeTo(10.4, 0.001));
      expect(total.proteinG, closeTo(0.4, 0.001));
      expect(formatKcal(total.kcal), '10 kcal');
      expect(formatGrams(total.proteinG), '0 g');
    });

    test('scaling a total keeps its macros aligned with its energy', () {
      const NutritionTotals base = NutritionTotals(
        kcal: 260,
        proteinG: 9,
        carbsG: 46,
        fatG: 3.7,
      );
      final NutritionTotals half = base.scale(0.5);
      expect(half.kcal, 130);
      expect(half.proteinG, 4.5);
      expect(half.carbsG, 23);
      expect(half.fatG, 1.85);
    });

    test('a meal total is the sum of its items', () {
      final FoodItem roti = testFood('roti-whole-wheat');
      final FoodItem dal = testFood('dal-toor-cooked');
      final NutritionTotals meal =
          roti.totalsFor(80) + dal.totalsFor(150) + roti.totalsFor(40);
      expect(meal.kcal, closeTo(208 + 174 + 104, 0.5));
      expect(meal.proteinG, greaterThan(18));
    });
  });

  group('formatting', () {
    test('quantities read like kitchen measures', () {
      expect(formatQuantity(40, 'g'), '40 g');
      expect(formatQuantity(1250, 'g'), '1.3 kg');
      expect(formatQuantity(1000, 'g'), '1 kg');
      expect(formatQuantity(250, 'ml'), '250 ml');
      expect(formatQuantity(2000, 'ml'), '2 L');
      expect(formatQuantity(1, 'serving'), '1 serving');
      expect(formatQuantity(1.5, 'serving'), '1.5 servings');
    });

    test('kcal and grams round at display time only', () {
      expect(formatKcal(116.4), '116 kcal');
      expect(formatKcal(116.6), '117 kcal');
      expect(formatGrams(7.5), '8 g');
    });
  });
}
