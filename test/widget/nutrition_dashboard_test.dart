import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:homefit/core/routing/app_routes.dart';
import 'package:homefit/features/nutrition/presentation/nutrition_screen.dart';

import '../fixtures/nutrition_widget_harness.dart';
import '../fixtures/profile_fixtures.dart';

GoRouter nutritionDashboardRouter() {
  return GoRouter(
    initialLocation: AppRoutes.nutrition,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.nutrition,
        builder: (BuildContext context, GoRouterState state) =>
            const NutritionScreen(),
        routes: <RouteBase>[
          GoRoute(path: 'plan', builder: (_, _) => const Text('plan-route')),
          GoRoute(path: 'log', builder: (_, _) => const Text('log-route')),
          GoRoute(
            path: 'recipes',
            builder: (_, _) => const Text('recipes-route'),
          ),
          GoRoute(
            path: 'grocery',
            builder: (_, _) => const Text('grocery-route'),
          ),
        ],
      ),
    ],
  );
}

void main() {
  testWidgets('the dashboard shows transparent targets and today at a glance', (
    tester,
  ) async {
    await pumpNutrition(
      tester,
      const NutritionScreen(),
      router: nutritionDashboardRouter(),
    );

    expect(find.byKey(const Key('nutrition_targets_card')), findsOneWidget);
    expect(find.text('2300–2750 kcal'), findsOneWidget);
    expect(find.textContaining('84–112 g protein'), findsOneWidget);
    expect(find.textContaining('Vegetarian · no eggs'), findsOneWidget);
    expect(find.byKey(const Key('nutrition_today_card')), findsOneWidget);
    expect(find.byKey(const Key('nutrition_meals_card')), findsOneWidget);
    expect(find.byKey(const Key('nutrition_empty_plan')), findsOneWidget);

    await reveal(tester, find.byKey(const Key('nutrition_safety_card')));
    expect(find.textContaining('not medical'), findsOneWidget);
    expect(find.byKey(const Key('nutrition_recipes_link')), findsOneWidget);
    expect(find.byKey(const Key('nutrition_grocery_link')), findsOneWidget);
  });

  testWidgets('target assumptions can be read and explain uncertainty', (
    tester,
  ) async {
    await pumpNutrition(
      tester,
      const NutritionScreen(),
      router: nutritionDashboardRouter(),
    );

    await tester.tap(find.byKey(const Key('targets_assumptions')));
    await tester.pumpAndSettle();

    expect(find.text('How targets are estimated'), findsOneWidget);
    expect(find.textContaining('Sex is not recorded'), findsOneWidget);
    expect(find.textContaining('not medical'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('How targets are estimated'), findsNothing);
  });

  testWidgets('a profile without a target shows why instead of a number', (
    tester,
  ) async {
    await pumpNutrition(
      tester,
      const NutritionScreen(),
      router: nutritionDashboardRouter(),
      profile: buildTestProfile(age: 17),
    );

    expect(find.byKey(const Key('nutrition_targets_card')), findsOneWidget);
    expect(find.textContaining('designed for adults'), findsOneWidget);
    expect(find.text('No target'), findsOneWidget);
    expect(find.byKey(const Key('targets_assumptions')), findsNothing);
  });

  testWidgets('the dashboard opens the planner and the log separately', (
    tester,
  ) async {
    await pumpNutrition(
      tester,
      const NutritionScreen(),
      router: nutritionDashboardRouter(),
    );

    await tester.tap(find.byKey(const Key('open_meal_plan')));
    await tester.pumpAndSettle();
    expect(find.text('plan-route'), findsOneWidget);
  });

  testWidgets('the dashboard opens the food log', (tester) async {
    await pumpNutrition(
      tester,
      const NutritionScreen(),
      router: nutritionDashboardRouter(),
    );

    await tester.tap(find.byKey(const Key('open_food_log')));
    await tester.pumpAndSettle();
    expect(find.text('log-route'), findsOneWidget);
  });

  testWidgets('recipes and grocery are reachable from the tab', (tester) async {
    await pumpNutrition(
      tester,
      const NutritionScreen(),
      router: nutritionDashboardRouter(),
    );

    await reveal(tester, find.byKey(const Key('nutrition_recipes_link')));
    await tester.tap(find.byKey(const Key('nutrition_recipes_link')));
    await tester.pumpAndSettle();
    expect(find.text('recipes-route'), findsOneWidget);
  });
}
