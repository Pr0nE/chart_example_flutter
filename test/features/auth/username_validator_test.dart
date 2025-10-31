import 'package:flutter_test/flutter_test.dart';
import 'package:chart_example_flutter/features/auth/domain/validators/username_validator.dart';

void main() {
  group('UsernameValidator', () {
    group('validate', () {
      test('should return true for valid username', () {
        expect(UsernameValidator.validate('Lely'), true);
        expect(UsernameValidator.validate('validUser123'), true);
        expect(UsernameValidator.validate('user_name'), true);
        expect(UsernameValidator.validate('user-name'), true);
      });

      test('should return false for username with invalid characters', () {
        expect(UsernameValidator.validate('user&name'), false);
        expect(UsernameValidator.validate('user^name'), false);
        expect(UsernameValidator.validate('user%name'), false);
        expect(UsernameValidator.validate('user\$name'), false);
        expect(UsernameValidator.validate('user#name'), false);
        expect(UsernameValidator.validate('user@name'), false);
        expect(UsernameValidator.validate('user*name'), false);
        expect(UsernameValidator.validate('user(name'), false);
        expect(UsernameValidator.validate('user)name'), false);
        expect(UsernameValidator.validate('user!name'), false);
      });
    });

    group('getErrorMessage', () {
      test('should return null for valid username', () {
        expect(UsernameValidator.getErrorMessage('Lely'), isNull);
        expect(UsernameValidator.getErrorMessage('validUser123'), isNull);
      });

      test('should return error message for username with invalid characters', () {
        final error = UsernameValidator.getErrorMessage('user&name');
        expect(error, isNotNull);
        expect(error, contains('invalid characters'));
      });

      test('should return error message for empty username', () {
        final error = UsernameValidator.getErrorMessage('');
        expect(error, isNotNull);
        expect(error, contains('cannot be empty'));
      });
    });
  });
}
