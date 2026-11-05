import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/nutrition/data/catalog/food_catalogue.dart';
import 'package:homefit/features/nutrition/data/catalog/recipe_catalogue.dart';
import 'package:homefit/features/nutrition/domain/food_item.dart';
import 'package:homefit/features/nutrition/domain/nutrition_totals.dart';
import 'package:homefit/features/nutrition/domain/recipe.dart';

void main() {
  final Map<String, FoodItem> foods = FoodCatalogue.bundled().byIdMap;
  final RecipeCatalogue recipes = RecipeCatalogue.bundled();
  final Recipe khichdi = recipes.byId('moong-dal-khichdi')!;

  test('recipe nutrition is the sum of its ingredients', () {
    NutritionTotals expected = NutritionTotals.zero;
    for (final RecipeIngredient ingredient in khichdi.ingredients) {
      expected =
          expected + foods[ingredient.foodId]!.totalsFor(ingredient.amount);
    }
    final NutritionTotals total = khichdi.totalNutrition(foods);
    expect(total.kcal, closeTo(expected.kcal, 0.001));
    expect(total.proteinG, closeTo(expected.proteinG, 0.001));
    expect(total.carbsG, closeTo(expected.carbsG, 0.001));
    expect(total.fatG, closeTo(expected.fatG, 0.001));
  });

  test('one serving is the total divided by the stated servings', () {
    final NutritionTotals total = khichdi.totalNutrition(foods);
    final NutritionTotals oneServing = khichdi.nutritionFor(foods);
    expect(khichdi.servings, 2);
    expect(oneServing.kcal, closeTo(total.kcal / 2, 0.001));
    expect(oneServing.proteinG, closeTo(total.proteinG / 2, 0.001));
  });

  test('serving counts scale ingredients correctly', () {
    final NutritionTotals one = khichdi.nutritionFor(foods);
    final NutritionTotals two = khichdi.nutritionFor(foods, servings: 2);
    final NutritionTotals half = khichdi.nutritionFor(foods, servings: 0.5);
    final NutritionTotals double = khichdi.nutritionFor(foods, servings: 4);

    expect(two.kcal, closeTo(one.kcal * 2, 0.001));
    expect(half.kcal, closeTo(one.kcal / 2, 0.001));
    expect(double.kcal, closeTo(one.kcal * 4, 0.001));
    expect(two.proteinG, closeTo(one.proteinG * 2, 0.001));
  });

  test('missing ingredients are skipped rather than invented', () {
    final Map<String, FoodItem> partial = <String, FoodItem>{
      'rice-white-cooked': foods['rice-white-cooked']!,
    };
    final NutritionTotals totals = khichdi.nutritionFor(partial);
    expect(
      totals.kcal,
      closeTo(foods['rice-white-cooked']!.totalsFor(300).kcal / 2, 0.001),
    );
  });

  test('search covers title, description and tags', () {
    expect(recipes.search('rajma').single.id, 'rajma-rice');
    expect(recipes.search('protein').length, greaterThan(3));
    expect(
      recipes.search('chickpea').single.id,
      'chole-masala',
      reason: 'description search should work',
    );
    expect(recipes.search('zzzz'), isEmpty);
    expect(
      recipes.search('', tag: RecipeTag.lactoseFree).map((Recipe r) => r.id),
      containsAll(<String>['soya-chunk-curry', 'chole-masala']),
    );
  });

  test('every recipe stays affordable and egg-free by construction', () {
    for (final Recipe recipe in recipes.all) {
      expect(recipe.title.toLowerCase(), isNot(contains('egg')));
      expect(recipe.servings, inInclusiveRange(1, 6));
      for (final RecipeIngredient ingredient in recipe.ingredients) {
        final FoodItem? food = foods[ingredient.foodId];
        expect(food, isNotNull, reason: recipe.id);
        expect(food!.isEstimated, isTrue);
      }
    }
  });
}
