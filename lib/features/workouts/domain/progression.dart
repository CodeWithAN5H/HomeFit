import '../../profile/domain/profile_options.dart';

/// What the next session should do with one exercise's rep target.
enum ProgressionAction {
  increase('Increase'),
  maintain('Hold'),
  reduce('Reduce'),
  recover('Recover');

  const ProgressionAction(this.label);

  final String label;
}

/// One exercise's evidence from the previous session, plus the recovery context
/// around it. Progression never looks at the calendar on its own.
class ProgressionInput {
  const ProgressionInput({
    required this.exerciseId,
    required this.prescribedSets,
    required this.targetReps,
    required this.completedReps,
    this.effort,
    this.sleepPattern,
    this.comfortableStreak = 0,
  });

  final String exerciseId;
  final int prescribedSets;
  final int targetReps;

  /// Actual reps per logged set, in order. `null` means the set was skipped.
  final List<int?> completedReps;

  /// Perceived effort of the whole session, 1 (easy) to 5 (maximal).
  final int? effort;

  final SleepPattern? sleepPattern;

  /// How many consecutive earlier sessions of this exercise were comfortable.
  final int comfortableStreak;

  bool get isComfortable => effort != null && effort! <= 2;

  bool get everySetHit {
    final List<int> reps = completedReps.whereType<int>().toList();
    if (reps.length < prescribedSets) return false;
    return reps.every((int value) => value >= targetReps);
  }

  double get completionRate {
    if (prescribedSets <= 0) return 0;
    final int hits = completedReps
        .where((int? value) => value != null && value >= targetReps)
        .length;
    final double rate = hits / prescribedSets;
    return rate > 1 ? 1 : rate;
  }

  bool get sleepIsPoor => sleepPattern == SleepPattern.severelyInsufficient;
}

class ProgressionDecision {
  const ProgressionDecision({
    required this.action,
    required this.targetReps,
    required this.reason,
  });

  final ProgressionAction action;
  final int targetReps;
  final String reason;

  bool get changesTarget =>
      action == ProgressionAction.increase ||
      action == ProgressionAction.reduce;

  @override
  String toString() => 'ProgressionDecision(${action.name}, $targetReps)';
}

/// Conservative, transparent, rule-based progression.
///
/// Guiding rules, in priority order:
/// 1. Need at least two comfortable sessions before adding a single rep.
/// 2. Hard effort or missed reps never increase anything.
/// 3. Poor sleep and a poor session reduces load instead of pushing.
/// 4. Targets move by one rep, never by a percentage, and never below one.
/// 5. A missed calendar week changes nothing.
abstract final class ProgressionEngine {
  /// Consecutive comfortable sessions required before a rep is added.
  static const int comfortableSessionsForIncrease = 2;

  static ProgressionDecision decide(ProgressionInput input) {
    final int floor = input.targetReps > 1 ? input.targetReps - 1 : 1;
    final int base = input.targetReps;

    if (input.completedReps.isEmpty) {
      return ProgressionDecision(
        action: ProgressionAction.maintain,
        targetReps: base,
        reason: 'No completed sets to learn from yet, so the target stays put.',
      );
    }

    if (input.everySetHit) {
      if (input.sleepIsPoor) {
        return ProgressionDecision(
          action: ProgressionAction.recover,
          targetReps: base,
          reason:
              'You hit every set, but short sleep limits recovery. Keep the '
              'target and prioritise rest before adding work.',
        );
      }
      if (input.effort == null) {
        return ProgressionDecision(
          action: ProgressionAction.maintain,
          targetReps: base,
          reason:
              'Target met. Rate the effort next time so progression can use '
              'it.',
        );
      }
      if (input.effort! >= 4) {
        return ProgressionDecision(
          action: ProgressionAction.maintain,
          targetReps: base,
          reason:
              'You completed the work but it felt hard. Repeat this target '
              'until it feels controlled.',
        );
      }
      final int comfortableSessions = input.comfortableStreak + 1;
      if (input.isComfortable &&
          comfortableSessions >= comfortableSessionsForIncrease) {
        return ProgressionDecision(
          action: ProgressionAction.increase,
          targetReps: base + 1,
          reason: 'Two comfortable, complete sessions in a row. One more rep.',
        );
      }
      return ProgressionDecision(
        action: ProgressionAction.maintain,
        targetReps: base,
        reason: input.isComfortable
            ? 'Comfortable session logged. Repeat it once more before adding a '
                  'rep.'
            : 'Target met. Repeat this target before increasing it.',
      );
    }

    final bool veryHard = input.effort != null && input.effort! >= 5;
    if (input.completionRate <= 0.5 || veryHard) {
      return ProgressionDecision(
        action: ProgressionAction.reduce,
        targetReps: floor,
        reason: input.sleepIsPoor
            ? 'Several sets fell short while sleep is short. Ease off and '
                  'recover rather than pushing.'
            : 'Several sets fell short. Drop a rep and rebuild with clean form.',
      );
    }

    if (input.effort != null && input.effort! >= 4) {
      return ProgressionDecision(
        action: ProgressionAction.maintain,
        targetReps: base,
        reason:
            'A hard session with a few missed reps. Repeat the target '
            'before changing anything.',
      );
    }

    return ProgressionDecision(
      action: ProgressionAction.maintain,
      targetReps: base,
      reason: 'Not every set met the target, so the target holds.',
    );
  }
}
