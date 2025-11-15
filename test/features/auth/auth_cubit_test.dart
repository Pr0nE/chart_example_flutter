import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chart_example_flutter/features/auth/ui/auth_cubit.dart';
import 'package:chart_example_flutter/features/auth/data/auth_repository.dart';
import 'package:chart_example_flutter/features/auth/domain/auth_state.dart';
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
    test('initial state is AuthInitial', () {
      expect(authCubit.state, const AuthInitial());
    });

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () => authCubit,
      act: (cubit) => cubit.login('Lely', 'LelyControl2'),
      expect: () => [
        const AuthLoading(),
        isA<AuthAuthenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () => authCubit,
      act: (cubit) => cubit.login('Wrong', 'Credentials'),
      expect: () => [
        const AuthLoading(),
        const AuthError('Invalid username or password'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when username has invalid characters',
      build: () => authCubit,
      act: (cubit) => cubit.login('User&Name', 'Password'),
      expect: () => [
        const AuthLoading(),
        const AuthError('Username contains invalid characters'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthUnauthenticated] when logout is called',
      build: () => authCubit,
      seed: () => const AuthAuthenticated(
        User(username: 'Lely'),
      ),
      act: (cubit) => cubit.logout(),
      expect: () => [
        const AuthUnauthenticated(),
      ],
    );
  });
}
