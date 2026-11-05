import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:homefit/core/database/app_database.dart';
import 'package:homefit/core/routing/app_routes.dart';
import 'package:homefit/core/services/clock.dart';
import 'package:homefit/features/profile/application/profile_providers.dart';
import 'package:homefit/features/workouts/application/workout_providers.dart';
import 'package:homefit/features/workouts/domain/workout_mode.dart';
import 'package:homefit/features/workouts/presentation/workout_session_screen.dart';

import '../fixtures/profile_fixtures.dart';
import '../fixtures/workout_fixtures.dart';

class Harness {
  Harness(this.container, this.clock);

  final ProviderContainer container;
  final TestClock clock;

  WorkoutRunnerController get controller =>
      container.read(workoutRunnerProvider.notifier);
  RunnerState get state => container.read(workoutRunnerProvider).value!;
}

Future<Harness> pumpRunner(WidgetTester tester) async {
  final AppDatabase database = AppDatabase.memory();
  addTearDown(database.close);
  final TestClock clock = TestClock(DateTime(2026, 11, 5, 18));
  final ProviderContainer container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      initialProfileProvider.overrideWithValue(buildTestProfile()),
      clockProvider.overrideWithValue(clock),
    ],
  );
  addTearDown(container.dispose);

  await container.read(workoutRunnerProvider.future);
  await container.read(workoutRunnerProvider.notifier).start(buildTestPlan());

  final GoRouter router = GoRouter(
    initialLocation: AppRoutes.workoutSession,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.workoutSession,
        builder: (context, state) => const WorkoutSessionScreen(),
      ),
      GoRoute(
        path: '/workout',
        builder: (context, state) => const Text('workout-route'),
      ),
      GoRoute(
        path: '/workout/summary/:sessionId',
        builder: (context, state) => const Text('summary-route'),
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
  return Harness(container, clock);
}

