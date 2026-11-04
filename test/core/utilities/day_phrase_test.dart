import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/core/utilities/day_phrase.dart';

void main() {
  group('greetingForHour', () {
    test('uses morning before noon', () {
      expect(greetingForHour(5), 'Good morning');
      expect(greetingForHour(11), 'Good morning');
    });

    test('uses afternoon from noon to late afternoon', () {
      expect(greetingForHour(12), 'Good afternoon');
      expect(greetingForHour(16), 'Good afternoon');
    });

    test('uses evening until late night', () {
      expect(greetingForHour(17), 'Good evening');
      expect(greetingForHour(21), 'Good evening');
    });

    test('uses night after 22 and before 5', () {
      expect(greetingForHour(22), 'Good night');
      expect(greetingForHour(23), 'Good night');
      expect(greetingForHour(0), 'Good night');
      expect(greetingForHour(4), 'Good night');
    });
  });
}
