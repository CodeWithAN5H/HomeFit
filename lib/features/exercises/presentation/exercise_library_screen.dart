import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/selectable_chip.dart';
import '../../profile/domain/profile_options.dart';
import '../application/exercise_providers.dart';
import '../domain/exercise.dart';
import '../domain/exercise_query.dart';
import 'exercise_card.dart';

/// Browse the bundled exercise library.
///
/// Filtering is pure and synchronous, so results update as the user types or
/// taps. The screen never talks to a network or an asset: the catalogue is
/// compiled in.
class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  ConsumerState<ExerciseLibraryScreen> createState() =>
      _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen> {
  static const String _anyValue = '__any__';

  final TextEditingController _searchField = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchField.text = ref.read(exerciseFilterProvider).search;
  }

  @override
  void dispose() {
    _searchField.dispose();
    super.dispose();
  }

  void _setSearch(String value) {
    ref.read(exerciseFilterProvider.notifier).setSearch(value);
  }

  void _clearSearch() {
    _searchField.clear();
    _setSearch('');
  }

  /// Clears the query but keeps chip filters, matching "X" on the search box.
  void _clearAll() {
    _searchField.clear();
    ref.read(exerciseFilterProvider.notifier).clearAll();
  }

  void _clearFilters() {
    ref.read(exerciseFilterProvider.notifier).clearFilters();
  }

  void _open(Exercise exercise) {
    context.push(AppRoutes.exerciseDetail(exercise.id));
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter filter = ref.watch(exerciseFilterProvider);
    final List<Exercise> exercises = ref.watch(exerciseListProvider);
    final int total = ref.watch(exerciseCountProvider);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Exercise library')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool wide = constraints.maxWidth >= 700;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.sm,
                  AppSpacing.xl,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      key: const Key('exercise_search'),
                      controller: _searchField,
                      onChanged: _setSearch,
                      textInputAction: TextInputAction.search,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Search exercises',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.textMuted,
                        ),
                        suffixIcon: filter.search.trim().isEmpty
                            ? null
                            : IconButton(
                                key: const Key('exercise_search_clear'),
                                tooltip: 'Clear search',
                                onPressed: _clearSearch,
                                icon: const Icon(
                                  Icons.close,
                                  color: AppColors.textMuted,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 48,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SelectableChip(
                            key: const Key('muscle_all'),
                            label: 'All muscles',
                            selected: filter.muscle == null,
                            onTap: () => ref
                                .read(exerciseFilterProvider.notifier)
                                .setMuscle(null),
                          ),
                          for (final MuscleGroup muscle in MuscleGroup.values)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: AppSpacing.sm,
                              ),
                              child: SelectableChip(
                                key: Key('muscle_${muscle.name}'),
                                label: muscle.label,
                                selected: filter.muscle == muscle,
                                onTap: () => ref
                                    .read(exerciseFilterProvider.notifier)
                                    .toggleMuscle(muscle),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        _FilterMenuButton<EquipmentItem>(
                          buttonKey: const Key('equipment_filter'),
                          icon: Icons.handyman_outlined,
                          anyLabel: 'Any equipment',
                          activeLabel: filter.equipment?.label,
                          options: EquipmentItem.values,
                          labelOf: (item) => item.label,
                          anyValue: _anyValue,
                          onSelected: (item) => ref
                              .read(exerciseFilterProvider.notifier)
                              .setEquipment(item),
                        ),
                        _FilterMenuButton<ExerciseDifficulty>(
                          buttonKey: const Key('difficulty_filter'),
                          icon: Icons.signal_cellular_alt,
                          anyLabel: 'Any difficulty',
                          activeLabel: filter.difficulty?.label,
                          options: ExerciseDifficulty.values,
                          labelOf: (item) => item.label,
                          anyValue: _anyValue,
                          onSelected: (item) => ref
                              .read(exerciseFilterProvider.notifier)
                              .setDifficulty(item),
                        ),
                        SelectableChip(
                          key: const Key('only_my_equipment'),
                          label: 'My equipment only',
                          selected: filter.onlyMyEquipment,
                          onTap: () => ref
                              .read(exerciseFilterProvider.notifier)
                              .toggleOnlyMyEquipment(),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            filter.hasAnyFilter
                                ? '${exercises.length} of $total exercises'
                                : '$total exercises',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        if (filter.hasChipFilter)
                          TextButton(
                            key: const Key('clear_filters'),
                            onPressed: _clearFilters,
                            child: const Text('Clear filters'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: exercises.isEmpty
                    ? _EmptyLibraryState(onClear: _clearAll)
                    : _ExerciseList(
                        exercises: exercises,
                        wide: wide,
                        onOpen: _open,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ExerciseList extends StatelessWidget {
  const _ExerciseList({
    required this.exercises,
    required this.wide,
    required this.onOpen,
  });

  final List<Exercise> exercises;
  final bool wide;
  final ValueChanged<Exercise> onOpen;

  static const EdgeInsets _padding = EdgeInsets.fromLTRB(
    AppSpacing.xl,
    AppSpacing.xs,
    AppSpacing.xl,
    AppSpacing.xxl,
  );

  @override
  Widget build(BuildContext context) {
    if (!wide) {
      return ListView.separated(
        padding: _padding,
        itemCount: exercises.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final Exercise exercise = exercises[index];
          return ExerciseCard(
            key: Key('exercise_card_${exercise.id}'),
            exercise: exercise,
            onTap: () => onOpen(exercise),
          );
        },
      );
    }

    final int columns = MediaQuery.sizeOf(context).width >= 1180 ? 3 : 2;
    return GridView.builder(
      padding: _padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisExtent: 152,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final Exercise exercise = exercises[index];
        return ExerciseCard(
          key: Key('exercise_card_${exercise.id}'),
          exercise: exercise,
          onTap: () => onOpen(exercise),
        );
      },
    );
  }
}

class _EmptyLibraryState extends StatelessWidget {
  const _EmptyLibraryState({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: kPagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.outline),
              ),
              child: const Icon(
                Icons.search_off,
                size: 32,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('No exercises match', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Nothing in the library matches this search and filter '
              'combination. Try a shorter search, a different muscle group or '
              'clear everything.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: 220,
              child: FilledButton(
                key: const Key('clear_filters_empty'),
                onPressed: onClear,
                child: const Text('Clear filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Button that opens a menu of one optional filter value.
///
/// A popup menu is used instead of a dropdown so the trigger can show its own
/// label and the same tap target works on touch and desktop.
class _FilterMenuButton<T> extends StatelessWidget {
  const _FilterMenuButton({
    required this.buttonKey,
    required this.icon,
    required this.anyLabel,
    required this.activeLabel,
    required this.options,
    required this.labelOf,
    required this.anyValue,
    required this.onSelected,
  });

  final Key buttonKey;
  final IconData icon;
  final String anyLabel;
  final String? activeLabel;
  final List<T> options;
  final String Function(T option) labelOf;
  final String anyValue;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool active = activeLabel != null;
    return PopupMenuButton<String>(
      key: buttonKey,
      tooltip: anyLabel,
      initialValue: activeLabel,
      onSelected: (String value) {
        if (value == anyValue) {
          onSelected(null);
          return;
        }
        onSelected(options.firstWhere((T item) => labelOf(item) == value));
      },
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(value: anyValue, child: Text(anyLabel)),
        for (final T option in options)
          PopupMenuItem<String>(
            value: labelOf(option),
            child: Text(labelOf(option)),
          ),
      ],
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryDim : AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.outline,
            width: active ? 1.2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              activeLabel ?? anyLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: active ? AppColors.primary : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
