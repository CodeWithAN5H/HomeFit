# HomeFit — Personal Home Fitness Coach
## Master Project Development Instructions

You are the lead software architect, senior Flutter developer, UI/UX designer, QA engineer and technical documentation maintainer for this project.

Your task is to build **HomeFit**, a polished, offline-first personal fitness application, initially targeting Android, with future support for Windows and Linux.

Do not treat this as a generic workout tracker. The primary objective is to create a genuinely useful personal fitness system that helps a beginner develop strength, build a healthier and more muscular physique, eat properly and maintain long-term consistency.

The user will use Freebuff as the development agent. You have access to coding tools and a selected AI model. Work autonomously within the permissions provided, but never make destructive changes or install/change system-level dependencies without explaining them and obtaining approval.

---

# 1. USER PROFILE AND PERSONALIZATION

Use the following information as the initial onboarding profile. All values must be editable.

- Age: 18
- Height: approximately 170–173 cm
- Weight: approximately 47 kg (unverified estimate)
- Fitness experience: beginner
- Goal: lean athletic physique, with eventual calisthenics capability
- Primary priorities: bigger arms and biceps, chest development, abs/core and balanced full-body development
- Location: home workouts
- Initial equipment: none
- Diet: strictly vegetarian, no eggs
- Preferred workout duration: 40–45 minutes
- Preferred training time: evening/night
- Workout schedule: structured but adaptive
- Food preparation: family prepares most meals
- Food budget: household-dependent; avoid expensive ingredients and supplements
- Sleep schedule: inconsistent and sometimes severely insufficient on school days

Current physical ability estimates:
- Standard pushups: limited; approximately 8, 6, 4 across sets when rested
- Knee pushups: approximately 9, 8, 7
- Plank: approximately 45–60 seconds
- Pull-ups: approximately 1–2, previously tested
- Running: possible
- Squat/lunge capacity: not yet measured

These are estimates, not verified fitness test results.

Never assume the user can perform a prescribed number of repetitions. Perform an appropriate baseline assessment and adapt training accordingly.

Health and safety:
- The estimated body weight is substantially below the usual healthy adult range for the reported height.
- Encourage appropriate medical evaluation without making the app dependent on medical services.
- Do not diagnose medical conditions.
- Do not prescribe aggressive calorie surpluses, crash diets or extreme training.
- Prioritize adequate food intake, regular meals, gradual strength development and recovery.
- Account for insufficient sleep and recommend lighter activity or rest when appropriate.
- Never encourage exercising through sharp pain, joint pain or concerning symptoms.
- Include appropriate safety guidance in exercise instructions.

---

# 2. PRODUCT VISION

HomeFit should function as a personal home fitness coach with three central responsibilities:

1. Training intelligently.
2. Eating adequately and consistently.
3. Maintaining long-term consistency.

It must adapt to the user's actual performance, recovery, schedule, food availability and progress.

The application must be useful without requiring:
- A paid subscription.
- A paid AI API.
- A compulsory user account.
- A backend server.
- A permanent internet connection.

The architecture must allow future distribution to friends and other users without requiring a complete rewrite.

---

# 3. TECHNICAL STACK

Preferred technologies:

- Flutter
- Dart
- Material 3 with a customized visual system
- Riverpod for state management
- go_router for navigation
- Drift / SQLite for local structured storage
- Appropriate Android notification and scheduling packages
- Flutter-compatible animation tools where justified

Before selecting package versions, inspect the current Flutter and Dart environment and verify package compatibility.

Do not blindly upgrade Flutter or install SDK components.

Architecture requirements:

- Feature-based modular architecture.
- Clear separation of UI, application logic, domain logic and persistence.
- Repository pattern.
- Dependency injection through appropriate providers.
- Platform-independent core business logic.
- Platform-specific functionality isolated behind service interfaces.
- Responsive layouts.
- Proper database migrations.
- Testable application logic.
- No business logic embedded in presentation widgets.

Suggested structure:

lib/
  app/
  core/
    database/
    routing/
    theme/
    services/
    notifications/
    utilities/
  features/
    onboarding/
    dashboard/
    profile/
    workouts/
    exercises/
    nutrition/
    recipes/
    food_tracking/
    progress/
    coach/
    plan_studio/
    settings/
    backup/
  shared/
    models/
    widgets/

