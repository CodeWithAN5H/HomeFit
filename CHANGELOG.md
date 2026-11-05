# Changelog

All notable changes to HomeFit are recorded here. Format loosely follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versions use `0.x` during development.

## [0.1.0] — 2026-11-04

First usable increment: a real app that onboards, stores a profile locally and navigates. Training and
nutrition are still absent and every affected tab says so.

### Added

- Dark Material 3 design system: design tokens (`app_tokens.dart`) and component themes for app bar,
  navigation bar, buttons, inputs, switches, dividers, snackbars.
- `go_router` navigation with a five-destination `StatefulShellRoute` (Home, Workout, Nutrition, Progress,
  Coach), an onboarding route and a profile-aware redirect.
- Five-step onboarding: about you, goals/focus, setup (equipment, session length, training time),
  food & sleep, optional baseline assessment — with pure, unit-tested validation.
- Profile domain model and option enums stored by name; Drift-free mappers that tolerate unknown stored
  values and normalise timestamps to UTC.
- Drift database (schema v1): `profile_rows` and `assessment_rows`, foreign keys enabled on open,
  generated code committed.
- `ProfileRepository` interface plus Drift implementation, Riverpod providers and `ProfileController`;
  the profile is loaded before the first frame.
- Home screen: greeting, saved-profile summary, sleep-aware recovery guidance.
- Honest "not implemented in this build" notices on the Workout, Nutrition, Progress and Coach tabs.
- Startup failure screen for database-open errors.
- 29 tests: draft validation, mapper edge cases, controller behaviour, in-memory SQLite persistence and
  constraints, greeting boundaries, onboarding widget flow.

### Changed

- Version is now `0.1.0+1`; Android application id and namespace are `com.homefit.app`
  (MainActivity moved to match), display label is `HomeFit`.
- Replaced the template description and dropped `cupertino_icons`.
- Gradle heap reduced from 8 GB to 3 GB for this machine.
- `.metadata` is now tracked so Flutter SDK migrations stay reproducible.
- Analysis options tightened (strict casts/inference/raw types plus selected lints).

### Removed

- The Flutter counter demo (`lib/main.dart`) and its smoke test.

### Added in M2.2 — profile editing

- **Edit profile** screen at `/profile/edit`, reachable from the Home app bar and an `Edit` button on the
  *Your setup* card. Every field is prepopulated: age, height, weight, experience, goals, focus areas,
  equipment, session length, training time, diet restrictions, sleep and reminders.
- Saving validates with the onboarding rules, updates the existing profile row in place (no duplicates,
  original `created_at` preserved) and returns Home with a confirmation snackbar; cancelling writes nothing.
- `OnboardingDraft.fromProfile` and `OnboardingDraft.validateProfile` so setup and editing share one set of
  rules and messages.
- Shared `AppNumberField`, used by both onboarding and the editor.
- Tests: editor prepopulation, save, cancel, invalid input, stale-error clearing, empty goals, a router-level
  navigation test and a temporary-file database round trip (47 tests total).

### Fixed in M2.2

- Validation messages now clear as soon as the user edits a field instead of lingering from the previous
  attempt, in onboarding and in the editor.
- Saving from the editor no longer leaves the editor open: the router refreshes only when profile presence
  changes, so the pop after saving is no longer undone by a re-push.

### Fixed after physical-device validation

- Long chip labels (sleep options) overflowed their card on a 393 dp-wide phone; the label now wraps inside
  a flexible box, with regression tests for narrow widths and `Wrap` layouts.
- Android Back closed HomeFit from every tab; it now returns to Home from a secondary tab and only exits
  from Home itself.
- Sleep no longer defaults to “Irregular”: onboarding requires an explicit sleep choice, so Home can never
  report a pattern the user did not select.

### Verification

- `flutter analyze`: no issues.
- `flutter test`: 33 passed (after the device fixes).
- `flutter build apk --debug`: succeeded; installed on a physical iQOO Z3 (Android 13) and exercised through
  onboarding, navigation, restart and SQLite read-back.

### Added in M3 — offline exercise library (2026-11-05)

- Bundled catalogue of **44 exercises** as const Dart data (`lib/features/exercises/data/catalog/`): chest,
  back, shoulders, arms, legs, core and full body, each with three or more steps and at least two form cues.
  No assets, no JSON, no network.
- **Exercise library** at `/workout/exercises`, reached from a new card on the Workout tab: name search,
  muscle chips, equipment and difficulty menus, **My equipment only**, live match count, clear-filters.
- **Exercise detail** at `/workout/exercises/:exerciseId`: visual panel, tags, equipment compatibility for the
  saved profile, overview including the user's experience level, numbered steps, form/safety cues, and up to
  four alternatives with *Needs …* markers when the profile lacks equipment.
- Empty state for zero matches (with its own clear action) and a not-found state for unknown ids.
- Pure `ExerciseQuery`/`ExerciseFilter` engine, kept free of Flutter so the rules are unit tested directly.
- 56 new tests (catalogue integrity, filtering, alternatives ranking, both screens, router navigation); 103 in
  total.

### Fixed in M3

- Exercise card tags overflowed their card: the tag label was measured without a width bound. It now sits in a
  `Flexible` with a single ellipsised line.

### Verification (M3)

- `flutter analyze`: no issues.
- `flutter test`: 103 passed.
- Debug APK installed over the existing one; library entry, list, search, filters, empty state, detail,
  alternatives and Back were exercised on the iQOO Z3 with no exceptions or overflow warnings.

### Known gaps

Profile editing, exercise library, workout engine, nutrition engine, reminders, progress tracking, Body
Goal Timeline, Plan Studio, backup/restore and release signing are not implemented. See
[PROJECT_STATUS.md](PROJECT_STATUS.md).
