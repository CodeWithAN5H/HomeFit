# HomeFit — Nutrition Engine (M5)

Offline-first nutrition for an affordable Indian vegetarian diet (no eggs). Everything — food values,
recipes, plans, logs and the shopping list — works without a network, an account or a paid API.

---

## What the feature does

| Area | Behaviour |
| --- | --- |
| Nutrition tab | Transparent target range, today's logged and planned totals, per-meal plan vs log rows, entries to the planner, log, recipes and grocery list, and a safety card |
| Meal planner (`/nutrition/plan`) | Five slots (breakfast, lunch, evening snack, dinner, extra snack), day navigation, add food or recipe, change quantity, replace/remove, day totals, save a reusable plan, load or delete saved plans, generate a grocery list |
| Food log (`/nutrition/log`) | Search and log what was actually eaten per slot, edit quantity, delete with confirmation, daily calories/protein/carbs/fat, meal breakdown, previous-day navigation (no future days), targets comparison |
| Recipes (`/nutrition/recipes`) | 13 bundled recipes with search, dietary chips, per-serving estimates, ingredients, numbered method, estimate badge and "add to a meal" with a serving choice |
| Grocery (`/nutrition/grocery`) | Generate from a planned day with duplicates combined, manual items, purchased ticks, remove a line, clear with confirmation, persistent state |

Plans and logs are **separate stores**. Editing or replacing a plan never rewrites what was recorded as
eaten, and logging food never changes a plan. That separation is enforced in the schema, the domain layer and
the UI.

## Food catalogue

`lib/features/nutrition/data/catalog/foods.dart` — **55 foods**, const Dart, no loader and no network.

- Categories: grains and starches (11), dals/beans/soy (11), milk and dairy (4), nuts/seeds/chana (5),
  vegetables (12), fruits (7), prepared dishes and drinks (5); plus oils.
- Practical coverage: roti, rice (white and brown), poha, oats, rava, bread, idli, dosa, upma, khichdi;
  toor/moong/chana dal, rajma, chole, soy chunks (dry and cooked), tofu, besan, sprouts, sattu; milk, curd,
  paneer, ghee; peanuts, almonds, sunflower seeds, roasted chana, makhana; everyday vegetables and fruits;
  simple prepared snacks and drinks.
- Every entry has a **stable lowercase slug id**, nutrition per **100 g or 100 ml** (kcal, protein, carbs,
  fat), at least one **household serving preset** ("1 roti", "1 katori", "1 glass", "1 medium"), an explicit
  unit, a **state** (raw / cooked / prepared) and a **source** note.
- Raw and cooked are never blurred: dry poha and soaked poha, dry soy chunks (345 kcal/100 g) and cooked soy
  chunks (105 kcal/100 g) are separate entries with notes explaining the weight change.
- Liquids are per 100 ml and use millilitres throughout; solids use grams.

### Where the numbers come from

Values are rounded reference figures typical of **IFCT 2017** and **USDA FoodData Central**, recorded in each
entry's `source` field. They are **estimates for planning**, not laboratory analysis of the user's kitchen:
home cooking oil, portion size, brand and water content all move the real total. The UI labels every total
with an *Estimate* badge and says so on the planner, log, recipe and dashboard screens.

### Adding a food

1. Add a `FoodItem` to `kBundledFoods` with a new unique slug, a category, a state, per-100 values, at least
   one serving preset and a note when the food is dry/cooked or commonly misunderstood.
2. Run `flutter test test/features/nutrition` — integrity tests reject duplicate ids, non-slug ids, missing
   servings, negative values, implausible energy/macro mismatch and any non-vegetarian name.
3. Never change an existing id: logs and plans store it.

## Recipes

`lib/features/nutrition/data/catalog/recipes.dart` — **13 recipes** (khichdi, paneer bhurji, soya chunk
curry, chole, rajma rice, poha, oats with milk and banana, besan chilla, curd rice, sprout chaat, banana
peanut shake, paneer sandwich, sattu shake). Each has a stable id, title, description, stated servings,
preparation minutes, ingredient quantities tied to food ids, numbered steps, dietary tags (high protein,
under 20 minutes, breakfast, snack, gluten-free, lactose-free, nut-free) and a note for allergens.

Recipe nutrition is **computed from the ingredients**, never stored, so a recipe cannot quote a per-serving
number that disagrees with its ingredient list. Changing servings scales the whole ingredient list
proportionally; the planner stores a recipe item as a serving count, and the grocery generator expands it at
the planned scale.

## Targets and safety

`NutritionTargets.estimate(profile)` derives a **range** from the saved profile only:

- maintenance ≈ **30–35 kcal per kg** of the saved weight (light daily activity);
- **+200–300 kcal** only when the user's own goals include building muscle or healthy weight gain — a modest
  surplus, never a bulk;
