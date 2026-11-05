import 'food_item.dart';
import 'food_log.dart';
import 'meal_plan.dart';
import 'meal_slot.dart';
import 'nutrition_totals.dart';
import 'recipe.dart';

/// One calendar day of nutrition: what was planned and what was logged.
///
/// The two lists stay separate on purpose. Editing a plan must never rewrite
/// what the user recorded eating, and logging food never changes the plan.
class NutritionDay {
  const NutritionDay({
    required this.dateKey,
    required this.plan,
    required this.log,
    required this.foods,
    required this.recipes,
  });

  final String dateKey;
  final List<MealPlanItem> plan;
  final List<LoggedFoodEntry> log;
  final Map<String, FoodItem> foods;
  final Map<String, Recipe> recipes;

  bool get hasPlan => plan.isNotEmpty;
  bool get hasLog => log.isNotEmpty;

  NutritionTotals get plannedTotals {
    NutritionTotals total = NutritionTotals.zero;
    for (final MealPlanItem item in plan) {
      total = total + totalsForPlanItem(item, foods, recipes);
    }
    return total;
  }

  NutritionTotals get loggedTotals {
    NutritionTotals total = NutritionTotals.zero;
    for (final LoggedFoodEntry entry in log) {
      total = total + entry.totals;
    }
    return total;
  }

  List<MealPlanItem> planFor(MealSlot slot) =>
      <MealPlanItem>[
        for (final MealPlanItem item in plan)
          if (item.slot == slot) item,
      ]..sort(
        (MealPlanItem a, MealPlanItem b) =>
            a.orderIndex.compareTo(b.orderIndex),
      );

  List<LoggedFoodEntry> logFor(MealSlot slot) => <LoggedFoodEntry>[
    for (final LoggedFoodEntry entry in log)
      if (entry.slot == slot) entry,
  ];

  NutritionTotals plannedTotalsFor(MealSlot slot) {
    NutritionTotals total = NutritionTotals.zero;
    for (final MealPlanItem item in planFor(slot)) {
      total = total + totalsForPlanItem(item, foods, recipes);
    }
    return total;
  }

  NutritionTotals loggedTotalsFor(MealSlot slot) {
    NutritionTotals total = NutritionTotals.zero;
    for (final LoggedFoodEntry entry in logFor(slot)) {
      total = total + entry.totals;
    }
    return total;
  }
}

/// Resolves a planned food or recipe into estimated nutrition.
NutritionTotals totalsForPlanItem(
  MealPlanItem item,
  Map<String, FoodItem> foods,
  Map<String, Recipe> recipes,
) {
  if (item.kind == MealPlanItemKind.food) {
    final FoodItem? food = foods[item.sourceId];
    return food == null ? NutritionTotals.zero : food.totalsFor(item.amount);
  }
  final Recipe? recipe = recipes[item.sourceId];
  return recipe == null
      ? NutritionTotals.zero
      : recipe.nutritionFor(foods, servings: item.amount);
}
