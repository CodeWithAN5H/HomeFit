import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/core/database/app_database.dart';
import 'package:homefit/features/nutrition/data/catalog/food_catalogue.dart';
import 'package:homefit/features/nutrition/data/catalog/recipe_catalogue.dart';
import 'package:homefit/features/nutrition/data/nutrition_repository.dart';
import 'package:homefit/features/nutrition/domain/food_item.dart';
import 'package:homefit/features/nutrition/domain/food_log.dart';
import 'package:homefit/features/nutrition/domain/grocery.dart';
import 'package:homefit/features/nutrition/domain/meal_plan.dart';
import 'package:homefit/features/nutrition/domain/meal_slot.dart';
import 'package:homefit/features/nutrition/domain/nutrition_day.dart';
import 'package:homefit/features/nutrition/domain/recipe.dart';

import '../../fixtures/nutrition_fixtures.dart';

void main() {
  late AppDatabase database;
  late DriftNutritionRepository repository;
  final Map<String, FoodItem> foods = FoodCatalogue.bundled().byIdMap;
  final Map<String, Recipe> recipes = RecipeCatalogue.bundled().byIdMap;

  setUp(() {
    database = AppDatabase.memory();
    repository = DriftNutritionRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('food log', () {
    test('entries round-trip with their frozen totals', () async {
      final LoggedFoodEntry entry = buildLogEntry();
      await repository.upsertLogEntry(entry);

      final List<LoggedFoodEntry> loaded = await repository.readLog(
        '2026-11-05',
      );
      expect(loaded, hasLength(1));
      expect(loaded.single.id, entry.id);
      expect(loaded.single.foodName, 'Banana');
      expect(loaded.single.slot, MealSlot.breakfast);
      expect(loaded.single.totals.kcal, closeTo(105.02, 0.01));
      expect(loaded.single.servingLabel, '1 medium');
      expect(
        loaded.single.loggedAt
            .toUtc()
            .difference(entry.loggedAt.toUtc())
            .inSeconds
            .abs(),
        lessThanOrEqualTo(1),
      );
    });

    test(
      'logging twice replaces the same entry instead of duplicating',
      () async {
        final LoggedFoodEntry entry = buildLogEntry();
        await repository.upsertLogEntry(entry);
        await repository.upsertLogEntry(entry.copyWith(amount: 236));

        final List<LoggedFoodEntry> loaded = await repository.readLog(
          '2026-11-05',
        );
        expect(loaded, hasLength(1));
        expect(loaded.single.amount, 236);
      },
    );

    test('logs are filtered by day and ordered by time', () async {
      await repository.upsertLogEntry(
        buildLogEntry(
          id: 'evening',
          loggedAt: DateTime(2026, 11, 5, 21),
          slot: MealSlot.dinner,
        ),
      );
      await repository.upsertLogEntry(
        buildLogEntry(id: 'morning', loggedAt: DateTime(2026, 11, 5, 8)),
      );
      await repository.upsertLogEntry(
        buildLogEntry(
          id: 'other-day',
          dateKey: '2026-11-04',
          loggedAt: DateTime(2026, 11, 4, 8),
        ),
      );

      final List<LoggedFoodEntry> today = await repository.readLog(
        '2026-11-05',
      );
      expect(today.map((LoggedFoodEntry e) => e.id), <String>[
        'morning',
        'evening',
      ]);
      expect(await repository.readLog('2026-11-04'), hasLength(1));
      expect(await repository.readLog('2026-11-06'), isEmpty);
    });

    test('deleting an entry removes only that entry', () async {
      await repository.upsertLogEntry(buildLogEntry(id: 'keep'));
      await repository.upsertLogEntry(buildLogEntry(id: 'drop'));
      await repository.deleteLogEntry('drop');
      final List<LoggedFoodEntry> loaded = await repository.readLog(
        '2026-11-05',
      );
      expect(loaded.map((LoggedFoodEntry e) => e.id), <String>['keep']);
    });
  });

  group('meal plan', () {
    test('plan items round-trip in order with servings', () async {
      await repository.upsertPlanItem(
        buildPlanItem(id: 'second', orderIndex: 1, amount: 40),
      );
      await repository.upsertPlanItem(
        buildPlanItem(id: 'first', orderIndex: 0),
      );

      final List<MealPlanItem> plan = await repository.readPlan('2026-11-05');
      expect(plan.map((MealPlanItem i) => i.id), <String>['first', 'second']);
      expect(plan.first.servingLabel, '2 rotis');
      expect(plan.first.kind, MealPlanItemKind.food);
    });

    test('replacing a day keeps other days intact', () async {
      await repository.upsertPlanItem(buildPlanItem(id: 'old'));
      await repository.upsertPlanItem(
        buildPlanItem(id: 'yesterday', dateKey: '2026-11-04'),
      );

      await repository.replacePlan('2026-11-05', <MealPlanItem>[
        buildPlanItem(id: 'new', slot: MealSlot.dinner),
      ]);

      final List<MealPlanItem> today = await repository.readPlan('2026-11-05');
      expect(today.map((MealPlanItem i) => i.id), <String>['new']);
      expect(await repository.readPlan('2026-11-04'), hasLength(1));
    });

    test('plans and logs stay independent', () async {
      await repository.upsertPlanItem(buildPlanItem());
      await repository.upsertLogEntry(buildLogEntry(id: 'eaten'));

      final NutritionDay day = NutritionDay(
        dateKey: '2026-11-05',
        plan: await repository.readPlan('2026-11-05'),
        log: await repository.readLog('2026-11-05'),
        foods: foods,
        recipes: recipes,
      );
      expect(day.plan, hasLength(1));
      expect(day.log, hasLength(1));
      expect(day.plannedTotals.kcal, closeTo(208, 0.5));
      expect(day.loggedTotals.kcal, closeTo(105.02, 0.01));

      await repository.replacePlan('2026-11-05', const <MealPlanItem>[]);
      expect(await repository.readLog('2026-11-05'), hasLength(1));
    });

    test('deleting a plan item leaves the rest', () async {
      await repository.upsertPlanItem(buildPlanItem(id: 'a'));
      await repository.upsertPlanItem(
        buildPlanItem(id: 'b', slot: MealSlot.dinner),
      );
      await repository.deletePlanItem('a');
      final List<MealPlanItem> plan = await repository.readPlan('2026-11-05');
      expect(plan.map((MealPlanItem i) => i.id), <String>['b']);
    });
  });

  group('saved plans', () {
    test(
      'a saved plan keeps its items and can be loaded on a new day',
      () async {
        final SavedMealPlan saved = SavedMealPlan(
          id: 'saved-1',
          name: 'Weekday basics',
          items: <MealPlanItem>[
            buildPlanItem(id: 'a').copyWith(dateKey: ''),
            buildPlanItem(
              id: 'b',
              slot: MealSlot.lunch,
              orderIndex: 1,
            ).copyWith(dateKey: ''),
          ],
          createdAt: DateTime.utc(2026, 11, 5, 8),
          updatedAt: DateTime.utc(2026, 11, 5, 8),
        );
        await repository.saveMealPlan(saved);

        final List<SavedMealPlan> loaded = await repository.readSavedPlans();
        expect(loaded, hasLength(1));
        expect(loaded.single.name, 'Weekday basics');
        expect(loaded.single.items.map((MealPlanItem i) => i.id), <String>[
          'a',
          'b',
        ]);
        expect(loaded.single.items.first.dateKey, isEmpty);
      },
    );

    test('deleting a saved plan removes its items', () async {
      await repository.saveMealPlan(
        SavedMealPlan(
          id: 'saved-2',
          name: 'Temp',
          items: <MealPlanItem>[buildPlanItem().copyWith(dateKey: '')],
          createdAt: DateTime.utc(2026, 11, 5),
          updatedAt: DateTime.utc(2026, 11, 5),
        ),
      );
      await repository.deleteSavedPlan('saved-2');

      expect(await repository.readSavedPlans(), isEmpty);
      expect(
        await database.select(database.savedMealPlanItemRows).get(),
        isEmpty,
      );
    });

    test('saving the same id replaces the stored copy', () async {
      final SavedMealPlan plan = SavedMealPlan(
        id: 'saved-3',
        name: 'First name',
        items: <MealPlanItem>[buildPlanItem().copyWith(dateKey: '')],
        createdAt: DateTime.utc(2026, 11, 1),
        updatedAt: DateTime.utc(2026, 11, 1),
      );
      await repository.saveMealPlan(plan);
      await repository.saveMealPlan(
        plan.copyWith(
          name: 'Renamed',
          items: <MealPlanItem>[
            buildPlanItem(id: 'x').copyWith(dateKey: ''),
            buildPlanItem(id: 'y').copyWith(dateKey: ''),
          ],
        ),
      );

      final List<SavedMealPlan> loaded = await repository.readSavedPlans();
      expect(loaded.single.name, 'Renamed');
      expect(loaded.single.items, hasLength(2));
    });
  });

  group('grocery checklist', () {
    test('checked state and manual lines persist', () async {
      await repository.replaceGrocery(<GroceryItem>[
        GroceryItem(
          id: 'plan-rice-white-cooked-g',
          name: 'White rice, cooked',
          checked: false,
          source: GrocerySource.plan,
          foodId: 'rice-white-cooked',
          amount: 400,
          unit: 'g',
          createdAt: DateTime.utc(2026, 11, 5, 8),
        ),
        GroceryItem(
          id: 'manual-1',
          name: 'Salt',
          checked: true,
          source: GrocerySource.manual,
          createdAt: DateTime.utc(2026, 11, 5, 9),
        ),
      ]);

      List<GroceryItem> loaded = await repository.readGrocery();
      expect(loaded, hasLength(2));
      expect(loaded[0].amountLabel, '400 g');
      expect(loaded[1].checked, isTrue);
      expect(loaded[1].source, GrocerySource.manual);

      await repository.replaceGrocery(<GroceryItem>[
        for (final GroceryItem item in loaded)
          if (item.id == 'plan-rice-white-cooked-g')
            item.copyWith(checked: true)
          else
            item,
      ]);

      loaded = await repository.readGrocery();
      expect(loaded.every((GroceryItem item) => item.checked), isTrue);
    });

    test('replacing the checklist removes previous lines', () async {
      await repository.replaceGrocery(<GroceryItem>[
        const GroceryItem(
          id: 'a',
          name: 'Old',
          checked: false,
          source: GrocerySource.manual,
        ),
      ]);
      await repository.replaceGrocery(const <GroceryItem>[]);
      expect(await repository.readGrocery(), isEmpty);
    });
  });
}
