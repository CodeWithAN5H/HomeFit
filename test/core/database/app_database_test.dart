import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/core/database/app_database.dart';
import 'package:homefit/features/profile/data/profile_repository.dart';
import 'package:homefit/features/profile/domain/fitness_assessment.dart';
import 'package:homefit/features/profile/domain/profile_options.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';

import '../../fixtures/profile_fixtures.dart';

/// Real SQLite tests against an in-memory database.
///
/// On Android the app uses the bundled SQLite from sqlite3_flutter_libs; this
/// test host relies on the sqlite3 package's own native asset, so no system
/// library or PATH changes are involved.
void main() {
  late AppDatabase database;
  late DriftProfileRepository repository;

  setUp(() {
    database = AppDatabase.memory();
    repository = DriftProfileRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('profile is absent before onboarding and persists afterwards', () async {
    expect(await repository.readProfile(), isNull);

    final UserProfile profile = buildTestProfile();
    await repository.saveProfile(profile);

    final UserProfile? loaded = await repository.readProfile();
    expect(loaded, isNotNull);
    expect(loaded!.age, profile.age);
    expect(loaded.heightCm, profile.heightCm);
    expect(loaded.goals, profile.goals);
    expect(loaded.priorities, profile.priorities);
    expect(loaded.equipment, profile.equipment);
    expect(loaded.sleep, profile.sleep);
    expect(loaded.restrictions, profile.restrictions);
  });

  test('saving twice updates the single profile row', () async {
    await repository.saveProfile(buildTestProfile());
    await repository.saveProfile(buildTestProfile(age: 33));

    final rows = await database.select(database.profileRows).get();
    expect(rows, hasLength(1));
    expect(rows.single.age, 33);
    expect(rows.single.id, UserProfile.primaryId);
  });

  test('assessments round-trip and the latest one wins', () async {
    await repository.saveProfile(buildTestProfile());
    await repository.saveAssessment(
      FitnessAssessment(
        pushUps: 8,
        kneePushUps: 9,
        plankSeconds: 50,
        pullUps: 1,
        recordedAt: DateTime.utc(2026, 1, 1),
      ),
    );
    await repository.saveAssessment(
      FitnessAssessment(pushUps: 10, recordedAt: DateTime.utc(2026, 2, 1)),
    );

    final FitnessAssessment? latest = await repository.readLatestAssessment();
    expect(latest, isNotNull);
    expect(latest!.pushUps, 10);
    expect(latest.recordedAt, DateTime.utc(2026, 2, 1));
  });

  test('an empty assessment is not stored', () async {
    await repository.saveProfile(buildTestProfile());
    await repository.saveAssessment(
      FitnessAssessment(recordedAt: DateTime.utc(2026, 3, 1)),
    );

    final rows = await database.select(database.assessmentRows).get();
    expect(rows, isEmpty);
  });

  test('foreign keys block an assessment without a profile', () async {
    await expectLater(
      repository.saveAssessment(
        FitnessAssessment(pushUps: 5, recordedAt: DateTime.utc(2026, 4, 1)),
      ),
      throwsA(anything),
    );
  });

  test('stored enum names survive a reload', () async {
    await repository.saveProfile(
      buildTestProfile().copyWith(sleep: SleepPattern.severelyInsufficient),
    );

    final UserProfile? loaded = await repository.readProfile();
    expect(loaded!.sleep, SleepPattern.severelyInsufficient);
    expect(loaded.needsRecoveryAttention, isTrue);
  });
}
