# HomeFit — Project Status

Last updated: 2026-11-05 · Version `0.1.0+1` (development)

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
| M2 | Database foundation | **Verified** — Drift schema v1 (profile + assessment), repository, mappers, FK enforcement, UTC timestamps; installed and exercised on a physical device |
| M2.2 | Profile editing and management | **Verified** — prepopulated editor, cancel, validated save into the single existing row, cleared validation feedback; 47 tests pass and the flow was exercised on the iQOO Z3 |
| M3 | Exercise library | **Verified** — 44 bundled movements with search, muscle/equipment/difficulty filters, "my equipment only", detail screens and profile-ranked alternatives; 103 tests pass, analyzer clean, exercised on the iQOO Z3 |
| M4 | Workout engine | Not started |
| M5 | Nutrition engine | Not started |
| M6 | Notifications and consistency | Not started |
| M7 | Progress tracking + Body Goal Timeline | Not started |
| M8 | AI Plan Studio | Not started |
| M9 | Backup, accessibility, performance polish | Not started |
| M10 | Android release | Not started |

## M2.1 — physical device validation (2026-11-04)

| Check | Result |
| --- | --- |
| Device | vivo **iQOO Z3** (`I2011`, device `2011`), **Android 13 / API 33**, `arm64-v8a`, 1080×2408 @ 440 dpi, adb serial `1375659727000XY`, state `device` |
| Install | `adb install -r` → **Success** (164 MB debug APK, `versionName 0.1.0`, `com.homefit.app`); first cold launch 7.5 s |
| Onboarding | All five steps completed on the phone: validation, goals/focus chips, equipment exclusivity, session slider (55 min), training time, restrictions toggle, sleep selection, reminder switch, blank optional baseline |
| Validation | `Continue` with empty fields → **“Enter your age.”** and the step is held; error clears after a successful press |
| Keyboard | Numeric keypad opens for number fields, the focused field stays visible, layout shrinks cleanly above the IME, and system Back closes the keyboard without leaving the app |
| Persistence | Profile written to the on-device SQLite file (`files/homefit.sqlite`, `user_version 1`, `integrity_check ok`, one `profile_rows` row, zero `assessment_rows`); force-stop + relaunch opened **Home** directly with identical values |
| Navigation | All five destinations open; each unfinished tab shows its explicit milestone notice |
| Back behaviour | Back from any secondary tab returns to **Home**; Back on Home exits to the launcher (fixed during this pass) |
| Logs | No crashes, no Flutter exceptions, no SQLite/Drift errors; only benign `hiddenapi ... denied` lines from Flutter's predictive-back access on API 33 |

### Defects found on hardware, and what was done

1. **Sleep option chips overflowed horizontally** (visible yellow/black overflow stripes, text clipped mid-word) at 393 dp width. **Fixed:** `SelectableChip` now lays its label out in a `Flexible` that soft-wraps; regression tests cover a long label at 320 dp and chips inside a `Wrap`. Re-verified on the phone.
2. **Android Back closed the app from every tab.** **Fixed:** `HomeShell` wraps the shell in `PopScope` — Back on a secondary tab returns to Home, Back on Home still exits. Re-verified on the phone.
3. **Sleep defaulted to “Irregular”**, so Home reported *“You reported irregular sleep”* for a choice the user never made. **Fixed:** the draft starts with no sleep pattern and step 4 requires an explicit choice; covered by unit tests. Not re-verified on hardware, because onboarding is no longer reachable on this install without wiping the saved profile.

**Known nit (not fixed):** after a failed validation the message stays visible while the user types, and only clears on the next `Continue` press.

## M2.2 — profile editing and management

### What it does

- **Edit profile** is reachable from the Home app bar (pencil) and from an `Edit` button on the *Your setup*
  card. Both push `/profile/edit`.
- The editor is one scrollable form covering age, height, weight, experience, goals, focus areas, equipment,
  session length, training time, diet restrictions, sleep and reminders — every field prepopulated from the
  saved profile via `OnboardingDraft.fromProfile`.
- Saving validates with the same rules and messages as onboarding (`OnboardingDraft.validateProfile`), writes
  through `ProfileController` into the existing `primary` row, keeps `created_at`, advances `updated_at`, then
  returns to Home with a **“Profile updated.”** snackbar.
- **Cancel** (bottom button, close icon, or Android Back) returns to Home without writing anything.
- A save failure surfaces inline (`Could not save your changes…`) and leaves the form intact.

### Validation feedback (the M2.1 nit)

Onboarding and the editor now clear a stale validation message as soon as anything is edited — text fields,
chips, the slider and the switch all route through one helper, so the old message can no longer sit under a
field the user has already corrected.

### Sleep-selection verification, without touching saved data

- `sleep` is nullable in the draft and step 4 requires it, so an unset choice cannot advance and
  `buildProfile` cannot produce a profile (throws, covered by test).
