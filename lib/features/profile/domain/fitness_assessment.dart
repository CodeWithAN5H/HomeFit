/// A beginner-friendly baseline self-assessment.
///
/// Every field is optional on purpose: "I cannot do this yet" is a valid answer
/// and must never block onboarding. Values are the user's own estimate, not a
/// clinical measurement.
class FitnessAssessment {
  const FitnessAssessment({
    this.pushUps,
    this.kneePushUps,
    this.plankSeconds,
    this.pullUps,
    this.squats,
    this.notes,
    required this.recordedAt,
  });

  final int? pushUps;
  final int? kneePushUps;
  final int? plankSeconds;
  final int? pullUps;
  final int? squats;
  final String? notes;
  final DateTime recordedAt;

  bool get isEmpty =>
      pushUps == null &&
      kneePushUps == null &&
      plankSeconds == null &&
      pullUps == null &&
      squats == null;
}
