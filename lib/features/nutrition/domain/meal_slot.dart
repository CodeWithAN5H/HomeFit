/// The five meal slots the planner and log use.
///
/// Order is display order. Stored values are the enum `name`s, so labels can
/// change without corrupting saved plans or logs.
enum MealSlot {
  breakfast('Breakfast'),
  lunch('Lunch'),
  snack('Evening snack'),
  dinner('Dinner'),
  extraSnack('Extra snack');

  const MealSlot(this.label);

  final String label;

  static MealSlot fromName(String? name) {
    for (final MealSlot slot in values) {
      if (slot.name == name) return slot;
    }
    return breakfast;
  }
}
