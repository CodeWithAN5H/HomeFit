import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/fitness_assessment.dart';
import '../domain/user_profile.dart';
import 'profile_mappers.dart';

/// Storage contract for the profile feature.
///
/// Presentation and application layers depend on this interface, not on Drift,
/// so controllers can be tested without a database.
abstract interface class ProfileRepository {
  Future<UserProfile?> readProfile();

  Future<void> saveProfile(UserProfile profile);

  Future<FitnessAssessment?> readLatestAssessment();

  Future<void> saveAssessment(FitnessAssessment assessment);
}

class DriftProfileRepository implements ProfileRepository {
  DriftProfileRepository(this._database);

  final AppDatabase _database;

  @override
  Future<UserProfile?> readProfile() async {
    final query = _database.select(_database.profileRows)
      ..where((row) => row.id.equals(UserProfile.primaryId));
    final ProfileRow? row = await query.getSingleOrNull();
    return row == null ? null : profileFromRow(row);
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _database
        .into(_database.profileRows)
        .insertOnConflictUpdate(profileToRow(profile));
  }

  @override
  Future<FitnessAssessment?> readLatestAssessment() async {
    final query = _database.select(_database.assessmentRows)
      ..orderBy([(row) => OrderingTerm.desc(row.recordedAt)])
      ..limit(1);
    final AssessmentRow? row = await query.getSingleOrNull();
    return row == null ? null : assessmentFromRow(row);
  }

  @override
  Future<void> saveAssessment(FitnessAssessment assessment) async {
    if (assessment.isEmpty) return;
    await _database
        .into(_database.assessmentRows)
        .insertOnConflictUpdate(assessmentToRow(assessment));
  }
}
