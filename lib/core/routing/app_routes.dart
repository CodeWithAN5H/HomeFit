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

  /// Preview of a session before it starts. [mode] is a [WorkoutMode] name;
  /// [templateId] and [muscle] narrow what is planned.
  static String workoutPreview({
    required String mode,
    String? templateId,
    String? muscle,
  }) {
    return Uri(
      path: '$workout/preview',
      queryParameters: <String, String>{
        'mode': mode,
        'template': ?templateId,
        'muscle': ?muscle,
      },
    ).toString();
  }

  /// The guided runner. Only reachable while a session is open.
  static const String workoutSession = '$workout/session';

  static String workoutSummary(String sessionId) =>
      '$workout/summary/$sessionId';

  static const String workoutHistory = '$workout/history';

  static String workoutSessionDetail(String sessionId) =>
      '$workoutHistory/$sessionId';

  static const String nutrition = '/nutrition';
  static const String nutritionPlan = '$nutrition/plan';
  static const String nutritionLog = '$nutrition/log';
  static const String nutritionRecipes = '$nutrition/recipes';
  static const String nutritionGrocery = '$nutrition/grocery';

  /// Detail screen for one bundled recipe.
  static String nutritionRecipeDetail(String recipeId) =>
      '$nutritionRecipes/$recipeId';
  static const String progress = '/progress';
  static const String coach = '/coach';
  static const String profileEdit = '/profile/edit';
}
