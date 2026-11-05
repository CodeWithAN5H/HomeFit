import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/food_log.dart';
import '../domain/grocery.dart';
import '../domain/meal_plan.dart';
import 'nutrition_mappers.dart';

/// Storage contract for the nutrition feature.
///
/// Planned meals and actual logs are separate by design: editing a plan can
/// never rewrite what was eaten.
abstract interface class NutritionRepository {
  Future<List<LoggedFoodEntry>> readLog(String dateKey);

  Future<void> upsertLogEntry(LoggedFoodEntry entry);

  Future<void> deleteLogEntry(String id);

  Future<List<MealPlanItem>> readPlan(String dateKey);

  Future<void> upsertPlanItem(MealPlanItem item);

  Future<void> deletePlanItem(String id);

  /// Replaces one day's plan with [items] in a single transaction.
  Future<void> replacePlan(String dateKey, List<MealPlanItem> items);

  Future<List<SavedMealPlan>> readSavedPlans();

  Future<void> saveMealPlan(SavedMealPlan plan);

  Future<void> deleteSavedPlan(String id);

  Future<List<GroceryItem>> readGrocery();

  Future<void> replaceGrocery(List<GroceryItem> items);
}

class DriftNutritionRepository implements NutritionRepository {
  DriftNutritionRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<LoggedFoodEntry>> readLog(String dateKey) async {
    final List<FoodLogRow> rows =
        await (_database.select(_database.foodLogRows)
              ..where((t) => t.dateKey.equals(dateKey))
              ..orderBy([
                (t) => OrderingTerm.asc(t.loggedAt),
                (t) => OrderingTerm.asc(t.id),
              ]))
            .get();
    return rows.map(logEntryFromRow).toList(growable: false);
  }

  @override
  Future<void> upsertLogEntry(LoggedFoodEntry entry) async {
    await _database
        .into(_database.foodLogRows)
        .insertOnConflictUpdate(logEntryToRow(entry));
  }

  @override
  Future<void> deleteLogEntry(String id) async {
    await (_database.delete(
      _database.foodLogRows,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<MealPlanItem>> readPlan(String dateKey) async {
    final List<MealPlanItemRow> rows =
        await (_database.select(_database.mealPlanItemRows)
              ..where((t) => t.dateKey.equals(dateKey))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .get();
    return rows.map(planItemFromRow).toList(growable: false);
  }

  @override
  Future<void> upsertPlanItem(MealPlanItem item) async {
    await _database
        .into(_database.mealPlanItemRows)
        .insertOnConflictUpdate(planItemToRow(item));
  }

  @override
  Future<void> deletePlanItem(String id) async {
    await (_database.delete(
      _database.mealPlanItemRows,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> replacePlan(String dateKey, List<MealPlanItem> items) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.mealPlanItemRows,
      )..where((t) => t.dateKey.equals(dateKey))).go();
      for (final MealPlanItem item in items) {
        await _database
            .into(_database.mealPlanItemRows)
            .insert(planItemToRow(item.copyWith(dateKey: dateKey)));
      }
    });
  }

  @override
  Future<List<SavedMealPlan>> readSavedPlans() async {
    final List<SavedMealPlanRow> rows = await (_database.select(
      _database.savedMealPlanRows,
    )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).get();
    if (rows.isEmpty) return const <SavedMealPlan>[];

    final List<String> ids = rows
        .map((SavedMealPlanRow row) => row.id)
        .toList(growable: false);
    final List<SavedMealPlanItemRow> itemRows =
        await (_database.select(_database.savedMealPlanItemRows)
              ..where((t) => t.planId.isIn(ids))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .get();

    final Map<String, List<MealPlanItem>> itemsByPlan =
        <String, List<MealPlanItem>>{};
    for (final SavedMealPlanItemRow row in itemRows) {
      itemsByPlan
          .putIfAbsent(row.planId, () => <MealPlanItem>[])
          .add(savedItemFromRow(row));
    }

    return <SavedMealPlan>[
      for (final SavedMealPlanRow row in rows)
        SavedMealPlan(
          id: row.id,
          name: row.name,
          items: itemsByPlan[row.id] ?? const <MealPlanItem>[],
          createdAt: row.createdAt.toLocal(),
          updatedAt: row.updatedAt.toLocal(),
        ),
    ];
  }

  @override
  Future<void> saveMealPlan(SavedMealPlan plan) async {
    await _database.transaction(() async {
      await _database
          .into(_database.savedMealPlanRows)
          .insertOnConflictUpdate(
            SavedMealPlanRow(
              id: plan.id,
              name: plan.name,
              createdAt: plan.createdAt.toUtc(),
              updatedAt: plan.updatedAt.toUtc(),
            ),
          );
      await (_database.delete(
        _database.savedMealPlanItemRows,
      )..where((t) => t.planId.equals(plan.id))).go();
      for (final MealPlanItem item in plan.items) {
        await _database
            .into(_database.savedMealPlanItemRows)
            .insert(savedItemToRow(plan.id, item));
      }
    });
  }

  @override
  Future<void> deleteSavedPlan(String id) async {
    await (_database.delete(
      _database.savedMealPlanRows,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<GroceryItem>> readGrocery() async {
    final List<GroceryItemRow> rows = await (_database.select(
      _database.groceryItemRows,
    )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();
    return rows.map(groceryFromRow).toList(growable: false);
  }

  @override
  Future<void> replaceGrocery(List<GroceryItem> items) async {
    await _database.transaction(() async {
      await _database.delete(_database.groceryItemRows).go();
      for (final GroceryItem item in items) {
        await _database
            .into(_database.groceryItemRows)
            .insert(groceryToRow(item));
      }
    });
  }
}
