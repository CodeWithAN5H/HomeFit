/// Calories and the three macros for a food, serving or whole day.
///
/// Values are estimates: household portions vary and Indian home cooking adds
/// unknown amounts of oil. Totals are accumulated unrounded and only rounded
/// for display, so small portions do not disappear.
class NutritionTotals {
  const NutritionTotals({
    this.kcal = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
  });

  static const NutritionTotals zero = NutritionTotals();

  final double kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;

  bool get isEmpty => kcal == 0 && proteinG == 0 && carbsG == 0 && fatG == 0;

  NutritionTotals operator +(NutritionTotals other) => NutritionTotals(
    kcal: kcal + other.kcal,
    proteinG: proteinG + other.proteinG,
    carbsG: carbsG + other.carbsG,
    fatG: fatG + other.fatG,
  );

  NutritionTotals scale(double factor) => NutritionTotals(
    kcal: kcal * factor,
    proteinG: proteinG * factor,
    carbsG: carbsG * factor,
    fatG: fatG * factor,
  );
}
