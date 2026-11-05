import 'meal_slot.dart';
import 'nutrition_totals.dart';
import 'nutrition_units.dart';

/// One food actually eaten, with the nutrition frozen at log time.
///
/// The values are snapshots rather than a live lookup: correcting or extending
/// the bundled catalogue later must not rewrite what a past day contained. The
/// food id is kept so entries can still be recognised and edited.
class LoggedFoodEntry {
  const LoggedFoodEntry({
    required this.id,
    required this.dateKey,
    required this.slot,
    required this.foodId,
    required this.foodName,
    required this.amount,
    required this.unit,
    required this.totals,
    required this.loggedAt,
    this.servingLabel,
  });

  final String id;
  final String dateKey;
  final MealSlot slot;
  final String foodId;
  final String foodName;

  /// Grams, millilitres, or servings depending on [unit].
  final double amount;
  final String unit;
  final String? servingLabel;
  final NutritionTotals totals;
  final DateTime loggedAt;

  String get amountLabel {
    final String quantity = formatQuantity(amount, unit);
    return servingLabel == null ? quantity : '$servingLabel · $quantity';
  }

  LoggedFoodEntry copyWith({
    MealSlot? slot,
    double? amount,
    String? servingLabel,
    bool clearServingLabel = false,
    NutritionTotals? totals,
    DateTime? loggedAt,
  }) {
    return LoggedFoodEntry(
      id: id,
      dateKey: dateKey,
      slot: slot ?? this.slot,
      foodId: foodId,
      foodName: foodName,
      amount: amount ?? this.amount,
      unit: unit,
      servingLabel: clearServingLabel
          ? null
          : (servingLabel ?? this.servingLabel),
      totals: totals ?? this.totals,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }
}
