# TaskManager Flutter App

## Overview

TaskManager is a cross-platform Flutter application for managing daily tasks. It supports adding, editing, deleting, searching, and marking tasks as complete, with persistent storage and a modern, responsive UI that supports both light and dark modes.

## Features

- Task list with title, description, due date, and priority
- Add, edit, and delete tasks
- Mark tasks as complete/incomplete
- Search tasks by title or description
- Overdue task highlighting
- Priority color coding (High/Medium/Low)
- Local data persistence using SQflite
- State management with Riverpod
- Manual dark/light mode toggle (persistent)
- Responsive and accessible UI
- Error handling and loading indicators

## Architecture

The app uses a feature-based architecture with clear separation of concerns:

- **UI Layer**: All screens and widgets are in `lib/screens/`.
- **State Management**: [Riverpod](https://riverpod.dev/) is used for all app state, with providers in `lib/providers/`.
- **Data Layer**: All database logic is in `lib/services/database_service.dart`, using SQflite for local persistence.
- **Models**: Data models are in `lib/models/`.

### State Management

- The app uses a `TaskListNotifier` (a Riverpod StateNotifier) to manage the list of tasks, including loading and error states.
- Theme mode is managed by a `ThemeModeNotifier`, which persists the user's choice using `shared_preferences`.

### Error Handling

- All database operations are wrapped in try/catch blocks.
- Loading and error states are surfaced to the UI for user feedback.

### UI/UX

- The UI is responsive and adapts to dark/light mode.
- Loading indicators and error messages are shown as appropriate.
- Overdue tasks and priorities are clearly marked.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart 3.9+

### Installation

1. Clone the repository:
	```sh
	git clone <your-repo-url>
	cd taskmanager
	```
2. Install dependencies:
	```sh
	flutter pub get
	```
3. Run the app:
	```sh
	flutter run
	```

### Apk FIle
link to apk; https://drive.google.com/file/d/1PUGu0-pP2oTXpoKUgfcdG-1o1GtEWT2O/view?usp=sharing

### Directory Structure

```
lib/
  models/           # Data models (Task)
  providers/        # Riverpod providers (state management, theme)
  screens/          # UI screens (task list, add/edit, detail)
  services/         # Database service (SQflite)
  main.dart         # App entry point
```

## Usage

- Tap the **+** button to add a new task.
- Tap a task to view details or edit.
- Long-press or use the delete icon to remove a task.
- Use the search bar to filter tasks.
- Tap the sun/moon icon to toggle dark/light mode (your choice is saved).

## Code Quality

- Clean, readable code with consistent naming conventions.
- Business logic is separated from UI components.
- Error handling and loading states are implemented.
- Comments are provided for complex logic.

## Dependencies

- [Flutter](https://flutter.dev/)
- [Riverpod](https://pub.dev/packages/flutter_riverpod)
- [SQflite](https://pub.dev/packages/sqflite)
- [Path](https://pub.dev/packages/path)
- [Path Provider](https://pub.dev/packages/path_provider)
- [Intl](https://pub.dev/packages/intl)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)

## License

MIT

## Credits

Developed by Abdoul. Inspired by best practices in Flutter app architecture and state management.
