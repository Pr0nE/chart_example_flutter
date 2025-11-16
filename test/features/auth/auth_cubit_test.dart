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
      expect(authCubit.state, isA<AuthInitial>());
    });

    blocTest<AuthCubit, AuthState>(
      'emits loading then authenticated states when login succeeds',
      build: () => authCubit,
      act: (cubit) => cubit.login('Lely', 'LelyControl2'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>()
            .having((s) => s.user.username, 'username', 'Lely'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits loading then error states when login fails',
      build: () => authCubit,
      act: (cubit) => cubit.login('Wrong', 'Credentials'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>()
            .having((s) => s.message, 'message', 'Invalid username or password'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated state when logout is called',
      build: () => authCubit,
      seed: () => AuthState.authenticated(const User(username: 'Lely')),
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<AuthUnauthenticated>(),
      ],
    );

    test('clearError emits unauthenticated state', () {
      authCubit.emit(const AuthState.error('Some error'));
      authCubit.clearError();
      expect(authCubit.state, isA<AuthUnauthenticated>());
    });
  });
}