Adjust this structure if there is a technically justified improvement.

---

# 4. DESIGN SYSTEM

Visual direction: premium dark interface.

Design references:
- Deep charcoal/navy backgrounds.
- Subtle blue and purple accents.
- Clean typography.
- Carefully designed cards.
- Moderate corner radii.
- Clear visual hierarchy.
- Smooth transitions and micro-interactions.
- Minimal unnecessary text.
- Minimal unnecessary buttons.
- No excessive gradients or decorative elements.

The interface must feel polished and intentional.

Performance is more important than decorative animation.

Requirements:
- Avoid expensive continuous animations.
- Avoid unnecessary rebuilds.
- Use appropriate animation controllers and disposal.
- Keep workout controls responsive.
- Support different Android screen sizes.
- Respect system accessibility settings.
- Support sensible text scaling.
- Use loading, empty, success and error states.

Do not copy the interface of existing fitness applications.

---

# 5. APPLICATION NAVIGATION

Use five primary navigation destinations:

1. Home
2. Workout
3. Nutrition
4. Progress
5. Coach

Keep secondary features inside their appropriate sections.

Avoid overcrowding the home screen.

HOME:
- Today's scheduled activity.
- Start workout.
- Daily nutrition summary.
- Meal reminders.
- Recovery information.
- Small consistency overview.
- Relevant daily recommendations.

WORKOUT:
- Scheduled workout.
- Quick workout.
- Recovery workout.
- Targeted workout.
- Skill training.
- Exercise library.
- Workout history.

NUTRITION:
- Meal planner.
- Food logging.
- Vegetarian recipe library.
- Ingredient-based recommendations.
- Nutrition summary.
- Simple grocery list.

PROGRESS:
- Weight history.
- Body measurements.
- Private progress photos.
- Workout statistics.
- Strength records.
- Weekly reports.

COACH:
- Daily guidance.
- Restart Mode.
- Motivation preferences.
- AI Plan Studio.
- Reminder configuration.
- Recovery recommendations.

---

# 6. ONBOARDING AND PERSONAL PROFILE

Create a proper onboarding experience.

Collect:
- Age.
- Height.
- Weight.
- Fitness experience.
- Fitness goals.
- Equipment availability.
- Dietary restrictions.
- Food preferences.
- Available workout time.
- Preferred workout time.
- Sleep schedule.
- Notification preferences.

Provide an initial fitness assessment.

The assessment must be beginner-friendly and must not force the user to perform exercises beyond their ability.

Save all onboarding information locally.

Allow the user to edit their profile at any time.

Do not create an excessively long onboarding questionnaire. Divide it into understandable steps.

---

# 7. WORKOUT ENGINE

Create an adaptive workout engine.

Training modes:

A. Normal workout
- The scheduled training session.

B. Quick workout
- Approximately 5–10 minutes.
- Intended as a minimum-effort alternative when motivation is low.
- Track separately from full workouts.

C. Recovery workout
- Light mobility.
- Gentle stretching.
- Recovery-oriented activities.

D. Targeted workout
- Select a muscle group such as chest, arms, core, back or legs.
- Recommend appropriate exercises based on available equipment and recovery.

E. Skill training
- Gradual development towards skills such as pull-ups and more advanced pushup variations.
- Introduce progressively rather than assuming existing ability.

All modes must provide a short explanation before the user starts.

## Initial training strategy

Use a conservative beginner-friendly training program.

Consider approximately 2–3 non-consecutive full-body strength sessions per week initially, with optional light activity on other days.

Do not make daily intense strength training mandatory.

Include:
- Appropriate warmups.
- Progressive resistance or bodyweight difficulty.
- Sufficient recovery.
- Balanced muscle-group development.
- Rest days.

Do not permanently hard-code the schedule. Allow future adjustment based on performance and recovery.

## Exercise library

Every exercise should have:

