import 'package:drift/drift.dart';

/// The single local profile row.
///
/// Enum-backed fields are stored by `name`, list-valued fields as JSON arrays of
/// enum names. [id] is always `primary` for now, which keeps the row addressable
/// without a login.
class ProfileRows extends Table {
  TextColumn get id => text()();
  IntColumn get age => integer()();
  IntColumn get heightCm => integer()();
  RealColumn get weightKg => real()();
  TextColumn get experienceLevel => text()();
  TextColumn get goals => text()();
  TextColumn get priorities => text()();
  TextColumn get equipment => text()();
  IntColumn get sessionMinutes => integer()();
  TextColumn get trainingTime => text()();
  TextColumn get dietPattern => text()();
  TextColumn get dietRestrictions => text()();
  TextColumn get sleepPattern => text()();
  BoolColumn get notificationsEnabled => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Baseline self-assessments. Every measurement is nullable because the user may
/// legitimately be unable to do an exercise yet, or may skip the assessment.
class AssessmentRows extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(ProfileRows, #id, onDelete: KeyAction.cascade)();
  IntColumn get pushUps => integer().nullable()();
  IntColumn get kneePushUps => integer().nullable()();
  IntColumn get plankSeconds => integer().nullable()();
  IntColumn get pullUps => integer().nullable()();
  IntColumn get squats => integer().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get recordedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
