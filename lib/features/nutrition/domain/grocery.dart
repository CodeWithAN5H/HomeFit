import 'food_item.dart';
import 'meal_plan.dart';
import 'nutrition_units.dart';
import 'recipe.dart';

/// Where a checklist line came from.
enum GrocerySource {
  plan,
  manual;

  static GrocerySource fromName(String? name) {
    for (final GrocerySource source in values) {
      if (source.name == name) return source;
    }
    return manual;
  }
}

/// One grocery line. Manual lines carry no [foodId] and are never merged.
class GroceryItem {
  const GroceryItem({
    required this.id,
    required this.name,
    required this.checked,
    required this.source,
    this.foodId,
    this.amount,
    this.unit,
    this.createdAt,
  });

  final String id;
  final String name;
  final bool checked;
  final GrocerySource source;
  final String? foodId;
  final double? amount;
  final String? unit;
  final DateTime? createdAt;

  String get amountLabel {
    final double? value = amount;
    if (value == null || unit == null) return '';
    return formatQuantity(value, unit!);
  }

  GroceryItem copyWith({bool? checked, String? name, double? amount}) {
    return GroceryItem(
      id: id,
      name: name ?? this.name,
      checked: checked ?? this.checked,
      source: source,
      foodId: foodId,
      amount: amount ?? this.amount,
      unit: unit,
      createdAt: createdAt,
    );
  }
}

/// Turns a day's plan into shopping lines.
///
/// Foods are summed when the same food and unit appear more than once (for
/// example rice in two meals). Recipes are expanded into their ingredients at
/// the planned number of servings. Nothing is marked as purchased: the user
/// decides that in the shop.
abstract final class GroceryPlanner {
  static List<GroceryItem> build({
    required List<MealPlanItem> plan,
    required Map<String, FoodItem> foods,
    required Map<String, Recipe> recipes,
    DateTime? createdAt,
    String Function()? idFactory,
  }) {
    final Map<String, GroceryItem> merged = <String, GroceryItem>{};

    void add(String foodId, double amount, String unit) {
      final FoodItem? food = foods[foodId];
      if (food == null || amount <= 0) return;
      final String key = '$foodId|$unit';
      final GroceryItem? existing = merged[key];
      if (existing != null) {
        merged[key] = existing.copyWith(amount: existing.amount! + amount);
        return;
      }
      merged[key] = GroceryItem(
        id: idFactory?.call() ?? 'plan-$foodId-$unit',
        name: food.name,
        checked: false,
        source: GrocerySource.plan,
        foodId: foodId,
        amount: amount,
        unit: unit,
        createdAt: createdAt,
      );
    }

    for (final MealPlanItem item in plan) {
      if (item.kind == MealPlanItemKind.food) {
        add(item.sourceId, item.amount, item.unit);
        continue;
      }
      final Recipe? recipe = recipes[item.sourceId];
      if (recipe == null || recipe.servings <= 0) continue;
      final double factor = item.amount / recipe.servings;
      for (final RecipeIngredient ingredient in recipe.ingredients) {
        final FoodItem? food = foods[ingredient.foodId];
        if (food == null) continue;
        add(ingredient.foodId, ingredient.amount * factor, food.unit);
      }
    }

    final List<GroceryItem> lines = merged.values.toList()
      ..sort((GroceryItem a, GroceryItem b) => a.name.compareTo(b.name));
    return lines;
  }
}