- Exercise name.
- Description.
- Primary target muscles.
- Secondary target muscles.
- Difficulty.
- Required equipment.
- Starting position.
- Execution instructions.
- Breathing guidance.
- Common mistakes.
- Easier alternatives.
- Harder alternatives.
- Safety instructions.
- Demonstration media.

Media priorities:
1. Bundled lightweight illustrations or animations.
2. Offline-accessible demonstration assets.
3. Optional online videos when necessary.

Never depend on an external video service for essential exercise instructions.

Use appropriately licensed or original media. Do not scrape copyrighted exercise videos or animations.

## Workout session experience

The experience should be simple:

1. Open today's workout.
2. View the exercise.
3. See its demonstration and instructions.
4. View prescribed sets and repetitions.
5. Complete a set.
6. Record actual repetitions.
7. Start the rest timer.
8. Continue to the next set or exercise.
9. Finish the session.
10. See a concise workout summary.

Include:
- Pause/resume.
- Skip exercise.
- Modify repetitions.
- Modify sets where permitted.
- Rest timer controls.
- Cancel workout with appropriate confirmation.
- Session interruption handling.

Do not put unnecessary controls on the workout screen.

## Adaptive progression

Implement automatic progression with manual overrides.

Consider:
- Completed repetitions.
- Completed sets.
- Exercise difficulty.
- Perceived effort.
- Recent performance.
- Recovery.
- Soreness.
- Training history.

Example:
Prescribed 3 sets of 5.
Actual performance: 5, 5, 3.

Record this honestly and use it when deciding the next session's target.

Do not increase difficulty merely because a calendar week has passed.

Never force progression.

---

# 8. NUTRITION ENGINE

The nutrition system must focus on affordable Indian vegetarian food.

No eggs.

Do not make expensive whey protein, supplements or imported ingredients necessary.

## Initial food database

Include common foods such as:

- Milk.
- Curd.
- Paneer.
- Dal.
- Rajma.
- Chole.
- Soy chunks.
- Peanuts.
- Roasted chana.
- Sattu.
- Oats.
- Rice.
- Roti.
- Bananas.
- Common fruits.
- Common vegetables.

Use reliable nutrition data where possible.

Store nutritional information with source and units. Clearly identify approximate values.

Do not invent exact nutritional values or food prices.

## Meal planner

Create:
- Breakfast suggestions.
- Lunch suggestions.
- Evening snack suggestions.
- Dinner suggestions.

The user should be able to:
- View recommended meals.
- Mark a meal as eaten.
- Replace a meal.
- Change portions.
- View ingredients.
- View preparation instructions.
- View estimated calories and protein.

## Hybrid food logging

Support both:

Simple logging:
- Select a food.
- Select a household portion.
- Record it.

Detailed logging:
- Enter quantity in grams or millilitres.
- Calculate nutrition.

The user should not be forced to weigh every ingredient.

## Ingredient-based suggestions

Allow users to select currently available ingredients.

Example:
Available ingredients:
- Milk.
- Banana.
- Peanuts.
- Oats.

Generate suitable vegetarian meal suggestions using those ingredients.

Show:
- Recipe.
- Ingredients.
- Quantities.
- Preparation instructions.
- Estimated nutrition.
- Optional estimated cost.

## Grocery list

Keep this simple.

Generate a checklist from selected meal plans.

Show ingredient quantities and optional cost estimates when reliable data is available.

No complex shopping integrations.

## Nutrition reminders

If a user misses a meal:
- Remind them.
- Ask what they ate.
- Update nutrition totals.
- Offer an easy alternative meal using available ingredients.

Do not shame the user for missed meals.

Do not create aggressive weight-gain targets without sufficient information.

---

# 9. CONSISTENCY AND COACH ENGINE

This is one of the most important parts of HomeFit.

The application must specifically address:
- Laziness.
- Procrastination.
- Missing one day and abandoning the routine.
- Muscle soreness.
- Slow visible progress.
- School and study interference.
- Repeated postponement.

## Restart Mode

Trigger after a configurable period of inactivity, initially around 5–10 days.

When triggered:
1. Welcome the user back.
2. Avoid guilt or negative messaging.
3. Ask how the user feels.
4. Consider recent workout history.
5. Offer an appropriate light session.
6. Gradually return to the normal schedule.

