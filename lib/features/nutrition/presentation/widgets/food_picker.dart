import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/nutrition_providers.dart';
import '../../data/catalog/food_catalogue.dart';
import '../../domain/food_item.dart';
import '../../domain/nutrition_totals.dart';
import '../../domain/nutrition_units.dart';

/// A chosen food and amount, ready to be stored.
class FoodAmount {
  const FoodAmount({
    required this.food,
    required this.amount,
    this.servingLabel,
  });

  final FoodItem food;
  final double amount;
  final String? servingLabel;
}

/// Searchable food picker. Returns the chosen food; the caller then asks for an
/// amount, so both steps stay short on a phone.
Future<FoodItem?> showFoodPicker(
  BuildContext context, {
  String title = 'Add a food',
}) {
  return showModalBottomSheet<FoodItem>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext context) => _FoodPickerSheet(title: title),
  );
}

/// Amount editor with household presets and a free grams/millilitres entry.
Future<FoodAmount?> showAmountSheet(
  BuildContext context,
  FoodItem food, {
  double? initialAmount,
  String? initialLabel,
}) {
  return showModalBottomSheet<FoodAmount>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext context) => _AmountSheet(
      food: food,
      initialAmount: initialAmount,
      initialLabel: initialLabel,
    ),
  );
}

class _FoodPickerSheet extends ConsumerStatefulWidget {
  const _FoodPickerSheet({required this.title});

  final String title;

  @override
  ConsumerState<_FoodPickerSheet> createState() => _FoodPickerSheetState();
}

class _FoodPickerSheetState extends ConsumerState<_FoodPickerSheet> {
  final TextEditingController _search = TextEditingController();
  bool _rawOnly = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FoodCatalogue catalogue = ref.watch(foodCatalogueProvider);
    final List<FoodItem> foods = <FoodItem>[
      for (final FoodItem food in catalogue.search(_search.text))
        if (!_rawOnly || food.state == FoodState.raw) food,
    ];

    return Padding(
      key: const Key('food_picker'),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.78,
        child: Column(
          children: <Widget>[
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: TextField(
                key: const Key('food_search'),
                controller: _search,
                autofocus: false,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Search dal, paneer, roti, banana…',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Row(
                children: <Widget>[
                  FilterChip(
                    key: const Key('food_raw_only'),
                    label: const Text('Raw ingredients'),
                    selected: _rawOnly,
                    onSelected: (bool value) =>
                        setState(() => _rawOnly = value),
                  ),
                  const Spacer(),
                  Text(
                    '${foods.length} foods',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: foods.isEmpty
                  ? const Center(child: Text('No foods match that search.'))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        AppSpacing.sm,
                        AppSpacing.xl,
                        AppSpacing.xl,
                      ),
                      itemCount: foods.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (BuildContext context, int index) {
                        final FoodItem food = foods[index];
                        final NutritionTotals perServing = food.totalsFor(
                          food.servings.first.amount,
                        );
                        return AppCard(
                          key: Key('food_${food.id}'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(food),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        food.name,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                    Text(
                                      formatKcal(perServing.kcal),
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(color: AppColors.primary),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${food.state.label} · ${food.category.label}'
                                  ' · per 100 ${food.unit}',
                                  style: theme.textTheme.bodySmall,
                                ),
                                Text(
                                  '${food.servings.first.label} · '
                                  '${formatGrams(perServing.proteinG)} protein',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountSheet extends StatefulWidget {
  const _AmountSheet({
    required this.food,
    this.initialAmount,
    this.initialLabel,
  });

  final FoodItem food;
  final double? initialAmount;
  final String? initialLabel;

  @override
  State<_AmountSheet> createState() => _AmountSheetState();
}

class _AmountSheetState extends State<_AmountSheet> {
  late final TextEditingController _amount;
  int? _selectedServing;

  @override
  void initState() {
    super.initState();
    final double initial =
        widget.initialAmount ?? widget.food.servings.first.amount;
    _amount = TextEditingController(text: initial.round().toString());
    final String? label = widget.initialLabel;
    if (label != null) {
      final int index = widget.food.servings.indexWhere(
        (ServingPreset serving) => serving.label == label,
      );
      if (index >= 0) _selectedServing = index;
    } else if (widget.initialAmount == null) {
      // A new entry starts on the first household portion, so the saved label
      // says "1 roti" rather than a bare gram figure.
      _selectedServing = 0;
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  double get _value => double.tryParse(_amount.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FoodItem food = widget.food;
    final ServingPreset? serving = _selectedServing == null
        ? null
        : food.servings[_selectedServing!];
    final double amount = serving?.amount ?? _value;
    final String? label = serving?.label;

    return Padding(
      key: const Key('amount_sheet'),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(food.name, style: theme.textTheme.titleLarge),
          const SizedBox(height: 2),
          Text(
            '${food.state.label} · ${formatKcal(food.per100.kcal)} per 100 '
            '${food.unit}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (int index = 0; index < food.servings.length; index++)
                ChoiceChip(
                  key: Key('serving_$index'),
                  label: Text(
                    '${food.servings[index].label} '
                    '(${food.servings[index].amount.round()} ${food.unit})',
                  ),
                  selected: _selectedServing == index,
                  onSelected: (_) => setState(() {
                    _selectedServing = index;
                    _amount.text = food.servings[index].amount
                        .round()
                        .toString();
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            key: const Key('amount_input'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: _amount,
            onChanged: (_) => setState(() => _selectedServing = null),
            decoration: InputDecoration(
              labelText: 'Quantity',
              suffixText: food.unit,
              helperText:
                  'Household portions are approximate; use grams or '
                  'millilitres if you weigh food.',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            amount > 0
                ? '≈ ${formatKcal(food.totalsFor(amount).kcal)} · '
                      '${formatGrams(food.totalsFor(amount).proteinG)} protein'
                : 'Enter a quantity',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton(
                  key: const Key('confirm_amount'),
                  onPressed: amount <= 0
                      ? null
                      : () => Navigator.of(context).pop(
                          FoodAmount(
                            food: food,
                            amount: amount,
                            servingLabel: label,
                          ),
                        ),
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
