# HomeFit — Project Status

Last updated: 2026-11-04 · Version `0.1.0+1` (development)

Status vocabulary: **Not started** · **In progress** · **Implemented** (code exists) · **Tested**
(automated checks pass) · **Verified** (checked on a device or by an end-to-end run).

---

## Toolchain (resolved)

| Component | Value |
| --- | --- |
| Flutter / Dart | **3.47.8 stable / Dart 3.13.7**, existing SDK at `C:\Users\alfa\Desktop\FlowState\.tooling\flutter` — invoked by absolute path, **not** installed again and **not** added to PATH |
| Android SDK | `C:\Users\alfa\AppData\Local\Android\Sdk` — platform-tools 37.0.1, `platforms;android-36`, `build-tools;36.0.0`, all licences accepted |
| JDK | 21.0.7 (system PATH) |
| Gradle / AGP / Kotlin | wrapper 9.3.1 (`-Xmx3G`, reduced from the template's 8 GB), AGP 9.1.0, Kotlin 2.4.0 |
| Device | `I2011` · `1375659727000XY` · Android 13 (API 33) · arm64-v8a · `adb` state `device` |

The earlier interrupted setup left 2.0 GB of temporary archives and an empty `C:\src`; they were **not**
deleted (per instruction) and are not used by the project.

## Milestones

| ID | Milestone | Status |
| --- | --- | --- |
| M0 | Audit, docs, Git, toolchain | **Verified** — audit documented, repo on `main`, baseline commit `924e64b`, debug APK proven |
| M1 | Design system, navigation, onboarding, profile | **Tested** — theme, shell, 5-step onboarding with validation, profile persistence; 29 tests pass, analyzer clean |
| M2 | Database foundation | **Tested** — Drift schema v1 (profile + assessment), repository, mappers, FK enforcement, UTC timestamps |
| M3 | Exercise library | Not started |
| M4 | Workout engine | Not started |
| M5 | Nutrition engine | Not started |
| M6 | Notifications and consistency | Not started |
| M7 | Progress tracking + Body Goal Timeline | Not started |
| M8 | AI Plan Studio | Not started |
| M9 | Backup, accessibility, performance polish | Not started |
| M10 | Android release | Not started |

## What M1 actually delivers

- **Design system** (`lib/core/theme`): dark charcoal/navy palette, one blue and one violet accent, 20 dp
  cards, 14 dp fields, Material 3 component themes for app bar, navigation bar, buttons, inputs, switches,
  dividers and snackbars. No looping animations.
- **Navigation** (`lib/core/routing`, `lib/app/home_shell.dart`): `go_router` with a
  `StatefulShellRoute.indexedStack` and the five primary destinations. Onboarding is a separate route; a
  redirect sends a profile-less install to onboarding and a profiled install to Home.
- **Onboarding** (`lib/features/onboarding`): five steps — about you, goals/focus, setup, food & sleep,
  optional baseline. Validation is a pure `OnboardingDraft` (`errorForStep`) covered by unit tests.
  Input is range-checked (age 13–99, height 120–220 cm, weight 30–250 kg), and the diet is fixed to
  vegetarian without eggs.
- **Profile** (`lib/features/profile`): immutable domain model, option enums stored by name, drift-free
  mappers, `ProfileRepository` interface with a Drift implementation, Riverpod providers and a
  `ProfileController`. The profile is read before the first frame so routing never flickers.
- **Home** (`lib/features/dashboard`): greeting, saved-profile summary, and recovery guidance derived from
  the reported sleep pattern. Tabs without features show an explicit “not implemented in this build”
  notice instead of dead controls.

## What M2 actually delivers

- Drift database (`lib/core/database/app_database.dart`), `schemaVersion = 1`, `PRAGMA foreign_keys = ON`
  on every open, generated code committed (`app_database.g.dart`) so a fresh checkout builds without
  `build_runner`.
- `profile_rows` (single row, `id = 'primary'`) and `assessment_rows` (nullable measurements, cascade
  delete from the profile).
- Enum lists stored as JSON arrays of names; unknown names fall back to a safe default rather than
  throwing, so a future build can read old data.
- Timestamps normalised to UTC in the mappers (Drift stores instants as unix seconds and otherwise
  returns local time — found by a failing test and fixed).

## Verification log

| Command | Result |
| --- | --- |
| `flutter analyze` (strict-casts/inference/raw-types, generated files excluded) | **No issues found** |
| `flutter test` | **29 tests passed** — draft validation, mappers (round-trip, unknown enums, corrupt JSON), controller with fake repository, in-memory SQLite (persistence, single-row upsert, assessment ordering, empty assessment, FK rejection, enum reload), greeting boundaries, onboarding widget flow |
| `dart run build_runner build` | Drift codegen succeeded (1 generated library) |
| `flutter build apk --debug` | Succeeded — build artifact only, not installed on the device |
| `adb devices` | Device online |

## Known limitations (honest list)

1. **Profile editing is not implemented yet.** Onboarding writes the profile; re-opening it for editing is
   the next small increment. Today the only way to change answers is a fresh install/reset (no reset UI
   either).
2. **No training, nutrition, progress or coaching features.** Those tabs state this explicitly.
3. **No notifications.** The reminder *preference* is stored; nothing is scheduled, and no permission flow
   exists yet.
4. **No migration test yet.** Schema v1 is the first version, so there is nothing to migrate from; the
   migration harness arrives with schema v1→v2.
5. **No device install test.** The APK builds and the phone is connected, but the build was not installed,
   so launch behaviour on hardware is unproven.
6. **Visual check limited to widget tests.** No screenshots were taken, and Android-level rendering was not
   inspected.
7. **Accessibility is partial.** Touch targets and semantics are implemented for chips and fields, but a
   full screen-reader and 2.0× text-scale pass has not been done (M9).
8. **Signing is debug-only.** Release APK signing is deliberately a placeholder until M10.
