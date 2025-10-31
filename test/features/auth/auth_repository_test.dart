import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chart_example_flutter/features/auth/data/auth_repository.dart';
import 'package:chart_example_flutter/features/auth/domain/repository/auth_repository.dart';

void main() {
  late AuthRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    repository = AuthRepositoryImpl(sharedPreferences: sharedPreferences);
  });

  group('AuthRepository', () {
    group('login', () {
      test('should return user when credentials are correct', () async {
        final user = await repository.login('Lely', 'LelyControl2');
        expect(user, isNotNull);
        expect(user!.username, 'Lely');
      });

      test('should return null when username is incorrect', () async {
        final user = await repository.login('WrongUser', 'LelyControl2');
        expect(user, isNull);
      });

      test('should return null when password is incorrect', () async {
        final user = await repository.login('Lely', 'WrongPassword');
        expect(user, isNull);
      });
    });

    group('getCurrentUser', () {
      test('should return user when logged in', () async {
        await repository.login('Lely', 'LelyControl2');
        final user = await repository.getCurrentUser();
        expect(user, isNotNull);
        expect(user!.username, 'Lely');
      });

      test('should return null when not logged in', () async {
        final user = await repository.getCurrentUser();
        expect(user, isNull);
      });
    });

    group('logout', () {
      test('should clear user data', () async {
        await repository.login('Lely', 'LelyControl2');
        await repository.logout();
        final user = await repository.getCurrentUser();
        expect(user, isNull);
      });
    });
  });
}