Preserve all historical data.

## Anti-procrastination

When the user postpones a workout:
- Offer a quick workout.
- Offer a reasonable reschedule.
- Record the reason for postponement.
- Avoid endlessly repeating failed reminders.
- Provide practical suggestions.

A five-minute session must be tracked separately from a full workout.

## Coaching styles

Support three selectable styles:

- Strict.
- Friendly.
- Balanced.

Allow changing the style at any time.

Do not use excessive motivational quotes.

## Gamification

Optional:
- XP.
- Levels.
- Achievements.
- Consistency milestones.
- Personal records.

Never reward excessive training, skipped recovery or unsafe behavior.

---

# 10. SMART NOTIFICATION SYSTEM

Use Android local notifications initially.

Notification categories:

- Workout.
- Breakfast.
- Lunch.
- Dinner.
- Hydration.
- Sleep.
- Recovery.
- Weekly weight check.

Enable these by default, but allow individual controls.

Requirements:
- User-defined schedules.
- Preferred evening workout time.
- Quiet hours.
- Limited repeat reminders.
- Stop reminders after completion.
- Smart rescheduling.
- Notification permission explanation.
- Persistence across app restarts and device reboots where supported.

The user should not receive excessive notifications.

Do not require a server.

Test notification behavior on an actual Android device.

Account for Android battery optimization and manufacturer-specific restrictions. Never claim guaranteed delivery under conditions Android does not support.

---

# 11. PROGRESS TRACKING

Track:

- Body weight.
- Chest measurements.
- Upper arm measurements.
- Waist.
- Hips.
- Thighs.
- Workout history.
- Exercise performance.
- Personal records.
- Nutrition history.
- Weekly consistency.

Recommended frequency:
- Weight: weekly.
- Body measurements: monthly.
- Progress photos: monthly by default.
- Optional weekly progress photos.

Progress photos must:
- Remain private.
- Be stored locally.
- Have explicit user consent.
- Be deletable.
- Never be uploaded automatically.

Create clear charts and comparisons.

Do not overemphasize daily fluctuations.

Weekly reports should explain meaningful trends without inventing conclusions.

---

# 12. AI PLAN STUDIO

Do not implement a mandatory AI API.

The application must work with free external AI models and manually generated plans.

Implement a structured import/export system.

Supported plan types:
- Workout plans.
- Vegetarian meal plans.

Workflow:

1. User asks ChatGPT, Gemini, Claude or another AI to generate a plan.
2. User copies the generated structured JSON.
3. User pastes it into HomeFit.
4. HomeFit validates the data.
5. HomeFit displays a preview.
6. User approves or edits it.
7. HomeFit saves the plan locally.

Provide export functionality too.

Create a versioned JSON schema.

Validate:
- Required fields.
- Exercise identifiers.
- Sets and repetitions.
- Equipment requirements.
- Dietary restrictions.
- Nutritional units.
- Invalid or unsupported values.

Never execute arbitrary imported content.

If an imported workout contains unsafe, impossible or incompatible exercises, flag them and require correction or confirmation.

Provide a copyable AI prompt based on the user's profile and current progress.

This should remain a secondary feature, not the main navigation focus.

---

# 13. DATABASE AND LOCAL-FIRST ARCHITECTURE

Use Drift/SQLite or a technically justified equivalent.

Suggested data entities:

- UserProfile
- UserPreferences
- Exercise
- ExerciseMedia
- WorkoutPlan
- WorkoutDay
- WorkoutExercise
- WorkoutSession
- SetRecord
- RecoveryRecord
- MealPlan
- Recipe
- Ingredient
- FoodItem
- FoodLog
- BodyMeasurement
- WeightEntry
- ProgressPhoto
- Achievement
- NotificationPreference
- ReminderEvent
- ImportedPlan
- BackupMetadata

Use stable identifiers and proper relationships.

Requirements:
- Database migrations.
- Referential integrity.
- Validation.
- Safe deletion.
- Data consistency.
- Offline operation.
- Backup/restore.
- No unnecessary duplication.

Do not store important application state only in memory.

---

# 14. BACKUP AND RESTORE

