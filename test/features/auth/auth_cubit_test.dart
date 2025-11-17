import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chart_example_flutter/features/auth/ui/cubit/auth_cubit.dart';
import 'package:chart_example_flutter/features/auth/ui/cubit/auth_state.dart';
import 'package:chart_example_flutter/features/auth/domain/models/user.dart';
import 'package:chart_example_flutter/features/auth/domain/repository/auth_repository.dart';

import '../../helpers/test_data.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthCubit authCubit;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authCubit = AuthCubit(mockAuthRepository);
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
      build: () {
        when(
          () => mockAuthRepository.login(
            TestData.validUsername,
            TestData.validPassword,
          ),
        ).thenAnswer((_) async => User(username: TestData.validUsername));
        return AuthCubit(mockAuthRepository);
      },
      act: (cubit) =>
          cubit.login(TestData.validUsername, TestData.validPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>().having(
          (s) => s.user.username,
          'username',
          TestData.validUsername,
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits loading then error states when login fails',
      build: () {
        when(
          () => mockAuthRepository.login(
            TestData.invalidUsername,
            TestData.invalidPassword,
          ),
        ).thenAnswer((_) async => null);
        return AuthCubit(mockAuthRepository);
      },
      act: (cubit) =>
          cubit.login(TestData.invalidUsername, TestData.invalidPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>().having(
          (s) => s.message,
          'message',
          TestData.invalidCredentialsError,
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated state when logout is called',
      build: () {
        when(() => mockAuthRepository.logout()).thenAnswer((_) async {});
        return AuthCubit(mockAuthRepository);
      },
      seed: () =>
          AuthState.authenticated(User(username: TestData.validUsername)),
      act: (cubit) => cubit.logout(),
      expect: () => [isA<AuthUnauthenticated>()],
    );
  });
}
