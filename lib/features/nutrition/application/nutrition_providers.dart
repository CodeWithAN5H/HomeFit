import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/clock.dart';
import '../../profile/application/profile_providers.dart';
import '../../profile/domain/user_profile.dart';
import '../data/catalog/food_catalogue.dart';
import '../data/catalog/recipe_catalogue.dart';
import '../data/nutrition_repository.dart';
import '../domain/food_item.dart';
import '../domain/food_log.dart';
import '../domain/grocery.dart';
import '../domain/meal_plan.dart';
import '../domain/meal_slot.dart';
import '../domain/nutrition_day.dart';
import '../domain/nutrition_targets.dart';
import '../domain/nutrition_totals.dart';
import '../domain/nutrition_units.dart';
import '../domain/recipe.dart';

/// Local storage for logs, plans and the grocery checklist.
final nutritionRepositoryProvider = Provider<NutritionRepository>(
  (ref) => DriftNutritionRepository(ref.watch(appDatabaseProvider)),
);

final foodCatalogueProvider = Provider<FoodCatalogue>(
  (ref) => FoodCatalogue.bundled(),
);

final recipeCatalogueProvider = Provider<RecipeCatalogue>(
  (ref) => RecipeCatalogue.bundled(),
);

/// Targets are derived from the saved profile, never stored separately, so
/// editing the profile updates them immediately.
final nutritionTargetsProvider = Provider<NutritionTargets>((ref) {
  final UserProfile? profile = ref.watch(profileControllerProvider);
  if (profile == null) {
    return const NutritionTargets.unavailable(
      'Save your profile to see estimated nutrition targets.',
    );
  }
  return NutritionTargets.estimate(profile);
});

/// A calendar day key (`yyyy-MM-dd`). Kept as text so a late-night meal never
/// moves to the next day after midnight.
final nutritionDayKeyProvider = Provider<String>((ref) {
  return dateKeyFor(ref.watch(clockProvider).now());
});

/// Everything planned and logged for one day, resolved against the catalogue.
final nutritionDayProvider = FutureProvider.family<NutritionDay, String>((
  ref,
  String dateKey,
) async {
  final NutritionRepository repository = ref.watch(nutritionRepositoryProvider);
  final List<MealPlanItem> plan = await repository.readPlan(dateKey);
  final List<LoggedFoodEntry> log = await repository.readLog(dateKey);
  return NutritionDay(
    dateKey: dateKey,
    plan: plan,
    log: log,
    foods: ref.watch(foodCatalogueProvider).byIdMap,
    recipes: ref.watch(recipeCatalogueProvider).byIdMap,
  );
});

final savedMealPlansProvider = FutureProvider<List<SavedMealPlan>>((ref) {
  return ref.watch(nutritionRepositoryProvider).readSavedPlans();
});

final groceryProvider = FutureProvider<List<GroceryItem>>((ref) {
  return ref.watch(nutritionRepositoryProvider).readGrocery();
});

/// Screens call these methods instead of touching the repository, so every
/// write invalidates exactly the day and list that changed.
final nutritionActionsProvider = Provider<NutritionActions>(
  (ref) => NutritionActions(ref),
);

class NutritionActions {
  NutritionActions(this._ref);

  final Ref _ref;
  static int _sequence = 0;

  NutritionRepository get _repository => _ref.read(nutritionRepositoryProvider);
  Clock get _clock => _ref.read(clockProvider);
  FoodCatalogue get _foods => _ref.read(foodCatalogueProvider);

  String _id(String prefix) {
    _sequence++;
    return '$prefix-${_clock.now().microsecondsSinceEpoch}-$_sequence';
  }

  void _invalidateDay(String dateKey) {
    _ref.invalidate(nutritionDayProvider(dateKey));
  }