- A fresh **temporary file database** (created under the OS temp directory, deleted afterwards) saves an
  explicit sleep choice, closes, reopens and reads it back as `regular` — proving the write path, not just
  the validator.
- A widget test confirms the editor prepopulates sleep as selected; no existing profile or database was
  cleared to test this.

### Device verification (iQOO Z3, Android 13)

| Check | Result |
| --- | --- |
| Existing profile loads | Home shows 30 years · 175 cm · 70.0 kg · Beginner · 55 min · Evening with the saved goals and focus |
| Prepopulation | Age/height/weight fields carried `30`/`175`/`70.0`; selected chips matched the row exactly (Beginner, Build muscle, Stay consistent, Arms, Chest, Resistance band, Evening, 55 min, Irregular, reminders on, no restrictions) |
| Invalid input | Age `5` → **“Age must be between 13 and 99.”**, form stays open, nothing written |
| Cancel | Edited age to 44 then cancelled → Home still 30; database row unchanged (same `updated_at`, 1 row) |
| Save | Age → 31 → snackbar, Home shows 31, one row, `created_at` unchanged, `updated_at` advanced |
| Restart | `force-stop` + relaunch → Home still 31, then the original 30 was restored and re-verified |
| Back | Android Back from the editor returns to Home; Back on a secondary tab still returns Home |
| Logs | No crashes, Flutter exceptions, SQLite errors or overflow warnings |
| Database after the pass | `integrity_check ok`, **one** row, original values restored (age 30, `created_at` unchanged), 0 assessment rows |

### Defect found and fixed during this milestone

Saving wrote the data and showed the snackbar but **left the editor on screen**. Cause: the router refreshed on
*every* profile state change, so the rebuild after `saveProfile` re-pushed the editor page it had just popped.
`appRouterProvider` now refreshes only when profile *presence* changes (onboarding ↔ app). A router-level test
(`test/app/profile_edit_navigation_test.dart`) reproduces the old behaviour and fails without the fix.

## M3 — offline exercise library (2026-11-05)

### What it does

- The **Workout** tab now leads with an *Exercise library* card (44 movements with steps, form cues and
alternatives) and keeps an explicit notice that guided training arrives in M4.
- **Library** (`/workout/exercises`): search by name, muscle chips (All + seven groups), an equipment menu,
  a difficulty menu, a **My equipment only** toggle, a live *N of 44 exercises* count and a *Clear filters*
  action. The list is alphabetical and one-handed; ≥700 dp widths use a two-column grid.
- **Detail** (`/workout/exercises/:exerciseId`): icon panel, name, muscle/difficulty/equipment tags, an
equipment-compatibility card, an overview (primary, secondary, equipment, difficulty, the user's own
  experience level), numbered steps, form/safety cues, and up to four alternatives — each marked
  *Needs …* when the profile lacks the equipment.
- **Empty state** when nothing matches (with its own clear action), and a not-found state for an unknown id
  instead of a crash.

### Dataset

44 exercises as **const Dart data** in `lib/features/exercises/data/catalog/` — chest 6, back 6, shoulders 6,
arms 6, legs 8, core 7, full body 5 — merged into one read-only list. Every entry carries a lowercase slug
id, a primary muscle, optional secondary muscles, declared equipment, a difficulty, at least three steps and
at least two form cues. Nothing is fetched, parsed or decoded at runtime, so the library works offline from
the first frame and is fully unit testable.

### Profile integration

- **My equipment only** filters through `canPerformWith(profile.equipment)`; bodyweight movements never
  require equipment the user does not have.
- The detail screen states the user's experience level next to the exercise's difficulty and shows either
  *“Ready with your equipment”* or the exact missing items.
- **Alternatives** are ranked by the saved profile: primary-muscle match **+6** (otherwise a shared muscle is
  **+1**), candidate works the target's muscle as a secondary **+2**, equipment already owned **+4**,
  difficulty within the profile's level **+2**, a user focus muscle **+1**, calisthenics goal with a
  bodyweight movement **+1**. Candidates must share at least one muscle with the target; ties break by easier
  difficulty and then name. The library list itself stays alphabetical — profile ordering is only used where
  it answers a question (“what can I do instead?”).

### Tests (56 new, 103 total)

| File | Covers |
| --- | --- |
| `test/features/exercises/exercise_catalog_test.dart` | Dataset integrity (unique slug ids, ≥3 steps, ≥2 cues, honest equipment, no duplicate muscles, ≥4 per group, ≥40 total), repository lookup by id, unknown id → null, read-only catalogue, experience→difficulty mapping, difficulty ordering |
| `test/features/exercises/exercise_query_test.dart` | Search (case-insensitive, trimmed), muscle filter including secondary muscles, equipment/difficulty filters, combined filters, "my equipment only", alphabetical order, empty result, clear-all semantics |
| `test/features/exercises/exercise_alternatives_test.dart` | Alternatives never include the target, always share a muscle, prefer owned equipment, respect difficulty, apply focus and goal bonuses, cap at four, ordering |
| `test/features/exercises/exercise_library_screen_test.dart` | Library renders the full catalogue, search narrows and clears, muscle chip toggles, equipment and difficulty menus, "my equipment only", empty state + clear, count text, card → detail |
| `test/features/exercises/exercise_detail_screen_test.dart` | Detail content (tags, overview, steps, cues), compatibility banner for ready and missing equipment, alternatives list and "Needs …" marker, unknown id |
| `test/app/exercise_navigation_test.dart` | Workout tab → library → exercise detail through the real router, Back returns to the library |

