# Robot Analytics Chart App

A Flutter application demonstrating **Pure Clean Architecture** with authentication and chart visualization. The UI depends only on domain abstractions using native Dart Streams instead of BLoC widgets.

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
│       │           │           │                              │
│       └───StreamBuilder/StreamListener───┐                   │
│                                          ▼                   │
│                                   Domain IO Interfaces       │
│                                   (AuthIO, ChartIO)          │
└─────────────────────────────────────────────────────────────┘
                            │ depends on
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  AuthIO/ChartIO Interfaces │ Validators │ Models & States    │
│  AuthRepo/ChartRepo Interfaces                               │
│  No dependencies - Pure Dart code                            │
└─────────────────────────────────────────────────────────────┘
                            ▲ implements
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                              │
│  AuthRepoImpl │ ChartRepoImpl │ AuthCubit │ ChartCubit       │
│                                     │                        │
│                              SharedPreferences               │
└─────────────────────────────────────────────────────────────┘
```

### Key Principles

1. **UI Depends Only on Domain** - NO BlocConsumer/BlocBuilder, uses `StreamBuilder` instead
2. **Interface-Based DI** - `RepositoryProvider` provides interfaces, not implementations
3. **Domain Validators** - Business rules live in domain layer
4. **Stream-Based State** - Native Dart `Stream<State>` pattern

### Why Cubits Are in Data Layer (Not UI)

**Architectural Debate:** While Cubits only depend on domain interfaces (making UI layer placement valid), this project places them in the data layer for these reasons:

1. **UI Remains Untouchable** - Switch from Cubit to Riverpod/GetX/Redux without changing UI code
2. **Easier Testing** - Test Cubits independently from Flutter widgets
3. **Reusable Across UIs** - Same Cubits can power Flutter UI, CLI apps, or web dashboards
4. **Not UI-Specific** - Cubits orchestrate data operations and business logic, not UI rendering

**Philosophy:** Cubits are implementation details of business logic (the "how"), not presentation layer (the "what to show"). They belong with repositories as data orchestrators, keeping UI purely about widgets and user interactions.

### Standard BLoC ❌ vs Our Approach ✅

```dart
// Standard BLoC - UI depends on data layer
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_cubit.dart'; // DATA LAYER IMPORT!
BlocConsumer<AuthCubit, AuthState>(...)

// Our Approach - UI depends only on domain
import '../domain/auth_io.dart'; // DOMAIN LAYER ONLY!
StreamBuilder<AuthState>(
  stream: context.read<AuthIO>().authStateStream,
  builder: ...,
)
```

### Folder Structure

```
lib/
├── app/app.dart                    # DI & app configuration
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── models/             # User, AuthState
│   │   │   ├── validators/         # UsernameValidator
│   │   │   ├── auth_io.dart        # Business logic interface
│   │   │   └── auth_repository.dart # Data access interface
│   │   ├── data/
│   │   │   ├── auth_repository_impl.dart
│   │   │   └── auth_cubit.dart     # Implements AuthIO
│   │   └── ui/
│   │       ├── splash_page.dart
│   │       └── login_page.dart
│   └── chart/
│       ├── domain/
│       │   ├── models/             # RobotDataPoint, ChartState
│       │   ├── chart_io.dart       # Business logic interface
│       │   └── chart_repository.dart # Data access interface
│       ├── data/
│       │   ├── chart_repository_impl.dart
│       │   └── chart_cubit.dart    # Implements ChartIO
│       └── ui/
│           ├── chart_page.dart
│           └── widgets/
└── main.dart
```

## Benefits

1. **Zero UI-Data Coupling** - UI depends only on domain abstractions
2. **Framework Independence** - Can swap BLoC/Cubit for any solution
3. **Testability** - Each layer tests independently
4. **Maintainability** - Changes isolated to single layer
5. **Flexibility** - Swap implementations without touching UI

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
- Widget tests with StreamBuilder rendering
