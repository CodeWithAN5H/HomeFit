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
@DriftDatabase(tables: [ProfileRows, AssessmentRows])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// In-memory database used by tests.
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
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
