import 'package:flutter_test/flutter_test.dart';
import 'package:chart_example_flutter/features/auth/domain/validators.dart';

import '../../helpers/test_data.dart';

void main() {
  group('Validators', () {
    group('usernameValidator', () {
      test('should return null for valid username', () {
        expect(Validators.usernameValidator(TestData.validUsername), isNull);
        expect(Validators.usernameValidator('validUser123'), isNull);
        expect(Validators.usernameValidator('user_name'), isNull);
        expect(Validators.usernameValidator('user-name'), isNull);
      });

      test('should return error message for username with invalid characters', () {
        expect(
          Validators.usernameValidator('user&name'),
          contains(TestData.usernameInvalidCharsError),
        );
        expect(
          Validators.usernameValidator('user^name'),
          contains(TestData.usernameInvalidCharsError),
        );
        expect(
          Validators.usernameValidator('user%name'),
          contains(TestData.usernameInvalidCharsError),
        );
        expect(
          Validators.usernameValidator('user\$name'),
          contains(TestData.usernameInvalidCharsError),
        );
        expect(
          Validators.usernameValidator('user#name'),
          contains(TestData.usernameInvalidCharsError),
        );
        expect(
          Validators.usernameValidator('user@name'),
          contains(TestData.usernameInvalidCharsError),
        );
        expect(
          Validators.usernameValidator('user*name'),
          contains(TestData.usernameInvalidCharsError),
        );
        expect(
          Validators.usernameValidator('user(name'),
          contains(TestData.usernameInvalidCharsError),
        );
        expect(
          Validators.usernameValidator('user)name'),
          contains(TestData.usernameInvalidCharsError),
        );
        expect(
          Validators.usernameValidator('user!name'),
          contains(TestData.usernameInvalidCharsError),
        );
      });

      test('should return error message for empty username', () {
        expect(
          Validators.usernameValidator(TestData.emptyUsername),
          contains(TestData.usernameEmptyError),
        );
        expect(
          Validators.usernameValidator(null),
          contains(TestData.usernameEmptyError),
        );
      });
    });

    group('passwordValidator', () {
      test('should return null for valid password', () {
        expect(Validators.passwordValidator(TestData.validPassword), isNull);
        expect(Validators.passwordValidator('anyPassword'), isNull);
      });

      test('should return error message for empty password', () {
        expect(
          Validators.passwordValidator(TestData.emptyPassword),
          contains(TestData.passwordEmptyError),
        );
        expect(
          Validators.passwordValidator(null),
          contains(TestData.passwordEmptyError),
        );
      });
    });
  });
}
