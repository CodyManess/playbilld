# Playbilld AI Agent Rules

This file contains custom rules and guidelines for AI agents working in this repository. 
Whenever an agent begins a task, it will automatically read these rules to understand your preferences.

## Project Context & Tech Stack
- **Project Name:** Playbilld
- **Description:** A Flutter application.
- **Target Platforms:** Android, iOS, and Web. (We have specifically excluded Windows, macOS, and Linux desktop builds).
- **Primary Devices/Browsers:** Prioritize mobile responsive layouts for modern iOS/Android devices, and ensure compatibility with modern desktop browsers (Chrome/Safari) for the web build.
- **Tech Stack:** Flutter 3.44+, Dart 3.12+, Riverpod 3.x for state management, and GoRouter for navigation. 

## UI & Styling
- [Example] Always use Material 3 design tokens.
- [Example] Prefer `SizedBox` over `Container` for empty spacing.

## Architecture & State Management
- [Example] All new providers should use the Riverpod `@riverpod` code generation syntax (Notifier/AsyncNotifier).
- [Example] Business logic should never be placed directly in the UI widgets.

## General Coding Standards
- [Example] Prefer descriptive names over abbreviations.
- [Example] Always include trailing commas in Flutter widget trees for better auto-formatting.
