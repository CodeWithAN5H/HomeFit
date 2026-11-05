# HomeFit — Workout Engine (M4)

Status: **implemented, tested and verified on a physical device.** Everything below runs offline and reads
only the saved profile and locally stored sessions.

---

## Why it is built this way

Three rules decided most of the design:

1. **The calendar never grants progress.** A session counts only when sets were actually logged; rep targets
   move only from what was performed and how hard it felt.
2. **The timer cannot drift.** Rest is stored as an absolute `restEndsAt` instant, so backgrounding the app,
   locking the phone or killing the process cannot make the countdown lie.
3. **Nothing is invented.** Every target, mode explanation and safety note is derived from the profile and
   the bundled exercise data; no screen shows a value the engine did not compute.

## The weekly shape

`WorkoutSchedule` (pure Dart) recommends what today should be:

| Situation | Recommendation |
| --- | --- |
| No completed session ever | Full body A |
| Last strength session today or yesterday | Recovery |
| Last strength session ≥ 2 days ago | Next template in the A → B → C rotation |
| Session length under 25 minutes | Quick session |
| Sleep reported as very short | Recovery, with the reason named |
| A session was started but not finished | The runner resumes it; the dashboard offers *Resume* |

- **Minimum gap:** two calendar days (`minimumStrengthGapDays = 2`), i.e. at least one full rest day between
  strength sessions. This is the conservative choice for a beginner training at home.
- **Rotation:** `full-body-a` → `full-body-b` → `full-body-c`, chosen from the most recent completed strength
  session. Repeated quick or recovery sessions do not advance the rotation.
- **Poor sleep never cancels a due session.** It is mentioned in the reason, because the user decides; the
  app does not silently remove training because of one bad night.
- Skipped days are not "made up" and no streak is broken by resting — consistency is measured separately.

## Modes

| Mode | Purpose | Rest | Counts as strength | Drives progression |
| --- | --- | --- | --- | --- |
| `normal` | The scheduled full-body session | 60 s | yes | yes |
| `quick` | ~10 minute circuit for a busy day | 20 s | yes (spacing) | **no** |
| `recovery` | Gentle mobility and easy movement | 30 s | no | no |
| `targeted` | Extra work for one muscle group | 45 s | yes | yes |
| `skill` | Push-up / pull-up practice | 45 s | no | no |

Each mode carries a one-paragraph `explanation` shown on the preview screen, so a mode is never a surprise.
Quick, recovery and skill sessions are excluded from progression on purpose: they are not a fair measure of
capacity, and rewarding them would reward doing less.

## Templates

Seven bundled templates live in `lib/features/workouts/data/workout_templates.dart` as const Dart data:

- `full-body-a`, `full-body-b`, `full-body-c` — the beginner rotation, ~30 minutes.
- `quick-full-body` — five slots, short rests, ~12 minutes estimated.
- `recovery-reset` — mobility and easy bodyweight work.
- `skill-push-progress`, `skill-pull-prep` — low-volume practice.

Each **slot** lists a chain of preferred exercise ids (`dead-bug` → `plank`, `band-row` → `superman`, …), a
set count, a rep range or hold time, rest and an optional coaching note. The planner walks the chain and picks
the first id the profile can actually perform, so one template serves a bodyweight-only beginner and an
equipped intermediate without duplicating content. Slots the profile cannot fill are dropped rather than
replaced with something random; if nothing remains, the preview says so instead of starting an empty session.

Planning also applies:

- **Experience ceiling** — beginner profiles are not given advanced movements, even inside a chain.
- **Time budget** — the session length trims slots instead of compressing rest below a safe minimum.
- **Focus and goals** — used to order the candidates inside a chain, not to invent new movements.
- **Progression** — an adjusted rep target per exercise (see below).

Estimated duration is computed from work (40 s per rep set or the hold time), the slot's rest and 20 s to
change movement, so it is comparable across templates and honest about being an estimate.

## The runner

`WorkoutRunnerController` is an `AsyncNotifier` and the single writer:

- **Start** — persists the planned session and its exercise rows first, closes any older unfinished session as
  `interrupted`, then moves to the runner. Nothing exists only in memory.
- **Complete set** — stores actual reps (edited in a text field, defaulting to the target) or hold seconds,
  advances the set index and starts rest from `now + restSeconds`.