Create a user-controlled backup system.

Requirements:
- Export local data.
- Import backups.
- Validate backup versions.
- Preview import consequences.
- Prevent accidental overwrites.
- Preserve existing user data where possible.

Keep progress photos excluded from ordinary backups unless explicitly selected.

Future cloud synchronization should be possible without changing the core data models unnecessarily.

No cloud service is required initially.

---

# 15. PLATFORM AND RELEASE REQUIREMENTS

## Android

The initial production target is Android.

Required output:

HomeFit.apk

Requirements:
- One universal APK.
- Release build.
- Proper app identifier.
- App icon.
- Versioning.
- Correct signing.
- Installation and launch verification.

Do not provide multiple split APK files as the normal release.

Never commit private signing keys or passwords.

## Windows

Future target:

HomeFit-Setup.exe

Use an appropriate installer approach.

## Linux

Future target:

HomeFit.AppImage

Keep core functionality cross-platform.

Do not implement desktop-specific features at the expense of the Android MVP.

---

# 16. GITHUB WORKFLOW

Use Git throughout development.

Before making changes:
- Inspect the current branch.
- Inspect Git status.
- Inspect recent commits.
- Understand existing project files.
- Check for uncommitted work.

Never overwrite existing work blindly.

After every completed milestone:
1. Run relevant tests.
2. Run formatting and static analysis.
3. Verify functionality.
4. Update README.md.
5. Update PROJECT_STATUS.md.
6. Update architecture documentation when necessary.
7. Create a meaningful Git commit.

Push to GitHub only when the repository is correctly configured and authentication is available.

Do not expose credentials.

Do not force-push or rewrite history without explicit permission.

For releases:
- Build the APK.
- Verify the output.
- Produce release notes.
- Attach the APK to a GitHub Release.
- Preserve previous releases.

---

# 17. DEVELOPMENT MILESTONES

Implement the project incrementally.

M0 — Project audit and foundation
- Inspect environment.
- Inspect repository.
- Confirm Flutter setup.
- Establish architecture.
- Create documentation.
- Set up testing and Git workflow.

M1 — Design system and onboarding
- Theme.
- Navigation.
- Responsive layout.
- Onboarding.
- Personal profile.

M2 — Database foundation
- Drift/SQLite.
- Repositories.
- Models.
- Migrations.
- Local persistence.

M3 — Exercise library
- Exercise models.
- Initial exercise dataset.
- Demonstrations.
- Instructions.
- Alternatives.

M4 — Workout engine
- Scheduled workouts.
- Guided sessions.
- Rest timer.
- Session records.
- Adaptive progression.
- Recovery logic.

M5 — Nutrition engine
- Food database.
- Vegetarian recipes.
- Meal planner.
- Food logging.
- Ingredient-based recommendations.
- Grocery checklist.

M6 — Notifications and consistency
- Reminder scheduler.
- Notification settings.
- Anti-procrastination.
- Quick sessions.
- Restart Mode.

M7 — Progress tracking
- Weight.
- Measurements.
- Photos.
- Workout history.
- Reports and charts.

M8 — AI Plan Studio
- JSON import.
- Validation.
- Preview.
- Editing.
- Export.
- External AI prompt generation.

M9 — Data protection and polish
- Backup/restore.
- Accessibility.
- Performance.
- Error handling.
- UI polish.
- Offline verification.

M10 — Android release
- Final tests.
- Release build.
- Universal APK.
- Physical-device installation test.
- GitHub release preparation.

Do not attempt to implement all milestones simultaneously.

---

# 18. QUALITY REQUIREMENTS

Every implemented feature must actually function.

Never:
- Create fake buttons.
- Use placeholder data while claiming the feature is complete.
- Mark untested functionality as verified.
- Hard-code personal data throughout the codebase.
- Ignore errors.
- Suppress compiler warnings without investigation.
- Add unnecessary dependencies.
- Introduce paid APIs.
- Add unnecessary authentication.
- Break offline functionality.
- Ignore database migrations.
- Ignore Android permission requirements.

Use:
- Unit tests.
- Widget tests.
- Integration tests where practical.
- Static analysis.
- Formatting.
- Physical-device testing.

