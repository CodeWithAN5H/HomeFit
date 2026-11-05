/// Date and unit helpers shared by the nutrition feature.
///
/// Food logs are keyed by a calendar *day*, not an instant: a meal eaten at
/// 23:55 belongs to that day even after the clock passes midnight. Storing
/// `yyyy-MM-dd` text keeps that decision stable across time zones and restarts.
library;

/// `2026-11-05` for the local calendar day of [date].
String dateKeyFor(DateTime date) {
  final String month = date.month.toString().padLeft(2, '0');
  final String day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

/// Parses a stored day key into local midnight.
///
/// A key that is not a real calendar date (for example `2026-02-30`) is
/// rejected rather than silently normalised into another day, and falls back.
DateTime dateFromKey(String key, {DateTime? fallback}) {
  final List<String> parts = key.split('-');
  if (parts.length == 3) {
    final int? year = int.tryParse(parts[0]);
    final int? month = int.tryParse(parts[1]);
    final int? day = int.tryParse(parts[2]);
    if (year != null && month != null && day != null) {
      final DateTime parsed = DateTime(year, month, day);
      if (parsed.year == year && parsed.month == month && parsed.day == day) {
        return parsed;
      }
    }
  }
  final DateTime base = fallback ?? DateTime.now();
  return DateTime(base.year, base.month, base.day);
}

/// Adds whole calendar days without crossing into a different time of day.
DateTime addDays(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);

/// `1 bowl`, `250 ml`, `1.5 servings`.
String formatQuantity(double amount, String unit) {
  if (unit == 'serving') {
    final String servings = amount == amount.roundToDouble()
        ? amount.round().toString()
        : amount.toStringAsFixed(1);
    return '$servings ${amount == 1 ? 'serving' : 'servings'}';
  }
  if (unit == 'g' || unit == 'ml') {
    if (amount >= 1000) {
      final double scaled = amount / 1000;
      final String value = scaled == scaled.roundToDouble()
          ? scaled.round().toString()
          : scaled.toStringAsFixed(1);
      return '$value ${unit == 'g' ? 'kg' : 'L'}';
    }
    return '${amount.round()} $unit';
  }
  return '${amount.toStringAsFixed(1)} $unit';
}

/// Estimated calories are shown rounded; the stored value stays precise.
String formatKcal(double kcal) => '${kcal.round()} kcal';

/// Grams of a macro, rounded for display.
String formatGrams(double grams) => '${grams.round()} g';
