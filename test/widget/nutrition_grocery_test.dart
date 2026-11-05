import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/nutrition/domain/meal_plan.dart';
import 'package:homefit/features/nutrition/domain/meal_slot.dart';
import 'package:homefit/features/nutrition/presentation/grocery_screen.dart';

import '../fixtures/nutrition_widget_harness.dart';

MealPlanItem riceItem({
  required String id,
  required double amount,
  MealSlot slot = MealSlot.lunch,
  int orderIndex = 0,
}) {
  return MealPlanItem(
    id: id,
    dateKey: '2026-11-05',
    slot: slot,
    kind: MealPlanItemKind.food,
    sourceId: 'rice-white-cooked',
    name: 'White rice, cooked',
    amount: amount,
    unit: 'g',
    orderIndex: orderIndex,
  );
}

void main() {
  testWidgets('a checklist is generated from the plan with duplicates merged', (
    tester,
  ) async {
    final NutritionHarness harness = await pumpNutrition(
      tester,
      const GroceryScreen(),
    );
    await harness.repository.upsertPlanItem(
      riceItem(id: 'rice-lunch', amount: 150),
    );
    await harness.repository.upsertPlanItem(
      riceItem(
        id: 'rice-dinner',
        amount: 250,
        slot: MealSlot.dinner,
        orderIndex: 1,
      ),
    );

    expect(find.byKey(const Key('grocery_empty')), findsOneWidget);

    await tester.tap(find.byKey(const Key('generate_grocery')));
    await tester.pumpAndSettle();

    expect(find.text('White rice, cooked'), findsOneWidget);
    expect(find.text('400 g'), findsOneWidget);
    expect(find.textContaining('1 of 1 still to buy'), findsOneWidget);

    final groceries = await harness.repository.readGrocery();
    expect(groceries, hasLength(1));
    expect(groceries.single.checked, isFalse);
  });

  testWidgets('items can be ticked, added manually and removed', (
    tester,
  ) async {
    final NutritionHarness harness = await pumpNutrition(
      tester,
      const GroceryScreen(),
    );

    await tester.tap(find.byKey(const Key('add_grocery_item')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('grocery_name_input')), 'Salt');
    await tester.tap(find.byKey(const Key('confirm_add_grocery')));
    await tester.pumpAndSettle();

    expect(find.text('Salt'), findsOneWidget);
    expect((await harness.repository.readGrocery()).single.name, 'Salt');

    await tester.tap(find.byKey(const Key('add_grocery_item')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('grocery_name_input')),
      'Lemon',
    );
    await tester.tap(find.byKey(const Key('confirm_add_grocery')));
    await tester.pumpAndSettle();

    final groceries = await harness.repository.readGrocery();
    expect(groceries, hasLength(2));
    final String saltId = groceries.firstWhere((g) => g.name == 'Salt').id;

    await tester.tap(find.byKey(Key('grocery_$saltId')));
    await tester.pumpAndSettle();
    final checked = await harness.repository.readGrocery();
    expect(checked.firstWhere((g) => g.id == saltId).checked, isTrue);
    expect(
      checked.where((g) => g.checked),
      hasLength(1),
      reason: 'the second item must stay unpurchased',
    );

    await tester.tap(find.byKey(Key('grocery_delete_$saltId')));
    await tester.pumpAndSettle();
    final remaining = await harness.repository.readGrocery();
    expect(remaining, hasLength(1));
    expect(remaining.single.name, 'Lemon');
  });

  testWidgets('clearing asks first and then empties the list', (tester) async {
    final NutritionHarness harness = await pumpNutrition(
      tester,
      const GroceryScreen(),
    );
    await harness.repository.upsertPlanItem(riceItem(id: 'rice', amount: 200));
    await tester.tap(find.byKey(const Key('generate_grocery')));
    await tester.pumpAndSettle();
    expect(await harness.repository.readGrocery(), hasLength(1));

    await tester.tap(find.byKey(const Key('clear_grocery')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm_clear_grocery')));
    await tester.pumpAndSettle();

    expect(await harness.repository.readGrocery(), isEmpty);
    expect(find.byKey(const Key('grocery_empty')), findsOneWidget);
  });

  testWidgets('generating from an empty plan changes nothing', (tester) async {
    final NutritionHarness harness = await pumpNutrition(
      tester,
      const GroceryScreen(),
    );

    await tester.tap(find.byKey(const Key('generate_grocery')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Nothing planned'), findsOneWidget);
    expect(await harness.repository.readGrocery(), isEmpty);
  });
}