Future<void> reveal(WidgetTester tester, Finder finder) async {
  // The reps TextField adds its own scrollable, so target the page list.
  await tester.scrollUntilVisible(
    finder,
    250,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> scrollToTop(WidgetTester tester) async {
  await tester.drag(find.byType(ListView), const Offset(0, 600));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the runner shows the current exercise and set', (tester) async {
    await pumpRunner(tester);

    expect(find.byKey(const Key('current_exercise_card')), findsOneWidget);
    expect(find.text('Bodyweight squat'), findsOneWidget);
    expect(find.text('Set 1 of 3'), findsOneWidget);
    expect(find.text('Target: 8 reps'), findsOneWidget);
    expect(find.byKey(const Key('session_progress')), findsOneWidget);

    await reveal(tester, find.byKey(const Key('complete_set')));
    expect(find.text('Complete set'), findsOneWidget);
    await reveal(tester, find.text('How to do it'));
    expect(find.text('How to do it'), findsOneWidget);
  });

  testWidgets('completing a set starts rest and progress moves', (
    tester,
  ) async {
    final Harness harness = await pumpRunner(tester);
    await reveal(tester, find.byKey(const Key('complete_set')));
    await tester.tap(find.byKey(const Key('complete_set')));
    await tester.pumpAndSettle();

    expect(harness.state.session!.loggedSets, 1);
    expect(harness.state.setIndex, 1);
    expect(harness.state.hasRest, isTrue);

    await scrollToTop(tester);
    expect(find.byKey(const Key('rest_card')), findsOneWidget);
    expect(find.text('1 of 17 sets logged'), findsOneWidget);
    expect(find.text('Set 2 of 3'), findsOneWidget);

    await tester.tap(find.byKey(const Key('skip_rest')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('rest_card')), findsNothing);
    expect(harness.state.hasRest, isFalse);
  });

  testWidgets('rest ends by itself once the stored end time passes', (
    tester,
  ) async {
    final Harness harness = await pumpRunner(tester);
    await reveal(tester, find.byKey(const Key('complete_set')));
    await tester.tap(find.byKey(const Key('complete_set')));
    await tester.pumpAndSettle();
    expect(harness.state.hasRest, isTrue);

    harness.clock.advance(const Duration(seconds: 61));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(harness.state.hasRest, isFalse);
    expect(harness.state.session!.restEndsAt, isNull);
    await scrollToTop(tester);
    expect(find.byKey(const Key('rest_card')), findsNothing);
  });

  testWidgets('skipping a set moves to the next one without rest', (
    tester,
  ) async {
    final Harness harness = await pumpRunner(tester);
    await reveal(tester, find.byKey(const Key('skip_set')));
    await tester.tap(find.byKey(const Key('skip_set')));
    await tester.pumpAndSettle();

    expect(harness.state.hasRest, isFalse);
    expect(harness.state.session!.skippedSets, 1);
    expect(harness.state.setIndex, 1);

    await scrollToTop(tester);
    expect(find.text('Set 2 of 3'), findsOneWidget);
    expect(find.byKey(const Key('rest_card')), findsNothing);
  });

  testWidgets('skipping an exercise advances to the next movement', (
    tester,
  ) async {
    final Harness harness = await pumpRunner(tester);
    await reveal(tester, find.byKey(const Key('skip_exercise')));
    await tester.tap(find.byKey(const Key('skip_exercise')));
    await tester.pumpAndSettle();

    expect(harness.state.exerciseIndex, 1);
    await scrollToTop(tester);
    expect(find.text('Push-up'), findsOneWidget);
    expect(find.text('Set 1 of 3'), findsOneWidget);
  });

  testWidgets('pause holds the session and disables logging', (tester) async {
    await pumpRunner(tester);
    await tester.tap(find.byKey(const Key('toggle_pause')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('paused_banner')), findsOneWidget);
    final FilledButton button = tester.widget<FilledButton>(
      find.byKey(const Key('complete_set')),
    );
    expect(button.onPressed, isNull);

    await tester.tap(find.byKey(const Key('resume_workout')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('paused_banner')), findsNothing);
  });

  testWidgets('ending with logged work finishes and opens the summary', (
    tester,
  ) async {
    final Harness harness = await pumpRunner(tester);
    await reveal(tester, find.byKey(const Key('complete_set')));
    await tester.tap(find.byKey(const Key('complete_set')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('end_workout')));
    await tester.pumpAndSettle();
    expect(find.text('End this workout?'), findsOneWidget);

    await tester.tap(find.byKey(const Key('confirm_finish')));
    await tester.pumpAndSettle();

    expect(find.text('summary-route'), findsOneWidget);
    expect(harness.state.session!.status, WorkoutSessionStatus.completed);
  });

  testWidgets('discarding an untouched session returns to the dashboard', (
    tester,
  ) async {
    final Harness harness = await pumpRunner(tester);
    await tester.tap(find.byKey(const Key('end_workout')));
    await tester.pumpAndSettle();
    expect(find.textContaining('recorded as abandoned'), findsOneWidget);

    await tester.tap(find.byKey(const Key('confirm_discard')));
    await tester.pumpAndSettle();

    expect(find.text('workout-route'), findsOneWidget);
    expect(harness.state.session!.status, WorkoutSessionStatus.abandoned);
  });

  testWidgets('an edited rep count is recorded', (tester) async {
    final Harness harness = await pumpRunner(tester);
    await reveal(tester, find.byKey(const Key('actual_reps')));
    await tester.enterText(find.byKey(const Key('actual_reps')), '5');
    await reveal(tester, find.byKey(const Key('complete_set')));
    await tester.tap(find.byKey(const Key('complete_set')));
    await tester.pumpAndSettle();

    expect(harness.state.session!.sets.single.actualReps, 5);
    expect(harness.state.session!.completedSets, 0);

    await scrollToTop(tester);
    await tester.tap(find.byKey(const Key('skip_rest')));
    await tester.pumpAndSettle();
  });

  testWidgets('with no session the runner explains how to start', (
    tester,
  ) async {
    final AppDatabase database = AppDatabase.memory();
    addTearDown(database.close);
    final ProviderContainer container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        initialProfileProvider.overrideWithValue(buildTestProfile()),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: WorkoutSessionScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('no_active_session')), findsOneWidget);
    expect(find.text('No workout in progress'), findsOneWidget);
  });
}
