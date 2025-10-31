import 'auth_state.dart';

abstract class AuthIO {
  Stream<AuthState> get authStateStream;
  AuthState get currentState;

  Future<void> login(String username, String password);
  Future<void> logout();
  Future<void> checkAuthStatus();
}
