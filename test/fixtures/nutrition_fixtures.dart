import 'package:homefit/core/services/clock.dart';
import 'package:homefit/features/nutrition/data/catalog/food_catalogue.dart';
import 'package:homefit/features/nutrition/domain/food_item.dart';
import 'package:homefit/features/nutrition/domain/food_log.dart';
import 'package:homefit/features/nutrition/domain/meal_plan.dart';
import 'package:homefit/features/nutrition/domain/meal_slot.dart';
import 'package:homefit/features/nutrition/domain/nutrition_totals.dart';

/// Deterministic clock for nutrition tests.
class FixedClock implements Clock {
  const FixedClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

FoodCatalogue get testFoodCatalogue => FoodCatalogue.bundled();

FoodItem testFood(String id) {
  final FoodItem? food = testFoodCatalogue.byId(id);
  if (food == null) throw StateError('No bundled food with id $id');
  return food;
}

MealPlanItem buildPlanItem({
  String id = 'plan-1',
  String dateKey = '2026-11-05',
  MealSlot slot = MealSlot.breakfast,
  MealPlanItemKind kind = MealPlanItemKind.food,
  String sourceId = 'roti-whole-wheat',
  String? name,
  double amount = 80,
  String? unit,
  String? servingLabel = '2 rotis',
  int orderIndex = 0,
}) {
  final FoodItem? food = kind == MealPlanItemKind.food
      ? testFood(sourceId)
      : null;
  return MealPlanItem(
    id: id,
    dateKey: dateKey,
    slot: slot,
    kind: kind,
    sourceId: sourceId,
    name: name ?? food?.name ?? sourceId,
    amount: amount,
    unit: unit ?? food?.unit ?? 'serving',
    servingLabel: servingLabel,
    orderIndex: orderIndex,
  );
}

LoggedFoodEntry buildLogEntry({
  String id = 'log-1',
  String dateKey = '2026-11-05',
  MealSlot slot = MealSlot.breakfast,
  String foodId = 'banana',
  String foodName = 'Banana',
  double amount = 118,
  String? servingLabel = '1 medium',
  DateTime? loggedAt,
}) {
  final FoodItem food = testFood(foodId);
  final NutritionTotals totals = food.totalsFor(amount);
  return LoggedFoodEntry(
    id: id,
    dateKey: dateKey,
    slot: slot,
    foodId: foodId,
    foodName: foodName,
    amount: amount,
    unit: food.unit,
    servingLabel: servingLabel,
    totals: totals,
    loggedAt: loggedAt ?? DateTime(2026, 11, 5, 8, 30),
  );
}