- calories clamped to a conservative floor/ceiling (1600–4000 low, 1700–4200 high);
- protein **1.2–1.6 g/kg** (clamped 45–160 / 55–200 g), which dal, curd, paneer, soy and chana can meet
  without supplements;
- a target is **unavailable** under 18, with a message directing the user to a doctor or dietitian instead
  of an app target.

The "How this is estimated" dialog lists every assumption: the per-kg basis, any surplus, the protein basis,
that sex is not recorded (so the range stays wide), that weight is self-reported, any saved restrictions,
and that the figures are estimates for planning — **not medical or dietetic advice**. The dashboard safety
card adds that HomeFit does not diagnose from weight or BMI, does not promise a rate of weight gain, and
that food intolerance, persistent symptoms or a medical condition need professional advice. No BMI is
computed and no weight-loss or cutting target is offered.

## Storage

Schema **v3**, additive from v2 — see [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md). Five tables:
`food_log_rows`, `meal_plan_item_rows`, `saved_meal_plan_rows`, `saved_meal_plan_item_rows`,
`grocery_item_rows`.

- Days are keyed by local `yyyy-MM-dd` text (`dateKeyFor` / `dateFromKey`), so a 23:55 meal stays on the day
  it was eaten even after midnight. Impossible keys are rejected rather than silently normalised.
- Logged entries store a **nutrition snapshot** plus the food id, so a future catalogue correction cannot
  rewrite a past day; the id keeps the entry editable.
- Saved plans are templates (no date key); loading one recreates fresh item ids on the target day.
- The migration only creates tables. Existing profile, assessment and workout rows are untouched.

## Grocery generation

`GroceryPlanner.build` takes one day's plan, expands recipe items into their ingredients at
`planned servings ÷ recipe servings`, and merges lines by `foodId|unit` (so rice in two meals becomes one
line with the summed grams). Lines carry the food name, amount and unit, and are sorted by name.

Regenerating keeps manual items and preserves the checked state of generated lines; it never marks anything
purchased. Unchecking, removing and clearing are explicit user actions, and clearing asks first.

## Code map

| Layer | Files |
| --- | --- |
| Domain (pure) | `domain/food_item.dart`, `nutrition_totals.dart`, `nutrition_units.dart`, `meal_slot.dart`, `food_log.dart`, `meal_plan.dart`, `nutrition_day.dart`, `recipe.dart`, `grocery.dart`, `nutrition_targets.dart` |
| Data | `data/catalog/foods.dart`, `recipes.dart`, `food_catalogue.dart`, `recipe_catalogue.dart`, `data/nutrition_repository.dart`, `nutrition_mappers.dart` |
| Application | `application/nutrition_providers.dart` (catalogues, targets, day provider, saved plans, grocery, `NutritionActions`) |
| Presentation | `presentation/nutrition_screen.dart`, `meal_plan_screen.dart`, `food_log_screen.dart`, `recipe_library_screen.dart`, `grocery_screen.dart`, `widgets/nutrition_widgets.dart`, `widgets/food_picker.dart`, `widgets/recipe_picker.dart` |

The domain layer has no Flutter, SQL or clock imports; the repository is the only place that touches Drift,
and screens call `NutritionActions` rather than repositories.

## Tests

79 new tests (285 total). Nutrition-specific files:

| File | Covers |
| --- | --- |
| `test/features/nutrition/food_catalogue_test.dart` | 55-food/13-recipe integrity: unique slug ids, sane nutrition, household servings, raw/cooked distinction, vegetarian and egg-free, search, category filter, tag filters, ingredient references, per-serving bounds |
| `nutrition_calculations_test.dart` | Per-100 scaling, serving presets, quantity changes, liquid units, unrounded accumulation, display rounding, meal sums |
| `nutrition_targets_test.dart` | Exact range for a known profile, maintenance vs gain, calorie floor, minor → unavailable, assumption wording (self-reported, no sex, not medical, no guarantees) |
| `nutrition_date_test.dart` | Day keys, late-night boundary, round-trip, invalid dates, month/year transitions |
| `nutrition_day_test.dart` | Plan vs log totals, per-slot ordering, unknown ids contribute zero, empty day |
| `recipe_test.dart` | Ingredient sum equals total, per-serving division, 0.5/2/4-serving scaling, missing ingredients, search/tags |
| `grocery_planner_test.dart` | Duplicate merge with summed quantities, recipe expansion at planned servings, direct+recipe merge, unknown ids, alphabetical order, nothing auto-checked |
| `nutrition_repository_test.dart` | Log and plan round trips, ordering, day filtering, delete, plan/log independence, saved-plan save/load/delete cascade, grocery checked persistence |
| `nutrition_migration_test.dart` | **Real temporary file database** rewound to v2: profile and workout session survive, v3 tables work afterwards |
| `test/widget/nutrition_dashboard_test.dart` | Targets range and diet label, today card, empty plan, assumptions dialog, minor → no target, navigation |
| `test/widget/nutrition_plan_log_test.dart` | Add food with a household serving, recipe at 1.5 servings, remove item, day change, log totals, plan untouched, delete with confirmation |
| `test/widget/nutrition_recipes_test.dart` | Search, tag filter, empty state, detail content, add-to-plan with meal and serving choice, unknown id |
| `test/widget/nutrition_grocery_test.dart` | Generate with merge, manual add, tick one of two, remove, clear with confirmation, generate from an empty plan |

