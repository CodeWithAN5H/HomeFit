import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/nutrition_providers.dart';
import '../domain/grocery.dart';
import 'widgets/nutrition_widgets.dart';

/// Grocery checklist. Generated from the plan, but ticking things off is always
/// a human action taken in the shop.
class GroceryScreen extends ConsumerWidget {
  const GroceryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<GroceryItem>> async = ref.watch(groceryProvider);
    final List<GroceryItem> items = async.value ?? const <GroceryItem>[];
    final int remaining = items
        .where((GroceryItem item) => !item.checked)
        .length;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Grocery checklist')),
      body: ListView(
        padding: kPagePadding,
        children: <Widget>[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  items.isEmpty
                      ? 'Nothing on the list yet.'
                      : '$remaining of ${items.length} still to buy',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Generated from a planned day, with duplicates combined. '
                  'Nothing is ticked off until you tick it.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  key: const Key('generate_grocery'),
                  onPressed: () => _generate(context, ref),
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: const Text('Generate from today’s plan'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('add_grocery_item'),
                  onPressed: () => _addManual(context, ref),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add item'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  key: const Key('clear_grocery'),
                  onPressed: items.isEmpty ? null : () => _clear(context, ref),
                  child: const Text('Clear list'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (async.isLoading && items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: LinearProgressIndicator(),
            )
          else if (items.isEmpty)
            AppCard(
              key: const Key('grocery_empty'),
              child: Text(
                'Plan a day of meals and generate a list, or add items '
                'yourself.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  for (final GroceryItem item in items)
                    CheckboxListTile(
                      key: Key('grocery_${item.id}'),
                      value: item.checked,
                      onChanged: (bool? value) => ref
                          .read(nutritionActionsProvider)
                          .setGroceryChecked(item, value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        item.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: item.checked
                              ? TextDecoration.lineThrough
                              : null,
                          color: item.checked
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                        ),
                      ),
                      subtitle: item.amountLabel.isEmpty
                          ? null
                          : Text(
                              item.amountLabel,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                      secondary: IconButton(
                        key: Key('grocery_delete_${item.id}'),
                        tooltip: 'Remove',
                        onPressed: () => ref
                            .read(nutritionActionsProvider)
                            .removeGroceryItem(item),
                        icon: const Icon(Icons.close, size: 18),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _generate(BuildContext context, WidgetRef ref) async {
    final int count = await ref
        .read(nutritionActionsProvider)
        .generateGroceryFromPlan(ref.read(nutritionDayKeyProvider));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          count == 0
              ? 'Nothing planned for today to turn into a list.'
              : 'List updated · $count items.',
        ),
      ),
    );
  }

  Future<void> _addManual(BuildContext context, WidgetRef ref) async {
    final String? name = await showTextPrompt(
      context,
      title: 'Add an item',
      label: 'Item',
      fieldKey: const Key('grocery_name_input'),
      confirmKey: const Key('confirm_add_grocery'),
      confirmLabel: 'Add',
    );
    if (name == null || name.trim().isEmpty || !context.mounted) return;
    await ref.read(nutritionActionsProvider).addManualGrocery(name);
  }

  Future<void> _clear(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Clear the list?'),
        content: const Text(
          'Every line, including ones you added yourself, will be removed.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep'),
          ),
          FilledButton(
            key: const Key('confirm_clear_grocery'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(nutritionActionsProvider).clearGrocery();
  }
}
