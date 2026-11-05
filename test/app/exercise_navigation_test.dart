import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:homefit/core/database/app_database.dart';
import 'package:homefit/core/routing/app_router.dart';
import 'package:homefit/core/routing/app_routes.dart';
import 'package:homefit/features/profile/application/profile_providers.dart';

import '../fixtures/profile_fixtures.dart';

/// Drives the real router so the Workout tab really reaches the library and
/// the library really reaches a detail screen.
void main() {
  testWidgets('Workout tab opens the library and an exercise', (tester) async {
    final AppDatabase database = AppDatabase.memory();
    addTearDown(database.close);
    final ProviderContainer container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        initialProfileProvider.overrideWithValue(buildTestProfile()),
      ],
    );
    addTearDown(container.dispose);

    final GoRouter router = container.read(appRouterProvider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    router.go(AppRoutes.workout);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('exercise_library_entry')),
      250,
    );
    expect(find.byKey(const Key('exercise_library_entry')), findsOneWidget);

    await tester.tap(find.byKey(const Key('exercise_library_entry')));
    await tester.pumpAndSettle();
    expect(find.text('Exercise library'), findsOneWidget);
    expect(find.byKey(const Key('exercise_search')), findsOneWidget);

    await tester.tap(find.byKey(const Key('exercise_card_band-biceps-curl')));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Band biceps curl'), findsOneWidget);
  });
}
