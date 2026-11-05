import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/core/database/app_database.dart';
import 'package:homefit/features/nutrition/data/nutrition_repository.dart';
import 'package:homefit/features/profile/data/profile_repository.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';
import 'package:homefit/features/workouts/data/workout_repository.dart';
import 'package:homefit/features/workouts/domain/workout_session.dart';
import 'package:path/path.dart' as p;

import '../../fixtures/nutrition_fixtures.dart';
import '../../fixtures/profile_fixtures.dart';
import '../../fixtures/workout_fixtures.dart';

/// The bundle needs a real file, so the v2 → v3 upgrade is exercised on disk
/// exactly as it happens on the phone.
void main() {
  test('v2 data survives the upgrade to schema v3', () async {
    final Directory directory = Directory.systemTemp.createTempSync(
      'homefit_m5_migration',
    );
    addTearDown(() {
      if (directory.existsSync()) directory.deleteSync(recursive: true);
    });
    final File file = File(p.join(directory.path, 'homefit.sqlite'));

    final AppDatabase first = AppDatabase(NativeDatabase(file));
    await DriftProfileRepository(first).saveProfile(buildTestProfile());
    final WorkoutSession session = buildStoredSession(id: 'before-m5');
    await DriftWorkoutRepository(first).createSession(session);

    // Rewind to a v2 database: the M5 tables disappear and user_version says 2.
    await first.customStatement('PRAGMA foreign_keys = OFF');
    await first.customStatement('DROP TABLE grocery_item_rows');
    await first.customStatement('DROP TABLE saved_meal_plan_item_rows');
    await first.customStatement('DROP TABLE saved_meal_plan_rows');
    await first.customStatement('DROP TABLE meal_plan_item_rows');
    await first.customStatement('DROP TABLE food_log_rows');
    await first.customStatement('PRAGMA user_version = 2');
    await first.close();

    final AppDatabase second = AppDatabase(NativeDatabase(file));
    addTearDown(second.close);

    final UserProfile? profile = await DriftProfileRepository(second)
        .readProfile();
    expect(profile, isNotNull, reason: 'the profile must survive the upgrade');
    expect(profile!.age, buildTestProfile().age);
    expect(profile.weightKg, buildTestProfile().weightKg);
    expect(profile.goals, buildTestProfile().goals);

    final WorkoutSession? workout = await DriftWorkoutRepository(second)
        .readSession('before-m5');
    expect(workout, isNotNull, reason: 'workout history must survive');
    expect(workout!.exercises, hasLength(2));
    expect(workout.templateName, 'Full body A');

    final DriftNutritionRepository nutrition = DriftNutritionRepository(second);
    expect(await nutrition.readLog('2026-11-05'), isEmpty);
    expect(await nutrition.readPlan('2026-11-05'), isEmpty);
    expect(await nutrition.readGrocery(), isEmpty);

    await nutrition.upsertLogEntry(buildLogEntry(id: 'after-upgrade'));
    await nutrition.upsertPlanItem(buildPlanItem(id: 'plan-after-upgrade'));

    expect((await nutrition.readLog('2026-11-05')).single.id, 'after-upgrade');
    expect(
      (await nutrition.readPlan('2026-11-05')).single.id,
      'plan-after-upgrade',
    );
  });
}
