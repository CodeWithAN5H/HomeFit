/// How a session was started, and what it is allowed to influence.
///
/// The mode is stored on every session so history and progression can tell a
/// short recovery walk apart from real strength work. The rules live here, next
/// to the values, so no screen has to re-implement them.
enum WorkoutMode {
  normal(
    'Full session',
    'Your planned full-body strength session.',
    'The scheduled session: a balanced full-body workout built from your '
        'equipment and experience.',
  ),
  quick(
    'Quick session',
    'A short circuit for a busy day.',
    'About ten minutes when time or energy is short. It keeps the habit alive '
        'and is tracked separately from full sessions.',
  ),
  recovery(
    'Recovery',
    'Light movement, no demanding strength work.',
    'Gentle mobility and easy bodyweight work. It never counts as a strength '
        'session and never drives progression.',
  ),
  targeted(
    'Targeted',
    'Extra work for one muscle group.',
    'A focused session for one area you choose. Useful after a full session, '
        'not instead of training the rest of your body.',
  ),
  skill(
    'Skill practice',
    'Beginner-friendly practice towards a skill.',
    'Low-volume practice for push-up and pull-up progressions. Technique '
        'comes first and it is not counted as a strength session.',
  );

  const WorkoutMode(this.label, this.summary, this.explanation);

  final String label;

  /// One line, used on cards and in history.
  final String summary;

  /// The paragraph shown before the user starts, so no mode is a surprise.
  final String explanation;

  /// Whether the mode loads the muscles enough to space sessions apart.
  bool get isStrength => this == normal || this == quick || this == targeted;

  /// Whether a completed session in this mode may move a rep target.
  ///
  /// Quick, recovery and skill sessions are deliberately excluded: they are
  /// not a fair measure of capacity, and increasing load from them would reward
  /// doing less.
  bool get drivesProgression => this == normal || this == targeted;

  /// Unknown stored values fall back to [normal] so old data never crashes.
  static WorkoutMode fromName(String? name) {
    for (final WorkoutMode mode in values) {
      if (mode.name == name) return mode;
    }
    return normal;
  }
}

/// Lifecycle of a stored session.
enum WorkoutSessionStatus {
  /// Started and still resumable. Only one session may be in this state.
  inProgress('In progress'),

  /// Finished with at least one completed set.
  completed('Completed'),

  /// Ended by the user before any set was completed.
  abandoned('Abandoned'),

  /// An older unfinished session closed when a new one started. Its partial
  /// data is kept, but it is never counted as a completed workout.
  interrupted('Interrupted');

  const WorkoutSessionStatus(this.label);

  final String label;

  bool get countsAsWorkout => this == completed;

  bool get isOpen => this == inProgress;

  static WorkoutSessionStatus fromName(String? name) {
    for (final WorkoutSessionStatus status in values) {
      if (status.name == name) return status;
    }
    return interrupted;
  }
}
