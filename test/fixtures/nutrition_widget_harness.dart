import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:homefit/core/database/app_database.dart';
import 'package:homefit/core/services/clock.dart';
import 'package:homefit/features/nutrition/data/nutrition_repository.dart';
import 'package:homefit/features/profile/application/profile_providers.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';

import 'nutrition_fixtures.dart';
import 'profile_fixtures.dart';

/// A phone-sized surface, the real database and a fixed clock.
class NutritionHarness {
  NutritionHarness(this.container, this.database, this.repository);

  final ProviderContainer container;
  final AppDatabase database;
  final DriftNutritionRepository repository;
}

/// Pumps one nutrition screen with the app's providers overridden and a
/// deterministic clock, then returns handles for asserting stored state.
Future<NutritionHarness> pumpNutrition(
  WidgetTester tester,
  Widget screen, {
  UserProfile? profile,
  GoRouter? router,
}) async {
  final AppDatabase database = AppDatabase.memory();
  addTearDown(database.close);
  final ProviderContainer container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      initialProfileProvider.overrideWithValue(profile ?? buildTestProfile()),
      clockProvider.overrideWithValue(FixedClock(DateTime(2026, 11, 5, 18))),
    ],
  );
  addTearDown(container.dispose);

  tester.view.physicalSize = const Size(1200, 2700);
  tester.view.devicePixelRatio = 3;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: router != null
          ? MaterialApp.router(theme: ThemeData.dark(), routerConfig: router)
          : MaterialApp(theme: ThemeData.dark(), home: screen),
    ),
  );
  await tester.pumpAndSettle();
  return NutritionHarness(
    container,
    database,
    DriftNutritionRepository(database),
  );
}

/// Scrolls a long screen until [finder] is on screen.
Future<void> reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    320,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}
