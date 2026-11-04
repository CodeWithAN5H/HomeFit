import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/profile/application/profile_providers.dart';
import 'package:homefit/features/profile/data/profile_repository.dart';
import 'package:homefit/features/profile/domain/fitness_assessment.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';

import '../../fixtures/profile_fixtures.dart';

class _FakeProfileRepository implements ProfileRepository {
  UserProfile? savedProfile;
  final List<FitnessAssessment> savedAssessments = <FitnessAssessment>[];

  @override
  Future<UserProfile?> readProfile() async => savedProfile;

  @override
  Future<void> saveProfile(UserProfile profile) async {
    savedProfile = profile;
  }

  @override
  Future<FitnessAssessment?> readLatestAssessment() async =>
      savedAssessments.isEmpty ? null : savedAssessments.last;

  @override
  Future<void> saveAssessment(FitnessAssessment assessment) async {
    savedAssessments.add(assessment);
  }
}

void main() {
  test('starts empty, then publishes and persists the saved profile', () async {
    final repository = _FakeProfileRepository();
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(repository),
        initialProfileProvider.overrideWithValue(null),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(profileControllerProvider), isNull);

    final UserProfile profile = buildTestProfile();
    await container
        .read(profileControllerProvider.notifier)
        .saveProfile(
          profile,
          assessment: FitnessAssessment(
            pushUps: 8,
            recordedAt: DateTime.utc(2026, 3, 1),
          ),
        );

    expect(container.read(profileControllerProvider), same(profile));
    expect(repository.savedProfile, same(profile));
    expect(repository.savedAssessments, hasLength(1));
    expect(repository.savedAssessments.single.pushUps, 8);
  });

  test('an empty assessment is not persisted', () async {
    final repository = _FakeProfileRepository();
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(repository),
        initialProfileProvider.overrideWithValue(null),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(profileControllerProvider.notifier)
        .saveProfile(
          buildTestProfile(),
          assessment: FitnessAssessment(recordedAt: DateTime.utc(2026, 3, 2)),
        );

    expect(repository.savedAssessments, isEmpty);
  });

  test('an existing profile is exposed immediately', () {
    final profile = buildTestProfile(age: 41);
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(_FakeProfileRepository()),
        initialProfileProvider.overrideWithValue(profile),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(profileControllerProvider)?.age, 41);
  });
}
