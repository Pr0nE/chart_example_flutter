# Architecture Documentation

## Clean Architecture Overview

This project implements **Pure Clean Architecture** with strict layer separation and **zero UI dependency on BLoC/Cubit**. The UI layer depends only on domain abstractions, using native Dart Streams instead of BLoC widgets.

```
┌─────────────────────────────────────────────────────────────┐
│                         UI Layer                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ SplashPage   │  │  LoginPage   │  │  ChartPage   │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│         │                  │                  │              │
│         │   StreamBuilder  │   StreamListener │              │
│         └──────────────────┴──────────────────┘              │
│                            │                                 │
│                            ▼                                 │
│                   ┌────────────────┐                         │
│                   │  Domain IO     │ (AuthIO, ChartIO)       │
│                   │  Interfaces    │                         │
│                   └────────────────┘                         │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ depends on
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   AuthIO     │  │   ChartIO    │  │  Validators  │      │
│  │ (Interface)  │  │ (Interface)  │  │              │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ AuthRepo     │  │ ChartRepo    │  │   Models     │      │
│  │ (Interface)  │  │ (Interface)  │  │   & States   │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                               │
│  No dependencies - Pure Dart code                            │
└─────────────────────────────────────────────────────────────┘
                            ▲
                            │ implements
                            │
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  AuthRepo    │  │  ChartRepo   │  │   AuthCubit  │      │
│  │    Impl      │  │    Impl      │  │  ChartCubit  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│         │                  │                                 │
│         └──────────────────┴──────────────────┐              │
│                                                │              │
│                                                ▼              │
│                                    ┌──────────────────┐      │
│                                    │ SharedPreferences │      │
│                                    └──────────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

## Key Architectural Decisions

### 1. UI Depends Only on Domain Abstractions
- **NO BlocConsumer/BlocBuilder** - Uses `StreamBuilder` instead
- **NO direct Cubit imports** - Uses `AuthIO` and `ChartIO` interfaces
- **Stream-based state** - Native Dart `Stream<State>` pattern
- **Flexible implementation** - Can swap Cubit for any other implementation

### 2. Dependency Injection via RepositoryProvider
- No `BlocProvider` used
- All dependencies provided as interfaces via `RepositoryProvider`
- UI reads `context.read<AuthIO>()` not `context.read<AuthCubit>()`

### 3. Validators in Domain Layer
- Business rules live in domain, not data layer
- Reusable across UI and business logic layers

## Dependency Flow

```
main.dart
   │
   ├─> Initializes SharedPreferences
   │
   └─> RobotAnalyticsApp (app/app.dart)
         │
         ├─> Creates Implementations:
         │   ├─> AuthRepositoryImpl
         │   ├─> ChartRepositoryImpl
         │   ├─> AuthCubit (implements AuthIO)
         │   └─> ChartCubit (implements ChartIO)
         │
         ├─> MultiRepositoryProvider
         │   ├─> RepositoryProvider<AuthRepository>
         │   ├─> RepositoryProvider<ChartRepository>
         │   ├─> RepositoryProvider<AuthIO> (interface!)
         │   └─> RepositoryProvider<ChartIO> (interface!)
         │
         └─> MaterialApp with Routes
               │
               ├─> / → SplashPage
               ├─> /login → LoginPage
               └─> /home → ChartPage
```

## Feature: Authentication

### Domain Layer (No Dependencies)

**Models:**
- `User`: Represents authenticated user
- `AuthState`: Union type for auth states
  - `AuthInitial`
  - `AuthLoading`
  - `AuthAuthenticated(User)`
  - `AuthUnauthenticated`
  - `AuthError(String)`

**Interfaces:**
```dart
// Business Logic Interface
abstract class AuthIO {
  Stream<AuthState> get authStateStream;
  AuthState get currentState;

  Future<void> login(String username, String password);
  Future<void> logout();
  Future<void> checkAuthStatus();
}

