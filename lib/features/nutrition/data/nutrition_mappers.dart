import '../../../core/database/app_database.dart';
import '../domain/food_log.dart';
import '../domain/grocery.dart';
import '../domain/meal_plan.dart';
import '../domain/meal_slot.dart';
import '../domain/nutrition_totals.dart';

/// Row ↔ domain conversion for nutrition storage.
FoodLogRow logEntryToRow(LoggedFoodEntry entry) => FoodLogRow(
  id: entry.id,
  dateKey: entry.dateKey,
  slot: entry.slot.name,
  foodId: entry.foodId,
  foodName: entry.foodName,
  amount: entry.amount,
  unit: entry.unit,
  servingLabel: entry.servingLabel,
  kcal: entry.totals.kcal,
  proteinG: entry.totals.proteinG,
  carbsG: entry.totals.carbsG,
  fatG: entry.totals.fatG,
  loggedAt: entry.loggedAt.toUtc(),
);

LoggedFoodEntry logEntryFromRow(FoodLogRow row) => LoggedFoodEntry(
  id: row.id,
  dateKey: row.dateKey,
  slot: MealSlot.fromName(row.slot),
  foodId: row.foodId,
  foodName: row.foodName,
  amount: row.amount,
  unit: row.unit,
  servingLabel: row.servingLabel,
  totals: NutritionTotals(
    kcal: row.kcal,
    proteinG: row.proteinG,
    carbsG: row.carbsG,
    fatG: row.fatG,
  ),
  loggedAt: row.loggedAt.toLocal(),
);

MealPlanItemRow planItemToRow(MealPlanItem item, {DateTime? createdAt}) =>
    MealPlanItemRow(
      id: item.id,
      dateKey: item.dateKey,
      slot: item.slot.name,
      kind: item.kind.name,
      sourceId: item.sourceId,
      name: item.name,
      amount: item.amount,
      unit: item.unit,
      servingLabel: item.servingLabel,
      orderIndex: item.orderIndex,
      createdAt: (createdAt ?? DateTime.now()).toUtc(),
    );

MealPlanItem planItemFromRow(MealPlanItemRow row) => MealPlanItem(
  id: row.id,
  dateKey: row.dateKey,
  slot: MealSlot.fromName(row.slot),
  kind: MealPlanItemKind.fromName(row.kind),
  sourceId: row.sourceId,
  name: row.name,
  amount: row.amount,
  unit: row.unit,
  servingLabel: row.servingLabel,
  orderIndex: row.orderIndex,
);

SavedMealPlanItemRow savedItemToRow(String planId, MealPlanItem item) =>
    SavedMealPlanItemRow(
      id: item.id,
      planId: planId,
      slot: item.slot.name,
      kind: item.kind.name,
      sourceId: item.sourceId,
      name: item.name,
      amount: item.amount,
      unit: item.unit,
      servingLabel: item.servingLabel,
      orderIndex: item.orderIndex,
    );

MealPlanItem savedItemFromRow(SavedMealPlanItemRow row) => MealPlanItem(
  id: row.id,
  dateKey: '',
  slot: MealSlot.fromName(row.slot),
  kind: MealPlanItemKind.fromName(row.kind),
  sourceId: row.sourceId,
  name: row.name,
  amount: row.amount,
  unit: row.unit,
  servingLabel: row.servingLabel,
  orderIndex: row.orderIndex,
);

GroceryItemRow groceryToRow(GroceryItem item) => GroceryItemRow(
  id: item.id,
  name: item.name,
  foodId: item.foodId,
  amount: item.amount,
  unit: item.unit,
  checked: item.checked,
  source: item.source.name,
  createdAt: item.createdAt?.toUtc() ?? DateTime.now().toUtc(),
);

GroceryItem groceryFromRow(GroceryItemRow row) => GroceryItem(
  id: row.id,
  name: row.name,
  foodId: row.foodId,
  amount: row.amount,
  unit: row.unit,
  checked: row.checked,
  source: GrocerySource.fromName(row.source),
  createdAt: row.createdAt?.toLocal(),
);