  // ------------------------------------------------------------------- log
  Future<void> addFoodToLog({
    required String dateKey,
    required MealSlot slot,
    required FoodItem food,
    required double amount,
    String? servingLabel,
  }) async {
    final double safeAmount = amount <= 0 ? 100 : amount;
    final LoggedFoodEntry entry = LoggedFoodEntry(
      id: _id('log'),
      dateKey: dateKey,
      slot: slot,
      foodId: food.id,
      foodName: food.name,
      amount: safeAmount,
      unit: food.unit,
      servingLabel: servingLabel,
      totals: food.totalsFor(safeAmount),
      loggedAt: _clock.now(),
    );
    await _repository.upsertLogEntry(entry);
    _invalidateDay(dateKey);
  }

  Future<void> updateLogEntry(
    LoggedFoodEntry entry, {
    required double amount,
    String? servingLabel,
    bool clearServingLabel = false,
  }) async {
    final double safeAmount = amount <= 0 ? entry.amount : amount;
    final FoodItem? food = _foods.byId(entry.foodId);
    final NutritionTotals totals = food != null
        ? food.totalsFor(safeAmount)
        : entry.totals.scale(safeAmount / entry.amount);
    await _repository.upsertLogEntry(
      entry.copyWith(
        amount: safeAmount,
        servingLabel: servingLabel,
        clearServingLabel: clearServingLabel,
        totals: totals,
        loggedAt: _clock.now(),
      ),
    );
    _invalidateDay(entry.dateKey);
  }

  Future<void> deleteLogEntry(LoggedFoodEntry entry) async {
    await _repository.deleteLogEntry(entry.id);
    _invalidateDay(entry.dateKey);
  }

  // ------------------------------------------------------------------ plan
  Future<void> addFoodToPlan({
    required String dateKey,
    required MealSlot slot,
    required FoodItem food,
    required double amount,
    String? servingLabel,
  }) async {
    final List<MealPlanItem> plan = await _repository.readPlan(dateKey);
    final int nextIndex = plan.isEmpty
        ? 0
        : plan.map((MealPlanItem item) => item.orderIndex).reduce(max) + 1;
    await _repository.upsertPlanItem(
      MealPlanItem(
        id: _id('plan'),
        dateKey: dateKey,
        slot: slot,
        kind: MealPlanItemKind.food,
        sourceId: food.id,
        name: food.name,
        amount: amount <= 0 ? 100 : amount,
        unit: food.unit,
        servingLabel: servingLabel,
        orderIndex: nextIndex,
      ),
    );
    _invalidateDay(dateKey);
  }

  Future<void> addRecipeToPlan({
    required String dateKey,
    required MealSlot slot,
    required Recipe recipe,
    double servings = 1,
  }) async {
    final List<MealPlanItem> plan = await _repository.readPlan(dateKey);
    final int nextIndex = plan.isEmpty
        ? 0
        : plan.map((MealPlanItem item) => item.orderIndex).reduce(max) + 1;
    await _repository.upsertPlanItem(
      MealPlanItem(
        id: _id('plan'),
        dateKey: dateKey,
        slot: slot,
        kind: MealPlanItemKind.recipe,
        sourceId: recipe.id,
        name: recipe.title,
        amount: servings <= 0 ? 1 : servings,
        unit: 'serving',
        orderIndex: nextIndex,
      ),
    );
    _invalidateDay(dateKey);
  }

  Future<void> updatePlanAmount(
    MealPlanItem item, {
    required double amount,
    String? servingLabel,
    bool clearServingLabel = false,
  }) async {
    if (amount <= 0) return;
    await _repository.upsertPlanItem(
      item.copyWith(
        amount: amount,
        servingLabel: servingLabel,
        clearServingLabel: clearServingLabel,
      ),
    );
    _invalidateDay(item.dateKey);
  }

  Future<void> removePlanItem(MealPlanItem item) async {
    await _repository.deletePlanItem(item.id);
    _invalidateDay(item.dateKey);
  }

  Future<void> clearPlan(String dateKey) async {
    await _repository.replacePlan(dateKey, const <MealPlanItem>[]);
    _invalidateDay(dateKey);
  }

