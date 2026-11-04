import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/clock.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/selectable_chip.dart';
import '../../profile/application/profile_providers.dart';
import '../../profile/domain/profile_options.dart';
import '../domain/onboarding_draft.dart';

/// Five short steps that create the local profile.
///
/// Step-specific rules live in [OnboardingDraft]; this widget only renders and
/// forwards input. Saving goes through [ProfileController] and the router then
/// leaves onboarding because the profile state becomes non-null.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final OnboardingDraft _draft = OnboardingDraft();

  final TextEditingController _ageField = TextEditingController();
  final TextEditingController _heightField = TextEditingController();
  final TextEditingController _weightField = TextEditingController();
  final TextEditingController _pushUpsField = TextEditingController();
  final TextEditingController _kneePushUpsField = TextEditingController();
  final TextEditingController _plankField = TextEditingController();
  final TextEditingController _pullUpsField = TextEditingController();

  int _step = 0;
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _pageController.dispose();
    for (final TextEditingController controller in <TextEditingController>[
      _ageField,
      _heightField,
      _weightField,
      _pushUpsField,
      _kneePushUpsField,
      _plankField,
      _pullUpsField,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _applyFields() {
    _draft
      ..age = int.tryParse(_ageField.text.trim())
      ..heightCm = int.tryParse(_heightField.text.trim())
      ..weightKg = double.tryParse(_weightField.text.trim())
      ..pushUps = int.tryParse(_pushUpsField.text.trim())
      ..kneePushUps = int.tryParse(_kneePushUpsField.text.trim())
      ..plankSeconds = int.tryParse(_plankField.text.trim())
      ..pullUps = int.tryParse(_pullUpsField.text.trim());
  }

  Future<void> _handleContinue() async {
    if (_saving) return;
    _applyFields();
    final String? error = _draft.errorForStep(_step);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() => _error = null);
    if (_step < OnboardingDraft.stepCount - 1) {
      setState(() => _step += 1);
      await _pageController.animateToPage(
        _step,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    await _save();
  }

  Future<void> _goBack() async {
    if (_step == 0 || _saving) return;
    setState(() {
      _step -= 1;
      _error = null;
    });
    await _pageController.animateToPage(
      _step,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final DateTime now = ref.read(clockProvider).now();
      await ref
          .read(profileControllerProvider.notifier)
          .saveProfile(
            _draft.buildProfile(now: now),
            assessment: _draft.buildAssessment(now: now),
          );
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Could not save your profile. $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: _step == 0
            ? null
            : IconButton(
                onPressed: _goBack,
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: 'Back',
              ),
        title: const Text('Set up HomeFit'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: (_step + 1) / OnboardingDraft.stepCount,
                  minHeight: 3,
                  backgroundColor: AppColors.surfaceHigh,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _basicsStep(theme),
                  _goalsStep(theme),
                  _setupStep(theme),
                  _foodAndSleepStep(theme),
                  _baselineStep(theme),
                ],
              ),
            ),
            Padding(
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
                      key: const Key('onboarding_error'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.danger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  FilledButton(
                    onPressed: _saving ? null : _handleContinue,
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.onAccent,
                            ),
                          )
                        : Text(
                            _step == OnboardingDraft.stepCount - 1
                                ? 'Finish setup'
                                : 'Continue',
                          ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Step ${_step + 1} of ${OnboardingDraft.stepCount}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepScaffold({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    final ThemeData theme = Theme.of(context);
    return ListView(
      padding: kPagePadding,
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        ...children,
      ],
    );
  }

  Widget _numberField({
    required Key fieldKey,
    required TextEditingController controller,
    required String label,
    String? suffix,
    String? hint,
    bool allowDecimal = false,
  }) {
    return TextField(
      key: fieldKey,
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      textInputAction: TextInputAction.next,
      inputFormatters: allowDecimal
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d{0,3}(\.\d{0,1})?'),
              ),
            ]
          : <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
      ),
    );
  }

  Widget _basicsStep(ThemeData theme) {
    return _stepScaffold(
      title: 'About you',
      subtitle:
          'These numbers set a safe starting point. They are estimates — you can '
          'change them any time after setup.',
      children: [
        _numberField(
          fieldKey: const Key('onboarding_age'),
          controller: _ageField,
          label: 'Age',
          suffix: 'years',
          hint: 'e.g. 18',
        ),
        const SizedBox(height: AppSpacing.md),
        _numberField(
          fieldKey: const Key('onboarding_height'),
          controller: _heightField,
          label: 'Height',
          suffix: 'cm',
          hint: 'e.g. 171',
        ),
        const SizedBox(height: AppSpacing.md),
        _numberField(
          fieldKey: const Key('onboarding_weight'),
          controller: _weightField,
          label: 'Weight',
          suffix: 'kg',
          hint: 'e.g. 47.0',
          allowDecimal: true,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Training experience', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        for (final ExperienceLevel level in ExperienceLevel.values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: SelectableChip(
              label: level.label,
              selected: _draft.experience == level,
              onTap: () => setState(() => _draft.experience = level),
            ),
          ),
        const SizedBox(height: AppSpacing.xs),
        Text(_draft.experience.description, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _goalsStep(ThemeData theme) {
    return _stepScaffold(
      title: 'Goals and focus',
      subtitle:
          'Pick what matters most. HomeFit uses this to balance push, pull, '
          'legs and core rather than training one area every day.',
      children: [
        Text(
          'What are you working toward?',
          style: theme.textTheme.titleMedium,
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
                onTap: () => setState(() {
                  if (!_draft.goals.remove(goal)) _draft.goals.add(goal);
                }),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Anywhere you want extra focus?',
          style: theme.textTheme.titleMedium,
        ),
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
                onTap: () => setState(() {
                  if (!_draft.priorities.remove(priority)) {
                    _draft.priorities.add(priority);
                  }
                }),
              ),
          ],
        ),
      ],
    );
  }

  void _toggleEquipment(EquipmentItem item) {
    setState(() {
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

  Widget _setupStep(ThemeData theme) {
    return _stepScaffold(
      title: 'Your setup',
      subtitle:
          'Bodyweight work is enough to start. Add equipment only if you '
          'actually have it at home.',
      children: [
        Text('Equipment', style: theme.textTheme.titleMedium),
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
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: Text('Session length', style: theme.textTheme.titleMedium),
            ),
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
              setState(() => _draft.sessionMinutes = value.round()),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('When do you usually train?', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final TrainingTimeOfDay time in TrainingTimeOfDay.values)
              SelectableChip(
                label: time.label,
                selected: _draft.trainingTime == time,
                onTap: () => setState(() => _draft.trainingTime = time),
              ),
          ],
        ),
      ],
    );
  }

  Widget _foodAndSleepStep(ThemeData theme) {
    return _stepScaffold(
      title: 'Food and sleep',
      subtitle:
          'HomeFit only suggests affordable vegetarian meals without eggs. '
          'Sleep matters as much as training for progress.',
      children: [
        AppCard(
          child: Row(
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
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Anything to avoid?', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final DietRestriction restriction in DietRestriction.values)
              SelectableChip(
                label: restriction.label,
                selected: _draft.restrictions.contains(restriction),
                onTap: () => setState(() {
                  if (!_draft.restrictions.remove(restriction)) {
                    _draft.restrictions.add(restriction);
                  }
                }),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('How is your sleep?', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        for (final SleepPattern pattern in SleepPattern.values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: SelectableChip(
              label: '${pattern.label} — ${pattern.description}',
              selected: _draft.sleep == pattern,
              onTap: () => setState(() => _draft.sleep = pattern),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          child: SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _draft.notificationsEnabled,
            onChanged: (value) =>
                setState(() => _draft.notificationsEnabled = value),
            title: Text('Reminders', style: theme.textTheme.titleMedium),
            subtitle: Text(
              'Meal and workout reminders. Android will ask for permission '
              'later, and every reminder can be switched off.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }

  Widget _baselineStep(ThemeData theme) {
    return _stepScaffold(
      title: 'Baseline (optional)',
      subtitle:
          'Rough numbers are enough. Leave anything blank if you are unsure — '
          'your first sessions will refine them.',
      children: [
        _numberField(
          fieldKey: const Key('onboarding_pushups'),
          controller: _pushUpsField,
          label: 'Push-ups in one set',
          suffix: 'reps',
          hint: 'blank if unsure',
        ),
        const SizedBox(height: AppSpacing.md),
        _numberField(
          fieldKey: const Key('onboarding_knee_pushups'),
          controller: _kneePushUpsField,
          label: 'Knee push-ups in one set',
          suffix: 'reps',
          hint: 'blank if unsure',
        ),
        const SizedBox(height: AppSpacing.md),
        _numberField(
          fieldKey: const Key('onboarding_plank'),
          controller: _plankField,
          label: 'Plank hold',
          suffix: 'seconds',
          hint: 'blank if unsure',
        ),
        const SizedBox(height: AppSpacing.md),
        _numberField(
          fieldKey: const Key('onboarding_pullups'),
          controller: _pullUpsField,
          label: 'Pull-ups',
          suffix: 'reps',
          hint: '0 is fine',
        ),
        const SizedBox(height: AppSpacing.xl),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text('Safety', style: theme.textTheme.titleMedium),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Never push through sharp pain, joint pain, dizziness or chest '
                'discomfort. Stop and rest. If you have an ongoing health '
                'concern, speak to a doctor — HomeFit cannot diagnose anything.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
