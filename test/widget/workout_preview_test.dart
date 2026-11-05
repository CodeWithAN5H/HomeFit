import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:homefit/core/database/app_database.dart';
import 'package:homefit/core/routing/app_routes.dart';
import 'package:homefit/core/services/clock.dart';
import 'package:homefit/features/profile/application/profile_providers.dart';
import 'package:homefit/features/workouts/application/workout_providers.dart';
import 'package:homefit/features/workouts/presentation/workout_preview_screen.dart';
import 'package:homefit/features/workouts/presentation/workout_session_screen.dart';

import '../fixtures/profile_fixtures.dart';
import '../fixtures/workout_fixtures.dart';

Future<ProviderContainer> pumpPreview(
  WidgetTester tester, {
  String mode = 'normal',
  String? templateId = 'full-body-a',
  String? muscle,
}) async {
  final AppDatabase database = AppDatabase.memory();
  addTearDown(database.close);
  final ProviderContainer container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      initialProfileProvider.overrideWithValue(buildTestProfile()),
      clockProvider.overrideWithValue(TestClock(DateTime(2026, 11, 5, 18))),
    ],
  );
  addTearDown(container.dispose);

  final GoRouter router = GoRouter(
    initialLocation: '/preview',
    routes: <RouteBase>[
      GoRoute(
        path: '/preview',
        builder: (context, state) => WorkoutPreviewScreen(
          mode: mode,
          templateId: templateId,
          muscle: muscle,
        ),
      ),
      GoRoute(
        path: AppRoutes.workoutSession,
        builder: (context, state) => const WorkoutSessionScreen(),
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
  testWidgets('preview explains the mode and lists the plan', (tester) async {
    await pumpPreview(tester);

    expect(find.text('Full body A'), findsOneWidget);
    expect(find.byKey(const Key('mode_explanation')), findsOneWidget);
    expect(find.textContaining('scheduled session'), findsOneWidget);
    expect(find.textContaining('≈'), findsWidgets);
    expect(find.text('Before you start'), findsOneWidget);

    await reveal(
      tester,
      find.byKey(const Key('preview_exercise_bodyweight-squat')),
    );
    final Finder squat = find.byKey(
      const Key('preview_exercise_bodyweight-squat'),
    );
    expect(squat, findsOneWidget);
    expect(
      find.descendant(of: squat, matching: find.text('8 reps')),
      findsOneWidget,
    );
  });

  testWidgets('a rep target can be adjusted before starting', (tester) async {
    await pumpPreview(tester);
    await reveal(tester, find.byKey(const Key('target_plus_bodyweight-squat')));

    final Finder squat = find.byKey(
      const Key('preview_exercise_bodyweight-squat'),
    );
    await tester.tap(find.byKey(const Key('target_plus_bodyweight-squat')));
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: squat, matching: find.text('9 reps')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('target_minus_bodyweight-squat')));
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: squat, matching: find.text('8 reps')),
      findsOneWidget,
    );
  });

  testWidgets('starting stores the session and opens the runner', (
    tester,
  ) async {
    final ProviderContainer container = await pumpPreview(tester);
    await reveal(tester, find.byKey(const Key('start_workout')));
    await tester.tap(find.byKey(const Key('start_workout')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('session_progress')), findsOneWidget);
    final RunnerState runner = container.read(workoutRunnerProvider).value!;
    expect(runner.session!.status.isOpen, isTrue);
    expect(runner.session!.exercises, hasLength(6));
  });

  testWidgets('an unavailable targeted session says so instead of starting', (
    tester,
  ) async {
    await pumpPreview(
      tester,
      mode: 'targeted',
      templateId: null,
      muscle: 'arms',
    );

    expect(find.byKey(const Key('preview_empty')), findsOneWidget);
    expect(find.text('Nothing available for this session'), findsOneWidget);
    expect(find.byKey(const Key('start_workout')), findsNothing);
  });

  testWidgets('recovery preview shows the lighter session', (tester) async {
    await pumpPreview(tester, mode: 'recovery', templateId: null);
    expect(find.text('Recovery reset'), findsOneWidget);
    expect(find.textContaining('Gentle mobility'), findsOneWidget);
  });
}
