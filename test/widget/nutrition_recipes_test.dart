import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/nutrition/domain/meal_plan.dart';
import 'package:homefit/features/nutrition/presentation/recipe_library_screen.dart';

import '../fixtures/nutrition_widget_harness.dart';

void main() {
  testWidgets('recipes are searchable and filterable', (tester) async {
    await pumpNutrition(tester, const RecipeLibraryScreen());

    await tester.enterText(find.byKey(const Key('recipe_search')), 'poha');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('recipe_card_vegetable-poha')), findsOneWidget);
    expect(
      find.byKey(const Key('recipe_card_moong-dal-khichdi')),
      findsNothing,
    );

    await tester.enterText(find.byKey(const Key('recipe_search')), 'khichdi');
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('recipe_card_moong-dal-khichdi')),
      findsOneWidget,
    );

    await tester.enterText(find.byKey(const Key('recipe_search')), '');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('recipe_tag_quick')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('recipe_card_banana-peanut-shake')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('recipe_card_chole-masala')), findsNothing);

    await tester.tap(find.byKey(const Key('recipe_tag_all')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('recipe_search')), 'chole');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('recipe_card_chole-masala')), findsOneWidget);
  });

  testWidgets('an empty search result explains itself', (tester) async {
    await pumpNutrition(tester, const RecipeLibraryScreen());

    await tester.enterText(find.byKey(const Key('recipe_search')), 'zzzzz');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('recipe_empty')), findsOneWidget);
  });

  testWidgets('recipe detail shows ingredients, method and estimates', (
    tester,
  ) async {
    await pumpNutrition(
      tester,
      const RecipeDetailScreen(recipeId: 'oats-porridge'),
    );

    expect(find.text('Oats with milk and banana'), findsWidgets);
    expect(find.text('Per serving (estimated)'), findsOneWidget);
    expect(find.text('Estimate'), findsOneWidget);
    expect(find.text('Rolled oats, dry'), findsOneWidget);
    expect(find.text('Toned milk'), findsOneWidget);
    expect(find.textContaining('Simmer the oats'), findsOneWidget);
    await reveal(tester, find.byKey(const Key('recipe_add_to_plan')));
    expect(find.byKey(const Key('recipe_add_to_plan')), findsOneWidget);
  });

  testWidgets('adding a recipe to the plan uses the chosen meal and servings', (
    tester,
  ) async {
    final NutritionHarness harness = await pumpNutrition(
      tester,
      const RecipeDetailScreen(recipeId: 'oats-porridge'),
    );

    await reveal(tester, find.byKey(const Key('recipe_add_to_plan')));
    await tester.tap(find.byKey(const Key('recipe_add_to_plan')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('slot_breakfast')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm_servings')));
    await tester.pumpAndSettle();

    final List<MealPlanItem> plan = await harness.repository.readPlan(
      '2026-11-05',
    );
    expect(plan, hasLength(1));
    expect(plan.single.sourceId, 'oats-porridge');
    expect(plan.single.kind, MealPlanItemKind.recipe);
    expect(plan.single.amount, 1);
  });

  testWidgets('an unknown recipe id is handled without crashing', (
    tester,
  ) async {
    await pumpNutrition(
      tester,
      const RecipeDetailScreen(recipeId: 'no-such-recipe'),
    );
    expect(find.textContaining('not in the catalogue'), findsOneWidget);
  });
}