### Device verification (iQOO Z3, Android 13)

| Check | Result |
| --- | --- |
| Entry point | Workout tab shows the library card (*44 movements…*) above the M4 notice; tapping it opens **Exercise library** |
| List | All 44 render, alphabetical, each card showing muscle, difficulty and equipment |
| Search | `pull` → **3 of 44** (Band face pull, Band pull-apart, Pull-up); clearing via the ✕ restores 44 |
| Muscle filter | **Chest** → **9 of 44** (primary *and* secondary chest work), "Clear filters" appears |
| My equipment only | With the profile's equipment → **21 of 44**; all visible results were bodyweight |
| Empty state | `zzz` → **0 of 44**, *No exercises match*, its own **Clear filters** button restores 44 |
| Detail | *Band chest press*: icon panel, caption, tags, *Ready with your equipment*, overview incl. *Your experience*, three steps, two cues |
| Alternatives | Knee push-up, Push-up, Incline push-up (*Needs Sturdy chair / table*), Band biceps curl |
| Back | Detail → library → Workout tab; no state loss, no crash (crash buffer empty) |
| Logs | No Flutter exceptions, no overflow warnings, no crash-buffer entries |

### Defect found and fixed during this milestone

Exercise tags overflowed their card on narrow cells: `ExerciseTag` put its label in a `Row` with no width
bound, so the text was measured unconstrained (caught by the library widget test at 800 px). The label now
sits in a `Flexible` with a single ellipsised line; the tag rows were re-checked on the device.

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
| `flutter build apk --debug` | Succeeded (14–45 s incremental) |
| `adb install -r` on iQOO Z3 | Success; app launched, onboarded, navigated, restarted and re-read from SQLite |
| `flutter test` after the device fixes | **33 tests passed** |
| `flutter test` after M2.2 | **47 tests passed** (editor, router navigation, fresh-file database, draft validation) |
| `adb install -r` + manual pass on iQOO Z3 (M2.2) | Prepopulation, invalid input, cancel, save, restart, Back and database state all checked |
| `flutter test` after M3 | **103 tests passed** (catalogue integrity, query engine, alternatives, library and detail widgets, router navigation) |
| `flutter analyze` after M3 | **No issues found** |
| `adb install -r` + manual pass on iQOO Z3 (M3) | Library entry, list, search, muscle filter, "my equipment only", empty state + clear, detail, alternatives, Back |

## Known limitations (honest list)

1. **The diet pattern itself cannot be changed.** HomeFit only plans vegetarian meals without eggs, so the
   editor shows it as fixed; only restrictions (lactose, nuts, gluten) are editable.
2. **The baseline assessment is not editable.** It is captured once during onboarding and still has no UI for
   later measurements; progress tracking (M7) owns that.
3. **No profile reset or delete.** There is no way to clear the local profile from inside the app yet.
4. **Unsaved edits are discarded on Back/Cancel without a confirmation prompt.** Deliberate for now, but it
   can lose typing.
5. **No training, nutrition, progress or coaching features.** Those tabs state this explicitly.
6. **No notifications.** The reminder *preference* is stored; nothing is scheduled, and no permission flow
   exists yet.
7. **No migration test yet.** Schema v1 is the first version, so there is nothing to migrate from; the
   migration harness arrives with schema v1→v2.
8. **Device coverage is a single phone.** Validation ran on one iQOO Z3 (Android 13, 440 dpi). Other
   densities, Android 14/15 behaviour and tablets are untested.
9. **Only the debug APK was exercised.** Release shrinking, AAB packaging and release signing remain
   unverified (M10).
10. **Accessibility is partial.** Touch targets and semantics are implemented for chips and fields, but a
    full screen-reader and 2.0× text-scale pass has not been done (M9).
11. **Signing is debug-only.** Release APK signing is deliberately a placeholder until M10.
12. **The library has no demonstration photos.** Each movement shows a generated muscle-group icon panel, and
    the detail screen says so; licensing a photo set was not part of M3.
13. **Library ordering is alphabetical only.** Profile-aware ranking is limited to alternatives; there is no
    "recommended for you" sort in the list itself.
14. **Exercises live in Dart, not in the database.** Ids are stable slugs, so M4 can store references to them,
    but moving the catalogue into seeded tables is deferred until user data actually needs it.
