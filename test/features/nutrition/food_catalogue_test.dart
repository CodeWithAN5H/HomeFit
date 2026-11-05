import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/nutrition/data/catalog/food_catalogue.dart';
import 'package:homefit/features/nutrition/data/catalog/recipe_catalogue.dart';
import 'package:homefit/features/nutrition/domain/food_item.dart';
import 'package:homefit/features/nutrition/domain/nutrition_totals.dart';
import 'package:homefit/features/nutrition/domain/recipe.dart';

void main() {
  final FoodCatalogue foods = FoodCatalogue.bundled();
  final RecipeCatalogue recipes = RecipeCatalogue.bundled();

  group('food catalogue integrity', () {
    test('every food id is a unique stable slug', () {
      expect(foods.all, hasLength(55));
      final Set<String> ids = <String>{
        for (final FoodItem food in foods.all) food.id,
      };
      expect(ids, hasLength(foods.all.length));
      final RegExp slug = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$');
      for (final FoodItem food in foods.all) {
        expect(
          slug.hasMatch(food.id),
          isTrue,
          reason: '${food.id} must be a lowercase slug so it can be stored',
        );
        expect(food.name.trim(), isNotEmpty);
        expect(food.source.trim(), isNotEmpty);
        expect(food.isEstimated, isTrue);
      }
    });

    test('nutrition values are present, non-negative and plausible', () {
      for (final FoodItem food in foods.all) {
        final NutritionTotals per100 = food.per100;
        expect(per100.kcal, inInclusiveRange(0, 900), reason: food.id);
        expect(per100.proteinG, inInclusiveRange(0, 100), reason: food.id);
        expect(per100.carbsG, inInclusiveRange(0, 100), reason: food.id);
        expect(per100.fatG, inInclusiveRange(0, 100), reason: food.id);

        // Stated energy should roughly agree with the macros. It is not exact:
        // fibre, organic acids (lemon juice) and rounding push some foods
        // either side, which is why the tolerance is generous.
        final double fromMacros =
            per100.proteinG * 4 + per100.carbsG * 4 + per100.fatG * 9;
        if (per100.kcal > 0) {
          expect(
            fromMacros / per100.kcal,
            inInclusiveRange(0.55, 1.45),
            reason: '${food.id} energy disagrees with its macros',
          );
        }
      }
    });

    test('every food offers household servings in its own unit', () {
      for (final FoodItem food in foods.all) {
        expect(food.servings, isNotEmpty, reason: food.id);
        expect(food.unit, food.isLiquid ? 'ml' : 'g');
        final Set<String> labels = <String>{};
        for (final ServingPreset serving in food.servings) {
          expect(serving.label.trim(), isNotEmpty);
          expect(serving.amount, greaterThan(0), reason: food.id);
          expect(
            serving.amount,
            lessThanOrEqualTo(500),
            reason: '${food.id} serving is not a household portion',
          );
          expect(labels.add(serving.label), isTrue);
        }
      }
    });

    test('raw and cooked values are explicitly distinguished', () {
      expect(
        foods.all.any((FoodItem food) => food.state == FoodState.raw),
        isTrue,
      );
      expect(
        foods.all.any((FoodItem food) => food.state == FoodState.cooked),
        isTrue,
      );

      final FoodItem drySoy = foods.byId('soy-chunks-dry')!;
      final FoodItem cookedSoy = foods.byId('soy-chunks-cooked')!;
      expect(drySoy.state, FoodState.raw);
      expect(cookedSoy.state, FoodState.cooked);
      expect(drySoy.per100.kcal, greaterThan(cookedSoy.per100.kcal));
      expect(drySoy.note, contains('Dry weight'));
      expect(drySoy.unit, cookedSoy.unit);

      expect(foods.byId('poha-raw')!.state, FoodState.raw);
      expect(foods.byId('rice-white-cooked')!.state, FoodState.cooked);
    });

    test('the catalogue is vegetarian and egg-free', () {
      const List<String> forbidden = <String>[
        'egg',
        'chicken',
        'mutton',
        'fish',
        'prawn',
        'bacon',
        'meat',
      ];
      for (final FoodItem food in foods.all) {
        final String haystack = '${food.id} ${food.name}'.toLowerCase();
        for (final String word in forbidden) {
          expect(
            haystack.contains(word),
            isFalse,
            reason: '${food.id} looks non-vegetarian',
          );
        }
      }
      for (final Recipe recipe in recipes.all) {
        final String haystack =
            '${recipe.id} ${recipe.title} '
                    '${recipe.description}'
                .toLowerCase();
        for (final String word in forbidden) {
          expect(
            haystack.contains(word),
            isFalse,
            reason: '${recipe.id} looks non-vegetarian',
          );
        }
      }
    });

    test('search is case-insensitive and narrows by category', () {
      expect(
        foods.search('PANEER').map((FoodItem f) => f.id),
        contains('paneer'),
      );
      expect(
        foods.search('dal').map((FoodItem f) => f.id),
        containsAll(<String>['dal-toor-cooked', 'dal-moong-cooked']),
      );
      expect(foods.search('nothing-matches-this'), isEmpty);

      final List<FoodItem> legumes = foods.search(
        '',
        category: FoodCategory.legumes,
      );
      expect(legumes, isNotEmpty);
      expect(
        legumes.every((FoodItem food) => food.category == FoodCategory.legumes),
        isTrue,
      );
      expect(
        foods
            .search('paneer', category: FoodCategory.dairy)
            .map((FoodItem food) => food.id),
        <String>['paneer'],
      );
    });

    test('lookup by id returns stable objects', () {
      expect(foods.byId('roti-whole-wheat')?.name, 'Whole-wheat roti');
      expect(foods.byId('missing-food'), isNull);
      expect(foods.byIdMap, hasLength(foods.all.length));
    });
  });

  group('recipe catalogue integrity', () {
    test('recipes have unique ids, ingredients and steps', () {
      expect(recipes.all, hasLength(13));
      final Set<String> ids = <String>{
        for (final Recipe recipe in recipes.all) recipe.id,
      };
      expect(ids, hasLength(recipes.all.length));

      for (final Recipe recipe in recipes.all) {
        expect(recipe.title.trim(), isNotEmpty);
        expect(recipe.servings, greaterThan(0), reason: recipe.id);
        expect(recipe.prepMinutes, greaterThan(0), reason: recipe.id);
        expect(recipe.ingredients, isNotEmpty, reason: recipe.id);
        expect(recipe.steps, isNotEmpty, reason: recipe.id);
        expect(recipe.tags, isNotEmpty, reason: recipe.id);

        for (final RecipeIngredient ingredient in recipe.ingredients) {
          expect(
            foods.byId(ingredient.foodId),
            isNotNull,
            reason: '${recipe.id} references ${ingredient.foodId}',
          );
          expect(ingredient.amount, greaterThan(0), reason: recipe.id);
        }

        final NutritionTotals perServing = recipe.nutritionFor(foods.byIdMap);
        expect(
          perServing.kcal,
          inInclusiveRange(30, 900),
          reason: '${recipe.id} per-serving energy looks wrong',
        );
        expect(perServing.proteinG, greaterThan(0), reason: recipe.id);
      }
    });

    test('search and tag filters combine', () {
      expect(recipes.search('poha').map((Recipe recipe) => recipe.id), <String>[
        'vegetable-poha',
      ]);
      expect(recipes.search('', tag: RecipeTag.breakfast), hasLength(3));
      final List<Recipe> quickHighProtein = recipes.search(
        'chilla',
        tag: RecipeTag.quick,
      );
      expect(quickHighProtein.map((Recipe recipe) => recipe.id), <String>[
        'besan-chilla',
      ]);
      expect(recipes.search('chilla', tag: RecipeTag.snack), isEmpty);
      expect(recipes.byId('missing-recipe'), isNull);
    });

    test('tagged recipes are consistent with their ingredients', () {
      final Recipe oats = recipes.byId('oats-porridge')!;
      expect(oats.tags, contains(RecipeTag.breakfast));
      expect(oats.tags, isNot(contains(RecipeTag.nutFree)));
      expect(oats.note, contains('milk'));

      final Recipe khichdi = recipes.byId('moong-dal-khichdi')!;
      expect(
        khichdi.ingredients.map((RecipeIngredient i) => i.foodId),
        containsAll(<String>['rice-white-cooked', 'dal-moong-cooked', 'ghee']),
      );
      expect(khichdi.tags, contains(RecipeTag.glutenFree));
    });
  });
}
