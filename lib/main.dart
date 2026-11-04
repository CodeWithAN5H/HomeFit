import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/startup_failure_app.dart';
import 'core/database/app_database.dart';
import 'features/profile/application/profile_providers.dart';
import 'features/profile/data/profile_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final AppDatabase database = await AppDatabase.open();
    final ProfileRepository repository = DriftProfileRepository(database);
    // Read the profile before the first frame so routing can decide
    // synchronously whether onboarding is required.
    final profile = await repository.readProfile();

    runApp(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          profileRepositoryProvider.overrideWithValue(repository),
          initialProfileProvider.overrideWithValue(profile),
        ],
        child: const HomeFitApp(),
      ),
    );
  } on Object catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'HomeFit bootstrap',
      ),
    );
    runApp(StartupFailureApp(message: error.toString()));
  }
}
