import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/profile/domain/profile_options.dart';
import 'package:homefit/features/workouts/domain/progression.dart';

ProgressionInput input({
  int prescribedSets = 3,
  int targetReps = 8,
  List<int?> reps = const <int?>[8, 8, 8],
  int? effort = 2,
  int comfortableStreak = 1,
  SleepPattern? sleep,
}) {
  return ProgressionInput(
    exerciseId: 'bodyweight-squat',
    prescribedSets: prescribedSets,
    targetReps: targetReps,
    completedReps: reps,
    effort: effort,
    sleepPattern: sleep,
    comfortableStreak: comfortableStreak,
  );
}

void main() {
  group('increase', () {
    test('two comfortable complete sessions add exactly one rep', () {
      final ProgressionDecision decision = ProgressionEngine.decide(input());
      expect(decision.action, ProgressionAction.increase);
      expect(decision.targetReps, 9);
    });

    test('a single comfortable session holds instead of jumping', () {
      final ProgressionDecision decision = ProgressionEngine.decide(
        input(comfortableStreak: 0),
      );
      expect(decision.action, ProgressionAction.maintain);
      expect(decision.targetReps, 8);
    });

    test('exceeding the target still only adds one rep', () {
      final ProgressionDecision decision = ProgressionEngine.decide(
        input(reps: <int?>[12, 12, 12]),
      );
      expect(decision.action, ProgressionAction.increase);
      expect(decision.targetReps, 9);
    });
  });

  group('hold', () {
    test('hard effort never increases, even with every set complete', () {
      final ProgressionDecision decision = ProgressionEngine.decide(
        input(effort: 4),
      );
      expect(decision.action, ProgressionAction.maintain);
      expect(decision.targetReps, 8);
    });

    test('missing effort rating holds the target', () {
      final ProgressionDecision decision = ProgressionEngine.decide(
        input(effort: null),
      );
      expect(decision.action, ProgressionAction.maintain);
      expect(decision.targetReps, 8);
    });

    test('a few missed reps at moderate effort hold', () {
      final ProgressionDecision decision = ProgressionEngine.decide(
        input(reps: <int?>[8, 8, 6], effort: 3),
      );
      expect(decision.action, ProgressionAction.maintain);
      expect(decision.targetReps, 8);
    });

    test('a skipped set is not treated as completed work', () {
      final ProgressionDecision decision = ProgressionEngine.decide(
        input(reps: <int?>[8, null, 8], effort: 2),
      );
      expect(decision.action, ProgressionAction.maintain);
    });

    test('no logged sets leaves the target alone', () {
      final ProgressionDecision decision = ProgressionEngine.decide(
        input(reps: const <int?>[], effort: 2),
      );
      expect(decision.action, ProgressionAction.maintain);
      expect(decision.targetReps, 8);
    });
  });

  group('reduce', () {
    test('completing half the prescribed sets drops one rep', () {
      final ProgressionDecision decision = ProgressionEngine.decide(
        input(reps: <int?>[8, 3], effort: 3),
      );
      expect(decision.action, ProgressionAction.reduce);
      expect(decision.targetReps, 7);
    });

    test('maximum effort with missed reps reduces instead of pushing', () {
      final ProgressionDecision decision = ProgressionEngine.decide(
        input(reps: <int?>[8, 7, 6], effort: 5),
      );
      expect(decision.action, ProgressionAction.reduce);
      expect(decision.targetReps, 7);
    });

    test('a target of one rep cannot fall below one', () {
      final ProgressionDecision decision = ProgressionEngine.decide(
        input(targetReps: 1, reps: <int?>[0, 0, 0], effort: 5),
      );
      expect(decision.action, ProgressionAction.reduce);
      expect(decision.targetReps, 1);
    });
  });

  group('recovery', () {
    test('short sleep stops progression even after a perfect session', () {
      final ProgressionDecision decision = ProgressionEngine.decide(
        input(sleep: SleepPattern.severelyInsufficient),
      );
      expect(decision.action, ProgressionAction.recover);
      expect(decision.targetReps, 8);
    });

    test('a poor session with short sleep eases off', () {
      final ProgressionDecision decision = ProgressionEngine.decide(
        input(
          reps: <int?>[8, 4],
          effort: 4,
          sleep: SleepPattern.severelyInsufficient,
        ),
      );
      expect(decision.action, ProgressionAction.reduce);
    });
  });

  test('every decision carries a reason the UI can show', () {
    final ProgressionDecision decision = ProgressionEngine.decide(input());
    expect(decision.reason.trim(), isNotEmpty);
    expect(decision.changesTarget, isTrue);
  });
}
