import 'profile_options.dart';

/// The single local profile HomeFit trains from.
///
/// There is exactly one profile row (id [primaryId]); a future multi-user build
/// can reuse the same shape with generated ids.
class UserProfile {
  const UserProfile({
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.experience,
    required this.goals,
    required this.priorities,
    required this.equipment,
    required this.sessionMinutes,
    required this.trainingTime,
    required this.diet,
    required this.restrictions,
    required this.sleep,
    required this.notificationsEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Stable identifier of the only profile row.
  static const String primaryId = 'primary';

  final int age;
  final int heightCm;
  final double weightKg;
  final ExperienceLevel experience;
  final Set<TrainingGoal> goals;
  final Set<MusclePriority> priorities;
  final Set<EquipmentItem> equipment;
  final int sessionMinutes;
  final TrainingTimeOfDay trainingTime;
  final DietPattern diet;
  final Set<DietRestriction> restrictions;
  final SleepPattern sleep;
  final bool notificationsEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// True when sleep is routinely too short, which is a recovery risk the UI
  /// and (later) the training engine must respect.
  bool get needsRecoveryAttention => sleep == SleepPattern.severelyInsufficient;

  UserProfile copyWith({
    int? age,
    int? heightCm,
    double? weightKg,
    ExperienceLevel? experience,
    Set<TrainingGoal>? goals,
    Set<MusclePriority>? priorities,
    Set<EquipmentItem>? equipment,
    int? sessionMinutes,
    TrainingTimeOfDay? trainingTime,
    DietPattern? diet,
    Set<DietRestriction>? restrictions,
    SleepPattern? sleep,
    bool? notificationsEnabled,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      experience: experience ?? this.experience,
      goals: goals ?? this.goals,
      priorities: priorities ?? this.priorities,
      equipment: equipment ?? this.equipment,
      sessionMinutes: sessionMinutes ?? this.sessionMinutes,
      trainingTime: trainingTime ?? this.trainingTime,
      diet: diet ?? this.diet,
      restrictions: restrictions ?? this.restrictions,
      sleep: sleep ?? this.sleep,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
