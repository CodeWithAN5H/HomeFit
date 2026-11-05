import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/profile/domain/profile_options.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';
import 'package:homefit/features/workouts/data/workout_templates.dart';
import 'package:homefit/features/workouts/domain/workout_mode.dart';
import 'package:homefit/features/workouts/domain/workout_schedule.dart';
import 'package:homefit/features/workouts/domain/workout_session.dart';

import '../../fixtures/profile_fixtures.dart';
import '../../fixtures/workout_fixtures.dart';

TodayRecommendation recommend({
  required DateTime now,
  List<WorkoutSession> sessions = const <WorkoutSession>[],
  UserProfile? profile,
}) {
  return WorkoutSchedule.recommend(
    profile: profile ?? buildTestProfile(),
    now: now,
    sessions: sessions,
    templates: kWorkoutTemplates,
  );
}

void main() {
  final DateTime now = DateTime(2026, 11, 5, 18);

  test('a brand new user is offered the first full-body session', () {
    final TodayRecommendation today = recommend(now: now);
    expect(today.kind, ScheduleKind.train);
    expect(today.mode, WorkoutMode.normal);
    expect(today.templateId, 'full-body-a');
    expect(today.nextTrainingDay, DateTime(2026, 11, 5));
  });

  test('training today recommends recovery, not more strength', () {
    final TodayRecommendation today = recommend(
      now: now,
      sessions: <WorkoutSession>[
        buildTestSession(id: 'a', startedAt: DateTime(2026, 11, 5, 9)),
      ],
    );
    expect(today.kind, ScheduleKind.recovery);
    expect(today.templateId, isNull);
    expect(today.reason, contains('trained today'));
    expect(today.nextTrainingDay, DateTime(2026, 11, 7));
  });

  test('training yesterday still recommends recovery for a full day', () {
    final TodayRecommendation today = recommend(
      now: now,
      sessions: <WorkoutSession>[
        buildTestSession(id: 'a', startedAt: DateTime(2026, 11, 4, 19)),
      ],
    );
    expect(today.kind, ScheduleKind.recovery);
    expect(today.nextTrainingDay, DateTime(2026, 11, 6));
  });

  test('two days later the next template in the rotation is suggested', () {
    final TodayRecommendation today = recommend(
      now: now,
      sessions: <WorkoutSession>[
        buildTestSession(id: 'a', startedAt: DateTime(2026, 11, 3, 19)),
      ],
    );
    expect(today.kind, ScheduleKind.train);
    expect(today.templateId, 'full-body-b');
  });

  test('the rotation wraps from the last template back to the first', () {
    final TodayRecommendation today = recommend(
      now: now,
      sessions: <WorkoutSession>[
        buildTestSession(
          id: 'c',
          startedAt: DateTime(2026, 11, 3, 19),
          templateId: 'full-body-c',
          templateName: 'Full body C',
        ),
      ],
    );
    expect(today.templateId, 'full-body-a');
  });

  test('a quick session still counts for spacing strength days', () {
    final TodayRecommendation today = recommend(
      now: now,
      sessions: <WorkoutSession>[
        buildTestSession(
          id: 'q',
          startedAt: DateTime(2026, 11, 4, 8),
          mode: WorkoutMode.quick,
          templateId: 'quick-full-body',
        ),
      ],
    );
    expect(today.kind, ScheduleKind.recovery);
  });

  test('a recovery session does not block training the next day', () {
    final TodayRecommendation today = recommend(
      now: now,
      sessions: <WorkoutSession>[
        buildTestSession(
          id: 'r',
          startedAt: DateTime(2026, 11, 4, 8),
          mode: WorkoutMode.recovery,
          templateId: 'recovery-reset',
        ),
      ],
    );
    expect(today.kind, ScheduleKind.train);
  });

  test('an abandoned session is not evidence of training', () {
    final TodayRecommendation today = recommend(
      now: now,
      sessions: <WorkoutSession>[
        buildTestSession(
          id: 'x',
          startedAt: DateTime(2026, 11, 5, 8),
          status: WorkoutSessionStatus.abandoned,
        ),
      ],
    );
    expect(today.kind, ScheduleKind.train);
    expect(today.templateId, 'full-body-a');
  });

  test('short sleep is called out but does not cancel a due session', () {
    final TodayRecommendation today = recommend(
      now: now,
      profile: buildTestProfile().copyWith(
        sleep: SleepPattern.severelyInsufficient,
      ),
      sessions: <WorkoutSession>[
        buildTestSession(id: 'a', startedAt: DateTime(2026, 11, 3, 19)),
      ],
    );
    expect(today.kind, ScheduleKind.train);
    expect(today.reason, contains('Short sleep'));
  });

  test('a profile with very short sessions gets the quick circuit', () {
    final TodayRecommendation today = recommend(
      now: now,
      profile: buildTestProfile().copyWith(sessionMinutes: 20),
    );
    expect(today.mode, WorkoutMode.quick);
    expect(today.templateId, 'quick-full-body');
    expect(today.recommendsStrength, isTrue);
  });

  test('recovery can be forced without changing the schedule', () {
    final TodayRecommendation today = WorkoutSchedule.recommend(
      profile: buildTestProfile(),
      now: now,
      sessions: const <WorkoutSession>[],
      templates: kWorkoutTemplates,
      forcedMode: WorkoutMode.recovery,
    );
    expect(today.kind, ScheduleKind.recovery);
    expect(today.mode, WorkoutMode.recovery);
  });
}
