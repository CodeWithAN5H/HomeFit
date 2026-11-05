import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/nutrition/domain/nutrition_units.dart';

void main() {
  group('day keys', () {
    test('a calendar day is keyed by its local date', () {
      expect(dateKeyFor(DateTime(2026, 11, 5, 0, 0)), '2026-11-05');
      expect(dateKeyFor(DateTime(2026, 1, 9, 23, 59)), '2026-01-09');
      expect(dateKeyFor(DateTime(2026, 12, 31, 12)), '2026-12-31');
    });

    test('a late-night meal stays on the day it was eaten', () {
      final DateTime beforeMidnight = DateTime(2026, 11, 5, 23, 55);
      final DateTime afterMidnight = beforeMidnight.add(
        const Duration(minutes: 10),
      );
      expect(dateKeyFor(beforeMidnight), '2026-11-05');
      expect(dateKeyFor(afterMidnight), '2026-11-06');
      expect(dateFromKey('2026-11-05').day, 5);
      expect(dateFromKey('2026-11-05').hour, 0);
    });

    test('keys round-trip through midnight local time', () {
      for (final DateTime date in <DateTime>[
        DateTime(2026, 2, 28),
        DateTime(2026, 3, 1),
        DateTime(2027, 1, 1),
        DateTime(2026, 11, 5),
      ]) {
        final String key = dateKeyFor(date);
        final DateTime parsed = dateFromKey(key);
        expect(dateKeyFor(parsed), key);
        expect(
          parsed.isAtSameMomentAs(DateTime(date.year, date.month, date.day)),
          isTrue,
        );
      }
    });

    test('an invalid key falls back instead of throwing', () {
      final DateTime fallback = DateTime(2026, 7, 4, 15, 30);
      expect(
        dateFromKey('not-a-date', fallback: fallback),
        DateTime(2026, 7, 4),
      );
      expect(
        dateFromKey('2026-13-99', fallback: fallback),
        DateTime(2026, 7, 4),
      );
    });

    test('adding days crosses month and year boundaries', () {
      expect(dateKeyFor(addDays(DateTime(2026, 12, 31), 1)), '2027-01-01');
      expect(dateKeyFor(addDays(DateTime(2026, 3, 1), -1)), '2026-02-28');
      expect(dateKeyFor(addDays(DateTime(2026, 11, 5), 30)), '2026-12-05');
      expect(addDays(DateTime(2026, 11, 5, 22), 1), DateTime(2026, 11, 6));
    });
  });
}
