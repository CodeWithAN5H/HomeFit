import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/nutrition_providers.dart';
import '../../domain/food_item.dart';
import '../../domain/recipe.dart';

/// Recipe picker used from the meal planner.
Future<Recipe?> showRecipePicker(BuildContext context) {
  return showModalBottomSheet<Recipe>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext context) => const _RecipePickerSheet(),
  );
}

class _RecipePickerSheet extends ConsumerWidget {
  const _RecipePickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Recipe> recipes = ref.watch(recipeCatalogueProvider).all;
    final Map<String, FoodItem> foods = ref
        .watch(foodCatalogueProvider)
        .byIdMap;
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      key: const Key('recipe_picker'),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: <Widget>[
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Add a recipe',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.xl),
              itemCount: recipes.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (BuildContext context, int index) {
                final Recipe recipe = recipes[index];
                final nutrition = recipe.nutritionFor(foods);
                return AppCard(
                  key: Key('pick_recipe_${recipe.id}'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(recipe),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(recipe.title, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          '${recipe.prepMinutes} min · per serving '
                          '≈ ${nutrition.kcal.round()} kcal · '
                          '${nutrition.proteinG.round()} g protein',
                          style: theme.textTheme.bodySmall,
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
    );
  }
}

/// Serving count for a recipe, with quick choices.
Future<double?> showServingSheet(
  BuildContext context, {
  required String title,
  double initial = 1,
}) {
  return showDialog<double>(
    context: context,
    builder: (BuildContext context) =>
        _ServingDialog(title: title, initial: initial),
  );
}

class _ServingDialog extends StatefulWidget {
  const _ServingDialog({required this.title, required this.initial});

  final String title;
  final double initial;

  @override
  State<_ServingDialog> createState() => _ServingDialogState();
}

class _ServingDialogState extends State<_ServingDialog> {
  late double _servings = widget.initial;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('How many servings?'),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                key: const Key('servings_minus'),
                onPressed: _servings <= 0.5
                    ? null
                    : () => setState(() => _servings -= 0.5),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                _servings.toStringAsFixed(
                  _servings == _servings.roundToDouble() ? 0 : 1,
                ),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                key: const Key('servings_plus'),
                onPressed: _servings >= 6
                    ? null
                    : () => setState(() => _servings += 0.5),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('confirm_servings'),
          onPressed: () => Navigator.of(context).pop(_servings),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
