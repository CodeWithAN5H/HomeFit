import '../../profile/domain/profile_options.dart';
import '../../profile/domain/user_profile.dart';

/// Transparent, deliberately conservative daily nutrition targets.
///
/// Sex is not part of the saved profile, and an app cannot know body
/// composition, so this returns a *range* rather than a precise number. The
/// range is based on self-reported weight and light daily activity, with a
/// modest surplus only when the user's own goal is to gain weight or muscle.
/// It is educational, not medical advice, and is never a prescription.
class NutritionTargets {
  const NutritionTargets({
    required this.isAvailable,
    required this.kcalLow,
    required this.kcalHigh,
    required this.proteinLowG,
    required this.proteinHighG,
    required this.assumptions,
    this.unavailableReason,
  });

  /// Used when the profile cannot support a responsible target (for example a
  /// minor, whose growth needs differ and who should get individual advice).
  const NutritionTargets.unavailable(String reason)
    : isAvailable = false,
      kcalLow = 0,
      kcalHigh = 0,
      proteinLowG = 0,
      proteinHighG = 0,
      assumptions = const <String>[],
      unavailableReason = reason;

  final bool isAvailable;
  final double kcalLow;
  final double kcalHigh;
  final double proteinLowG;
  final double proteinHighG;

  /// Every assumption behind the numbers, in plain language.
  final List<String> assumptions;
  final String? unavailableReason;

  double get kcalMid => (kcalLow + kcalHigh) / 2;
  double get proteinMid => (proteinLowG + proteinHighG) / 2;

  static NutritionTargets estimate(UserProfile profile) {
    if (profile.age < 18) {
      return const NutritionTargets.unavailable(
        'Nutrition targets in HomeFit are designed for adults. At 17 or '
        'younger, growth and activity needs differ, so ask a doctor or '
        'dietitian for individual advice instead of following an app target.',
      );
    }

    final bool gaining =
        profile.goals.contains(TrainingGoal.buildMuscle) ||
        profile.goals.contains(TrainingGoal.healthyWeightGain);
    final bool lactoseFree = profile.restrictions.contains(
      DietRestriction.lactoseIntolerant,
    );
    final bool nutFree = profile.restrictions.contains(
      DietRestriction.nutAllergy,
    );
    final bool glutenFree = profile.restrictions.contains(
      DietRestriction.glutenSensitive,
    );

    // 30–35 kcal per kg is a population estimate for light daily activity.
    // The extra 200–300 kcal for a gain goal is intentionally small: it favours
    // consistency over a fast scale change.
    final double maintenanceLow = profile.weightKg * 30;
    final double maintenanceHigh = profile.weightKg * 35;
    final double kcalLow = (gaining ? maintenanceLow + 200 : maintenanceLow)
        .clamp(1600, 4000)
        .toDouble();
    final double kcalHigh = (gaining ? maintenanceHigh + 300 : maintenanceHigh)
        .clamp(1700, 4200)
        .toDouble();

    final double proteinLow = (profile.weightKg * 1.2)
        .clamp(45, 160)
        .toDouble();
    final double proteinHigh = (profile.weightKg * 1.6)
        .clamp(55, 200)
        .toDouble();

    final List<String> assumptions = <String>[
      'Maintenance is estimated at 30–35 kcal per kg of your saved weight '
          '(about light daily activity).',
      if (gaining)
        'Because your goal includes building muscle or healthy weight gain, '
            'the range adds a modest 200–300 kcal — no aggressive surplus.',
      'Protein is set at 1.2–1.6 g per kg, which home vegetarian meals '
          '(dal, curd, paneer, soy, chana) can meet without supplements.',
      'Sex is not recorded, so the range stays wide instead of pretending to '
          'a precise figure.',
      'Your weight is self-reported and not a measurement taken by the app.',
      if (lactoseFree)
        'Your lactose-intolerance restriction is respected in suggestions; '
            'targets themselves do not change.',
      if (nutFree)
        'Your nut-allergy restriction is respected; peanut and tree-nut foods '
            'are filtered out of suggestion copy.',
      if (glutenFree)
        'Your gluten-sensitivity restriction is respected; wheat items are '
            'avoided in suggestions.',
      'These are estimates for planning, not medical or dietetic advice.',
    ];

    return NutritionTargets(
      isAvailable: true,
      kcalLow: kcalLow,
      kcalHigh: kcalHigh,
      proteinLowG: proteinLow,
      proteinHighG: proteinHigh,
      assumptions: assumptions,
    );
  }
}
