import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chart_example_flutter/features/auth/data/auth_repository.dart';

import '../../helpers/test_data.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthRepositoryImpl repository;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    repository = AuthRepositoryImpl(sharedPreferences: mockSharedPreferences);
  });

  group('AuthRepository', () {
    group('login', () {
      test('should return user when credentials are correct', () async {
        when(
          () => mockSharedPreferences.setString(
            TestData.spKeyUser,
            TestData.validUsername,
          ),
        ).thenAnswer((_) async => true);

        final user = await repository.login(
          TestData.validUsername,
          TestData.validPassword,
        );

        expect(user, isNotNull);
        expect(user!.username, TestData.validUsername);
        verify(
          () => mockSharedPreferences.setString(
            TestData.spKeyUser,
            TestData.validUsername,
          ),
        ).called(1);
      });

      test('should return null when username is incorrect', () async {
        final user = await repository.login(
          TestData.invalidUsername,
          TestData.validPassword,
        );

        expect(user, isNull);
        verifyNever(() => mockSharedPreferences.setString(any(), any()));
      });

      test('should return null when password is incorrect', () async {
        final user = await repository.login(
          TestData.validUsername,
          TestData.invalidPassword,
        );

        expect(user, isNull);
        verifyNever(() => mockSharedPreferences.setString(any(), any()));
      });
    });

    group('getCurrentUser', () {
      test('should return user when logged in', () async {
        when(() => mockSharedPreferences.getString(TestData.spKeyUser))
            .thenReturn(TestData.validUsername);

        final user = await repository.getCurrentUser();

        expect(user, isNotNull);
        expect(user!.username, TestData.validUsername);
        verify(() => mockSharedPreferences.getString(TestData.spKeyUser))
            .called(1);
      });

      test('should return null when not logged in', () async {
        when(() => mockSharedPreferences.getString(TestData.spKeyUser))
            .thenReturn(null);

        final user = await repository.getCurrentUser();

        expect(user, isNull);
        verify(() => mockSharedPreferences.getString(TestData.spKeyUser))
            .called(1);
      });
    });

    group('logout', () {
      test('should clear user data', () async {
        when(() => mockSharedPreferences.remove(TestData.spKeyUser))
            .thenAnswer((_) async => true);

        await repository.logout();

        verify(() => mockSharedPreferences.remove(TestData.spKeyUser))
            .called(1);
      });
    });
  });
}
