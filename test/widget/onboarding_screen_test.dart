import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/core/theme/app_theme.dart';
import 'package:homefit/features/onboarding/presentation/onboarding_screen.dart';
import 'package:homefit/features/profile/application/profile_providers.dart';
import 'package:homefit/features/profile/data/profile_repository.dart';
import 'package:homefit/features/profile/domain/fitness_assessment.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';

class _NoopRepository implements ProfileRepository {
  @override
  Future<UserProfile?> readProfile() async => null;

  @override
  Future<void> saveProfile(UserProfile profile) async {}

  @override
  Future<FitnessAssessment?> readLatestAssessment() async => null;

  @override
  Future<void> saveAssessment(FitnessAssessment assessment) async {}
}

Widget _app() {
  return ProviderScope(
    overrides: [
      profileRepositoryProvider.overrideWithValue(_NoopRepository()),
      initialProfileProvider.overrideWithValue(null),
    ],
    child: MaterialApp(theme: buildAppTheme(), home: const OnboardingScreen()),
  );
}

void main() {
  testWidgets('shows the first step and blocks empty input', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_app());

    expect(find.text('About you'), findsOneWidget);
    expect(find.text('Step 1 of 5'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.byKey(const Key('onboarding_error')), findsOneWidget);
    expect(find.text('Enter your age.'), findsOneWidget);
    expect(find.text('About you'), findsOneWidget);
  });

  testWidgets('advances to goals once the basics are valid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_app());

    await tester.enterText(find.byKey(const Key('onboarding_age')), '18');
    await tester.enterText(find.byKey(const Key('onboarding_height')), '171');
    await tester.enterText(find.byKey(const Key('onboarding_weight')), '47');

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Goals and focus'), findsOneWidget);
    expect(find.byKey(const Key('onboarding_error')), findsNothing);
    expect(find.text('Step 2 of 5'), findsOneWidget);
  });
}
