import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/nutrition_providers.dart';
import '../domain/food_item.dart';
import '../domain/meal_slot.dart';
import '../domain/nutrition_totals.dart';
import '../domain/nutrition_units.dart';
import '../domain/recipe.dart';
import 'widgets/nutrition_widgets.dart';
import 'widgets/recipe_picker.dart';

/// Offline recipe library with search and dietary filters.
class RecipeLibraryScreen extends ConsumerStatefulWidget {
  const RecipeLibraryScreen({super.key});

  @override
  ConsumerState<RecipeLibraryScreen> createState() =>
      _RecipeLibraryScreenState();
}

class _RecipeLibraryScreenState extends ConsumerState<RecipeLibraryScreen> {
  final TextEditingController _search = TextEditingController();
  RecipeTag? _tag;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Map<String, FoodItem> foods = ref
        .watch(foodCatalogueProvider)
        .byIdMap;
    final List<Recipe> recipes = ref
        .watch(recipeCatalogueProvider)
        .search(_search.text, tag: _tag);

    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      body: ListView(
        padding: kPagePadding,
        children: <Widget>[
          TextField(
            key: const Key('recipe_search'),
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Search poha, dal, paneer…',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              ChoiceChip(
                key: const Key('recipe_tag_all'),
                label: const Text('All'),
                selected: _tag == null,
                onSelected: (_) => setState(() => _tag = null),
              ),
              for (final RecipeTag tag in RecipeTag.values)
                ChoiceChip(
                  key: Key('recipe_tag_${tag.name}'),
                  label: Text(tag.label),
                  selected: _tag == tag,
                  onSelected: (bool selected) =>
                      setState(() => _tag = selected ? tag : null),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (recipes.isEmpty)
            AppCard(
              key: const Key('recipe_empty'),
              child: Text(
                'No recipes match. Clear the search or pick another filter.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          for (final Recipe recipe in recipes) ...<Widget>[
            AppCard(
              key: Key('recipe_card_${recipe.id}'),
              child: InkWell(
                onTap: () =>
                    context.push(AppRoutes.nutritionRecipeDetail(recipe.id)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(recipe.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      recipe.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _RecipeMeta(
                      recipe: recipe,
                      nutrition: recipe.nutritionFor(foods),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _RecipeMeta extends StatelessWidget {
  const _RecipeMeta({required this.recipe, required this.nutrition});

  final Recipe recipe;
  final NutritionTotals nutrition;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(
          '≈ ${formatKcal(nutrition.kcal)} · '
          '${formatGrams(nutrition.proteinG)} protein per serving',
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primary),
        ),
        Text(
          '${recipe.prepMinutes} min · '
          '${formatQuantity(recipe.servings.toDouble(), 'serving')}',
          style: theme.textTheme.bodySmall,
        ),
        for (final RecipeTag tag in recipe.tags)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.chip),
            ),
            child: Text(
              tag.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),
      ],
    );
  }
}

/// Full recipe with ingredients, steps and a per-serving estimate.
class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({required this.recipeId, super.key});

  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final Recipe? recipe = ref.watch(recipeCatalogueProvider).byId(recipeId);
    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recipe')),
        body: const Center(child: Text('This recipe is not in the catalogue.')),
      );
    }
    final Map<String, FoodItem> foods = ref
        .watch(foodCatalogueProvider)
        .byIdMap;
    final NutritionTotals perServing = recipe.nutritionFor(foods);

    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: ListView(
        padding: kPagePadding,
        children: <Widget>[
          Text(recipe.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            recipe.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${recipe.prepMinutes} min · '
                  '${formatQuantity(recipe.servings.toDouble(), 'serving')}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const EstimateBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Per serving (estimated)',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                MacroSummary(totals: perServing),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Ingredients', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                for (final RecipeIngredient ingredient in recipe.ingredients)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            foods[ingredient.foodId]?.name ?? ingredient.foodId,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          _formatIngredient(
                            foods[ingredient.foodId],
                            ingredient,
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Method', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                for (int index = 0; index < recipe.steps.length; index++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${index + 1}. ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            recipe.steps[index],
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (recipe.note != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Text(
              recipe.note!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            key: const Key('recipe_add_to_plan'),
            onPressed: () => _addToPlan(context, ref, recipe),
            child: const Text('Add to a meal plan'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Values are estimates from ingredient reference figures; home '
            'cooking oil and portion sizes change the real total.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  String _formatIngredient(FoodItem? food, RecipeIngredient ingredient) {
    final String unit = food?.unit ?? 'g';
    return '${ingredient.amount.round()} $unit';
  }

  Future<void> _addToPlan(
    BuildContext context,
    WidgetRef ref,
    Recipe recipe,
  ) async {
    final MealSlot? slot = await showDialog<MealSlot>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add to which meal?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final MealSlot option in MealSlot.values)
              ListTile(
                key: Key('slot_${option.name}'),
                title: Text(option.label),
                onTap: () => Navigator.of(context).pop(option),
              ),
          ],
        ),
      ),
    );
    if (slot == null || !context.mounted) return;
    final double? servings = await showServingSheet(
      context,
      title: recipe.title,
    );
    if (servings == null || !context.mounted) return;
    await ref
        .read(nutritionActionsProvider)
        .addRecipeToPlan(
          dateKey: ref.read(nutritionDayKeyProvider),
          slot: slot,
          recipe: recipe,
          servings: servings,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${recipe.title} added to today’s ${slot.label.toLowerCase()}.',
        ),
        action: SnackBarAction(
          label: 'View plan',
          onPressed: () => context.push(AppRoutes.nutritionPlan),
        ),
      ),
    );
  }
}