- **Skip set** — records the set as skipped, adds no rest.
- **Skip exercise** — records the remaining sets as skipped and moves on.
- **Pause / resume** — pause freezes the remaining rest into `restRemainingSeconds` and clears the end
  instant; resume converts it back to an absolute instant. Both are persisted.
- **Skip rest / tick** — rest can be skipped, or ends when the stored instant passes; the ticker lives in a
  small `_RestCountdown` widget, not the whole screen.
- **Finish** — requires at least one logged set to be `completed`; otherwise the session is `abandoned`.
- **Discard** — confirmed in a dialog and recorded as `abandoned`, never silently deleted.
- **Effort** — 1–5, stored on the session and used by progression.

Every action writes to SQLite before updating the in-memory state, so a crash loses at most the set in flight.
On launch the provider reopens the unfinished session and restores the exercise index, set index and any
running rest from stored timestamps.

Automatic finish: when every planned set has been logged or skipped, the session completes and the summary
opens by itself. No "finish" tap is required to avoid losing the last set.

## History and statuses

| Status | Meaning | Counts as a workout |
| --- | --- | --- |
| `inProgress` | Resumable; at most one exists | no |
| `completed` | Ended with at least one logged set | **yes** |
| `abandoned` | Discarded, or ended with no sets | no |
| `interrupted` | Older open session closed when a new one started | no |

History shows all four, with the real sets, reps, duration and effort. Hiding unfinished attempts would make
the history flatter than the training actually was; the summary states plainly when a session did not count.

## Progression

`ProgressionEngine` is pure and rule-based; it is not a model and it never guesses:

- **Increase by one rep** after **two consecutive comfortable** sessions of the same exercise in a
  progression-driving mode, where comfortable means every prescribed set was completed at the target and
  perceived effort was 1–2.
- **Hold** after a hard effort (4–5) or when effort was not recorded.
- **Reduce by one rep** (floor 1) after a session with ≤ 50% of sets completed or effort 5.
- **Recover** instead of training when the reported sleep is very short.
- **Manual override wins**: reps adjusted on the preview screen are stored as the target for that session and
  replace the computed suggestion, without writing anything until the session starts.

Progression history is derived from the stored sessions and sets — no extra table and no cached "current
target" that could disagree with the log.

## Safety

- Templates and the preview carry explicit notes (stop on sharp pain, keep joints stacked, breathe, use a
  wall or chair for support where relevant).
- No mode encourages training through pain; recovery is offered whenever the schedule or sleep suggests it.
- Rep ranges start conservative and only move after two comfortable performances.
- The summary reminds the user to rest and eat, and to seek advice for sharp pain rather than train through it.

## Files

| Path | Responsibility |
| --- | --- |
| `domain/workout_mode.dart` | Mode and status semantics, progression eligibility |
| `domain/workout_template.dart` | Template + slot models, duration estimate |
| `domain/planned_workout.dart` | Personalised plan produced by the planner |
| `domain/workout_session.dart` | Stored session, exercises, set logs, positional helpers |
| `domain/workout_planner.dart` | Template → plan for a profile, overrides, time budget |
| `domain/workout_schedule.dart` | Today's recommendation and rotation |
| `domain/progression.dart` | Rule-based target decisions |
| `domain/workout_history.dart` | Per-exercise history derived from stored sessions |
| `data/workout_templates.dart` | The seven bundled templates |
| `data/workout_repository.dart` | Interface + Drift implementation (sessions, sets, history) |
| `data/workout_mappers.dart` | Row ↔ domain mapping, UTC timestamps |
| `application/workout_providers.dart` | Repository, planner, today, preview, runner, history controllers |
| `presentation/workout_screen.dart` | Dashboard: resume, today, modes, targeted, recent, library |
| `presentation/workout_preview_screen.dart` | Explanation, adjustment, safety, start |
| `presentation/workout_session_screen.dart` | Runner, rest countdown, pause, skip, end |
| `presentation/workout_summary_screen.dart` | Result, status, effort |
| `presentation/workout_history_screen.dart` | List and detail |
| `presentation/workout_report.dart` | Shared per-exercise report and status chip |

## Tests

`test/features/workouts/` covers templates, scheduling, planning, progression, the repository (round trip,
cascade, interruption, history, v1 → v2 migration) and the runner (sets, rest, pause, skip, finish, discard,
restore, auto-finish). `test/widget/` drives the dashboard, preview, runner, summary and history through a
real router, and `test/app/exercise_navigation_test.dart` keeps the M3 entry point working.
