# SAHAYATA - Task Management App

SAHAYATA is a Flutter-based task management application that helps users organize their tasks efficiently. The app features a clean, intuitive interface with both list and calendar views for task management.

## Features

- ✅ Task Management
  - Add new tasks with title, description, and due date
  - Mark tasks as completed
  - Delete tasks with swipe gesture
  - View tasks in a checklist style

- 📅 Calendar Integration
  - Monthly calendar view
  - View tasks by date
  - Easy date selection for task creation

- 💾 Local Storage
  - SQLite database for persistent storage
  - Tasks remain available offline
  - Fast and efficient data management

- 📱 Platform Support
  - iOS support
  - Material Design 3
  - Responsive layout

## Getting Started

### Prerequisites

- Flutter SDK (3.x or later)
- Dart SDK
- iOS development setup (for iOS deployment)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/sahayata.git
```

2. Navigate to the project directory:
```bash
cd sahayata
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── models/          # Data models
├── widgets/         # UI components
├── providers/       # State management
├── helpers/         # Utility classes
└── main.dart        # App entry point
```

## Dependencies

- sqflite: ^2.3.2
- path: ^1.8.3
- table_calendar: ^3.0.9
- intl: ^0.19.0
- provider: ^6.1.1
- flutter_local_notifications: ^16.3.2
- shared_preferences: ^2.2.2

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- All contributors and maintainers of the packages used in this project
