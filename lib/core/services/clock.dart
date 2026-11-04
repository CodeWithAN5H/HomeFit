import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstraction over "now" so time-dependent behaviour (greetings, streaks,
/// Restart Mode later) can be tested deterministically.
abstract interface class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

final clockProvider = Provider<Clock>((ref) => const SystemClock());
