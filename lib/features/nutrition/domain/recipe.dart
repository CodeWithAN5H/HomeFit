import 'food_item.dart';
import 'nutrition_totals.dart';

/// Dietary and practical tags shown as filters and on recipe cards.
enum RecipeTag {
  highProtein('High protein'),
  quick('Under 20 min'),
  breakfast('Breakfast'),
  snack('Snack'),
  glutenFree('Gluten-free'),
  lactoseFree('Lactose-free'),
  nutFree('Nut-free');

  const RecipeTag(this.label);

  final String label;
}

/// One ingredient quantity. Amounts are grams (or millilitres for liquids).
class RecipeIngredient {
  const RecipeIngredient({required this.foodId, required this.amount});

  final String foodId;
  final double amount;
}

/// A bundled home recipe.
///
/// Nutrition is not stored on the recipe: it is computed from the ingredient
/// foods, so values stay consistent with the catalogue and the per-serving
/// figure can never silently disagree with the ingredients.
class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.servings,
    required this.prepMinutes,
    required this.ingredients,
    required this.steps,
    required this.tags,
    this.note,
  });

  final String id;
  final String title;
  final String description;

  /// Number of servings the ingredient list produces.
  final int servings;
  final int prepMinutes;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final Set<RecipeTag> tags;
  final String? note;

  NutritionTotals totalNutrition(Map<String, FoodItem> foods) {
    NutritionTotals total = NutritionTotals.zero;
    for (final RecipeIngredient ingredient in ingredients) {
      final FoodItem? food = foods[ingredient.foodId];
      if (food == null) continue;
      total = total + food.totalsFor(ingredient.amount);
    }
    return total;
  }

  /// One serving, or [servings] servings when scaled.
  NutritionTotals nutritionFor(
    Map<String, FoodItem> foods, {
    double servings = 1,
  }) {
    if (this.servings <= 0) return NutritionTotals.zero;
    return totalNutrition(foods).scale(servings / this.servings);
  }

  bool matches(String query) {
    final String needle = query.trim().toLowerCase();
    if (needle.isEmpty) return true;
    return title.toLowerCase().contains(needle) ||
        description.toLowerCase().contains(needle) ||
        tags.any((RecipeTag tag) => tag.label.toLowerCase().contains(needle));
  }
}
