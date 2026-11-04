/// Time-of-day greeting used on the home screen.
///
/// Kept as a pure function so its boundaries can be unit tested.
String greetingForHour(int hour) {
  assert(hour >= 0 && hour <= 23, 'hour must be 0-23');
  if (hour >= 5 && hour < 12) return 'Good morning';
  if (hour >= 12 && hour < 17) return 'Good afternoon';
  if (hour >= 17 && hour < 22) return 'Good evening';
  return 'Good night';
}