  // ---------------------------------------------------------- saved plans
  Future<SavedMealPlan?> savePlanAs({
    required String dateKey,
    required String name,
  }) async {
    final List<MealPlanItem> plan = await _repository.readPlan(dateKey);
    if (plan.isEmpty) return null;
    final DateTime now = _clock.now();
    final SavedMealPlan saved = SavedMealPlan(
      id: _id('saved-plan'),
      name: name.trim().isEmpty ? 'My meal plan' : name.trim(),
      items: plan,
      createdAt: now,
      updatedAt: now,
    );
    await _repository.saveMealPlan(saved);
    _ref.invalidate(savedMealPlansProvider);
    return saved;
  }

  Future<void> loadSavedPlan(SavedMealPlan plan, String dateKey) async {
    final List<MealPlanItem> items = <MealPlanItem>[
      for (int index = 0; index < plan.items.length; index++)
        plan.items[index].copyWith(dateKey: dateKey, orderIndex: index),
    ];
    // Reloaded items need their own ids so two copies can coexist historically.
    final List<MealPlanItem> recreated = <MealPlanItem>[
      for (final MealPlanItem item in items)
        MealPlanItem(
          id: _id('plan'),
          dateKey: dateKey,
          slot: item.slot,
          kind: item.kind,
          sourceId: item.sourceId,
          name: item.name,
          amount: item.amount,
          unit: item.unit,
          servingLabel: item.servingLabel,
          orderIndex: item.orderIndex,
        ),
    ];
    await _repository.replacePlan(dateKey, recreated);
    _invalidateDay(dateKey);
  }

  Future<void> deleteSavedPlan(String id) async {
    await _repository.deleteSavedPlan(id);
    _ref.invalidate(savedMealPlansProvider);
  }

  // -------------------------------------------------------------- grocery
  Future<int> generateGroceryFromPlan(String dateKey) async {
    final List<MealPlanItem> plan = await _repository.readPlan(dateKey);
    final List<GroceryItem> existing = await _repository.readGrocery();
    final List<GroceryItem> generated = GroceryPlanner.build(
      plan: plan,
      foods: _foods.byIdMap,
      recipes: _ref.read(recipeCatalogueProvider).byIdMap,
      createdAt: _clock.now(),
    );
    // Keep completed checks and hand-added lines; replace only generated ones.
    final Map<String, GroceryItem> previousGenerated = <String, GroceryItem>{
      for (final GroceryItem item in existing)
        if (item.source == GrocerySource.plan) item.id: item,
    };
    final List<GroceryItem> next = <GroceryItem>[
      for (final GroceryItem item in existing)
        if (item.source == GrocerySource.manual) item,
      for (final GroceryItem item in generated)
        previousGenerated[item.id]?.checked == true
            ? item.copyWith(checked: true)
            : item,
    ];
    await _repository.replaceGrocery(next);
    _ref.invalidate(groceryProvider);
    return generated.length;
  }

  Future<void> setGroceryChecked(GroceryItem item, bool checked) async {
    final List<GroceryItem> existing = await _repository.readGrocery();
    await _repository.replaceGrocery(<GroceryItem>[
      for (final GroceryItem row in existing)
        if (row.id == item.id) row.copyWith(checked: checked) else row,
    ]);
    _ref.invalidate(groceryProvider);
  }

  Future<void> addManualGrocery(String name) async {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final List<GroceryItem> existing = await _repository.readGrocery();
    await _repository.replaceGrocery(<GroceryItem>[
      ...existing,
      GroceryItem(
        id: _id('grocery'),
        name: trimmed,
        checked: false,
        source: GrocerySource.manual,
        createdAt: _clock.now(),
      ),
    ]);
    _ref.invalidate(groceryProvider);
  }

  Future<void> removeGroceryItem(GroceryItem item) async {
    final List<GroceryItem> existing = await _repository.readGrocery();
    await _repository.replaceGrocery(<GroceryItem>[
      for (final GroceryItem row in existing)
        if (row.id != item.id) row,
    ]);
    _ref.invalidate(groceryProvider);
  }

  Future<void> clearGrocery() async {
    await _repository.replaceGrocery(const <GroceryItem>[]);
    _ref.invalidate(groceryProvider);
  }
}
