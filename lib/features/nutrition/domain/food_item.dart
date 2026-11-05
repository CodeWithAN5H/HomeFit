import 'nutrition_totals.dart';

/// Human-readable grouping used by the food picker.
enum FoodCategory {
  grains('Grains & starches'),
  legumes('Dals, beans & soy'),
  dairy('Milk & dairy'),
  nutsSeeds('Nuts, seeds & chana'),
  vegetables('Vegetables'),
  fruits('Fruits'),
  prepared('Prepared dishes'),
  fats('Oils & ghee'),
  drinks('Drinks');

  const FoodCategory(this.label);

  final String label;
}

/// Whether the values describe the food raw, cooked or as a prepared dish.
///
/// The distinction matters: 100 g of dry rice and 100 g of cooked rice differ
/// by roughly a factor of three, so every entry says which one it is.
enum FoodState {
  raw('Raw'),
  cooked('Cooked'),
  prepared('Prepared');

  const FoodState(this.label);

  final String label;
}

/// A real household portion: one roti, one katori, one glass.
class ServingPreset {
  const ServingPreset(this.label, this.amount);

  final String label;

  /// Grams for solids, millilitres for liquids.
  final double amount;
}

/// One bundled food with values per 100 g or 100 ml.
///
/// Arabic numerals are used for quantities because the app formats them; the
/// labels stay short enough to fit a chip.
class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.state,
    required this.per100,
    required this.servings,
    this.isLiquid = false,
    this.note,
    this.source = kTypicalFoodSource,
    this.isEstimated = true,
  });

  /// Stable slug. Food logs and plans store this id, so it must never change.
  final String id;
  final String name;
  final FoodCategory category;
  final FoodState state;

  /// Energy and macros per 100 g, or per 100 ml when [isLiquid].
  final NutritionTotals per100;
  final List<ServingPreset> servings;
  final bool isLiquid;
  final String? note;

  /// Where the figures came from, shown to the user with the estimate label.
  final String source;

  /// True when the values are rounded reference figures rather than a
  /// laboratory measurement of this exact dish.
  final bool isEstimated;

  String get unit => isLiquid ? 'ml' : 'g';

  String get baseLabel => 'per 100 $unit';

  NutritionTotals totalsFor(double amount) => per100.scale(amount / 100);

  NutritionTotals totalsForServing(ServingPreset serving) =>
      totalsFor(serving.amount);

  bool matches(String query) {
    final String needle = query.trim().toLowerCase();
    if (needle.isEmpty) return true;
    return name.toLowerCase().contains(needle) ||
        category.label.toLowerCase().contains(needle) ||
        (note?.toLowerCase().contains(needle) ?? false);
  }
}

/// Every bundled entry uses this attribution unless it says otherwise.
const String kTypicalFoodSource =
    'Typical values from IFCT 2017 / USDA FoodData Central, rounded';

/// The diet this build plans for: vegetarian, no eggs.
const String kDietLabel = 'Vegetarian · no eggs';
