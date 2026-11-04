import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/services/clock.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utilities/day_phrase.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/detail_row.dart';
import '../../../shared/widgets/milestone_notice.dart';
import '../../profile/application/profile_providers.dart';
import '../../profile/domain/user_profile.dart';

/// Today at a glance.
///
/// Only shows what this build can actually know: the saved profile, sleep-based
/// recovery guidance, and honest status for features that do not exist yet.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserProfile? profile = ref.watch(profileControllerProvider);
    final DateTime now = ref.watch(clockProvider).now();
    final ThemeData theme = Theme.of(context);

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeFit'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xl),
            child: Center(
              child: Text(
                DateFormat('EEE d MMM').format(now),
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: kPagePadding,
        children: [
          Text(
            greetingForHour(now.hour),
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Your setup is saved on this device.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _ProfileCard(profile: profile),
          const SizedBox(height: AppSpacing.md),
          _RecoveryCard(profile: profile),
          const SizedBox(height: AppSpacing.md),
          const MilestoneNotice(
            icon: Icons.fitness_center,
            title: 'Workout engine — next milestone',
            body:
                'Your adaptive plan, the guided session runner and the rest '
                'timer are not part of this build, so nothing on Home starts a '
                'workout yet.',
            planned: [
              'Conservative 2–3 day beginner plan from your profile',
              'Guided sets, recorded reps and a rest timer',
              'Progression driven by what you actually completed',
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Consistency', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'No sessions logged yet — session history arrives with the '
                  'workout engine.',
                  style: theme.textTheme.bodyMedium?.copyWith(
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

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your setup', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          DetailRow(label: 'Age', value: '${profile.age} years'),
          DetailRow(label: 'Height', value: '${profile.heightCm} cm'),
          DetailRow(
            label: 'Weight',
            value: '${profile.weightKg.toStringAsFixed(1)} kg',
          ),
          DetailRow(label: 'Experience', value: profile.experience.label),
          DetailRow(
            label: 'Sessions',
            value:
                '${profile.sessionMinutes} min · ${profile.trainingTime.label}',
          ),
          if (profile.goals.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text('Goals', style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.xs),
            _TagWrap(labels: profile.goals.map((goal) => goal.label)),
          ],
          if (profile.priorities.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text('Focus', style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.xs),
            _TagWrap(labels: profile.priorities.map((item) => item.label)),
          ],
        ],
      ),
    );
  }
}

class _RecoveryCard extends StatelessWidget {
  const _RecoveryCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool attention = profile.needsRecoveryAttention;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                attention ? Icons.bedtime_outlined : Icons.self_improvement,
                color: attention ? AppColors.warning : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text('Recovery', style: theme.textTheme.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            attention
                ? 'You reported frequent short sleep. That limits progress '
                      'more than any missing set. Keep today light, and treat an '
                      'earlier bedtime as the priority.'
                : 'You reported irregular sleep. A steadier bedtime helps more '
                      'than extra sets, and lighter days are a valid choice.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagWrap extends StatelessWidget {
  const _TagWrap({required this.labels});

  final Iterable<String> labels;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final String label in labels)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(AppRadius.chip),
              border: Border.all(color: AppColors.outline),
            ),
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
      ],
    );
  }
}
