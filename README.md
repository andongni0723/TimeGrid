<div align="center">
  <img src="assets/icon/app_icon.png" width="54px" alt="TimeGrid App Icon" />
  <h1>TimeGrid</h1>
</div>

<p align="center">
  <a href="https://deepwiki.com/andongni0723/TimeGrid">
    <img src="https://deepwiki.com/badge.svg" alt="Ask DeepWiki">
  </a>
  <a href="https://github.com/andongni0723/TimeGrid/actions/workflows/flutter-ci.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/andongni0723/TimeGrid/flutter-ci.yml?branch=main&label=CI" alt="CI" />
  </a>
  <a href="https://github.com/andongni0723/TimeGrid/releases">
    <img src="https://img.shields.io/github/v/release/andongni0723/TimeGrid?label=Release" alt="Release" />
  </a>
</p>

<p align="center">
  A Flutter class schedule app focused on fast editing, local persistence, and Android home widget support.
</p>

<p align="center">
  <img src="assets/readme-imgs/Screenshot_20260308_182535.png" width="32%" alt="TimeGrid screenshot" />
</p>

## Features
- Weekly schedule grid with adjustable days and periods.
- Drag, move, and resize course blocks in edit mode.
- Reusable course chips for quick course and room presets.
- Editable time cells (title, start/end time, and visibility options).
- Import and export schedule data as JSON for backup and migration.
- Android home widget (`Next Course`) for upcoming classes.
- In-app update prompt based on the latest GitHub release.

## Tech Stack
- **Dart**: Main programming language.
- **Flutter (Material 3)**: Cross-platform UI framework.
- **Riverpod**: State management and dependency wiring.
- **Hive**: Local persistent storage for courses, chips, settings, and time cells.
- **Freezed + json_serializable**: Immutable data models and serialization.
- **Android Glance + MethodChannel**: Home widget integration and updates.

## Getting Started
1. Install Flutter SDK (stable channel).
2. Install dependencies:

```bash
flutter pub get
```

3. Run on emulator/device:

```bash
flutter run
```

4. Build Android release APK:

```bash
flutter build apk --release --split-per-abi
```

Get the latest package in [Releases](https://github.com/andongni0723/TimeGrid/releases/latest).
