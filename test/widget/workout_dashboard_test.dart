import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:homefit/core/database/app_database.dart';
import 'package:homefit/core/routing/app_routes.dart';
import 'package:homefit/core/services/clock.dart';
import 'package:homefit/features/profile/application/profile_providers.dart';
import 'package:homefit/features/workouts/data/workout_repository.dart';
import 'package:homefit/features/workouts/domain/workout_session.dart';
import 'package:homefit/features/workouts/presentation/workout_screen.dart';

import '../fixtures/profile_fixtures.dart';
import '../fixtures/workout_fixtures.dart';

Future<ProviderContainer> pumpDashboard(
  WidgetTester tester, {
  List<WorkoutSession> sessions = const <WorkoutSession>[],
  DateTime? now,
}) async {
  final AppDatabase database = AppDatabase.memory();
  addTearDown(database.close);
  final DriftWorkoutRepository repository = DriftWorkoutRepository(database);
  for (final WorkoutSession session in sessions) {
    await repository.createSession(session);
  }

  final ProviderContainer container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      initialProfileProvider.overrideWithValue(buildTestProfile()),
      clockProvider.overrideWithValue(
        TestClock(now ?? DateTime(2026, 11, 5, 18)),
      ),
    ],
  );
  addTearDown(container.dispose);

  final GoRouter router = GoRouter(
    initialLocation: AppRoutes.workout,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.workout,
        builder: (context, state) => const WorkoutScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'preview',
            builder: (context, state) => const Text('preview-route'),
          ),
          GoRoute(
            path: 'session',
            builder: (context, state) => const Text('session-route'),
          ),
          GoRoute(
            path: 'history',
            builder: (context, state) => const Text('history-route'),
          ),
        ],
      ),
    ],
  );

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

Future<void> reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder, 300);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the dashboard recommends the first full-body session', (
    tester,
  ) async {
    await pumpDashboard(tester);

    expect(find.byKey(const Key('today_card')), findsOneWidget);
    expect(find.text('Full body A'), findsOneWidget);
    expect(find.textContaining('≈'), findsWidgets);
    expect(find.byKey(const Key('start_today')), findsOneWidget);

    await reveal(tester, find.byKey(const Key('mode_quick')));
    expect(find.byKey(const Key('mode_recovery')), findsOneWidget);
    expect(find.byKey(const Key('mode_skill')), findsOneWidget);

    await reveal(tester, find.byKey(const Key('targeted_chest')));
    expect(find.byKey(const Key('no_sessions')), findsOneWidget);

    await reveal(tester, find.byKey(const Key('exercise_library_entry')));
    expect(find.byKey(const Key('exercise_library_entry')), findsOneWidget);
  });

  testWidgets('training today turns the card into a recovery day', (
    tester,
  ) async {
    await pumpDashboard(
      tester,
      sessions: <WorkoutSession>[
        buildTestSession(id: 'today', startedAt: DateTime(2026, 11, 5, 9)),
      ],
    );

    expect(find.byKey(const Key('today_card')), findsOneWidget);
    expect(find.text('Today · recovery'), findsOneWidget);
    expect(find.text('Open recovery'), findsOneWidget);
  });

  testWidgets('a stored session appears in the recent list', (tester) async {
    await pumpDashboard(
      tester,
      sessions: <WorkoutSession>[
        buildTestSession(
          id: 'done',
          startedAt: DateTime(2026, 11, 3, 19),
          perceivedEffort: 3,
        ),
      ],
    );

    await reveal(tester, find.byKey(const Key('recent_session_done')));
    expect(find.byKey(const Key('recent_session_done')), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.byKey(const Key('no_sessions')), findsNothing);
  });

  testWidgets('an open session offers resume instead of a new start', (
    tester,
  ) async {
    await pumpDashboard(
      tester,
      sessions: <WorkoutSession>[
        buildStoredSession(id: 'open', startedAt: DateTime(2026, 11, 5, 9)),
      ],
    );

    expect(find.byKey(const Key('resume_session')), findsOneWidget);
    expect(find.text('Session in progress'), findsOneWidget);

    await tester.tap(find.byKey(const Key('resume_session_button')));
    await tester.pumpAndSettle();
    expect(find.text('session-route'), findsOneWidget);
  });

  testWidgets('starting today opens the preview, not the runner', (
    tester,
  ) async {
    await pumpDashboard(tester);
    await tester.tap(find.byKey(const Key('start_today')));
    await tester.pumpAndSettle();
    expect(find.text('preview-route'), findsOneWidget);
  });

  testWidgets('history is reachable from the dashboard', (tester) async {
    await pumpDashboard(tester);
    await reveal(tester, find.byKey(const Key('workout_history_link')));
    await tester.tap(find.byKey(const Key('workout_history_link')));
    await tester.pumpAndSettle();
    expect(find.text('history-route'), findsOneWidget);
  });
}
