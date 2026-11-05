import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/nutrition_providers.dart';
import '../domain/food_item.dart';
import '../domain/meal_plan.dart';
import '../domain/meal_slot.dart';
import '../domain/nutrition_day.dart';
import '../domain/nutrition_totals.dart';
import '../domain/nutrition_units.dart';
import '../domain/recipe.dart';
import 'widgets/food_picker.dart';
import 'widgets/nutrition_widgets.dart';
import 'widgets/recipe_picker.dart';

/// Plan one day's meals. Nothing here touches the food log: planned food is an
/// intention, logged food is a record.
class MealPlanScreen extends ConsumerStatefulWidget {
  const MealPlanScreen({super.key});

  @override
  ConsumerState<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends ConsumerState<MealPlanScreen> {
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _date = dateFromKey(ref.read(nutritionDayKeyProvider));
  }

  String get _key => dateKeyFor(_date);
  String get _todayKey => ref.read(nutritionDayKeyProvider);

  @override
  Widget build(BuildContext context) {
    final AsyncValue<NutritionDay> async = ref.watch(
      nutritionDayProvider(_key),
    );
    final NutritionDay? day = async.value;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Meal plan')),
      body: ListView(
        padding: kPagePadding,
        children: <Widget>[
          NutritionDateBar(
            dateKey: _key,
            todayKey: _todayKey,
            onChanged: (String key) => setState(() => _date = dateFromKey(key)),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            key: const Key('plan_totals'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Planned for this day',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const EstimateBadge(),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (day == null)
                  const LinearProgressIndicator()
                else
                  MacroSummary(totals: day.plannedTotals),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final MealSlot slot in MealSlot.values) ...<Widget>[
            _SlotCard(
              slot: slot,
              items: day?.planFor(slot) ?? const <MealPlanItem>[],
              totals: day?.plannedTotalsFor(slot) ?? NutritionTotals.zero,
              onAddFood: () => _addFood(slot),
              onAddRecipe: () => _addRecipe(slot),
              onEdit: _editItem,
              onRemove: _removeItem,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          if (day != null && !day.hasPlan)
            AppCard(
              key: const Key('plan_empty'),
              child: Text(
                'Nothing planned for this day. Add a food or a recipe to a '
                'meal, then save the plan or turn it into a grocery list.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton(
            key: const Key('save_plan'),
            onPressed: () => _savePlan(day),
            child: const Text('Save this plan'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  key: const Key('open_saved_plans'),
                  onPressed: _openSavedPlans,
                  child: const Text('Saved plans'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  key: const Key('create_grocery'),
                  onPressed: _createGrocery,
                  child: const Text('Grocery list'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Saving a plan stores a reusable copy; loading it later replaces '
            'this day’s plan only. Logged food is never changed.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addFood(MealSlot slot) async {
    final FoodItem? food = await showFoodPicker(
      context,
      title: 'Add to ${slot.label.toLowerCase()}',
    );
    if (food == null || !mounted) return;
    final FoodAmount? amount = await showAmountSheet(context, food);
    if (amount == null || !mounted) return;
    await ref
        .read(nutritionActionsProvider)
        .addFoodToPlan(
          dateKey: _key,
          slot: slot,
          food: amount.food,
          amount: amount.amount,
          servingLabel: amount.servingLabel,
        );
    if (!mounted) return;
    _snack('${food.name} added to ${slot.label.toLowerCase()}.');
  }

  Future<void> _addRecipe(MealSlot slot) async {
    final Recipe? recipe = await showRecipePicker(context);
    if (recipe == null || !mounted) return;
    final double? servings = await showServingSheet(
      context,
      title: recipe.title,
    );
    if (servings == null || !mounted) return;
    await ref
        .read(nutritionActionsProvider)
        .addRecipeToPlan(
          dateKey: _key,
          slot: slot,
          recipe: recipe,
          servings: servings,
        );
    if (!mounted) return;
    _snack('${recipe.title} added to ${slot.label.toLowerCase()}.');
  }

  Future<void> _editItem(MealPlanItem item) async {
    if (item.kind == MealPlanItemKind.food) {
      final FoodItem? food = ref
          .read(foodCatalogueProvider)
          .byId(item.sourceId);
      if (food == null) {
        _snack('This food is no longer in the catalogue.');
        return;
      }
      final FoodAmount? amount = await showAmountSheet(
        context,
        food,
        initialAmount: item.amount,
        initialLabel: item.servingLabel,
      );
      if (amount == null || !mounted) return;
      await ref
          .read(nutritionActionsProvider)
          .updatePlanAmount(
            item,
            amount: amount.amount,
            servingLabel: amount.servingLabel,
          );
      return;
    }
    final double? servings = await showServingSheet(
      context,
      title: item.name,
      initial: item.amount,
    );
    if (servings == null || !mounted) return;
    await ref
        .read(nutritionActionsProvider)
        .updatePlanAmount(item, amount: servings);
  }

  Future<void> _removeItem(MealPlanItem item) async {
    await ref.read(nutritionActionsProvider).removePlanItem(item);
  }

  Future<void> _savePlan(NutritionDay? day) async {
    if (day == null || !day.hasPlan) {
      _snack('Add something to the plan first.');
      return;
    }
    final String? name = await showTextPrompt(
      context,
      title: 'Save this plan',
      label: 'Plan name',
      fieldKey: const Key('plan_name_input'),
      confirmKey: const Key('confirm_save_plan'),
      initial: 'Plan for ${DateFormat('d MMM').format(_date)}',
    );
    if (name == null || !mounted) return;
    final SavedMealPlan? saved = await ref
        .read(nutritionActionsProvider)
        .savePlanAs(dateKey: _key, name: name);
    if (!mounted) return;
    _snack(saved == null ? 'Add something first.' : 'Plan saved.');
  }

  Future<void> _openSavedPlans() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext sheetContext) => Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final AsyncValue<List<SavedMealPlan>> async = ref.watch(
            savedMealPlansProvider,
          );
          final List<SavedMealPlan> plans =
              async.value ?? const <SavedMealPlan>[];
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Saved plans',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (plans.isEmpty)
                    const Text('No saved plans yet.')
                  else
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          for (final SavedMealPlan plan in plans)
                            ListTile(
                              key: Key('saved_plan_${plan.id}'),
                              title: Text(plan.name),
                              subtitle: Text('${plan.items.length} items'),
                              trailing: IconButton(
                                key: Key('delete_saved_plan_${plan.id}'),
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () async {
                                  await ref
                                      .read(nutritionActionsProvider)
                                      .deleteSavedPlan(plan.id);
                                },
                              ),
                              onTap: () async {
                                Navigator.of(sheetContext).pop();
                                await ref
                                    .read(nutritionActionsProvider)
                                    .loadSavedPlan(plan, _key);
                                if (!mounted) return;
                                _snack('Loaded “${plan.name}”.');
                              },
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _createGrocery() async {
    final int count = await ref
        .read(nutritionActionsProvider)
        .generateGroceryFromPlan(_key);
    if (!mounted) return;
    _snack(
      count == 0
          ? 'Nothing planned for this day to turn into a list.'
          : 'Grocery list updated · $count items.',
    );
    if (count > 0 && mounted) context.push(AppRoutes.nutritionGrocery);
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.slot,
    required this.items,
    required this.totals,
    required this.onAddFood,
    required this.onAddRecipe,
    required this.onEdit,
    required this.onRemove,
  });

  final MealSlot slot;
  final List<MealPlanItem> items;
  final NutritionTotals totals;
  final VoidCallback onAddFood;
  final VoidCallback onAddRecipe;
  final ValueChanged<MealPlanItem> onEdit;
  final ValueChanged<MealPlanItem> onRemove;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppCard(
      key: Key('plan_slot_${slot.name}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(iconForSlot(slot.name), size: 18, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(slot.label, style: theme.textTheme.titleMedium),
              ),
              Text(
                '≈ ${totals.kcal.round()} kcal',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                'Nothing planned.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            for (final MealPlanItem item in items)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: InkWell(
                  key: Key('plan_item_${item.id}'),
                  onTap: () => onEdit(item),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(item.name, style: theme.textTheme.bodyMedium),
                            Text(
                              item.amountLabel,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        key: Key('remove_plan_item_${item.id}'),
                        tooltip: 'Remove',
                        visualDensity: VisualDensity.compact,
                        onPressed: () => onRemove(item),
                        icon: const Icon(Icons.close, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
          Row(
            children: <Widget>[
              TextButton(
                key: Key('add_food_${slot.name}'),
                onPressed: onAddFood,
                child: const Text('Add food'),
              ),
              TextButton(
                key: Key('add_recipe_${slot.name}'),
                onPressed: onAddRecipe,
                child: const Text('Add recipe'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
