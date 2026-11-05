# HomeFit — Exercise Library (M3)

Status: **implemented, tested (56 library tests, 103 in total) and exercised on a physical iQOO Z3.**
Nothing in this feature touches the network, the database or an asset bundle; the whole library ships inside
the app binary.

---

## What the user sees

| Where | What |
| --- | --- |
| Workout tab | *Exercise library* card — “44 movements with steps, form cues and alternatives. Works offline.” |
| `/workout/exercises` | Search field, muscle chips (All, Chest, Back, Shoulders, Arms, Legs, Core, Full body), an equipment menu, a difficulty menu, a **My equipment only** toggle, a live *N of 44 exercises* count and a *Clear filters* action. |
| `/workout/exercises/:exerciseId` | Icon panel, name, muscle/difficulty/equipment tags, an equipment-compatibility card, an overview (primary muscle, secondary muscles, equipment, difficulty, the user's own experience level), numbered steps, form & safety cues, and up to four alternatives. |
| Empty / unknown | *No exercises match* with a clear action; an unknown id gets a not-found message instead of a crash. |

The list is **alphabetical**, a single column on phones and a two-column grid from 700 dp upwards. Search is
trimmed and case-insensitive and matches the name only — a filter suite that silently searched form cues
would hide why a movement matched.

## Where the data lives

```
lib/features/exercises/
  data/
    catalog/chest.dart     back.dart   shoulders.dart   arms.dart
    catalog/legs.dart      core.dart   full_body.dart
    exercise_catalog.dart        # merges the seven lists into one unmodifiable list
    exercise_repository.dart     # BundledExerciseRepository: all(), byId()
  domain/
    exercise.dart                # Exercise, MuscleGroup, ExerciseDifficulty
    exercise_query.dart          # ExerciseFilter, ExerciseAlternative, ExerciseQuery
  application/exercise_providers.dart
  presentation/                  # library screen, detail screen, card, visual panel
```

Why const Dart data rather than JSON in `assets/` or seeded SQLite rows:

- **No loading state.** The catalogue is available before the first frame, so there is no spinner, no error
  branch and nothing to go wrong offline.
- **Testable as data.** Dataset integrity (unique ids, step counts, honest equipment) is a plain unit test
  with no fixture loader.
- **Cheap to change.** Adding a movement is one `const Exercise(...)` entry; a wrong step count fails the
  test suite immediately.

Ids are lowercase hyphenated slugs (`band-chest-press`). They are the stable key M4 will store in workout
history, so an exercise may gain steps or cues but must never be renamed by id. The catalogue itself is
wrapped in `List.unmodifiable`, which a test asserts.

## Model

`Exercise` (`lib/features/exercises/domain/exercise.dart`):

| Field | Notes |
| --- | --- |
| `id` | slug, unique, stable |
| `name` | displayed name |
| `primaryMuscle` | one `MuscleGroup` |
| `secondaryMuscles` | zero or more, never repeating the primary (enforced by test) |
| `equipment` | `EquipmentItem` list; bodyweight movements list exactly `bodyweight` |
| `difficulty` | `beginner` / `intermediate` / `advanced`, with a `rank` for ordering |
| `steps` | ≥ 3 ordered instructions |
| `formCues` | ≥ 2 safety/technique notes |

Derived behaviour: `isBodyweight`, `canPerformWith(owned)` (always true for bodyweight-only work),
`equipmentLabel` (“No equipment” or the ownership labels joined with “ + ”), `missingFor(owned)`, `targets()`
(primary **or** secondary) and `allMuscles`.

`EquipmentItem` is reused from the profile feature, so “the user owns a resistance band” and “this movement
needs a resistance band” are literally the same type. `ExerciseDifficulty.fromExperience` maps beginner and
returning to beginner and intermediate to intermediate.

## Query engine

`ExerciseQuery.apply` is pure: search → muscle (primary or secondary) → exact equipment requirement → exact
difficulty → *my equipment only* → alphabetical sort. `ExerciseFilter` is immutable; its `copyWith` uses a
private sentinel so `null` can clear a nullable field, and `hasAnyFilter` drives the clear action.

`ExerciseQuery.alternativesFor` answers “what else trains this area?”:

| Signal | Weight |
| --- | --- |
| Same primary muscle as the target | +6 |
| Any other shared muscle (required for candidacy) | +1 |
| Works the target's primary muscle as a secondary | +2 |
| Equipment the profile already owns | +4 |
| Difficulty within the profile's level | +2 |
| Movement trains a profile focus area | +1 |
| Calisthenics goal and a bodyweight movement | +1 |

Candidates that need unavailable equipment are **kept** but rank below ready ones, and the card says
*Needs …* rather than hiding the option. Ties break by easier difficulty, then name; the default limit is 4.
The target itself is never suggested.

## Profile integration

| Profile field | Effect |
| --- | --- |
| `experience` | Shown as *Your experience* on the detail screen and used as the difficulty ceiling for alternative scoring |
| `equipment` | Drives **My equipment only**, the compatibility card and the *Needs …* markers |
| `goals` | Calisthenics goal boosts bodyweight alternatives |
| `priorities` (focus areas) | Boosts alternatives that train a focus muscle |

The library list is never reordered by the profile — stable muscle-based browsing matters more than ranking,
and profile ordering is applied where it actually answers a question.

## Tests

| File | Focus |
| --- | --- |
| `test/features/exercises/exercise_catalog_test.dart` | Slug ids unique, ≥ 3 steps and ≥ 2 non-empty cues, honest equipment declarations, primary not repeated in secondary, ≥ 4 movements per muscle group, ≥ 40 total, bodyweight/band representation, repository lookup, unknown id → null, unmodifiable list, difficulty mapping and ordering |
| `test/features/exercises/exercise_query_test.dart` | Search (case-insensitive, trimmed, name-only), muscle filter incl. secondary muscles, equipment and difficulty filters, combined filters, *my equipment only*, alphabetical ordering, zero matches, clearing |
| `test/features/exercises/exercise_alternatives_test.dart` | Excludes the target, requires shared muscle, prefers owned equipment, respects difficulty, applies focus and goal bonuses, limit, ordering |
| `test/features/exercises/exercise_library_screen_test.dart` | Full catalogue renders, search narrows and clears, chip toggles, menus, *my equipment only*, empty state and its clear action, count text, card → detail |
| `test/features/exercises/exercise_detail_screen_test.dart` | Tags, overview, steps, cues, ready/missing compatibility banners, alternatives and *Needs …*, unknown id |
| `test/app/exercise_navigation_test.dart` | Workout → library → detail through the real router, Back returns to the library |

Widget tests that assert on content far down the detail screen set a tall `tester.view.physicalSize`, because
the detail page is a lazy `ListView` and off-screen sections do not exist in the tree.

## Adding a movement

1. Add a `const Exercise(...)` to the file for its primary muscle in `data/catalog/`.
2. Use a new lowercase slug id; never reuse or rename an existing one.
3. Give it at least three ordered steps and two sincere form/safety cues — the catalogue test enforces both.
4. If it needs equipment, list exactly that equipment and do **not** include `bodyweight`; if it needs
   nothing, list only `bodyweight`.
5. Run `dart format`, `flutter analyze` and `flutter test`. The integrity tests fail loudly if the entry is
   incomplete, and the UI picks it up with no further change.

## Limitations

1. **No photographs.** Visuals are generated icon panels per muscle group; the detail screen states that no
   demonstration photo is licensed yet.
2. **No progression data.** Sets, reps and load ranges belong to the M4 workout engine.
3. **No favourites or custom exercises.** The catalogue is read-only; user-authored movements are not planned
   for M3.
4. **Search covers names only**, by design.
5. **No tablet/landscape pass beyond the ≥ 700 dp grid.** Verification ran on one phone.
