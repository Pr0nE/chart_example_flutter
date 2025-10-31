import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/auth_io.dart';
import '../domain/auth_state.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/validators/username_validator.dart';

class AuthCubit extends Cubit<AuthState> implements AuthIO {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthInitial());

  @override
  Stream<AuthState> get authStateStream => stream;

  @override
  AuthState get currentState => state;

  @override
  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());

    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> login(String username, String password) async {
    emit(const AuthLoading());

    try {
      if (!UsernameValidator.validate(username)) {
        emit(const AuthError('Username contains invalid characters'));
        return;
      }

      final user = await _repository.login(username, password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthError('Invalid username or password'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _repository.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
