import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chart_example_flutter/features/auth/ui/cubit/auth_cubit.dart';
import 'package:chart_example_flutter/features/auth/ui/cubit/auth_state.dart';
import 'package:chart_example_flutter/features/auth/domain/models/user.dart';
import 'package:chart_example_flutter/features/auth/domain/repository/auth_repository.dart';

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
          () => mockAuthRepository.login('Lely', 'LelyControl2'),
        ).thenAnswer((_) async => const User(username: 'Lely'));
        return AuthCubit(mockAuthRepository);
      },
      act: (cubit) => cubit.login('Lely', 'LelyControl2'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>().having(
          (s) => s.user.username,
          'username',
          'Lely',
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits loading then error states when login fails',
      build: () {
        when(
          () => mockAuthRepository.login('Wrong', 'Credentials'),
        ).thenAnswer((_) async => null);
        return AuthCubit(mockAuthRepository);
      },
      act: (cubit) => cubit.login('Wrong', 'Credentials'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>().having(
          (s) => s.message,
          'message',
          'Invalid username or password',
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated state when logout is called',
      build: () {
        when(() => mockAuthRepository.logout()).thenAnswer((_) async {});
        return AuthCubit(mockAuthRepository);
      },
      seed: () => AuthState.authenticated(const User(username: 'Lely')),
      act: (cubit) => cubit.logout(),
      expect: () => [isA<AuthUnauthenticated>()],
    );
  });
}
