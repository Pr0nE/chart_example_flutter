import 'package:flutter_test/flutter_test.dart';
import 'package:chart_example_flutter/features/auth/domain/validators.dart';

void main() {
  group('Validators', () {
    group('usernameValidator', () {
      test('should return null for valid username', () {
        expect(Validators.usernameValidator('Lely'), isNull);
        expect(Validators.usernameValidator('validUser123'), isNull);
        expect(Validators.usernameValidator('user_name'), isNull);
        expect(Validators.usernameValidator('user-name'), isNull);
      });

      test('should return error message for username with invalid characters', () {
        expect(Validators.usernameValidator('user&name'), contains('invalid characters'));
        expect(Validators.usernameValidator('user^name'), contains('invalid characters'));
        expect(Validators.usernameValidator('user%name'), contains('invalid characters'));
        expect(Validators.usernameValidator('user\$name'), contains('invalid characters'));
        expect(Validators.usernameValidator('user#name'), contains('invalid characters'));
        expect(Validators.usernameValidator('user@name'), contains('invalid characters'));
        expect(Validators.usernameValidator('user*name'), contains('invalid characters'));
        expect(Validators.usernameValidator('user(name'), contains('invalid characters'));
        expect(Validators.usernameValidator('user)name'), contains('invalid characters'));
        expect(Validators.usernameValidator('user!name'), contains('invalid characters'));
      });

      test('should return error message for empty username', () {
        expect(Validators.usernameValidator(''), contains('Please enter username'));
        expect(Validators.usernameValidator(null), contains('Please enter username'));
      });
    });

    group('passwordValidator', () {
      test('should return null for valid password', () {
        expect(Validators.passwordValidator('password123'), isNull);
        expect(Validators.passwordValidator('anyPassword'), isNull);
      });

      test('should return error message for empty password', () {
        expect(Validators.passwordValidator(''), contains('Please enter password'));
        expect(Validators.passwordValidator(null), contains('Please enter password'));
      });
    });
  });
}