// Data Access Interface
abstract class AuthRepository {
  Future<User?> login(String username, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
}
```

**Validators:**
```dart
class UsernameValidator {
  static bool validate(String username);
  static String? getErrorMessage(String username);
}
```

### Data Layer (Depends on Domain)

**AuthRepositoryImpl:**
- Manages SharedPreferences
- Validates credentials
- Hardcoded credentials: Lely/LelyControl2
- **Does NOT contain business validation logic**

**AuthCubit implements AuthIO:**
- Manages auth state via Cubit
- Exposes state as `Stream<AuthState>` (via `stream` property)
- Uses `UsernameValidator` from domain
- Calls `AuthRepository` for data operations
- **No manual StreamController** - uses built-in Cubit stream

### UI Layer (Depends ONLY on Domain)

**SplashPage:**
- Uses `StreamSubscription<AuthState>` to listen for navigation
- Calls `context.read<AuthIO>().checkAuthStatus()`
- Navigates based on auth state
- **Zero dependency on AuthCubit**

**LoginPage:**
- Uses `StreamBuilder<AuthState>` for UI rendering
- Uses `StreamSubscription<AuthState>` for side effects (navigation, snackbars)
- Calls `context.read<AuthIO>().login()`
- Uses `UsernameValidator` from domain for real-time validation
- **Zero dependency on AuthCubit**

## Feature: Chart

### Domain Layer (No Dependencies)

**Models:**
- `RobotDataPoint`: Contains date and minutesActive
  - Computed property: `hoursActive`
- `ChartState`: Union type for chart states
  - `ChartInitial`
  - `ChartLoading`
  - `ChartLoaded(List<RobotDataPoint>)`
  - `ChartError(String)`

**Interfaces:**
```dart
// Data Access Interface
abstract class ChartRepository {
  Future<List<RobotDataPoint>> getChartData();
  Future<void> addDataPoint(RobotDataPoint dataPoint);
  Future<bool> dateExists(DateTime date);
}

// Business Logic Interface
abstract class ChartIO {
  Stream<ChartState> get chartStateStream;
  ChartState get currentState;

