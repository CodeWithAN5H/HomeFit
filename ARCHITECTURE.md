# HomeFit — Architecture

Status: **design agreed in M0; no source code exists yet.** Every statement below describes the intended
structure that the first code commits will follow. It will be revised as implementation reveals reality.

---

## Goals that shape the architecture

1. **Offline-first, single device.** No component may require a network call to function. Photos, plans,
   logs and settings live in local storage.
2. **No accounts, no backend.** Nothing personal leaves the device unless the user exports a backup.
3. **Adaptive, not calendar-driven.** Progression decisions come from recorded performance, effort,
   soreness and recovery — never from "a week has passed".
4. **Testable coaching logic.** Training, nutrition and consistency rules must run in pure Dart without a
   device, widget tree or database, so they can be unit tested exhaustively.
5. **Portable to Windows/Linux later.** Android-only APIs sit behind interfaces; the core cannot import
   `dart:io` platform plugins directly.

## Layering

Each feature owns the same four layers. Dependencies point inward only.

```
presentation  →  application  →  domain
      ↓               ↓            ↑
      └───────────→  data  ────────┘
```

| Layer | Contents | Rules |
| --- | --- | --- |
| `presentation` | Screens, widgets, Riverpod `ConsumerWidget`s, visual state | No business rules, no SQL, no direct plugin calls. Reads state, dispatches intents. |
| `application` | Riverpod `Notifier`/`AsyncNotifier` controllers, feature use-cases | Orchestrates repositories and domain engines; holds transient UI-independent state. |
| `domain` | Entities, value objects, pure engines (`ProgressionEngine`, `SessionPlanner`, `NutritionCalculator`, `ConsistencyEngine`, `GoalTimelineEstimator`) | Pure Dart. No Flutter imports. Deterministic and unit tested. |
| `data` | Repository implementations, Drift DAOs, mappers, asset/dataset loaders | Implements domain-facing interfaces; the only place that talks to the database. |

Widgets never call a repository and repositories never import a widget. This is the rule that keeps the
coaching engines testable.

## Project structure

```
lib/
  app/
    app.dart                 # root MaterialApp.router + theme wiring
    bootstrap.dart           # startup: database open, migrations, notification init
  core/
    database/                # Drift database, tables, DAOs, migrations, seed loader
    routing/                 # go_router configuration, route names, shell
    theme/                   # design tokens, ColorScheme, typography, component themes
    services/                # interfaces + platform implementations (notifications, files,
                             # photos, clock, haptics, app lifecycle)
    notifications/           # scheduling, quiet hours, rescheduling, permission flow
    utilities/               # date/format helpers, result types, validators
  features/
    onboarding/  dashboard/  profile/  workouts/  exercises/
    nutrition/   recipes/    food_tracking/  progress/  coach/
    plan_studio/ settings/   backup/
      data/  domain/  presentation/
  shared/
    models/                  # cross-feature value types
    widgets/                 # buttons, cards, tiles, empty/error/loading states, charts
test/
  domain/                    # pure engine unit tests
  data/                      # in-memory Drift database tests
  widget/                    # focused widget tests
  fixtures/                  # plan JSON, food datasets for import validation tests
assets/
  exercises/                 # original, lightweight SVG/PNG demonstration illustrations
  data/                      # exercises.json, foods.json, recipes.json (bundled seeds)
```

`core/services` holds **interfaces** in plain Dart and platform implementations in separate files, so a
Linux/Windows build can supply its own implementation later without touching feature code.

## State management and dependency injection

- **Riverpod** for both state and injection: database → DAO → repository → controller → widget.
- Providers are declared next to the feature that owns them; cross-cutting ones (`databaseProvider`,
  `clockProvider`, `notificationServiceProvider`) live in `core`.
- Sealed/immutable state classes with explicit `loading / data / empty / error` states so every screen has
  real states instead of an implicit blank.
- Long-lived providers are `keepAlive` only where state must survive navigation (an in-progress workout);
  everything else is auto-disposed to avoid stale data and extra rebuilds.
- `Clock` is injected rather than read from `DateTime.now()` inside engines, so time-dependent logic
  (Restart Mode, weekly reports, streak boundaries) is testable.

## Navigation

`go_router` with a `StatefulShellRoute.indexedStack` and five primary destinations: **Home, Workout,
Nutrition, Progress, Coach**. Secondary features are pushed routes inside their section:

- Workout → exercise library, session runner, history, targeted/quick/recovery/skill modes
- Nutrition → meal planner, food log, recipes, ingredient suggestions, grocery list
- Progress → weight, measurements, photos, records, weekly report, Body Goal Timeline
- Coach → daily guidance, Restart Mode, style preferences, reminders, Plan Studio

The active workout session is a full-screen route that intercepts back navigation and asks before
discarding an unfinished session.

## Persistence

Drift (SQLite) with versioned migrations — see [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md). SQLite is opened
with foreign keys enabled and a documented migration path per schema version. Seeded content (exercises,
foods, recipes) is loaded from bundled JSON into tables with stable string IDs, so user data references
content that survives app updates.

Important state is never memory-only: an in-progress session writes its set records as they are completed,
so a process kill loses at most the current set.

## Platform-specific functionality

| Capability | Interface | Android implementation | Later |
| --- | --- | --- | --- |
| Notifications & scheduling | `ReminderService` | `flutter_local_notifications` + timezone + boot receiver | Windows toast / Linux notification daemon |
| Export/import files | `FileExchangeService` | share sheet + storage access framework | native file dialogs |
| Progress photos | `PhotoStore` | app-private directory, no media-library upload | same pattern |
| Permissions | `PermissionService` | notification permission + exact-alarm handling with user-facing explanation | no-op |
| Haptics / feedback | `FeedbackService` | light haptics on set completion and rest end | no-op |

No implementation may assume notification or background delivery is guaranteed; the UI states the
limitations instead of promising them.

## Performance and accessibility

- No continuous/looping animations. Transitions are short and only on state change; controllers are
  disposed with their widgets.
- `const` widgets and narrow `select`-based rebuilds on the dashboard and workout runner; the rest timer
  ticks a dedicated small widget rather than rebuilding the screen.
- Respects system text scale up to at least 2.0 without clipping, honor `MediaQuery.disableAnimations`.
- Minimum 48×48 dp touch targets, semantic labels on interactive controls, no color-only status encoding.

## Error handling

Repositories convert storage failures into typed results; controllers expose an error state with a
retry action instead of swallowing exceptions. Imported plan data is validated before it can reach the
database, and validation failures are shown as a list of concrete problems, never silently ignored.

## Testing strategy

| Layer | Approach |
| --- | --- |
| Domain engines | Pure unit tests covering boundaries (first session, missed week, regression in reps, insufficient sleep, no data) |
| Data | Drift against an in-memory `NativeDatabase` — migration tests plus CRUD and integrity checks |
| Application | Controller tests with fake repositories and a fake clock |
| Widget | Focused widget tests for onboarding steps, workout runner states, and empty/error states |
| Device | Manual checklist on a physical Android phone: install, upgrade-in-place, notification delivery, reboot persistence |

Static analysis runs with a strict `analysis_options.yaml`; formatting is `dart format`. Warnings are fixed,
not suppressed.
