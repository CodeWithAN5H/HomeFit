import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/coach/presentation/coach_screen.dart';
import '../../features/dashboard/presentation/home_screen.dart';
import '../../features/exercises/presentation/exercise_detail_screen.dart';
import '../../features/exercises/presentation/exercise_library_screen.dart';
import '../../features/nutrition/presentation/nutrition_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/application/profile_providers.dart';
import '../../features/profile/domain/user_profile.dart';
import '../../features/profile/presentation/profile_edit_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/workouts/presentation/workout_screen.dart';
import '../../app/home_shell.dart';
import 'app_routes.dart';

/// Notifies GoRouter when the profile appears, without rebuilding the router
/// (which would discard the navigation stack and shell state).
class _RouterRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh();
  ref.onDispose(refresh.dispose);
  // Only the presence of a profile changes routing (onboarding <-> app).
  // Refreshing on every save would rebuild the route stack while the editor
  // is popping, which pushed the closed editor back onto the stack.
  ref.listen<UserProfile?>(profileControllerProvider, (previous, next) {
    if ((previous == null) != (next == null)) refresh.refresh();
  });

  final router = GoRouter(
    initialLocation: ref.read(profileControllerProvider) == null
        ? AppRoutes.onboarding
        : AppRoutes.home,
    refreshListenable: refresh,
    redirect: (context, state) {
      final hasProfile = ref.read(profileControllerProvider) != null;
      final onOnboarding = state.matchedLocation == AppRoutes.onboarding;
      if (!hasProfile && !onOnboarding) return AppRoutes.onboarding;
      if (hasProfile && onOnboarding) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileEdit,
        builder: (context, state) => const ProfileEditScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.workout,
                builder: (context, state) => const WorkoutScreen(),
                routes: [
                  GoRoute(
                    path: 'exercises',
                    builder: (context, state) => const ExerciseLibraryScreen(),
                    routes: [
                      GoRoute(
                        path: ':exerciseId',
                        builder: (context, state) => ExerciseDetailScreen(
                          exerciseId: state.pathParameters['exerciseId'] ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.nutrition,
                builder: (context, state) => const NutritionScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.progress,
                builder: (context, state) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.coach,
                builder: (context, state) => const CoachScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
