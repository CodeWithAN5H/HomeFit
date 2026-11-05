import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app_tables.dart';

part 'app_database.g.dart';

/// Local SQLite database. The only storage HomeFit uses; nothing is uploaded.
///
/// Schema changes must bump [schemaVersion] and add a matching step in
/// [migration] (see DATABASE_SCHEMA.md).
@DriftDatabase(
  tables: [
    ProfileRows,
    AssessmentRows,
    WorkoutSessionRows,
    WorkoutSessionExerciseRows,
    WorkoutSetRows,
    FoodLogRows,
    MealPlanItemRows,
    SavedMealPlanRows,
    SavedMealPlanItemRows,
    GroceryItemRows,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// In-memory database used by tests.
  AppDatabase.memory() : super(NativeDatabase.memory());

  /// v1: profile + assessment. v2: workout sessions, session exercises and set
  /// logs (M4). v3: food log, meal plans, saved plans and grocery checklist
  /// (M5). Every migration only creates tables, so no existing row is touched.
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from < 2) {
        await migrator.createTable(workoutSessionRows);
        await migrator.createTable(workoutSessionExerciseRows);
        await migrator.createTable(workoutSetRows);
      }
      if (from < 3) {
        await migrator.createTable(foodLogRows);
        await migrator.createTable(mealPlanItemRows);
        await migrator.createTable(savedMealPlanRows);
        await migrator.createTable(savedMealPlanItemRows);
        await migrator.createTable(groceryItemRows);
      }
    },
    beforeOpen: (OpeningDetails details) async {
      // Drift opens SQLite with foreign keys off by default; assessment rows
      // must not outlive their profile.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Opens the on-disk database in the app support directory.
  static Future<AppDatabase> open() async {
    final Directory directory = await getApplicationSupportDirectory();
    final File file = File(p.join(directory.path, 'homefit.sqlite'));
    await file.parent.create(recursive: true);
    return AppDatabase(NativeDatabase.createInBackground(file));
  }
}
