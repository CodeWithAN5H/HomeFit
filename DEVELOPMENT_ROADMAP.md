# HomeFit — Development Roadmap

Status: M0 in progress. Milestones are sequential; each ends with a verifiable artifact, not just code.

---

## Definition of done (applies to every milestone)

1. Code formatted (`dart format`) and analyzer clean (`flutter analyze`, warnings fixed not suppressed).
2. Relevant unit/widget tests written and passing (`flutter test`).
3. Manual verification recorded — what was run, on what, and what it showed.
4. `README.md`, `PROJECT_STATUS.md`, `CHANGELOG.md` and any affected design doc updated.
5. One meaningful Git commit describing the milestone.
6. Nothing reported as verified that was only written.

## Release strategy

An **installable development APK ships as soon as the foundation below exists**, rather than waiting for
the whole product:

- onboarding + editable profile
- bundled beginner exercise library
- conservative beginner strength plan
- guided session runner with rest timer
- workout history
- weight tracking
- local persistence with migrations
- Body Goal Timeline in its first rule-based form (insufficient-data state is acceptable at this point)

After that first APK, every milestone improves the same app. Updates must preserve user data: schema
changes ship with migrations and are tested by installing over the previous build.

Builds are labelled honestly: `0.x-dev` for development APKs, with a short list of known gaps in the
release notes. Incomplete features are not described as finished.

---

## M0 — Project audit and foundation *(in progress)*

- Windows 11, Git, JDK 21, VS 2022 confirmed; Flutter, Dart and the Android SDK are **missing**.
- Toolchain install proposed and awaiting approval (see `PROJECT_STATUS.md`).
- Documentation set created; repository initialized on `main`.
- **Exit criteria:** `flutter doctor` reports a working Android toolchain, `flutter create` scaffold
  committed, `flutter analyze` and `flutter test` run on an empty smoke test.

## M1 — Design system and onboarding

- Design tokens: deep charcoal/navy surfaces, blue and purple accents, typographic scale, spacing, radii,
  elevation; Material 3 `ColorScheme` plus component themes; light scheme only if it does not dilute the
  identity.
- Shared widgets: cards, primary/secondary buttons, chips, progress rings, stat tiles, empty/error/loading
  states.
- `go_router` shell with the five destinations; responsive behavior for narrow phones and tablets.
- Onboarding: ~5 short steps (profile → goals & priorities → equipment & time → diet & sleep → assessment
  intro), resumable, editable later from Settings.
- Beginner-friendly baseline assessment: no exercise forced beyond ability, "cannot do this yet" is a valid
  answer for every item.
- **Exit criteria:** onboarding persists to the database, restarting the app skips it, profile is editable,
  widget tests for the steps and a text-scale check.

## M2 — Database foundation

- Drift schema for profile/preferences/notifications/exercises, codegen, in-memory database tests,
  `schemaVersion` + migration test harness, seeded content loader with stable slugs.
- Repository implementations and Riverpod wiring.
- **Exit criteria:** data survives process restart; migration test from the previous schema version passes.

## M3 — Exercise library

- Exercise dataset with instructions, breathing, mistakes, easier/harder alternatives, safety notes,
  muscle targets, equipment.
- Original lightweight demonstration illustrations (SVG/animation) — no scraped or copyrighted media; every
  asset records licence/attribution.
- Library UI with search, filters by muscle/equipment/difficulty, and detail view showing alternatives.
- **Exit criteria:** every exercise in the plan resolves to a complete instruction record and media asset;
  a test asserts no missing references and that all content is egg-free/vegetarian where food-related.

## M4 — Workout engine

- Plan generation from profile + assessment (2–3 non-consecutive full-body sessions/week initially,
  warm-up and cool-down included, at least two rest/light days).
- Guided runner: view exercise → instructions → prescribed sets → complete set → record actual reps →
  rest timer → next set → finish → concise summary.
- Pause/resume, skip, modify reps, permitted set changes, rest controls, cancel with confirmation,
  interruption recovery.
- Progressive adaptation from actual reps, perceived effort, soreness, sleep and history; no forced
  progression; every suggestion overridable.
