class Validators {
  static const _invalidCharsPattern = r'[&^%$#@!*()]';

  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter username';
    }

    final invalidChars = RegExp(_invalidCharsPattern);
    if (invalidChars.hasMatch(value)) {
      return 'Username contains invalid characters (&, ^, %, etc.)';
    }

    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }

    return null;
  }
}
