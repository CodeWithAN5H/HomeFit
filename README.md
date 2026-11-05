# HomeFit

A personal home fitness coach for training intelligently, eating adequately, and staying consistent —
built offline-first, with no account, no backend, no subscription and no paid AI API required.

HomeFit is being built for **Android first**, with Windows and Linux planned. All data stays on the device.

> **Health note:** HomeFit is a training and nutrition *organizer*, not a medical device or a clinician.
> It does not diagnose, treat or predict medical outcomes. If you have a health concern — especially
> unexplained weight loss, persistent fatigue or pain — talk to a doctor. HomeFit's guidance is
> deliberately conservative and never asks you to train through sharp pain, joint pain or worrying symptoms.

---

## Current status

**M0 complete · M1 implemented and tested · M2 verified · M2.2 profile editing done · M3 offline exercise
library done · M4 guided training done · M5 offline nutrition done.** Progress, coaching and notifications
are **not implemented yet**.

What actually works in this build:

- A five-step onboarding flow (age, height, weight, experience, goals, focus areas, equipment, session
  length, training time, diet, sleep, optional baseline) with validated input.
- The profile and optional baseline assessment are saved to a local SQLite database and survive restarts.
- **Profile editing**: every answer can be changed later from Home → *Edit* (or the app-bar pencil), with the
  same validation as onboarding, cancel-without-saving, and an in-place update of the single stored row.
- **Offline exercise library** (M3): 44 movements with muscle group, difficulty, equipment, steps and form
  cues — search, muscle/equipment/difficulty filters, *my equipment only*, detail screens and alternatives
  ranked for the saved profile. Bundled in the app: no network, no assets, no photos.
- **Workout engine** (M4): a schedule-aware dashboard (today's session with its reason, resume card, quick,
  recovery, targeted and skill modes), a preview with mode explanation, safety notes and adjustable rep
  targets, and a guided runner with set logging, skip set/exercise, pause/resume, a rest timer that survives
  backgrounding and restarts, and confirm-before-discard. History lists completed, abandoned and interrupted
  sessions with the real sets and reps, and rep targets move only from recorded performance and effort.
- **Nutrition engine** (M5): a bundled catalogue of 55 Indian vegetarian foods (per 100 g/ml, household
  servings, raw/cooked states) and 13 recipes; a five-slot daily meal planner with save/load; a separate food
  log with daily calories/protein/carbs/fat and day navigation; recipe search and detail with per-serving
  estimates; a grocery checklist generated from a day's plan with duplicates merged, manual items and
  purchased ticks; and a transparent, conservative target range derived only from the saved profile (no
  target for under-18s, no BMI diagnosis, no promised rate of gain).
- A dark Material 3 design system, five-destination navigation (Home, Workout, Nutrition, Progress, Coach),
  and a home screen that summarises the saved profile and gives sleep-aware recovery guidance.
- An honest "not built yet" state on every tab whose features are still missing — no dead controls.

Verified: `flutter analyze` → no issues; `flutter test` → 285 tests pass; the debug APK was installed over an
existing install and exercised on a physical iQOO Z3 (Android 13) through onboarding, profile editing, the
exercise library, the whole training flow, a force-stop/relaunch mid-session, and the nutrition flow (targets,
planner, food log, recipes, grocery generation, manual item, tick, restart persistence), plus v1 → v2 and
v2 → v3 database upgrades that kept existing data. Full detail, including limitations, is in
[PROJECT_STATUS.md](PROJECT_STATUS.md).

## Documentation

| Document | Purpose |
| --- | --- |
| [PROJECT_STATUS.md](PROJECT_STATUS.md) | Environment, milestone status, verification log, limitations |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Layering, module boundaries, state, persistence, platform abstractions |
| [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) | Data model, units, deletion and migration policy |
| [EXERCISE_LIBRARY.md](EXERCISE_LIBRARY.md) | The bundled exercise catalogue, filters, alternatives ranking and how to add a movement |
| [WORKOUT_ENGINE.md](WORKOUT_ENGINE.md) | Schedule, modes, templates, runner, rest timer, history and progression rules |
| [NUTRITION.md](NUTRITION.md) | Food and recipe catalogues, targets and assumptions, planner/log separation, grocery generation, schema and tests |
| [DEVELOPMENT_ROADMAP.md](DEVELOPMENT_ROADMAP.md) | Milestones, release gates and definition of done |
| [CHANGELOG.md](CHANGELOG.md) | What actually changed, per version |

## Technology

- **Flutter / Dart** — one codebase for Android, later Windows and Linux
- **Material 3** with a custom dark visual system (`lib/core/theme`)
- **Riverpod** — state management and dependency injection
- **go_router** — navigation with a five-destination shell and an onboarding redirect
- **Drift / SQLite** — local structured storage with a versioned schema and migrations
- **Const Dart datasets** — the exercise, food and recipe catalogues ship in code, so everything is instant
  and fully offline

Package versions are pinned in `pubspec.lock` and were resolved against the installed SDK, not guessed.

## Project structure

```
lib/
  app/                  # root app widget, navigation shell, startup failure screen
  core/
    database/           # Drift tables, database, migrations (schema v1)
    routing/            # go_router configuration and route names
    services/           # injectable Clock (platform services later)
    theme/              # design tokens + Material 3 theme
    utilities/          # enum codec, greeting helper
  features/
    onboarding/         # draft validation (pure) + five-step UI
    profile/            # domain models, repository, mappers, providers, edit screen
    dashboard/          # home screen
    exercises/          # bundled catalogue, query engine, library + detail screens
    workouts/           # schedule, templates, planner, runner, history, progression + UI
    nutrition/          # catalogues, totals, targets, plans, logs, recipes, grocery + UI
    progress/ coach/    # honest not-built-yet states
  shared/widgets/       # card, chips, number field, detail rows, milestone notice
test/
  app/  core/  features/  widget/  fixtures/   # routing, unit, database, controller and widget tests
```

## Developer setup

This machine reuses an existing Flutter SDK by absolute path rather than a PATH entry:

```
C:\Users\alfa\Desktop\FlowState\.tooling\flutter\bin\flutter.bat   # Flutter 3.47.8 / Dart 3.13.7
C:\Users\alfa\AppData\Local\Android\Sdk                             # platform 36, build-tools 36.0.0
```

Commands (run from the project root, with that SDK's `flutter`/`dart` invoked by absolute path):

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Drift codegen into *.g.dart
flutter analyze
flutter test
flutter build apk --debug                                   # development APK
```

Drift code generation is only needed after changing `app_tables.dart`; the generated file is committed.

Release signing keys are never committed; `android/key.properties`, keystores and `*.apk` are ignored.

## Rules this project follows

- No fake buttons, no placeholder data presented as a finished feature.
- Migrations are written before data models change.
- Nothing is reported as verified unless a command or device check actually passed.
- Every milestone updates `README.md`, `PROJECT_STATUS.md` and `CHANGELOG.md` in the same commit.
