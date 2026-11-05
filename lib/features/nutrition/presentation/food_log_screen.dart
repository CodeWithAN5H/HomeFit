import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/nutrition_providers.dart';
import '../domain/food_item.dart';
import '../domain/food_log.dart';
import '../domain/meal_slot.dart';
import '../domain/nutrition_day.dart';
import '../domain/nutrition_targets.dart';
import '../domain/nutrition_units.dart';
import 'widgets/food_picker.dart';
import 'widgets/nutrition_widgets.dart';

/// Record what was actually eaten. This screen never touches the meal plan.
class FoodLogScreen extends ConsumerStatefulWidget {
  const FoodLogScreen({super.key});

  @override
  ConsumerState<FoodLogScreen> createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends ConsumerState<FoodLogScreen> {
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _date = dateFromKey(ref.read(nutritionDayKeyProvider));
  }

  String get _key => dateKeyFor(_date);

  @override
  Widget build(BuildContext context) {
    final AsyncValue<NutritionDay> async = ref.watch(
      nutritionDayProvider(_key),
    );
    final NutritionDay? day = async.value;
    final NutritionTargets targets = ref.watch(nutritionTargetsProvider);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Food log')),
      body: ListView(
        padding: kPagePadding,
        children: <Widget>[
          NutritionDateBar(
            dateKey: _key,
            todayKey: ref.watch(nutritionDayKeyProvider),
            allowFuture: false,
            onChanged: (String key) => setState(() => _date = dateFromKey(key)),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            key: const Key('log_totals'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Logged for this day',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const EstimateBadge(),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (day == null)
                  const LinearProgressIndicator()
                else ...<Widget>[
                  MacroSummary(totals: day.loggedTotals),
                  if (targets.isAvailable) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Estimated target: '
                      '${targets.kcalLow.round()}–${targets.kcalHigh.round()} '
                      'kcal and ${targets.proteinLowG.round()}–'
                      '${targets.proteinHighG.round()} g protein.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (day != null && !day.hasLog)
            AppCard(
              key: const Key('log_empty'),
              child: Text(
                'Nothing logged for this day yet. Add what you actually ate — '
                'logging is separate from the meal plan.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),
          for (final MealSlot slot in MealSlot.values) ...<Widget>[
            _LogSlotCard(
              slot: slot,
              entries: day?.logFor(slot) ?? const <LoggedFoodEntry>[],
              onAdd: () => _add(slot),
              onEdit: _edit,
              onDelete: _delete,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(
            'Nutrition figures are estimates based on household portions, so '
            'they round and vary with cooking oil and brands.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _add(MealSlot slot) async {
    final FoodItem? food = await showFoodPicker(
      context,
      title: 'Log for ${slot.label.toLowerCase()}',
    );
    if (food == null || !mounted) return;
    final FoodAmount? amount = await showAmountSheet(context, food);
    if (amount == null || !mounted) return;
    await ref
        .read(nutritionActionsProvider)
        .addFoodToLog(
          dateKey: _key,
          slot: slot,
          food: amount.food,
          amount: amount.amount,
          servingLabel: amount.servingLabel,
        );
    if (!mounted) return;
    _snack('${food.name} logged.');
  }

  Future<void> _edit(LoggedFoodEntry entry) async {
    final FoodItem? food = ref.read(foodCatalogueProvider).byId(entry.foodId);
    if (food == null) {
      _snack('This food is no longer in the catalogue.');
      return;
    }
    final FoodAmount? amount = await showAmountSheet(
      context,
      food,
      initialAmount: entry.amount,
      initialLabel: entry.servingLabel,
    );
    if (amount == null || !mounted) return;
    await ref
        .read(nutritionActionsProvider)
        .updateLogEntry(
          entry,
          amount: amount.amount,
          servingLabel: amount.servingLabel,
          clearServingLabel: amount.servingLabel == null,
        );
    if (!mounted) return;
    _snack('Entry updated.');
  }

  Future<void> _delete(LoggedFoodEntry entry) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete this entry?'),
        content: Text(
          '${entry.foodName} (${entry.amountLabel}) will be removed from '
          '${entry.dateKey}. This cannot be undone.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep'),
          ),
          FilledButton(
            key: const Key('confirm_delete_log'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(nutritionActionsProvider).deleteLogEntry(entry);
    if (!mounted) return;
    _snack('Entry deleted.');
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _LogSlotCard extends StatelessWidget {
  const _LogSlotCard({
    required this.slot,
    required this.entries,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final MealSlot slot;
  final List<LoggedFoodEntry> entries;
  final VoidCallback onAdd;
  final ValueChanged<LoggedFoodEntry> onEdit;
  final ValueChanged<LoggedFoodEntry> onDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double kcal = 0;
    for (final LoggedFoodEntry entry in entries) {
      kcal += entry.totals.kcal;
    }
    return AppCard(
      key: Key('log_slot_${slot.name}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(iconForSlot(slot.name), size: 18, color: AppColors.success),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(slot.label, style: theme.textTheme.titleMedium),
              ),
              Text('≈ ${kcal.round()} kcal', style: theme.textTheme.bodySmall),
            ],
          ),
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                'Nothing logged.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            for (final LoggedFoodEntry entry in entries)
              InkWell(
                key: Key('log_entry_${entry.id}'),
                onTap: () => onEdit(entry),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              entry.foodName,
                              style: theme.textTheme.bodyMedium,
                            ),
                            Text(
                              '${entry.amountLabel} · '
                              '${formatKcal(entry.totals.kcal)} · '
                              '${formatGrams(entry.totals.proteinG)} protein',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        key: Key('delete_log_${entry.id}'),
                        tooltip: 'Delete',
                        visualDensity: VisualDensity.compact,
                        onPressed: () => onDelete(entry),
                        icon: const Icon(Icons.delete_outline, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              key: Key('log_add_${slot.name}'),
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Log food'),
            ),
          ),
        ],
      ),
    );
  }
}