  Future<void> loadChartData();
  Future<void> addDataPoint(DateTime date, int minutes);
}
```

### Data Layer (Depends on Domain)

**ChartRepositoryImpl:**
- Stores data in SharedPreferences as JSON
- Provides initial sample data
- Sorts data chronologically
- Validates duplicate dates

**ChartCubit implements ChartIO:**
- Manages chart states
- Exposes state as `Stream<ChartState>`
- On error, temporarily shows error then restores previous state
- **No manual StreamController** - uses built-in Cubit stream

### UI Layer (Depends ONLY on Domain)

**ChartPage:**
- Uses `StreamBuilder<ChartState>` for rendering
- Uses `StreamSubscription<ChartState>` for error snackbars
- Calls `context.read<ChartIO>().loadChartData()`
- Displays statistics cards
- Shows custom line chart
- **Zero dependency on ChartCubit**

**CustomLineChart (CustomPainter):**
- Calculates chart dimensions
- Draws axes and grid
- Renders gradient fill
- Draws line with data points
- Displays labels

**AddDataBottomSheet:**
- Date navigation (forward/backward)
- Minutes input with validation
- Form validation

## State Management Flow

### Authentication Flow

```
User Action: Login button pressed
     │
     ▼
UI: LoginPage calls context.read<AuthIO>().login()
     │
     ▼
Domain: AuthIO interface (implemented by AuthCubit)
     │
     ▼
Data: AuthCubit.login()
     │
     ├─> emit(AuthLoading)
     │
     ├─> validates with UsernameValidator (domain)
     │
     ├─> calls AuthRepository.login() (data)
     │
     └─> emit(AuthAuthenticated) or emit(AuthError)
           │
           ▼
     Stream<AuthState> emits new state
           │
           ▼
UI: StreamBuilder rebuilds with new state
     │
UI: StreamSubscription triggers navigation/snackbar
```

### Chart Data Flow

```
User Action: Tap "Add Data"
     │
     ▼
UI: Shows AddDataBottomSheet
     │
     ▼
User: Enters date and minutes
     │
     ▼
UI: Calls context.read<ChartIO>().addDataPoint()
     │
     ▼
Domain: ChartIO interface (implemented by ChartCubit)
     │
     ▼
Data: ChartCubit.addDataPoint()
     │
     ├─> Saves current state
     │
     ├─> checks ChartRepository.dateExists()
     │   │
     │   ├─> If exists:
     │   │   ├─> emit(ChartError)
     │   │   └─> restore previous state
     │   │
     │   └─> If not:
     │       ├─> calls ChartRepository.addDataPoint()
     │       └─> calls loadChartData()
     │
     └─> Stream<ChartState> emits new state
           │
           ▼
UI: StreamBuilder rebuilds with new state
     │
UI: StreamSubscription shows error snackbar if needed
```

## Testing Strategy

### Unit Tests
- **Repository Tests**: Test data operations without UI
  - Mocked SharedPreferences
  - Test all CRUD operations
  - No business logic validation

- **Validator Tests**: Test business rules
  - Pure domain logic
  - No dependencies
  - Fast and isolated

- **Cubit Tests**: Test state transitions
  - Use bloc_test package
  - Verify emitted states
  - Test error scenarios

### Widget Tests
- **Page Tests**: Test UI components
  - Provide domain interfaces via RepositoryProvider
  - Test with StreamBuilder rendering
  - Simulate user interactions
  - Verify UI updates

## Key Design Patterns

1. **Repository Pattern**: Abstracts data sources
2. **Stream Pattern**: Pure Dart streams for reactive state
3. **Dependency Injection**: RepositoryProvider for all dependencies
4. **Interface Segregation**: Separate interfaces for data and business logic
5. **Validator Pattern**: Reusable domain validators
6. **State Restoration**: Preserve UI state during transient errors

## Benefits of This Architecture

1. **Zero UI-Data Coupling**: UI depends only on domain abstractions
2. **Framework Independence**: Can swap BLoC/Cubit for any other solution
3. **Pure Clean Architecture**: Strict layer separation
4. **Testability**: Each layer can be tested independently
5. **Maintainability**: Changes in one layer don't affect others
6. **Scalability**: Easy to add new features
7. **Flexibility**: Can swap implementations without touching UI
8. **Clarity**: Clear separation of concerns

## Why This Is Better Than Standard BLoC

### Standard BLoC Approach ❌
```dart
// UI depends on BLoC package
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_cubit.dart'; // DATA LAYER IMPORT!

// Widget
BlocConsumer<AuthCubit, AuthState>( // Coupled to Cubit
  listener: ...,
  builder: ...,
)
```

### Our Clean Architecture Approach ✅
```dart
// UI depends only on domain
import '../domain/auth_io.dart'; // DOMAIN LAYER ONLY!

// Widget
StreamBuilder<AuthState>( // Pure Dart Streams
  stream: context.read<AuthIO>().authStateStream,
  builder: ...,
)
```

### Key Differences
| Aspect | Standard BLoC | Our Approach |
|--------|---------------|--------------|
| UI Dependency | BLoC package + Cubit | Domain interface only |
| Widgets | BlocConsumer | StreamBuilder |
| Flexibility | Locked to BLoC | Any stream implementation |
| Testing | Requires BLoC mocks | Standard Dart mocks |
| Coupling | Tight (UI→Data) | Loose (UI→Domain) |

## Implementation Checklist

When adding a new feature:

- [ ] **Domain Layer**
  - [ ] Create models/states
  - [ ] Define repository interface (data access)
  - [ ] Define IO interface (business logic)
  - [ ] Create validators if needed

- [ ] **Data Layer**
  - [ ] Implement repository (data persistence)
  - [ ] Implement IO interface (Cubit or custom)
  - [ ] Use domain validators, not local validation

- [ ] **UI Layer**
  - [ ] Use StreamBuilder for rendering
  - [ ] Use StreamSubscription for side effects
  - [ ] Call IO interface methods
  - [ ] Import only from domain layer

- [ ] **Dependency Injection**
  - [ ] Provide repository interface
  - [ ] Provide IO interface
  - [ ] Never provide concrete implementations directly

This architecture ensures maximum flexibility and adherence to Clean Architecture principles! 🎯

## Development Notes

**Architecture Design:**
The architectural concepts, patterns, and design decisions in this project are original and were not derived from or suggested by AI tools. The clean architecture approach, the IO interface pattern, the separation of concerns, and the decision to decouple UI from BLoC/Cubit implementations are all human-designed architectural choices.

**AI-Assisted Development:**
AI tools were utilized only for trivial, repetitive tasks including:
- Writing boilerplate test cases
- Generating boilerplate code for cubits and repositories
- Implementing the custom line chart with CustomPainter

The core architectural vision, design patterns, and implementation strategy remain entirely original work.
