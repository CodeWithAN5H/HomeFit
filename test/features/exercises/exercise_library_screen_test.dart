import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:homefit/core/routing/app_routes.dart';
import 'package:homefit/features/exercises/application/exercise_providers.dart';
import 'package:homefit/features/exercises/data/exercise_catalog.dart';
import 'package:homefit/features/exercises/domain/exercise.dart';
import 'package:homefit/features/exercises/presentation/exercise_detail_screen.dart';
import 'package:homefit/features/exercises/presentation/exercise_library_screen.dart';
import 'package:homefit/features/profile/application/profile_providers.dart';
import 'package:homefit/features/profile/domain/profile_options.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';

import '../../fixtures/profile_fixtures.dart';

Future<ProviderContainer> pumpLibrary(
  WidgetTester tester, {
  UserProfile? profile,
}) async {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      initialProfileProvider.overrideWithValue(profile ?? buildTestProfile()),
    ],
  );
  addTearDown(container.dispose);

  final GoRouter router = GoRouter(
    initialLocation: AppRoutes.workoutExercises,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.workoutExercises,
        builder: (context, state) => const ExerciseLibraryScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: ':exerciseId',
            builder: (context, state) => ExerciseDetailScreen(
              exerciseId: state.pathParameters['exerciseId'] ?? '',
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

String searchText(WidgetTester tester) {
  return tester
      .widget<TextField>(find.byKey(const Key('exercise_search')))
      .controller!
      .text;
}

void main() {
  testWidgets('opens on the full library', (tester) async {
    await pumpLibrary(tester);
    expect(find.text('${exerciseCatalog.length} exercises'), findsOneWidget);
    expect(
      find.byKey(const Key('exercise_card_band-biceps-curl')),
      findsOneWidget,
    );
  });

  testWidgets('searching by name narrows the list', (tester) async {
    final ProviderContainer container = await pumpLibrary(tester);
    await tester.enterText(find.byKey(const Key('exercise_search')), 'pull');
    await tester.pumpAndSettle();

    // "Pull-up", "Band pull-apart" and "Band face pull".
    expect(container.read(exerciseListProvider).length, 3);
    expect(
      find.text('3 of ${exerciseCatalog.length} exercises'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('exercise_card_pull-up')), findsOneWidget);
    expect(find.byKey(const Key('exercise_card_band-row')), findsNothing);
  });

  testWidgets('an unmatched search shows the empty state and clears', (
    tester,
  ) async {
    final ProviderContainer container = await pumpLibrary(tester);
    await tester.enterText(find.byKey(const Key('exercise_search')), 'zzzz');
    await tester.pumpAndSettle();

    expect(find.text('No exercises match'), findsOneWidget);
    expect(container.read(exerciseListProvider), isEmpty);

    await tester.tap(find.byKey(const Key('clear_filters_empty')));
    await tester.pumpAndSettle();

    expect(find.text('No exercises match'), findsNothing);
    expect(find.text('${exerciseCatalog.length} exercises'), findsOneWidget);
    expect(searchText(tester), isEmpty);
    expect(container.read(exerciseFilterProvider).search, isEmpty);
  });

  testWidgets('a muscle chip filters and taps off again', (tester) async {
    final ProviderContainer container = await pumpLibrary(tester);
    await tester.tap(find.byKey(const Key('muscle_chest')));
    await tester.pumpAndSettle();

    expect(container.read(exerciseFilterProvider).muscle, MuscleGroup.chest);
    final List<Exercise> results = container.read(exerciseListProvider);
    expect(results, isNotEmpty);
    expect(
      results.every((Exercise exercise) => exercise.targets(MuscleGroup.chest)),
      isTrue,
    );

    await tester.tap(find.byKey(const Key('muscle_chest')));
    await tester.pumpAndSettle();
    expect(container.read(exerciseFilterProvider).muscle, isNull);
    expect(container.read(exerciseListProvider).length, exerciseCatalog.length);
  });

  testWidgets('the equipment menu filters by an exact requirement', (
    tester,
  ) async {
    final ProviderContainer container = await pumpLibrary(tester);
    await tester.tap(find.byKey(const Key('equipment_filter')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(PopupMenuItem<String>, 'Resistance band'),
    );
    await tester.pumpAndSettle();

    expect(
      container.read(exerciseFilterProvider).equipment,
      EquipmentItem.resistanceBand,
    );
    final List<Exercise> results = container.read(exerciseListProvider);
    expect(results, isNotEmpty);
    expect(
      results.every(
        (Exercise exercise) =>
            exercise.equipment.contains(EquipmentItem.resistanceBand),
      ),
      isTrue,
    );
    expect(find.byKey(const Key('clear_filters')), findsOneWidget);
  });

  testWidgets('"my equipment only" respects the saved equipment', (
    tester,
  ) async {
    final UserProfile profile = buildTestProfile().copyWith(
      equipment: <EquipmentItem>{EquipmentItem.resistanceBand},
    );
    final ProviderContainer container = await pumpLibrary(
      tester,
      profile: profile,
    );

    await tester.tap(find.byKey(const Key('only_my_equipment')));
    await tester.pumpAndSettle();

    final List<Exercise> results = container.read(exerciseListProvider);
    expect(results, isNotEmpty);
    expect(
      results.every((Exercise exercise) {
        final Set<EquipmentItem> owned = container
            .read(profileControllerProvider)!
            .equipment;
        return exercise.canPerformWith(owned);
      }),
      isTrue,
    );
    expect(
      results.map((Exercise exercise) => exercise.id),
      isNot(contains('pull-up')),
    );
  });

  testWidgets('clearing filters keeps the search text', (tester) async {
    final ProviderContainer container = await pumpLibrary(tester);
    await tester.enterText(find.byKey(const Key('exercise_search')), 'band');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('muscle_back')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('clear_filters')));
    await tester.pumpAndSettle();

    expect(container.read(exerciseFilterProvider).muscle, isNull);
    expect(container.read(exerciseFilterProvider).search, 'band');
    expect(searchText(tester), 'band');
  });

  testWidgets('tapping a card opens its detail screen', (tester) async {
    await pumpLibrary(tester);
    await tester.tap(find.byKey(const Key('exercise_card_band-biceps-curl')));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Band biceps curl'), findsOneWidget);
    expect(find.byKey(const Key('exercise_search')), findsNothing);
  });
}
