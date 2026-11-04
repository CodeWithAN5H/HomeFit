import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:homefit/features/profile/application/profile_providers.dart';
import 'package:homefit/features/profile/data/profile_repository.dart';
import 'package:homefit/features/profile/domain/fitness_assessment.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';
import 'package:homefit/features/profile/presentation/profile_edit_screen.dart';
import 'package:homefit/shared/widgets/selectable_chip.dart';

import '../../fixtures/profile_fixtures.dart';

class RecordingProfileRepository implements ProfileRepository {
  UserProfile? profile;
  int saves = 0;

  @override
  Future<UserProfile?> readProfile() async => profile;

  @override
  Future<void> saveProfile(UserProfile profile) async {
    this.profile = profile;
    saves += 1;
  }

  @override
  Future<FitnessAssessment?> readLatestAssessment() async => null;

  @override
  Future<void> saveAssessment(FitnessAssessment assessment) async {}
}

/// Opens the editor from a stub Home route, so popping is observable.
Future<RecordingProfileRepository> pumpEditor(WidgetTester tester) async {
  final repository = RecordingProfileRepository()..profile = buildTestProfile();
  final router = GoRouter(
    initialLocation: '/home',
    routes: <RouteBase>[
      GoRoute(
        path: '/home',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Home stub')),
          body: Center(
            child: TextButton(
              onPressed: () => context.push('/profile/edit'),
              child: const Text('open editor'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const ProfileEditScreen(),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        initialProfileProvider.overrideWithValue(repository.profile),
        profileRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.tap(find.text('open editor'));
  await tester.pumpAndSettle();
  return repository;
}

String fieldText(WidgetTester tester, String key) {
  return tester.widget<TextField>(find.byKey(Key(key))).controller!.text;
}

void main() {
  testWidgets('every field is prepopulated from the saved profile', (
    tester,
  ) async {
    await pumpEditor(tester);

    expect(fieldText(tester, 'profile_age'), '30');
    expect(fieldText(tester, 'profile_height'), '175');
    expect(fieldText(tester, 'profile_weight'), '70.0');

    final SelectableChip beginner = tester.widget<SelectableChip>(
      find.widgetWithText(SelectableChip, 'Beginner'),
    );
    expect(beginner.selected, isTrue);

    final SelectableChip goal = tester.widget<SelectableChip>(
      find.widgetWithText(SelectableChip, 'Build muscle'),
    );
    expect(goal.selected, isTrue);

    // The form is longer than the test viewport, so the sleep section has to be
    // scrolled into existence before it can be inspected.
    final Finder sleepLabel = find.text(
      'Irregular — Bedtime moves around a lot',
    );
    await tester.scrollUntilVisible(
      sleepLabel,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    final SelectableChip sleep = tester.widget<SelectableChip>(
      find.ancestor(of: sleepLabel, matching: find.byType(SelectableChip)),
    );
    expect(sleep.selected, isTrue);
  });

  testWidgets('saving writes the edited values and keeps the creation time', (
    tester,
  ) async {
    final repository = await pumpEditor(tester);

    await tester.enterText(find.byKey(const Key('profile_age')), '33');
    await tester.tap(find.byKey(const Key('profile_save')));
    await tester.pumpAndSettle();

    expect(repository.saves, 1);
    expect(repository.profile!.age, 33);
    expect(repository.profile!.createdAt, buildTestProfile().createdAt);
    expect(find.text('open editor'), findsOneWidget);
  });

  testWidgets('cancelling leaves the saved profile untouched', (tester) async {
    final repository = await pumpEditor(tester);

    await tester.enterText(find.byKey(const Key('profile_age')), '44');
    await tester.tap(find.byKey(const Key('profile_cancel')));
    await tester.pumpAndSettle();

    expect(repository.saves, 0);
    expect(repository.profile!.age, 30);
    expect(find.text('open editor'), findsOneWidget);
  });

  testWidgets('invalid input is rejected with the onboarding message', (
    tester,
  ) async {
    final repository = await pumpEditor(tester);

    await tester.enterText(find.byKey(const Key('profile_age')), '5');
    await tester.tap(find.byKey(const Key('profile_save')));
    await tester.pumpAndSettle();

    expect(repository.saves, 0);
    expect(find.byKey(const Key('profile_error')), findsOneWidget);
    expect(find.text('Age must be between 13 and 99.'), findsOneWidget);
    expect(find.byType(ProfileEditScreen), findsOneWidget);
  });

  testWidgets('the validation message clears as soon as the user edits', (
    tester,
  ) async {
    await pumpEditor(tester);

    await tester.enterText(find.byKey(const Key('profile_age')), '5');
    await tester.tap(find.byKey(const Key('profile_save')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('profile_error')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('profile_age')), '34');
    await tester.pump();

    expect(find.byKey(const Key('profile_error')), findsNothing);
  });

  testWidgets('removing every goal blocks saving', (tester) async {
    final repository = await pumpEditor(tester);

    for (final String label in <String>['Build muscle', 'Stay consistent']) {
      final Finder chip = find.widgetWithText(SelectableChip, label);
      await tester.ensureVisible(chip);
      await tester.pumpAndSettle();
      await tester.tap(chip);
      await tester.pumpAndSettle();
    }

    await tester.tap(find.byKey(const Key('profile_save')));
    await tester.pumpAndSettle();

    expect(repository.saves, 0);
    expect(find.text('Choose at least one goal.'), findsOneWidget);
  });
}
