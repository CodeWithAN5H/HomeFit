import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/nutrition/data/catalog/food_catalogue.dart';
import 'package:homefit/features/nutrition/data/catalog/recipe_catalogue.dart';
import 'package:homefit/features/nutrition/domain/food_item.dart';
import 'package:homefit/features/nutrition/domain/food_log.dart';
import 'package:homefit/features/nutrition/domain/meal_plan.dart';
import 'package:homefit/features/nutrition/domain/meal_slot.dart';
import 'package:homefit/features/nutrition/domain/nutrition_day.dart';
import 'package:homefit/features/nutrition/domain/nutrition_totals.dart';
import 'package:homefit/features/nutrition/domain/recipe.dart';

import '../../fixtures/nutrition_fixtures.dart';

void main() {
  final Map<String, FoodItem> foods = FoodCatalogue.bundled().byIdMap;
  final Map<String, Recipe> recipes = RecipeCatalogue.bundled().byIdMap;

  test('planned and logged totals are reported separately', () {
    final NutritionDay day = NutritionDay(
      dateKey: '2026-11-05',
      plan: <MealPlanItem>[
        buildPlanItem(id: 'roti', amount: 80),
        buildPlanItem(
          id: 'khichdi',
          slot: MealSlot.lunch,
          kind: MealPlanItemKind.recipe,
          sourceId: 'moong-dal-khichdi',
          name: 'Moong dal khichdi',
          amount: 2,
          unit: 'serving',
          servingLabel: null,
          orderIndex: 1,
        ),
      ],
      log: <LoggedFoodEntry>[buildLogEntry(id: 'banana', slot: MealSlot.snack)],
      foods: foods,
      recipes: recipes,
    );

    expect(day.hasPlan, isTrue);
    expect(day.hasLog, isTrue);
    expect(day.plannedTotalsFor(MealSlot.breakfast).kcal, closeTo(208, 0.5));

    final NutritionTotals khichdi = recipes['moong-dal-khichdi']!.nutritionFor(
      foods,
      servings: 2,
    );
    expect(
      day.plannedTotalsFor(MealSlot.lunch).kcal,
      closeTo(khichdi.kcal, 0.001),
    );
    expect(day.loggedTotalsFor(MealSlot.snack).kcal, closeTo(105.02, 0.01));
    expect(day.loggedTotalsFor(MealSlot.lunch).isEmpty, isTrue);

    expect(
      day.plannedTotals.kcal,
      closeTo(
        day.plannedTotalsFor(MealSlot.breakfast).kcal +
            day.plannedTotalsFor(MealSlot.lunch).kcal,
        0.001,
      ),
    );
  });

  test('slots are ordered by plan order, not insertion order', () {
    final NutritionDay day = NutritionDay(
      dateKey: '2026-11-05',
      plan: <MealPlanItem>[
        buildPlanItem(id: 'later', orderIndex: 2, slot: MealSlot.lunch),
        buildPlanItem(id: 'first', orderIndex: 0, slot: MealSlot.lunch),
        buildPlanItem(id: 'middle', orderIndex: 1, slot: MealSlot.lunch),
        buildPlanItem(id: 'breakfast', slot: MealSlot.breakfast),
      ],
      log: const <LoggedFoodEntry>[],
      foods: foods,
      recipes: recipes,
    );

    expect(day.planFor(MealSlot.lunch).map((MealPlanItem i) => i.id), <String>[
      'first',
      'middle',
      'later',
    ]);
    expect(day.planFor(MealSlot.breakfast), hasLength(1));
    expect(day.planFor(MealSlot.dinner), isEmpty);
  });

  test('an unknown food or recipe contributes nothing instead of guessing', () {
    const MealPlanItem food = MealPlanItem(
      id: 'x',
      dateKey: '2026-11-05',
      slot: MealSlot.breakfast,
      kind: MealPlanItemKind.food,
      sourceId: 'removed-food',
      name: 'Removed food',
      amount: 100,
      unit: 'g',
      orderIndex: 0,
    );
    const MealPlanItem recipe = MealPlanItem(
      id: 'y',
      dateKey: '2026-11-05',
      slot: MealSlot.breakfast,
      kind: MealPlanItemKind.recipe,
      sourceId: 'removed-recipe',
      name: 'Removed recipe',
      amount: 1,
      unit: 'serving',
      orderIndex: 1,
    );

    expect(totalsForPlanItem(food, foods, recipes).isEmpty, isTrue);
    expect(totalsForPlanItem(recipe, foods, recipes).isEmpty, isTrue);
  });

  test('an empty day has no plan, no log and zero totals', () {
    final NutritionDay empty = NutritionDay(
      dateKey: '2026-11-06',
      plan: const <MealPlanItem>[],
      log: const <LoggedFoodEntry>[],
      foods: foods,
      recipes: recipes,
    );
    expect(empty.hasPlan, isFalse);
    expect(empty.hasLog, isFalse);
    expect(empty.plannedTotals.isEmpty, isTrue);
    expect(empty.loggedTotals.isEmpty, isTrue);
  });
}
