class UsernameValidator {
  static const _invalidCharsPattern = r'[&^%$#@!*()]';

  static bool validate(String username) {
    final invalidChars = RegExp(_invalidCharsPattern);
    return !invalidChars.hasMatch(username);
  }

  static String? getErrorMessage(String username) {
    if (username.isEmpty) {
      return 'Username cannot be empty';
    }

    if (!validate(username)) {
      return 'Username contains invalid characters (&, ^, %, etc.)';
    }

    return null;
  }
}
