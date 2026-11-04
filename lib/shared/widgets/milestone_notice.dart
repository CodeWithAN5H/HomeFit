import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';
import 'app_card.dart';

/// Honest statement of what a tab does *not* do yet.
///
/// Used so development builds never show dead controls or pretend features.
class MilestoneNotice extends StatelessWidget {
  const MilestoneNotice({
    required this.icon,
    required this.title,
    required this.body,
    this.planned = const <String>[],
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final List<String> planned;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryDim,
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          if (planned.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            for (final String item in planned)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.circle,
                        size: 5,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(item, style: theme.textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: AppSpacing.md),
          Text(
            'Not implemented in this build.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
