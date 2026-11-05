import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/nutrition/data/catalog/food_catalogue.dart';
import 'package:homefit/features/nutrition/data/catalog/recipe_catalogue.dart';
import 'package:homefit/features/nutrition/domain/food_item.dart';
import 'package:homefit/features/nutrition/domain/grocery.dart';
import 'package:homefit/features/nutrition/domain/meal_plan.dart';
import 'package:homefit/features/nutrition/domain/meal_slot.dart';
import 'package:homefit/features/nutrition/domain/recipe.dart';

import '../../fixtures/nutrition_fixtures.dart';

void main() {
  final Map<String, FoodItem> foods = FoodCatalogue.bundled().byIdMap;
  final Map<String, Recipe> recipes = RecipeCatalogue.bundled().byIdMap;

  List<GroceryItem> build(List<MealPlanItem> plan) => GroceryPlanner.build(
    plan: plan,
    foods: foods,
    recipes: recipes,
    createdAt: DateTime(2026, 11, 5, 18),
  );

  test('duplicate foods merge into one line with summed quantity', () {
    final List<GroceryItem> lines = build(<MealPlanItem>[
      buildPlanItem(
        id: 'a',
        sourceId: 'rice-white-cooked',
        name: 'White rice, cooked',
        amount: 150,
        servingLabel: null,
        orderIndex: 0,
      ),
      buildPlanItem(
        id: 'b',
        slot: MealSlot.dinner,
        sourceId: 'rice-white-cooked',
        name: 'White rice, cooked',
        amount: 250,
        servingLabel: null,
        orderIndex: 1,
      ),
      buildPlanItem(
        id: 'c',
        sourceId: 'paneer',
        name: 'Paneer',
        amount: 50,
        servingLabel: null,
        orderIndex: 2,
      ),
    ]);

    expect(lines, hasLength(2));
    final GroceryItem rice = lines.firstWhere(
      (GroceryItem line) => line.foodId == 'rice-white-cooked',
    );
    expect(rice.amount, 400);
    expect(rice.unit, 'g');
    expect(rice.amountLabel, '400 g');
    expect(rice.source, GrocerySource.plan);
    expect(rice.checked, isFalse, reason: 'planning must not tick items off');
    expect(rice.id, 'plan-rice-white-cooked-g');
  });

  test('recipe plan items expand into ingredients at the planned servings', () {
    final Recipe khichdi = recipes['moong-dal-khichdi']!;
    final List<GroceryItem> oneServing = build(<MealPlanItem>[
      MealPlanItem(
        id: 'r1',
        dateKey: '2026-11-05',
        slot: MealSlot.lunch,
        kind: MealPlanItemKind.recipe,
        sourceId: khichdi.id,
        name: khichdi.title,
        amount: 1,
        unit: 'serving',
        orderIndex: 0,
      ),
    ]);

    // The recipe is written for two servings, so one serving halves each line.
    final GroceryItem rice = oneServing.firstWhere(
      (GroceryItem line) => line.foodId == 'rice-white-cooked',
    );
    expect(rice.amount, 150);
    expect(oneServing.map((GroceryItem line) => line.foodId), contains('ghee'));
    expect(
      oneServing.firstWhere((GroceryItem l) => l.foodId == 'ghee').amount,
      4,
    );

    final List<GroceryItem> doubled = build(<MealPlanItem>[
      MealPlanItem(
        id: 'r2',
        dateKey: '2026-11-05',
        slot: MealSlot.dinner,
        kind: MealPlanItemKind.recipe,
        sourceId: khichdi.id,
        name: khichdi.title,
        amount: 4,
        unit: 'serving',
        orderIndex: 0,
      ),
    ]);
    expect(
      doubled
          .firstWhere((GroceryItem l) => l.foodId == 'rice-white-cooked')
          .amount,
      600,
    );
  });

  test('recipe ingredients merge with directly planned foods', () {
    final List<GroceryItem> lines = build(<MealPlanItem>[
      buildPlanItem(
        id: 'direct',
        sourceId: 'rice-white-cooked',
        name: 'White rice, cooked',
        amount: 100,
        servingLabel: null,
      ),
      const MealPlanItem(
        id: 'recipe',
        dateKey: '2026-11-05',
        slot: MealSlot.dinner,
        kind: MealPlanItemKind.recipe,
        sourceId: 'rajma-rice',
        name: 'Rajma rice',
        amount: 2,
        unit: 'serving',
        orderIndex: 1,
      ),
    ]);
    final GroceryItem rice = lines.firstWhere(
      (GroceryItem line) => line.foodId == 'rice-white-cooked',
    );
    expect(rice.amount, 400);
    expect(
      lines.map((GroceryItem line) => line.foodId),
      containsAll(<String>['rajma-cooked', 'ghee']),
    );
  });

  test('unknown ids are ignored and the list is alphabetical', () {
    final List<GroceryItem> lines = build(<MealPlanItem>[
      buildPlanItem(
        id: 'missing-food',
        sourceId: 'rice-white-cooked',
        name: 'White rice, cooked',
        amount: 100,
        servingLabel: null,
      ),
      const MealPlanItem(
        id: 'missing-recipe',
        dateKey: '2026-11-05',
        slot: MealSlot.lunch,
        kind: MealPlanItemKind.recipe,
        sourceId: 'not-a-recipe',
        name: 'Ghost',
        amount: 1,
        unit: 'serving',
        orderIndex: 1,
      ),
    ]);
    expect(lines, hasLength(1));
    expect(lines.single.name, 'White rice, cooked');

    final List<GroceryItem> sorted = build(<MealPlanItem>[
      buildPlanItem(
        id: 'p',
        sourceId: 'paneer',
        name: 'Paneer',
        amount: 100,
        servingLabel: null,
      ),
      buildPlanItem(
        id: 'r',
        sourceId: 'rice-white-cooked',
        name: 'White rice, cooked',
        amount: 100,
        servingLabel: null,
        orderIndex: 1,
      ),
    ]);
    expect(sorted.map((GroceryItem line) => line.name), <String>[
      'Paneer',
      'White rice, cooked',
    ]);
  });

  test('an empty plan produces an empty checklist', () {
    expect(build(const <MealPlanItem>[]), isEmpty);
  });
}
