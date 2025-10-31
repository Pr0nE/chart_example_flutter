import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/user.dart';
import '../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUsername = 'username';
  static const String _validUsername = 'Lely';
  static const String _validPassword = 'LelyControl2';

  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({required this.sharedPreferences});

  @override
  Future<User?> login(String username, String password) async {
    if (username.toLowerCase() == _validUsername.toLowerCase() && password == _validPassword) {
      await sharedPreferences.setBool(_keyIsLoggedIn, true);
      await sharedPreferences.setString(_keyUsername, username);
      return User(username: username);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove(_keyIsLoggedIn);
    await sharedPreferences.remove(_keyUsername);
  }

  @override
  Future<User?> getCurrentUser() async {
    final isLoggedIn = sharedPreferences.getBool(_keyIsLoggedIn) ?? false;
    if (isLoggedIn) {
      final username = sharedPreferences.getString(_keyUsername);
      if (username != null) {
        return User(username: username);
      }
    }
    return null;
  }
}
