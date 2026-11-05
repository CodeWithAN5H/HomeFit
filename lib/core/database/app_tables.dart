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

/// One workout attempt, whether it finished or not.
///
/// [restEndsAt] stores an absolute instant instead of a countdown, so rest stays
/// accurate if the app is backgrounded or the process is recreated. [status] is
/// stored by name (`inProgress`, `completed`, `abandoned`, `interrupted`).
class WorkoutSessionRows extends Table {
  TextColumn get id => text()();
  TextColumn get templateId => text()();
  TextColumn get templateName => text()();
  TextColumn get mode => text()();
  TextColumn get status => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get plannedMinutes => integer()();
  IntColumn get perceivedEffort => integer().nullable()();
  BoolColumn get isPaused => boolean().withDefault(const Constant(false))();
  DateTimeColumn get restEndsAt => dateTime().nullable()();
  IntColumn get restRemainingSeconds => integer().nullable()();
  DateTimeColumn get lastActivityAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// The plan a session followed, copied in at start time.
///
/// [exerciseId] is the stable slug from the bundled catalogue. There is no
/// foreign key because exercises live in code, not in a table; the ids are
/// immutable, which is what keeps history readable across releases.
class WorkoutSessionExerciseRows extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId =>
      text().references(WorkoutSessionRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text()();
  IntColumn get orderIndex => integer()();
  IntColumn get plannedSets => integer()();
  IntColumn get targetReps => integer().nullable()();
  IntColumn get targetSeconds => integer().nullable()();
  IntColumn get restSeconds => integer()();
  BoolColumn get skipped => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One logged set, written as soon as the user completes or skips it.
class WorkoutSetRows extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId =>
      text().references(WorkoutSessionRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get sessionExerciseId => text().references(
    WorkoutSessionExerciseRows,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get exerciseId => text()();
  IntColumn get setIndex => integer()();
  IntColumn get targetReps => integer().nullable()();
  IntColumn get actualReps => integer().nullable()();
  IntColumn get targetSeconds => integer().nullable()();
  IntColumn get actualSeconds => integer().nullable()();
  IntColumn get restSecondsTaken => integer().nullable()();
  BoolColumn get skipped => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One food actually eaten. Nutrition is snapshotted at log time so catalogue
/// corrections never rewrite a past day; [foodId] stays for editing.
class FoodLogRows extends Table {
  TextColumn get id => text()();
  TextColumn get dateKey => text()();
  TextColumn get slot => text()();
  TextColumn get foodId => text()();
  TextColumn get foodName => text()();
  RealColumn get amount => real()();
  TextColumn get unit => text()();
  TextColumn get servingLabel => text().nullable()();
  RealColumn get kcal => real()();
  RealColumn get proteinG => real()();
  RealColumn get carbsG => real()();
  RealColumn get fatG => real()();
  DateTimeColumn get loggedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One planned food or recipe in a day's plan. [sourceId] is a bundled food or
/// recipe slug; the catalogue lives in code, so there is no foreign key.
class MealPlanItemRows extends Table {
  TextColumn get id => text()();
  TextColumn get dateKey => text()();
  TextColumn get slot => text()();
  TextColumn get kind => text()();
  TextColumn get sourceId => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get unit => text()();
  TextColumn get servingLabel => text().nullable()();
  IntColumn get orderIndex => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// A named plan the user can load onto another day.
class SavedMealPlanRows extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One item of a saved plan. No date key: a template is not bound to a day.
class SavedMealPlanItemRows extends Table {
  TextColumn get id => text()();
  TextColumn get planId =>
      text().references(SavedMealPlanRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get slot => text()();
  TextColumn get kind => text()();
  TextColumn get sourceId => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get unit => text()();
  TextColumn get servingLabel => text().nullable()();
  IntColumn get orderIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// A shopping checklist line. Manual lines have no [foodId] and are never
/// merged; generated lines can be refreshed from a plan without losing checks.
class GroceryItemRows extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get foodId => text().nullable()();
  RealColumn get amount => real().nullable()();
  TextColumn get unit => text().nullable()();
  BoolColumn get checked => boolean().withDefault(const Constant(false))();
  TextColumn get source => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();

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