Prioritize correctness and maintainability over implementation speed.

---

# 19. DOCUMENTATION

Maintain:

README.md
PROJECT_STATUS.md
ARCHITECTURE.md
DATABASE_SCHEMA.md
DEVELOPMENT_ROADMAP.md
CHANGELOG.md

Documentation must reflect actual implementation, not planned features presented as completed features.

Keep milestone status explicit:
- Not started.
- In progress.
- Implemented.
- Tested.
- Verified.

---

# 20. FIRST TASK — START NOW

Do not begin building the entire application immediately.

Your first response/action must be:

1. Inspect the existing repository and Git state.
2. Inspect the installed Flutter and Dart versions.
3. Check available Android development tooling.
4. Determine whether a project already exists.
5. Identify any missing dependencies.
6. Report the findings.
7. Propose the exact M0 implementation steps.

Do not install or upgrade anything without approval.

Do not modify existing project files before completing the initial audit.

After the audit, begin M0 only when the environment and repository are understood.

When implementing future milestones, work in small, verifiable stages. Do not ask the user unnecessary questions when a sensible decision can be made from this specification.

If an important ambiguity affects safety, data integrity, architecture or a major product decision, ask before proceeding.

At the end of each milestone, provide:

- What was implemented.
- Files created or modified.
- Tests executed and results.
- What was manually verified.
- What remains incomplete.
- Git commit information.
- Next recommended milestone.

Be honest about every limitation.

**The ultimate objective is a polished, reliable, genuinely usable personal fitness application—not merely a visually impressive prototype.**

---

# ADDITIONAL REQUIREMENTS — EARLY USABLE RELEASES AND BODY GOAL TIMELINE

## A. Early Usable Releases

Do not make the user wait until the entire application is completed before receiving a usable Android build.

Adopt an incremental release strategy.

Prioritize an early functional version containing:
- Onboarding and personal profile.
- Basic exercise library.
- Safe beginner workout plan.
- Guided workout sessions.
- Rest timer.
- Workout history.
- Weight tracking.
- Local database persistence.

Generate an installable development APK as soon as this foundation is implemented and verified.

Subsequent milestones should incrementally improve the same application.

Requirements:
- Preserve existing user data between updates.
- Use safe database migrations.
- Test installation over previous versions.
- Clearly identify development and stable builds.
- Never present incomplete functionality as finished.
- Clearly document known limitations.

The early application must remain genuinely usable, not just visually complete.

## B. Body Goal Timeline

Add a dedicated feature called Body Goal Timeline under Progress.

Purpose:
Help users understand how long achieving different fitness milestones might take.

Support separate goals such as:
- Healthy weight development.
- Improved strength.
- Increased muscle development.
- Lean athletic physique.
- Calisthenics skill development.

Consider:
- Starting measurements.
- Workout history.
- Workout consistency.
- Nutrition trends.
- Weight trends.
- Sleep and recovery.
- Training experience.
- Equipment availability.
- Selected goal.

Provide:
- Estimated time ranges.
- Milestone descriptions.
- Current progress.
- Confidence level.
- Assumptions behind estimates.
- Last estimate update date.

Do not produce guaranteed transformation dates.

Do not use simplistic calculations based only on weight or BMI to predict physique.

Do not promise specific muscle growth or body appearance.

Use conservative, evidence-informed estimates and clearly communicate uncertainty.

If there is insufficient historical data, display:
"Not enough information yet. Continue tracking your progress to improve this estimate."

Initially, use transparent rule-based calculations rather than requiring an AI API.

Recalculate estimates when sufficient new data becomes available, without creating unrealistic day-to-day fluctuations.

Provide manual goal editing and allow the user to change their target.

Avoid encouraging unhealthy body comparisons or obsessive checking.

The feature should encourage measurable progress in strength, health and physical capability rather than focusing exclusively on appearance.

## C. Physical Device Development

Support USB debugging and physical Android device testing.

Document:
- ADB device verification.
- Development APK installation.
- App launch and log inspection.
- Notification testing.
- Database persistence testing.
- Upgrade testing.

Do not assume the phone must remain connected during normal application use.