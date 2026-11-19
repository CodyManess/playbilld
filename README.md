# Playbilld

Letterboxd for Broadway performances — built with Flutter for Android, iOS, and Web.

## Features

- **Discover (`/`)**: Curated carousels for *Now Playing*, *Upcoming Runs*, and *Top Rated Theater*.
- **Browse (`/browse`)**: Search by title, venue, creator, or cast, and filter by theater form (`Musical`, `Play`, `Opera`, `Dance`, `Other Theater`) and run status (`Now Playing`, `Upcoming`, `Closed`).
- **Diary (`/diary`)**: Chronological log of performances you've attended, including the specific run/venue, date seen, half-star rating, likes, and review notes.
- **Profile (`/profile`)**: Theatergoer stats, Watchlist, and Liked shows, plus theme settings (`/settings`).
- **Show Details (`/shows/:id`)**: Deep-linkable show pages listing all runs/venues, cast & creators, community & user reviews, and quick logging.

## Tech Stack

- **Flutter 3.47+ / Dart 3.12+** (`package:material_ui/material_ui.dart`, Material 3)
- **State Management:** Riverpod (`flutter_riverpod` + `@riverpod` code generation via `riverpod_generator`)
- **Navigation:** `go_router` with deep-linkable routes (`/`, `/settings`, `/shows/:id`)
- **Persistence:** `shared_preferences` for user theme preferences
- **Localization:** `flutter gen-l10n` using ARB files in `lib/src/localization/`

## Getting Started

```bash
flutter pub get
dart run build_runner build
flutter gen-l10n
flutter run
```

## Verification

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test --coverage
flutter build web --wasm
```

## Release Checklist

Before publishing to Google Play or the App Store:
- Replace the temporary `com.playbilld.app` application/bundle ID in `android/app/build.gradle.kts` and `ios/Runner.xcodeproj/project.pbxproj` with your final release ID.
- Configure a release signing keystore in `android/app/build.gradle.kts`.
