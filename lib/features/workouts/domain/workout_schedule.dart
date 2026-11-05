import '../../profile/domain/profile_options.dart';
import '../../profile/domain/user_profile.dart';
import 'workout_mode.dart';
import 'workout_session.dart';
import 'workout_template.dart';

/// What today should look like.
enum ScheduleKind {
  train('Training day'),
  recovery('Recovery day'),
  rest('Rest day');

  const ScheduleKind(this.label);

  final String label;
}

/// The dashboard's recommendation, with the reason the user can read.
class TodayRecommendation {
  const TodayRecommendation({
    required this.kind,
    required this.mode,
    required this.headline,
    required this.reason,
    required this.nextTrainingDay,
    this.templateId,
  });

  final ScheduleKind kind;
  final WorkoutMode mode;

  /// Short phrase for the card title, e.g. "Full body A".
  final String headline;
  final String reason;

  /// The earliest date a strength session is recommended again.
  final DateTime nextTrainingDay;

  /// Template to open when the user starts; null for recovery days.
  final String? templateId;

  bool get recommendsStrength => kind == ScheduleKind.train;
}

/// Pure training calendar.
///
/// Rules, deliberately simple enough to explain:
/// - Strength sessions are spaced by at least one full day, because the same
///   muscles are trained each time in a full-body programme.
/// - Training today or yesterday therefore recommends recovery, never more
///   strength.
/// - Otherwise the next full-body template in the rotation is suggested, so the
///   plan is predictable rather than random.
/// - Very short sleep never increases load; on a recovery day it is called out.
/// - The calendar alone never upgrades anything — only completed work does that.
abstract final class WorkoutSchedule {
  /// Minimum gap, in days, between two strength sessions.
  static const int minimumStrengthGapDays = 2;

  /// Sessions below this preferred length get the short circuit instead of a
  /// full session.
  static const int shortSessionMinutes = 25;

  static TodayRecommendation recommend({
    required UserProfile profile,
    required DateTime now,
    required List<WorkoutSession> sessions,
    required List<WorkoutTemplate> templates,
    WorkoutMode? forcedMode,
  }) {
    final List<WorkoutTemplate> normalTemplates = templates
        .where(
          (WorkoutTemplate template) => template.mode == WorkoutMode.normal,
        )
        .toList();
    final DateTime today = _dateOnly(now);

    final List<WorkoutSession> strength =
        sessions
            .where(
              (WorkoutSession session) =>
                  session.status.countsAsWorkout && session.mode.isStrength,
            )
            .toList()
          ..sort(
            (WorkoutSession a, WorkoutSession b) =>
                _sessionEnd(b).compareTo(_sessionEnd(a)),
          );

    final WorkoutSession? last = strength.isEmpty ? null : strength.first;
    final int? daysSince = last == null
        ? null
        : today.difference(_dateOnly(_sessionEnd(last))).inDays;

    final DateTime nextEligible = daysSince == null
        ? today
        : _dateOnly(_sessionEnd(last!))
              .add(const Duration(days: minimumStrengthGapDays));
    final DateTime nextTrainingDay = nextEligible.isBefore(today)
        ? today
        : nextEligible;

    if (forcedMode == WorkoutMode.recovery) {
      return TodayRecommendation(
        kind: ScheduleKind.recovery,
        mode: WorkoutMode.recovery,
        headline: 'Recovery session',
        reason: 'You chose a lighter day. Movement without load still counts.',
        nextTrainingDay: nextTrainingDay,
      );
    }

    if (daysSince != null && daysSince < minimumStrengthGapDays) {
      return TodayRecommendation(
        kind: ScheduleKind.recovery,
        mode: WorkoutMode.recovery,
        headline: 'Recovery day',
        reason: daysSince == 0
            ? 'You trained today. Let the muscles recover before loading them '
                  'again.'
            : 'You trained yesterday, and this programme trains the same '
                  'muscles each session. One full day between strength days '
                  'protects progress.',
        nextTrainingDay: nextTrainingDay,
      );
    }

    if (profile.sessionMinutes < shortSessionMinutes) {
      return TodayRecommendation(
        kind: ScheduleKind.train,
        mode: WorkoutMode.quick,
        headline: 'Quick full-body circuit',
        reason:
            'Your saved sessions are ${profile.sessionMinutes} minutes, so '
            'the short circuit fits today.',
        nextTrainingDay: today,
        templateId: _templateIdFor(templates, WorkoutMode.quick),
      );
    }

    final WorkoutTemplate nextTemplate = _nextTemplate(
      templates: normalTemplates,
      lastTemplateId: last?.templateId,
    );
    final bool poorSleep = profile.sleep == SleepPattern.severelyInsufficient;

    final String reason;
    if (poorSleep) {
      reason =
          'Short sleep is the limit today. Train, but keep two reps in reserve '
          'and stop early if form slips.';
    } else if (last == null) {
      reason =
          'A balanced full-body session to start with. Three non-consecutive '
          'days a week is the plan.';
    } else {
      reason =
          'Next in your rotation after ${last.templateName}. '
          '${_daysLabel(daysSince ?? 0)} since your last strength session.';
    }

    return TodayRecommendation(
      kind: ScheduleKind.train,
      mode: WorkoutMode.normal,
      headline: nextTemplate.name,
      reason: reason,
      nextTrainingDay: today,
      templateId: nextTemplate.id,
    );
  }

  static String? _templateIdFor(
    List<WorkoutTemplate> templates,
    WorkoutMode mode,
  ) {
    for (final WorkoutTemplate template in templates) {
      if (template.mode == mode) return template.id;
    }
    return null;
  }

  static WorkoutTemplate _nextTemplate({
    required List<WorkoutTemplate> templates,
    required String? lastTemplateId,
  }) {
    if (templates.isEmpty) {
      throw StateError('No full-body templates are bundled');
    }
    final int lastIndex = templates.indexWhere(
      (WorkoutTemplate template) => template.id == lastTemplateId,
    );
    if (lastIndex < 0) return templates.first;
    return templates[(lastIndex + 1) % templates.length];
  }

  static String _daysLabel(int days) => days == 1 ? '1 day' : '$days days';

  static DateTime _dateOnly(DateTime value) {
    final DateTime local = value.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  static DateTime _sessionEnd(WorkoutSession session) =>
      session.endedAt ?? session.lastActivityAt;
}
