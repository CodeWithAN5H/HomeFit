# HomeFit — Project Status

Last updated: 2026-11-04

This file records what exists and what has been verified. A feature is only listed as **Tested** or
**Verified** when a command or device check actually passed.

---

## M0 environment audit

### Machine

| Item | Finding |
| --- | --- |
| OS | Microsoft Windows 11 (`10.0.26200.9711`), x64 |
| Shell used by the agent | Git Bash (POSIX syntax) |
| Free disk space on `C:` | 52 GB free of 413 GB (88% used) |
| Git | Installed (Git for Windows); global identity configured |
| Java | JDK 21.0.7 LTS available on `PATH` |
| Visual Studio | Visual Studio 2022 installed (`C:\Program Files\Microsoft Visual Studio\2022`) — sufficient for the future Windows target |
| Package manager | `winget` v1.29.380 available; no Chocolatey, no Scoop |

### Missing toolchain (blocking application work)

| Component | State | Notes |
| --- | --- | --- |
| Flutter SDK | **Not installed** (`flutter` not on `PATH`, not in common install locations) | No official winget package exists for the Flutter SDK; it is distributed as a zip from `storage.googleapis.com` |
| Dart SDK | **Not installed** standalone | Ships inside the Flutter SDK, so a separate install is unnecessary |
| Android SDK (platform-tools, build-tools, platform, cmdline-tools) | **Not installed** | `adb` not found; `ANDROID_HOME` / `ANDROID_SDK_ROOT` unset; no SDK under `%LOCALAPPDATA%\Android` |
| Android Studio | **Not installed** | Optional for this workflow: a CLI SDK + `sdkmanager` can build the APK |
| Connected Android device | **Not verified** | `adb` unavailable, so no device enumeration yet |
| Emulator / AVD | **Not installed** | Not required for an APK build, but useful for UI checks without a phone |

`winget` candidates that do exist: `Google.DartSDK` (3.13.7), `Google.AndroidStudio` (2026.2.2.8),
`Google.AndroidCLI` (1.1.16717390).

### Proposed, approval-gated install steps

Nothing in this list has been executed. Each step is a system-level change and needs explicit approval.

1. **Flutter SDK (stable)** — download the official stable Windows zip and extract to `C:\src\flutter`
   (~1.1 GB), then add `C:\src\flutter\bin` to the *user* `PATH`. Verify with `flutter --version`.
2. **Android command-line tools + SDK packages** — install `cmdline-tools;latest`, `platform-tools`,
   `build-tools`, and one stable `platforms;android-*` into `C:\Users\alfa\AppData\Local\Android\Sdk`,
   accept the SDK licences, then `flutter config --android-sdk <path>`. JDK 21 is already present.
3. *(Optional)* **Emulator system image** — only if there is no physical phone available for UI and
   notification checks (`emulator` + one `system-images;android-*;google_apis;x86_64` AVD).

No Flutter upgrade, no SDK-component change and no dependency install will happen without explaining it first.

---

## Environment-independent work completed

| Item | State |
| --- | --- |
| Repository initialized with `main` as the default branch | Done |
| `.gitignore` covering Flutter, Android, signing keys, build artifacts, `.freebuff/` | Done |
| `README.md`, `PROJECT_STATUS.md`, `ARCHITECTURE.md`, `DATABASE_SCHEMA.md`, `DEVELOPMENT_ROADMAP.md`, `CHANGELOG.md` | Done |
| Architecture, layering and schema design documented | Done |
| Flutter project scaffold (`flutter create`) | **Not started** — needs the SDK |
| Any Dart source file, test, or asset | **Not started** |
| Any build, analysis, test or device verification | **Not started** |

---

## Milestones

| ID | Milestone | Status |
| --- | --- | --- |
| M0 | Project audit and foundation | **In progress** — audit + docs + Git done; toolchain pending approval |
| M1 | Design system and onboarding | Not started |
| M2 | Database foundation (Drift, repositories, migrations) | Not started |
| M3 | Exercise library (models, dataset, demonstrations) | Not started |
| M4 | Workout engine (sessions, rest timer, adaptive progression) | Not started |
| M5 | Nutrition engine (foods, recipes, planner, logging, groceries) | Not started |
| M6 | Notifications and consistency (reminders, Restart Mode, anti-procrastination) | Not started |
| M7 | Progress tracking (weight, measurements, photos, reports, Body Goal Timeline) | Not started |
| M8 | AI Plan Studio (JSON import/export, validation, prompt generation) | Not started |
| M9 | Data protection and polish (backup/restore, accessibility, performance) | Not started |
| M10 | Android release (universal signed APK, device test, release notes) | Not started |

## Known limitations right now

- The app cannot be built, run, analyzed or tested on this machine until the toolchain is installed.
- No Android device has been detected yet, so physical-device verification (notifications, reboot
  persistence, upgrade-in-place) is unproven and cannot be claimed.
- Package versions are unpinned because the Flutter/Dart version is not yet known; pinning before that
  would risk an unresolvable dependency set.
- Notification delivery on Android is subject to battery-optimization and manufacturer restrictions.
  HomeFit will document this rather than promise guaranteed delivery.

## Standing rules for this project

- No fake buttons, no placeholder data presented as a finished feature.
- Migrations are written before data models change.
- Signing material and passwords never enter Git.
- Each milestone ends with formatting, static analysis, relevant tests, updated docs and one meaningful commit.
