import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../profile/domain/profile_options.dart';
import '../domain/exercise.dart';
import 'exercise_visual.dart';

/// Small label for a muscle, difficulty or equipment value.
class ExerciseTag extends StatelessWidget {
  const ExerciseTag({required this.label, this.icon, this.tint, super.key});

  final String label;
  final IconData? icon;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color colour = tint ?? AppColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: colour),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colour,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One exercise in a list or grid.
///
/// [missingEquipment] is only non-empty when the card is shown as a
/// suggestion, so the library list stays quiet while alternatives clearly say
/// what the user would need.
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    required this.exercise,
    required this.onTap,
    this.missingEquipment = const <EquipmentItem>[],
    super.key,
  });

  final Exercise exercise;
  final VoidCallback onTap;
  final List<EquipmentItem> missingEquipment;

  String get _semanticLabel {
    final StringBuffer buffer = StringBuffer(
      '${exercise.name}. ${exercise.primaryMuscle.label}. '
      '${exercise.difficulty.label}. ${exercise.equipmentLabel}.',
    );
    if (missingEquipment.isNotEmpty) {
      buffer.write(
        ' Needs ${missingEquipment.map((item) => item.label).join(', ')}.',
      );
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      button: true,
      label: _semanticLabel,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.outline),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDim,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: Icon(
                    iconForMuscle(exercise.primaryMuscle),
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: theme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          ExerciseTag(label: exercise.primaryMuscle.label),
                          ExerciseTag(
                            label: exercise.difficulty.label,
                            tint: colorForDifficulty(exercise.difficulty),
                          ),
                          ExerciseTag(
                            label: exercise.equipmentLabel,
                            icon: exercise.isBodyweight
                                ? Icons.accessibility
                                : Icons.handyman_outlined,
                          ),
                        ],
                      ),
                      if (missingEquipment.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 14,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'Needs ${missingEquipment.map((item) => item.label).join(', ')}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.warning,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xs),
                  child: Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
