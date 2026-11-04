import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../data/profile_repository.dart';
import '../domain/fitness_assessment.dart';
import '../domain/user_profile.dart';

/// Overridden in `main()` with the opened database.
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw StateError(
    'appDatabaseProvider must be overridden at startup (see lib/main.dart).',
  ),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => DriftProfileRepository(ref.watch(appDatabaseProvider)),
);

/// Profile read before the first frame, so routing can decide synchronously
/// whether onboarding is needed (no flash of the wrong screen).
final initialProfileProvider = Provider<UserProfile?>((ref) => null);

final profileControllerProvider =
    NotifierProvider<ProfileController, UserProfile?>(ProfileController.new);

class ProfileController extends Notifier<UserProfile?> {
  @override
  UserProfile? build() => ref.watch(initialProfileProvider);

  /// Persists the profile (and an optional baseline assessment), then publishes
  /// it. Routing listens to this state to leave onboarding.
  Future<void> saveProfile(
    UserProfile profile, {
    FitnessAssessment? assessment,
  }) async {
    final repository = ref.read(profileRepositoryProvider);
    await repository.saveProfile(profile);
    if (assessment != null && !assessment.isEmpty) {
      await repository.saveAssessment(assessment);
    }
    state = profile;
  }
}
