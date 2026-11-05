/// Every navigation target in the app, in one place.
///
/// Screens import this file instead of the router, so navigation constants can
/// be used without creating an import cycle with [appRouterProvider].
abstract final class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String workout = '/workout';
  static const String workoutExercises = '$workout/exercises';

  /// Detail screen for one bundled exercise.
  static String exerciseDetail(String exerciseId) =>
      '$workoutExercises/$exerciseId';
  static const String nutrition = '/nutrition';
  static const String progress = '/progress';
  static const String coach = '/coach';
  static const String profileEdit = '/profile/edit';
}
