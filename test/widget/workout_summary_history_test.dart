import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:homefit/core/database/app_database.dart';
import 'package:homefit/core/routing/app_routes.dart';
import 'package:homefit/core/services/clock.dart';
import 'package:homefit/features/profile/application/profile_providers.dart';
import 'package:homefit/features/workouts/application/workout_providers.dart';
import 'package:homefit/features/workouts/data/workout_repository.dart';
import 'package:homefit/features/workouts/domain/workout_mode.dart';
import 'package:homefit/features/workouts/domain/workout_session.dart';
import 'package:homefit/features/workouts/presentation/workout_history_screen.dart';
import 'package:homefit/features/workouts/presentation/workout_summary_screen.dart';

import '../fixtures/profile_fixtures.dart';
import '../fixtures/workout_fixtures.dart';

Future<ProviderContainer> pumpWorkoutApp(
  WidgetTester tester, {
  required List<WorkoutSession> sessions,
  required String location,
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
      clockProvider.overrideWithValue(TestClock(DateTime(2026, 11, 5, 18))),
    ],
  );
  addTearDown(container.dispose);

  final GoRouter router = GoRouter(
    initialLocation: location,
    routes: <RouteBase>[
      GoRoute(
        path: '/workout',
        builder: (context, state) => const Text('workout-route'),
      ),
      GoRoute(
        path: '/workout/summary/:sessionId',
        builder: (context, state) => WorkoutSummaryScreen(
          sessionId: state.pathParameters['sessionId'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.workoutHistory,
        builder: (context, state) => const WorkoutHistoryScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: ':sessionId',
            builder: (context, state) => WorkoutSessionDetailScreen(
              sessionId: state.pathParameters['sessionId'] ?? '',
            ),
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
  await tester.scrollUntilVisible(finder, 250);
  await tester.pumpAndSettle();
}

void main() {
  final WorkoutSession completed = buildStoredSession(
    id: 'done',
    startedAt: DateTime(2026, 11, 3, 19),
    status: WorkoutSessionStatus.completed,
    effort: 3,
  );

  testWidgets('summary reports the work, the status and the effort', (
    tester,
  ) async {
    await pumpWorkoutApp(
      tester,
      sessions: <WorkoutSession>[completed],
      location: AppRoutes.workoutSummary('done'),
    );

    expect(find.text('Session complete'), findsOneWidget);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Bodyweight squat'), findsOneWidget);

    await reveal(tester, find.byKey(const Key('summary_done')));
    expect(find.text('Saved: effort 3 of 5.'), findsOneWidget);
    expect(find.byKey(const Key('summary_done')), findsOneWidget);
  });

  testWidgets('effort can be changed from the summary', (tester) async {
    final ProviderContainer container = await pumpWorkoutApp(
      tester,
      sessions: <WorkoutSession>[
        buildStoredSession(
          id: 'done',
          startedAt: DateTime(2026, 11, 3, 19),
          status: WorkoutSessionStatus.completed,
        ),
      ],
      location: AppRoutes.workoutSummary('done'),
    );

    await reveal(tester, find.byKey(const Key('effort_2')));
    await tester.tap(find.byKey(const Key('effort_2')));
    await tester.pumpAndSettle();

    final WorkoutSession? stored = await container
        .read(workoutRepositoryProvider)
        .readSession('done');
    expect(stored!.perceivedEffort, 2);
    expect(find.text('Saved: effort 2 of 5.'), findsOneWidget);
  });

  testWidgets('an abandoned session is honest about not counting', (
    tester,
  ) async {
    await pumpWorkoutApp(
      tester,
      sessions: <WorkoutSession>[
        buildStoredSession(
          id: 'abandoned',
          startedAt: DateTime(2026, 11, 4, 19),
          status: WorkoutSessionStatus.abandoned,
          reps: const <int>[],
        ),
      ],
      location: AppRoutes.workoutSummary('abandoned'),
    );

    expect(
      find.textContaining('not counted as a completed workout'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('effort_1')), findsNothing);
  });

  testWidgets('missing sessions show a not-found state', (tester) async {
    await pumpWorkoutApp(
      tester,
      sessions: const <WorkoutSession>[],
      location: AppRoutes.workoutSummary('missing'),
    );
    expect(find.text('Session not found'), findsOneWidget);
  });

  testWidgets('history explains an empty state', (tester) async {
    await pumpWorkoutApp(
      tester,
      sessions: const <WorkoutSession>[],
      location: AppRoutes.workoutHistory,
    );

    expect(find.byKey(const Key('history_empty')), findsOneWidget);
    expect(find.text('No sessions yet'), findsOneWidget);
  });

  testWidgets('history lists completed and abandoned sessions', (tester) async {
    await pumpWorkoutApp(
      tester,
      sessions: <WorkoutSession>[
        completed,
        buildStoredSession(
          id: 'dropped',
          startedAt: DateTime(2026, 11, 4, 19),
          status: WorkoutSessionStatus.abandoned,
          reps: const <int>[],
        ),
      ],
      location: AppRoutes.workoutHistory,
    );

    expect(find.byKey(const Key('history_session_done')), findsOneWidget);
    expect(find.byKey(const Key('history_session_dropped')), findsOneWidget);
    expect(find.text('1 completed · 2 total'), findsOneWidget);
    expect(find.text('Abandoned'), findsOneWidget);
  });

  testWidgets('a history entry opens its stored detail', (tester) async {
    await pumpWorkoutApp(
      tester,
      sessions: <WorkoutSession>[completed],
      location: AppRoutes.workoutHistory,
    );

    await tester.tap(find.byKey(const Key('history_session_done')));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Session'), findsOneWidget);
    expect(find.text('Bodyweight squat'), findsOneWidget);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Bodyweight squat'), findsOneWidget);
  });
}
