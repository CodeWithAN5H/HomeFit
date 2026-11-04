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

**Milestone M0 — project audit and foundation — in progress.**

The environment audit is complete and the repository is initialized. The application source tree has not
been created yet because the Flutter/Dart/Android toolchain is not installed on this machine and installing
it requires explicit approval (see [PROJECT_STATUS.md](PROJECT_STATUS.md) for the full audit and the exact
proposed install steps).

Nothing in this repository is compiled, tested or verified yet. Milestone statuses are tracked honestly in
[PROJECT_STATUS.md](PROJECT_STATUS.md).

## Documentation

| Document | Purpose |
| --- | --- |
| [PROJECT_STATUS.md](PROJECT_STATUS.md) | Environment audit, milestone status, known limitations |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Layering, module boundaries, state, persistence, platform abstractions |
| [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) | Data model and migration policy |
| [DEVELOPMENT_ROADMAP.md](DEVELOPMENT_ROADMAP.md) | Milestones, release gates and definition of done |
| [CHANGELOG.md](CHANGELOG.md) | What actually changed, per version |

## Planned technology

- **Flutter** / **Dart** — single codebase for Android, later Windows and Linux
- **Material 3** with a custom premium dark visual system
- **Riverpod** — state management and dependency injection
- **go_router** — declarative navigation with five primary destinations
- **Drift / SQLite** — local structured storage with versioned migrations
- **flutter_local_notifications** + timezone scheduling — offline reminders
- Platform-independent coaching logic in pure Dart, unit tested without a device

Package versions will be pinned only after the installed Flutter/Dart SDK is known, so that
compatibility is verified rather than assumed.

## Intended project structure (not yet created)

```
lib/
  app/            # bootstrap, app widget, router assembly
  core/           # database, routing, theme, services, notifications, utilities
  features/       # onboarding, dashboard, profile, workouts, exercises, nutrition,
                  # recipes, food_tracking, progress, coach, plan_studio, settings, backup
  shared/         # cross-feature models and widgets
test/             # unit + widget tests
```

See [ARCHITECTURE.md](ARCHITECTURE.md) for the layer rules each feature follows.

## Developer setup

HomeFit requires the Flutter SDK and an Android SDK. Neither is installed on the current development
machine yet; the proposed, approval-gated setup is documented in [PROJECT_STATUS.md](PROJECT_STATUS.md#m0-environment-audit).

Once the toolchain exists, the standard commands are:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Drift + Riverpod codegen
flutter analyze
flutter test
flutter build apk --release --target-platform android-arm64,android-arm,android-x64
```

Release signing keys are never committed; `android/key.properties` is ignored by Git.

## Contributing to this repository

- Do not commit personal signing keys, keystores or passwords.
- Keep business logic out of widgets: engines must be testable in pure Dart.
- Every milestone must update `README.md`, `PROJECT_STATUS.md` and `CHANGELOG.md`, and must state what was
  actually verified rather than what was merely written.
