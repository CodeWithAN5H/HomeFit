import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/nutrition/application/nutrition_providers.dart';
import 'package:homefit/features/nutrition/domain/food_log.dart';
import 'package:homefit/features/nutrition/domain/meal_plan.dart';
import 'package:homefit/features/nutrition/domain/meal_slot.dart';
import 'package:homefit/features/nutrition/presentation/food_log_screen.dart';
import 'package:homefit/features/nutrition/presentation/meal_plan_screen.dart';

import '../fixtures/nutrition_fixtures.dart';
import '../fixtures/nutrition_widget_harness.dart';

void main() {
  testWidgets('a food can be planned with a household serving', (tester) async {
    final NutritionHarness harness = await pumpNutrition(
      tester,
      const MealPlanScreen(),
    );

    await reveal(tester, find.byKey(const Key('plan_empty')));
    expect(find.byKey(const Key('plan_empty')), findsOneWidget);

    // Back to the top before opening the breakfast picker.
    await tester.drag(find.byType(ListView).first, const Offset(0, 4000));
    await tester.pumpAndSettle();
    await reveal(tester, find.byKey(const Key('add_food_breakfast')));
    await tester.tap(find.byKey(const Key('add_food_breakfast')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('food_search')), 'roti');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('food_roti-whole-wheat')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('amount_sheet')), findsOneWidget);
    await tester.tap(find.byKey(const Key('confirm_amount')));
    await tester.pumpAndSettle();

    expect(find.text('Whole-wheat roti'), findsOneWidget);
    expect(find.textContaining('1 roti'), findsWidgets);

    final List<MealPlanItem> plan = await harness.repository.readPlan(
      '2026-11-05',
    );
    expect(plan, hasLength(1));
    expect(plan.single.slot, MealSlot.breakfast);
    expect(plan.single.amount, 40);
    expect(plan.single.servingLabel, '1 roti');
    expect(plan.single.kind, MealPlanItemKind.food);
  });

  testWidgets('a recipe can be planned with adjusted servings', (tester) async {
    final NutritionHarness harness = await pumpNutrition(
      tester,
      const MealPlanScreen(),
    );

    await reveal(tester, find.byKey(const Key('add_recipe_lunch')));
    await tester.tap(find.byKey(const Key('add_recipe_lunch')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('pick_recipe_moong-dal-khichdi')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('servings_plus')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm_servings')));
    await tester.pumpAndSettle();

    final List<MealPlanItem> plan = await harness.repository.readPlan(
      '2026-11-05',
    );
    expect(plan, hasLength(1));
    expect(plan.single.kind, MealPlanItemKind.recipe);
    expect(plan.single.slot, MealSlot.lunch);
    expect(plan.single.amount, 1.5);
    expect(plan.single.unit, 'serving');
    expect(find.textContaining('1.5 servings'), findsOneWidget);
  });

  testWidgets('planned items can be removed and days are independent', (
    tester,
  ) async {
    final NutritionHarness harness = await pumpNutrition(
      tester,
      const MealPlanScreen(),
    );
    // Seed today's plan directly so the test focuses on the UI.
    await harness.repository.upsertPlanItem(
      const MealPlanItem(
        id: 'seed',
        dateKey: '2026-11-05',
        slot: MealSlot.breakfast,
        kind: MealPlanItemKind.food,
        sourceId: 'rice-white-cooked',
        name: 'White rice, cooked',
        amount: 150,
        unit: 'g',
        orderIndex: 0,
      ),
    );
    harness.container.invalidate(nutritionDayProvider('2026-11-05'));
    await tester.pumpAndSettle();

    await reveal(tester, find.byKey(const Key('remove_plan_item_seed')));
    await tester.tap(find.byKey(const Key('remove_plan_item_seed')));
    await tester.pumpAndSettle();
    expect(await harness.repository.readPlan('2026-11-05'), isEmpty);

    await tester.drag(find.byType(ListView).first, const Offset(0, 3000));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('date_prev')));
    await tester.pumpAndSettle();
    await reveal(tester, find.byKey(const Key('plan_empty')));
    expect(find.byKey(const Key('plan_empty')), findsOneWidget);
  });

  testWidgets('the log is separate from the plan and keeps daily totals', (
    tester,
  ) async {
    final NutritionHarness harness = await pumpNutrition(
      tester,
      const FoodLogScreen(),
    );

    expect(find.byKey(const Key('log_empty')), findsOneWidget);

    await reveal(tester, find.byKey(const Key('log_add_breakfast')));
    await tester.tap(find.byKey(const Key('log_add_breakfast')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('food_search')), 'banana');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('food_banana')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm_amount')));
    await tester.pumpAndSettle();

    expect(find.text('Banana'), findsOneWidget);
    final List<LoggedFoodEntry> logged = await harness.repository.readLog(
      '2026-11-05',
    );
    expect(logged, hasLength(1));
    expect(logged.single.totals.kcal, closeTo(105.02, 0.01));
    expect(await harness.repository.readPlan('2026-11-05'), isEmpty);

    await tester.drag(find.byType(ListView).first, const Offset(0, 3000));
    await tester.pumpAndSettle();
    expect(find.text('105 kcal'), findsWidgets);
    expect(find.byKey(const Key('log_empty')), findsNothing);

    await tester.tap(find.byKey(const Key('date_prev')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('log_empty')), findsOneWidget);
  });

  testWidgets('a logged entry can be deleted after confirmation', (
    tester,
  ) async {
    final NutritionHarness harness = await pumpNutrition(
      tester,
      const FoodLogScreen(),
    );
    await harness.repository.upsertLogEntry(buildLogEntry());

    // Reload the screen's day after the direct write.
    harness.container.invalidate(nutritionDayProvider('2026-11-05'));
    await tester.pumpAndSettle();
    await reveal(tester, find.byKey(const Key('log_entry_log-1')));
    expect(find.byKey(const Key('log_entry_log-1')), findsOneWidget);

    await tester.tap(find.byKey(const Key('delete_log_log-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm_delete_log')));
    await tester.pumpAndSettle();

    expect(await harness.repository.readLog('2026-11-05'), isEmpty);
    expect(find.byKey(const Key('log_empty')), findsOneWidget);
  });
}
