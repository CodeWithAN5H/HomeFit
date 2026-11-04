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

**M0 complete · M1 implemented and tested · M2 implemented and tested.**
Workout, nutrition, progress, coaching and notifications are **not implemented yet**.

What actually works in this build:

- A five-step onboarding flow (age, height, weight, experience, goals, focus areas, equipment, session
  length, training time, diet, sleep, optional baseline) with validated input.
- The profile and optional baseline assessment are saved to a local SQLite database and survive restarts.
- A dark Material 3 design system, five-destination navigation (Home, Workout, Nutrition, Progress, Coach),
  and a home screen that summarises the saved profile and gives sleep-aware recovery guidance.
- An honest "not built yet" state on every tab whose features are still missing — no dead controls.

Verified commands: `flutter analyze` → no issues; `flutter test` → 29 tests pass; debug APK builds.
Full detail, including limitations, is in [PROJECT_STATUS.md](PROJECT_STATUS.md).

## Documentation

| Document | Purpose |
| --- | --- |
| [PROJECT_STATUS.md](PROJECT_STATUS.md) | Environment, milestone status, verification log, limitations |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Layering, module boundaries, state, persistence, platform abstractions |
| [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) | Data model, units, deletion and migration policy |
| [DEVELOPMENT_ROADMAP.md](DEVELOPMENT_ROADMAP.md) | Milestones, release gates and definition of done |
| [CHANGELOG.md](CHANGELOG.md) | What actually changed, per version |

## Technology

- **Flutter / Dart** — one codebase for Android, later Windows and Linux
- **Material 3** with a custom dark visual system (`lib/core/theme`)
- **Riverpod** — state management and dependency injection
- **go_router** — navigation with a five-destination shell and an onboarding redirect
- **Drift / SQLite** — local structured storage with a versioned schema and migrations

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
    profile/            # domain models, repository, mappers, providers
    dashboard/          # home screen
    workouts/ nutrition/ progress/ coach/   # honest not-built-yet states
  shared/widgets/       # card, chips, detail rows, milestone notice
test/
  core/  features/  widget/  fixtures/      # unit, database, controller and widget tests
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

Release signing keys are never committed; `android/key.properties`, keystores and `*.apk` are ignored.

## Rules this project follows

- No fake buttons, no placeholder data presented as a finished feature.
- Migrations are written before data models change.
- Nothing is reported as verified unless a command or device check actually passed.
- Every milestone updates `README.md`, `PROJECT_STATUS.md` and `CHANGELOG.md` in the same commit.
