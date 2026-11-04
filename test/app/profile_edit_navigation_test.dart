import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:homefit/core/routing/app_router.dart';
import 'package:homefit/core/routing/app_routes.dart';
import 'package:homefit/features/profile/application/profile_providers.dart';
import 'package:homefit/features/profile/data/profile_repository.dart';
import 'package:homefit/features/profile/domain/fitness_assessment.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';

import '../fixtures/profile_fixtures.dart';

class _Repository implements ProfileRepository {
  _Repository(this.profile);

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

/// The router reacts to profile changes; this test drives the real
/// [appRouterProvider] so a refresh cannot silently re-open a closed editor.
void main() {
  testWidgets('saving from the editor returns to Home', (tester) async {
    final repository = _Repository(buildTestProfile());
    final container = ProviderContainer(
      overrides: [
        initialProfileProvider.overrideWithValue(repository.profile),
        profileRepositoryProvider.overrideWithValue(repository),
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

    router.push(AppRoutes.profileEdit);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('profile_save')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('profile_age')), '34');
    await tester.tap(find.byKey(const Key('profile_save')));
    await tester.pumpAndSettle();

    expect(repository.saves, 1);
    expect(repository.profile!.age, 34);
    expect(find.byKey(const Key('profile_save')), findsNothing);
    expect(find.text('HomeFit'), findsOneWidget);
  });
}
