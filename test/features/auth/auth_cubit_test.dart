import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chart_example_flutter/features/auth/ui/cubit/auth_cubit.dart';
import 'package:chart_example_flutter/features/auth/data/auth_repository.dart';
import 'package:chart_example_flutter/features/auth/ui/cubit/auth_state.dart';
import 'package:chart_example_flutter/features/auth/domain/models/user.dart';
import 'package:chart_example_flutter/features/auth/domain/repository/auth_repository.dart';

void main() {
  late AuthCubit authCubit;
  late AuthRepository authRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    authRepository = AuthRepositoryImpl(sharedPreferences: sharedPreferences);
    authCubit = AuthCubit(authRepository);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    test('initial state is correct', () {
      expect(authCubit.state.isInitial, true);
      expect(authCubit.state.isLoading, false);
      expect(authCubit.state.errorMessage, null);
      expect(authCubit.state.user, null);
    });

    blocTest<AuthCubit, AuthState>(
      'emits loading then authenticated states when login succeeds',
      build: () => authCubit,
      act: (cubit) => cubit.login('Lely', 'LelyControl2'),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.errorMessage, 'errorMessage', null),
        isA<AuthState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isAuthenticated, 'isAuthenticated', true)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits loading then error states when login fails',
      build: () => authCubit,
      act: (cubit) => cubit.login('Wrong', 'Credentials'),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.errorMessage, 'errorMessage', null),
        isA<AuthState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorMessage, 'errorMessage', 'Invalid username or password'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated state when logout is called',
      build: () => authCubit,
      seed: () => const AuthState(user: User(username: 'Lely')),
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.user, 'user', null)
            .having((s) => s.isAuthenticated, 'isAuthenticated', false),
      ],
    );

    test('clearError removes error message', () {
      authCubit.emit(const AuthState(errorMessage: 'Some error'));
      authCubit.clearError();
      expect(authCubit.state.errorMessage, null);
    });
  });
}
