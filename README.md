# Robot Analytics Chart App

A Flutter application demonstrating **Clean Architecture with BLoC** for authentication and chart visualization. Uses BlocListener and BlocBuilder for reactive state management.

## Features

- **Authentication**: Splash screen, login with validation, persistent state
- **Chart Visualization**: Custom-drawn line chart with gradient fill, grid lines, axis labels
- **Data Management**: Add data via bottom sheet, duplicate date validation, real-time updates

**Login Credentials:** `Lely` / `LelyControl2`

## Architecture

### Clean Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                         UI Layer                             │
│  SplashPage │ LoginPage │ ChartPage                          │
│  AuthCubit  │ ChartCubit                                     │
│       │           │           │                              │
│       └───BlocBuilder/BlocListener───┐                       │
│                                      ▼                       │
│                               Domain States                  │
│                          (AuthState, ChartState)             │
└─────────────────────────────────────────────────────────────┘
                            │ depends on
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  Validators │ Models & States │ Repository Interfaces        │
│  AuthRepository │ ChartRepository                            │
│  No dependencies - Pure Dart code                            │
└─────────────────────────────────────────────────────────────┘
                            ▲ implements
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                              │
│  AuthRepositoryImpl │ ChartRepositoryImpl                    │
│                              │                               │
│                       SharedPreferences                      │
└─────────────────────────────────────────────────────────────┘
```

### Key Principles

1. **Standard BLoC Pattern** - Uses BlocProvider, BlocListener, and BlocBuilder for reactive UI
2. **Cubits in UI Layer** - State management logic lives close to the presentation layer
3. **Domain Validators** - Business rules live in domain layer
4. **Repository Pattern** - Data layer abstractions for testability and flexibility

### BLoC Pattern Implementation

This project follows the standard flutter_bloc pattern:

**BlocListener** - For side effects (navigation, snackbars)
```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      Navigator.pushReplacementNamed('/home');
    } else if (state is AuthError) {
      ScaffoldMessenger.showSnackBar(...);
    }
  },
  child: ...,
)
```

**BlocBuilder** - For reactive UI updates
```dart
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    final isLoading = state is AuthLoading;
    return ElevatedButton(
      onPressed: isLoading ? null : _handleLogin,
      child: isLoading ? CircularProgressIndicator() : Text('Login'),
    );
  },
)
```

### Folder Structure

```
lib/
├── app/app.dart                    # BlocProvider setup & app configuration
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── models/             # User
│   │   │   ├── validators/         # UsernameValidator
│   │   │   ├── auth_state.dart     # AuthState classes
│   │   │   └── repository/         # AuthRepository interface
│   │   ├── data/
│   │   │   └── auth_repository.dart # Repository implementation
│   │   └── ui/
│   │       ├── auth_cubit.dart     # State management
│   │       ├── splash_page.dart
│   │       └── login_page.dart
│   └── chart/
│       ├── domain/
│       │   ├── models/             # RobotDataPoint
│       │   ├── chart_state.dart    # ChartState classes
│       │   └── repository/         # ChartRepository interface
│       ├── data/
│       │   └── chart_repository_impl.dart # Repository implementation
│       └── ui/
│           ├── chart_cubit.dart    # State management
│           ├── chart_page.dart
│           └── widgets/
└── main.dart
```

## Benefits

1. **Standard BLoC Pattern** - Follows flutter_bloc best practices
2. **Automatic Subscription Management** - BlocBuilder/BlocListener handle stream cleanup
3. **Testability** - Cubits and repositories test independently
4. **Maintainability** - Clear separation between state management and UI
5. **Reactive UI** - Declarative state-driven rendering

## Testing

```bash
flutter test                         # All tests
flutter test test/features/auth/     # Auth tests only
flutter test test/features/chart/    # Chart tests only
```

**Coverage:**
- Repository tests with mocked SharedPreferences
- Validator tests (pure domain logic)
- Cubit tests with bloc_test
- Widget tests with BlocBuilder/BlocListener rendering
