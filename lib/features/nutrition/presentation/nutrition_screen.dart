import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/nutrition_providers.dart';
import '../domain/food_item.dart';
import '../domain/meal_slot.dart';
import '../domain/nutrition_day.dart';
import '../domain/nutrition_targets.dart';
import '../domain/nutrition_totals.dart';
import '../domain/nutrition_units.dart';
import 'widgets/nutrition_widgets.dart';

/// Nutrition home: transparent targets, today's logged and planned intake, and
/// entry points to the planner, log, recipes and grocery checklist.
class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NutritionTargets targets = ref.watch(nutritionTargetsProvider);
    final String todayKey = ref.watch(nutritionDayKeyProvider);
    final AsyncValue<NutritionDay> async = ref.watch(
      nutritionDayProvider(todayKey),
    );
    final NutritionDay? day = async.value;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition')),
      body: ListView(
        padding: kPagePadding,
        children: <Widget>[
          _TargetsCard(targets: targets),
          const SizedBox(height: AppSpacing.md),
          _TodayCard(day: day, targets: targets, dateLabel: todayKey),
          const SizedBox(height: AppSpacing.md),
          _MealsCard(day: day, todayKey: todayKey),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                ListTile(
                  key: const Key('nutrition_recipes_link'),
                  leading: const Icon(
                    Icons.menu_book_outlined,
                    color: AppColors.primary,
                  ),
                  title: const Text('Recipe library'),
                  subtitle: Text(
                    '${ref.watch(recipeCatalogueProvider).all.length} '
                    'affordable vegetarian recipes with estimates',
                    style: theme.textTheme.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.nutritionRecipes),
                ),
                const Divider(height: 1),
                ListTile(
                  key: const Key('nutrition_grocery_link'),
                  leading: const Icon(
                    Icons.shopping_basket_outlined,
                    color: AppColors.secondary,
                  ),
                  title: const Text('Grocery checklist'),
                  subtitle: Text(
                    'Built from planned meals; you still tick items off',
                    style: theme.textTheme.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.nutritionGrocery),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            key: const Key('nutrition_safety_card'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.health_and_safety_outlined,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Before you rely on these numbers',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Nutrition values are estimates for planning, not medical '
                  'or dietetic advice. HomeFit does not diagnose conditions '
                  'from weight or BMI and does not promise a rate of weight '
                  'gain. If you have a food intolerance, persistent symptoms '
                  'or a medical condition, follow professional advice rather '
                  'than an app. Check labels on packaged foods, and treat '
                  'allergy restrictions seriously.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetsCard extends StatelessWidget {
  const _TargetsCard({required this.targets});

  final NutritionTargets targets;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppCard(
      key: const Key('nutrition_targets_card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Daily targets',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const EstimateBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (!targets.isAvailable) ...<Widget>[
            Text(
              targets.unavailableReason ??
                  'Not enough profile information for a target.',
              style: theme.textTheme.bodyMedium,
            ),
          ] else ...<Widget>[
            Text(
              '${targets.kcalLow.round()}–${targets.kcalHigh.round()} kcal',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
              ),
            ),
            Text(
              '${targets.proteinLowG.round()}–${targets.proteinHighG.round()} g '
              'protein · $kDietLabel',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'A range, not a prescription. It keeps a modest surplus and '
              'adequate protein without supplements.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                key: const Key('targets_assumptions'),
                onPressed: () => _showAssumptions(context, targets),
                child: const Text('How this is estimated'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAssumptions(BuildContext context, NutritionTargets targets) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('How targets are estimated'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final String assumption in targets.assumptions)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('•  '),
                      Expanded(child: Text(assumption)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({
    required this.day,
    required this.targets,
    required this.dateLabel,
  });

  final NutritionDay? day;
  final NutritionTargets targets;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NutritionTotals logged = day?.loggedTotals ?? NutritionTotals.zero;
    final NutritionTotals planned = day?.plannedTotals ?? NutritionTotals.zero;
    final double progress = targets.isAvailable && targets.kcalMid > 0
        ? (logged.kcal / targets.kcalMid).clamp(0.0, 1.0)
        : 0;

    return AppCard(
      key: const Key('nutrition_today_card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Today · ${DateFormat('d MMM').format(dateFromKey(dateLabel))}',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              EstimateBadge(
                label: targets.isAvailable ? 'Estimate' : 'No target',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          MacroSummary(totals: logged),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.surfaceHigh,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            targets.isAvailable
                ? '${logged.kcal.round()} of ~${targets.kcalMid.round()} kcal '
                      'logged (estimated target)'
                : '${logged.kcal.round()} kcal logged',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Planned meals: ${planned.kcal.round()} kcal · '
            '${planned.proteinG.round()} g protein',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton(
                  key: const Key('open_meal_plan'),
                  onPressed: () => context.push(AppRoutes.nutritionPlan),
                  child: const Text('Plan meals'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  key: const Key('open_food_log'),
                  onPressed: () => context.push(AppRoutes.nutritionLog),
                  child: const Text('Log food'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MealsCard extends StatelessWidget {
  const _MealsCard({required this.day, required this.todayKey});

  final NutritionDay? day;
  final String todayKey;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NutritionDay? value = day;
    return AppCard(
      key: const Key('nutrition_meals_card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Today’s meals', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          if (value == null)
            const LinearProgressIndicator()
          else ...<Widget>[
            for (final MealSlot slot in MealSlot.values)
              _SlotRow(day: value, slot: slot),
            if (!value.hasPlan)
              Padding(
                key: const Key('nutrition_empty_plan'),
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  'Nothing planned for today yet. Planned meals feed the '
                  'grocery checklist; logging stays separate.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => context.push(AppRoutes.nutritionPlan),
                child: Text(value.hasPlan ? 'Edit plan' : 'Plan today’s meals'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SlotRow extends StatelessWidget {
  const _SlotRow({required this.day, required this.slot});

  final NutritionDay day;
  final MealSlot slot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NutritionTotals planned = day.plannedTotalsFor(slot);
    final NutritionTotals logged = day.loggedTotalsFor(slot);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          Icon(iconForSlot(slot.name), size: 18, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(slot.label, style: theme.textTheme.bodyMedium),
                Text(
                  planned.isEmpty
                      ? 'Nothing planned'
                      : 'Plan ≈ ${planned.kcal.round()} kcal',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            logged.isEmpty ? '—' : '${logged.kcal.round()} kcal',
            style: theme.textTheme.bodySmall?.copyWith(
              color: logged.isEmpty ? AppColors.textMuted : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
