import 'meal_slot.dart';
import 'nutrition_units.dart';

/// Whether a planned item points at a bundled food or a recipe.
enum MealPlanItemKind {
  food,
  recipe;

  static MealPlanItemKind fromName(String? name) {
    for (final MealPlanItemKind kind in values) {
      if (kind.name == name) return kind;
    }
    return food;
  }
}

/// One item in a day's plan. Amount is grams/millilitres for food and servings
/// for a recipe; [unit] makes that explicit instead of guessing later.
class MealPlanItem {
  const MealPlanItem({
    required this.id,
    required this.dateKey,
    required this.slot,
    required this.kind,
    required this.sourceId,
    required this.name,
    required this.amount,
    required this.unit,
    required this.orderIndex,
    this.servingLabel,
  });

  final String id;

  /// Calendar day key (`yyyy-MM-dd`). Empty for items inside a saved template.
  final String dateKey;
  final MealSlot slot;
  final MealPlanItemKind kind;
  final String sourceId;
  final String name;
  final double amount;
  final String unit;
  final String? servingLabel;
  final int orderIndex;

  String get amountLabel {
    final String quantity = formatQuantity(amount, unit);
    return servingLabel == null ? quantity : '$servingLabel · $quantity';
  }

  MealPlanItem copyWith({
    MealSlot? slot,
    double? amount,
    String? servingLabel,
    bool clearServingLabel = false,
    int? orderIndex,
    String? dateKey,
  }) {
    return MealPlanItem(
      id: id,
      dateKey: dateKey ?? this.dateKey,
      slot: slot ?? this.slot,
      kind: kind,
      sourceId: sourceId,
      name: name,
      amount: amount ?? this.amount,
      unit: unit,
      servingLabel: clearServingLabel
          ? null
          : (servingLabel ?? this.servingLabel),
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}

/// A named plan that can be loaded onto another day.
class SavedMealPlan {
  const SavedMealPlan({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final List<MealPlanItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavedMealPlan copyWith({
    String? name,
    List<MealPlanItem>? items,
    DateTime? updatedAt,
  }) {
    return SavedMealPlan(
      id: id,
      name: name ?? this.name,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