- Mode differentiation: scheduled, quick (5–10 min, tracked separately), recovery, targeted, skill.
- **Exit criteria:** a complete session can be recorded end-to-end; unit tests cover progression and
  regression scenarios including the 5/5/3 example; a skipped week does not inflate targets.

## M5 — Nutrition engine

- Affordable Indian vegetarian food database (milk, curd, paneer, dal, rajma, chole, soy chunks, peanuts,
  roasted chana, sattu, oats, rice, roti, seasonal fruit and vegetables) with sources and approximate
  flags; no eggs; no reliance on supplements or imported goods.
- Recipes with portions, steps, estimated kcal/protein, optional cost estimates.
- Meal planner (breakfast/lunch/snack/dinner) with replace, portion change, mark eaten.
- Hybrid logging: household portions *or* grams/millilitres.
- Ingredient-based suggestions from a user-selected pantry.
- Grocery checklist generated from the plan.
- **Exit criteria:** totals for a logged day reconcile with the underlying items in tests; a meal can be
  logged in three taps; nutrition values carry source/approximate metadata in the UI.

## M6 — Notifications and consistency

- Offline reminder scheduling: workout, breakfast, lunch, dinner, hydration, sleep, recovery, weekly weight
  check; per-category toggles, schedules, quiet hours, repeat caps.
- Stop reminders once the action is completed; smart rescheduling; boot persistence; permission
  explanation screen.
- Anti-procrastination: postponement captures a reason, then offers a quick session or candid reschedule
  instead of repeating failed reminders.
- Restart Mode after configurable inactivity (default ~7 days): welcome back without guilt, ask how they
  feel, propose a light session, ramp back to the normal schedule.
- Coaching styles (strict/friendly/balanced) and optional XP/achievements that never reward overtraining or
  skipped recovery.
- **Exit criteria:** scheduled notifications arrive on a physical device, survive reboot, stop after
  completion, and quiet hours are respected — or limitations are documented if the device blocks them.

## M7 — Progress tracking

- Weekly weight entries, monthly measurements, private local progress photos with explicit consent,
  workout statistics, strength records, weekly reports focused on trends rather than daily noise.
- Charts with accessible labels; no shaming when data is flat.
- **Body Goal Timeline:** separate goals (healthy weight development, strength, muscle, lean athletic
  physique, calisthenics skills) with conservative rule-based ranges, milestone descriptions, current
  progress, confidence level, explicit assumptions and a last-updated date. Insufficient data shows
  "Not enough information yet. Continue tracking your progress to improve this estimate." Recalculated on
  meaningful data change, not daily.
- **Exit criteria:** estimator unit tests cover insufficient-data and conflicting-signal cases; no guaranteed
  dates anywhere in the UI copy.

## M8 — AI Plan Studio

- Versioned JSON schema for workout and meal plans; paste → validate → preview → approve/edit → save.
- Validation of required fields, exercise identifiers, sets/reps, equipment, dietary restrictions,
  nutrition units; unsafe or incompatible prescriptions flagged and blocked until corrected.
- Export of plans; copyable prompt generated from the user's profile and progress.
- No AI API is required and no imported content is executed.
- **Exit criteria:** fixtures for valid, malformed, and unsafe plans produce the expected accept/flag
  results in tests.

## M9 — Data protection and polish

- Backup export/import with version validation, consequence preview, overwrite protection, photos excluded
  by default.
- Accessibility pass (screen reader labels, text scale 2.0, contrast, touch targets), performance pass
  (frame timings on mid-range hardware, no janky timers), error handling audit, offline verification with
  the network fully disabled.
- **Exit criteria:** restore round-trip test; accessibility checklist signed off; app usable entirely
  offline.

## M10 — Android release

- Application ID, icon, versioning, release signing via untracked `key.properties`.
- Universal release APK (single file, arm64 + arm + x64), installation over the previous build with data
  preserved, launch verification, log inspection, notification test on device.
- Release notes, tagged version, APK attached to the release; previous releases preserved.
- **Exit criteria:** `HomeFit.apk` installs and runs on a physical phone with existing data intact.

## Later — desktop

Windows (`HomeFit-Setup.exe`) and Linux (`HomeFit.AppImage`) builds reuse the same core with platform
service implementations. No desktop-specific work is done at the expense of the Android MVP.
