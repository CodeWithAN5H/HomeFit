import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/clock.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/number_field.dart';
import '../../../shared/widgets/selectable_chip.dart';
import '../../onboarding/domain/onboarding_draft.dart';
import '../application/profile_providers.dart';
import '../domain/profile_options.dart';
import '../domain/user_profile.dart';

/// One scrollable editor for the saved profile.
///
/// It reuses [OnboardingDraft] for prepopulation and validation, so setup and
/// later edits can never disagree about what a valid profile is. Saving writes
/// the single `primary` row through the same repository as onboarding, keeping
/// the creation time and leaving the baseline assessment untouched.
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _ageField = TextEditingController();
  final TextEditingController _heightField = TextEditingController();
  final TextEditingController _weightField = TextEditingController();

  late UserProfile _original;
  late OnboardingDraft _draft;
  String? _error;
  bool _saving = false;
  bool _hasProfile = false;

  @override
  void initState() {
    super.initState();
    final UserProfile? profile = ref.read(profileControllerProvider);
    if (profile == null) return;
    _hasProfile = true;
    _original = profile;
    _draft = OnboardingDraft.fromProfile(profile);
    _ageField.text = '${profile.age}';
    _heightField.text = '${profile.heightCm}';
    _weightField.text = profile.weightKg.toStringAsFixed(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _ageField.dispose();
    _heightField.dispose();
    _weightField.dispose();
    super.dispose();
  }

  void _applyFields() {
    _draft
      ..age = int.tryParse(_ageField.text.trim())
      ..heightCm = int.tryParse(_heightField.text.trim())
      ..weightKg = double.tryParse(_weightField.text.trim());
  }

  /// Clears a stale validation message as soon as the user edits anything.
  void _edited() {
    if (_error == null) return;
    setState(() => _error = null);
  }

  /// Applies a draft change and clears the message in a single rebuild.
  void _update(VoidCallback change) {
    setState(() {
      change();
      _error = null;
    });
  }

  void _toggleEquipment(EquipmentItem item) {
    _update(() {
      if (item == EquipmentItem.bodyweight) {
        _draft.equipment
          ..clear()
          ..add(item);
        return;
      }
      _draft.equipment.remove(EquipmentItem.bodyweight);
      if (!_draft.equipment.remove(item)) _draft.equipment.add(item);
    });
  }

  void _cancel() {
    if (_saving) return;
    context.pop();
  }

  Future<void> _save() async {
    if (_saving) return;
    _applyFields();
    final String? error = _draft.validateProfile();
    if (error != null) {
      setState(() => _error = error);
      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final DateTime now = ref.read(clockProvider).now();
      final UserProfile updated = _draft.buildProfile(
        now: now,
        createdAt: _original.createdAt,
      );
      await ref.read(profileControllerProvider.notifier).saveProfile(updated);
      if (!mounted) return;
      // Captured before popping; the messenger lives above this route.
      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      context.pop();
      messenger.showSnackBar(const SnackBar(content: Text('Profile updated.')));
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Could not save your changes. $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (!_hasProfile) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit profile')),
        body: Center(
          child: Padding(
            padding: kPagePadding,
            child: Text(
              'No profile was found on this device, so there is nothing to '
              'edit yet.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('profile_cancel_icon'),
          onPressed: _saving ? null : _cancel,
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Cancel',
        ),
        title: const Text('Edit profile'),
      ),
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          padding: kPagePadding,
          children: [
            Text(
              'Changes are saved on this device only. Nothing is uploaded.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            _basicsCard(theme),
            const SizedBox(height: AppSpacing.md),
            _goalsCard(theme),
            const SizedBox(height: AppSpacing.md),
            _focusCard(theme),
            const SizedBox(height: AppSpacing.md),
            _setupCard(theme),
            const SizedBox(height: AppSpacing.md),
            _foodAndSleepCard(theme),
            const SizedBox(height: AppSpacing.md),
            _remindersCard(theme),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_error != null) ...[
                Text(
                  _error!,
                  key: const Key('profile_error'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('profile_cancel'),
                      onPressed: _saving ? null : _cancel,
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      key: const Key('profile_save'),
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.onAccent,
                              ),
                            )
                          : const Text('Save changes'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, String title) {
    return Text(title, style: theme.textTheme.titleMedium);
  }

  Widget _basicsCard(ThemeData theme) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(theme, 'About you'),
          const SizedBox(height: AppSpacing.md),
          AppNumberField(
            fieldKey: const Key('profile_age'),
            controller: _ageField,
            label: 'Age',
            suffix: 'years',
            onChanged: (_) => _edited(),
          ),
          const SizedBox(height: AppSpacing.md),
          AppNumberField(
            fieldKey: const Key('profile_height'),
            controller: _heightField,
            label: 'Height',
            suffix: 'cm',
            onChanged: (_) => _edited(),
          ),
          const SizedBox(height: AppSpacing.md),
          AppNumberField(
            fieldKey: const Key('profile_weight'),
            controller: _weightField,
            label: 'Weight',
            suffix: 'kg',
            allowDecimal: true,
            onChanged: (_) => _edited(),
          ),
          const SizedBox(height: AppSpacing.lg),
          _sectionTitle(theme, 'Training experience'),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final ExperienceLevel level in ExperienceLevel.values)
                SelectableChip(
                  label: level.label,
                  selected: _draft.experience == level,
                  onTap: () => _update(() => _draft.experience = level),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(_draft.experience.description, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _goalsCard(ThemeData theme) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(theme, 'Goals'),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Keep at least one goal selected.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final TrainingGoal goal in TrainingGoal.values)
                SelectableChip(
                  label: goal.label,
                  selected: _draft.goals.contains(goal),
                  onTap: () => _update(() {
                    if (!_draft.goals.remove(goal)) _draft.goals.add(goal);
                  }),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _focusCard(ThemeData theme) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(theme, 'Focus areas'),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Optional. Balance still comes first.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final MusclePriority priority in MusclePriority.values)
                SelectableChip(
                  label: priority.label,
                  selected: _draft.priorities.contains(priority),
                  onTap: () => _update(() {
                    if (!_draft.priorities.remove(priority)) {
                      _draft.priorities.add(priority);
                    }
                  }),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _setupCard(ThemeData theme) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(theme, 'Equipment'),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final EquipmentItem item in EquipmentItem.values)
                SelectableChip(
                  label: item.label,
                  selected: _draft.equipment.contains(item),
                  onTap: () => _toggleEquipment(item),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: _sectionTitle(theme, 'Session length')),
              Text(
                '${_draft.sessionMinutes} min',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Slider(
            value: _draft.sessionMinutes.toDouble(),
            min: 20,
            max: 60,
            divisions: 8,
            label: '${_draft.sessionMinutes} min',
            onChanged: (value) =>
                _update(() => _draft.sessionMinutes = value.round()),
          ),
          const SizedBox(height: AppSpacing.sm),
          _sectionTitle(theme, 'When do you usually train?'),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final TrainingTimeOfDay time in TrainingTimeOfDay.values)
                SelectableChip(
                  label: time.label,
                  selected: _draft.trainingTime == time,
                  onTap: () => _update(() => _draft.trainingTime = time),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _foodAndSleepCard(ThemeData theme) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(theme, 'Food'),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.eco_outlined,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Vegetarian, no eggs',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'HomeFit currently plans vegetarian meals without eggs only, so '
            'this cannot be changed yet.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          _sectionTitle(theme, 'Anything to avoid?'),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final DietRestriction restriction in DietRestriction.values)
                SelectableChip(
                  label: restriction.label,
                  selected: _draft.restrictions.contains(restriction),
                  onTap: () => _update(() {
                    if (!_draft.restrictions.remove(restriction)) {
                      _draft.restrictions.add(restriction);
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _sectionTitle(theme, 'How is your sleep?'),
          const SizedBox(height: AppSpacing.sm),
          for (final SleepPattern pattern in SleepPattern.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: SelectableChip(
                label: '${pattern.label} — ${pattern.description}',
                selected: _draft.sleep == pattern,
                onTap: () => _update(() => _draft.sleep = pattern),
              ),
            ),
        ],
      ),
    );
  }

  Widget _remindersCard(ThemeData theme) {
    return AppCard(
      child: SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        value: _draft.notificationsEnabled,
        onChanged: (value) =>
            _update(() => _draft.notificationsEnabled = value),
        title: Text('Reminders', style: theme.textTheme.titleMedium),
        subtitle: Text(
          'Meal and workout reminders. No notification is scheduled in this '
          'build yet; this preference is stored for when they are.',
          style: theme.textTheme.bodySmall,
        ),
      ),
    );
  }
}