Widget tests run on a 400 × 900 logical surface with a real in-memory Drift database and a fixed clock.

## Device verification (iQOO Z3, Android 13)

| Check | Result |
| --- | --- |
| Upgrade in place | Debug APK installed over the existing install: profile (30 years, 180 cm, 58.0 kg, beginner, 45 min evening) and workout history intact, nutrition tables created on open, no error screen |
| Dashboard | 1940–2330 kcal, 70–93 g protein, *Vegetarian · no eggs*, 0 kcal logged, empty plan, five meal rows, recipes/grocery entries, safety card |
| Targets dialog | Listed the per-kg basis, modest surplus, no-sex-recorded, self-reported weight and "not medical" statement |
| Meal planner | Whole-wheat roti at 1 roti · 40 g → 104 kcal; khichdi at 1.5 servings → day 709 kcal / 23 g protein, per-slot estimate, remove controls |
| Food log | Banana at 1 medium · 118 g → 105 kcal, 1 g protein, 27 g carbs; meal-wise entry card; planned total stayed 709 kcal |
| Recipes | 13 recipes, search and filters; *Banana peanut shake* detail: estimate badge, 335 kcal / 13 g protein per serving, three ingredients with quantities, numbered method, milk/peanut note |
| Grocery | Generated five merged lines (ghee 6 g, mixed vegetable sabzi 113 g, moong dal 150 g, white rice 225 g, whole-wheat roti 40 g), added "Salt" manually, ticked ghee → *5 of 6 still to buy* |
| Restart | Force-stop + relaunch: 105 kcal logged, 709 kcal planned, checklist still 5 of 6 with the tick and the manual item |
| Existing features | Workout tab still shows the recovery day, modes and targeted chips; Home still shows 30 years · 180 cm · 58.0 kg · Beginner with the Edit entry |
| Logs | No Flutter exceptions, overflow warnings or crash-buffer entries during the pass |

### Defects found and fixed

1. **`ListTile` and `CheckboxListTile` inside `AppCard`** triggered Flutter's "ink may be invisible"
   assertion (the card's decorated box sat between the tile and its Material). `AppCard` now wraps its child
   in a transparent `Material`.
2. **Impossible day keys were silently normalised** (`2026-13-99` became a date in 2027). `dateFromKey` now
   validates the round trip and falls back instead of inventing a day.
3. **A new entry saved a bare quantity** ("40 g") even though the first household preset was shown. The
   amount sheet now selects the first preset, so the stored label is "1 roti".
4. **The dashboard safety-card header overflowed by 231 px** at 393 dp; the title is now in an `Expanded`.
5. **Plan and grocery name dialogs disposed their `TextEditingController` while the dialog was still
   animating out**, producing a framework "wrong build scope" failure in tests. A shared `showTextPrompt`
   dialog owns and disposes its controller.

## Known limitations

- Nutrition values are **estimates** from reference tables; there is no barcode scanning, label import or
  laboratory accuracy, and home cooking oil is the largest source of error.
- The catalogue is **55 foods and 13 recipes**. It is easy to extend in code, but there is no in-app editor,
  no custom food creation and no import.
- **No micronutrients or fibre** — calories, protein, carbs and fat only.
- **No cost data**, even though the catalogue favours affordable foods.
- **No automatic meal suggestions** beyond browsing recipes; the planner is manual.
- **Saved plans can be loaded or deleted, not renamed or edited**; loading replaces the target day's plan
  (logged food is unaffected).
- **No copy-plan-between-days** action and no weekly plan view.
- Grocery **manual items are never merged** with generated lines, and quantities are not converted between
  units (grams and millilitres stay separate).
- **Nutrition targets ignore sex and measured activity** (sex is not in the profile), so they are a wide
  range; they are not a prescription and not suitable for minors (target withheld).
- **Days are local calendar days**; travelling across time zones does not re-key existing entries.
- **No export, backup or sync** of plans, logs or the grocery list (M9 owns backup).
- The **debug APK** was exercised, not release packaging (M10).
