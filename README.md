# Robot Analytics Chart App

A Flutter application for tracking and visualizing robot activity data with authentication and clean architecture.

## Features

- **Authentication System**
  - Splash screen with automatic login detection
  - Login page with username/password validation
  - Character validation for usernames (blocks special characters like &, ^, %, etc.)
  - Persistent login state using local storage

- **Chart Visualization**
  - Custom-drawn line chart with gradient fill
  - Displays robot hours active per day (converts minutes to hours)
  - Interactive data points with statistics (average, max, min)
  - Sorted chronological data display

- **Data Management**
  - Add new data points via bottom sheet
  - Date picker with forward/backward navigation
  - Duplicate date validation
  - Real-time chart updates with loading indicators

## Architecture

This project follows **Clean Architecture** principles with three distinct layers:

### Domain Layer
- Contains business logic and models
- No dependencies on other layers
- Defines interfaces (e.g., `AuthIO`, `ChartRepository`)
- Pure Dart code

### Data Layer
- Implements repositories and data sources
- Depends only on the domain layer
- Uses Cubit for state management
- Handles data persistence with SharedPreferences

### UI Layer
- Contains all Flutter widgets and pages
- Depends only on the domain layer
- Implements BLoC pattern with Cubits
- Three main pages: Splash, Login, Chart

### Folder Structure

```
lib/
├── app/
│   └── app.dart                    # Main app configuration & DI
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── models/             # User, AuthState
│   │   │   └── auth_io.dart        # Auth interface
│   │   ├── data/
│   │   │   ├── auth_repository.dart
│   │   │   └── auth_cubit.dart
│   │   └── ui/
│   │       ├── splash_page.dart
│   │       └── login_page.dart
│   └── chart/
│       ├── domain/
│       │   ├── models/             # RobotDataPoint
│       │   └── repository/         # ChartRepository interface
│       ├── data/
│       │   ├── chart_repository_impl.dart
│       │   └── chart_cubit.dart
│       └── ui/
│           ├── chart_page.dart
│           └── widgets/
│               ├── custom_line_chart.dart
│               └── add_data_bottom_sheet.dart
└── main.dart
```

## Dependencies

- `flutter_bloc` (^8.1.6) - State management
- `equatable` (^2.0.5) - Value equality
- `shared_preferences` (^2.3.5) - Local storage
- `intl` (^0.19.0) - Date formatting
- `bloc_test` (^9.1.7) - Testing Cubits
- `mocktail` (^1.0.4) - Mocking for tests

## Getting Started

### Prerequisites

- Flutter SDK (^3.9.2)
- Dart SDK (^3.9.2)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd chart_example_flutter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

**Note for WSL/Windows users:** If you encounter line ending issues with Flutter commands, you can either:
- Run the provided setup script: `bash setup.sh`
- Or manually run: `dos2unix $(which flutter)` before running flutter commands

## Login Credentials

Use the following credentials to log in:

- **Username:** `Lely`
- **Password:** `LelyControl2`

## Sample Data

The app comes pre-loaded with sample data:
```json
{
  "Collector": {
    "10/08/2025": "100 min",
    "10/09/2025": "60 min",
    "10/10/2025": "180 min",
    "10/11/2025": "120 min",
    "10/12/2025": "90 min",
    "10/13/2025": "150 min",
    "10/14/2025": "200 min"
  }
}
```

## Testing

The project includes comprehensive unit and widget tests.

### Run all tests:
```bash
flutter test
```

### Run specific test suites:
```bash
# Auth tests
flutter test test/features/auth/

# Chart tests
flutter test test/features/chart/
```

### Test Coverage:
- Unit tests for repositories and cubits
- Widget tests for UI components
- Integration tests for user flows

## Key Implementation Details

### Custom Line Chart
The chart is drawn using Flutter's `CustomPainter` API with:
- Gradient fill from line to x-axis
- Smooth line rendering
- Interactive data points
- Dynamic scaling based on data range
- Grid lines and axis labels

### State Management
- Uses Cubit (simplified BLoC) for state management
- Reactive UI updates based on state changes
- Separation of business logic from UI

### Validation
- Real-time username validation
- Prevents invalid characters during input
- Duplicate date detection when adding data
- Form validation for all user inputs

## Project Highlights

- Clean separation of concerns
- Feature-based folder structure
- Dependency injection with BLoC providers
- Comprehensive test coverage
- Custom chart implementation (no external chart library)
- Gradient fill visualization
- Responsive UI design

## Future Enhancements

- Data export functionality
- Multiple chart types
- Date range filtering
- User profile management
- API integration
- Dark mode support

## License

This project is created for demonstration purposes.
