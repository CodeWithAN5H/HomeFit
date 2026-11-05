import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../domain/nutrition_totals.dart';
import '../../domain/nutrition_units.dart';

/// Calories plus the three macros, in one consistent row.
class MacroSummary extends StatelessWidget {
  const MacroSummary({required this.totals, this.compact = false, super.key});

  final NutritionTotals totals;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        _Macro(
          label: 'Calories',
          value: formatKcal(totals.kcal),
          compact: compact,
        ),
        _Macro(
          label: 'Protein',
          value: formatGrams(totals.proteinG),
          compact: compact,
        ),
        _Macro(
          label: 'Carbs',
          value: formatGrams(totals.carbsG),
          compact: compact,
        ),
        _Macro(label: 'Fat', value: formatGrams(totals.fatG), compact: compact),
      ],
    );
  }
}

class _Macro extends StatelessWidget {
  const _Macro({
    required this.label,
    required this.value,
    required this.compact,
  });

  final String label;
  final String value;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          value,
          style:
              (compact
                      ? theme.textTheme.titleSmall
                      : theme.textTheme.titleMedium)
                  ?.copyWith(color: AppColors.textPrimary),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

/// Small "estimate" marker used wherever nutrition figures are approximate.
class EstimateBadge extends StatelessWidget {
  const EstimateBadge({this.label = 'Estimate', super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppColors.warning,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Previous / next / today navigation for the planner and the log.
class NutritionDateBar extends StatelessWidget {
  const NutritionDateBar({
    required this.dateKey,
    required this.todayKey,
    required this.onChanged,
    this.allowFuture = true,
    super.key,
  });

  final String dateKey;
  final String todayKey;
  final ValueChanged<String> onChanged;
  final bool allowFuture;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateTime date = dateFromKey(dateKey);
    final String nextKey = dateKeyFor(addDays(date, 1));
    final String previousKey = dateKeyFor(addDays(date, -1));
    final bool nextEnabled = allowFuture || nextKey.compareTo(todayKey) <= 0;
    final String relative = dateKey == todayKey
        ? 'Today'
        : dateKey == dateKeyFor(addDays(dateFromKey(todayKey), -1))
        ? 'Yesterday'
        : dateKey == dateKeyFor(addDays(dateFromKey(todayKey), 1))
        ? 'Tomorrow'
        : date.year.toString();

    return Row(
      children: <Widget>[
        IconButton(
          key: const Key('date_prev'),
          tooltip: 'Previous day',
          onPressed: () => onChanged(previousKey),
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Text(
                DateFormat('EEE d MMM').format(date),
                style: theme.textTheme.titleMedium,
              ),
              Text(
                relative,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          key: const Key('date_next'),
          tooltip: 'Next day',
          onPressed: nextEnabled ? () => onChanged(nextKey) : null,
          icon: const Icon(Icons.chevron_right),
        ),
        TextButton(
          key: const Key('date_today'),
          onPressed: dateKey == todayKey ? null : () => onChanged(todayKey),
          child: const Text('Today'),
        ),
      ],
    );
  }
}

/// A one-field prompt that owns its controller, so nothing is disposed while
/// the dialog is still animating out.
Future<String?> showTextPrompt(
  BuildContext context, {
  required String title,
  required String label,
  required Key fieldKey,
  required Key confirmKey,
  String initial = '',
  String confirmLabel = 'Save',
}) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => _TextPromptDialog(
      title: title,
      label: label,
      fieldKey: fieldKey,
      confirmKey: confirmKey,
      initial: initial,
      confirmLabel: confirmLabel,
    ),
  );
}

class _TextPromptDialog extends StatefulWidget {
  const _TextPromptDialog({
    required this.title,
    required this.label,
    required this.fieldKey,
    required this.confirmKey,
    required this.initial,
    required this.confirmLabel,
  });

  final String title;
  final String label;
  final Key fieldKey;
  final Key confirmKey;
  final String initial;
  final String confirmLabel;

  @override
  State<_TextPromptDialog> createState() => _TextPromptDialogState();
}

class _TextPromptDialogState extends State<_TextPromptDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        key: widget.fieldKey,
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: widget.label),
        onSubmitted: (String value) => Navigator.of(context).pop(value),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: widget.confirmKey,
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

/// Icon used for a meal slot in lists.
IconData iconForSlot(String slot) {
  switch (slot) {
    case 'breakfast':
      return Icons.wb_sunny_outlined;
    case 'lunch':
      return Icons.lunch_dining_outlined;
    case 'snack':
      return Icons.cookie_outlined;
    case 'dinner':
      return Icons.nightlight_outlined;
    default:
      return Icons.add_circle_outline;
  }
}
