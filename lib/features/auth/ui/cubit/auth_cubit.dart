import 'package:chart_example_flutter/features/auth/domain/models/user.dart';
import 'package:chart_example_flutter/features/auth/ui/cubit/auth_state.dart';
import 'package:chart_example_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState.initial());

  Future<void> checkAuthStatus() async {
    //temp
    emit(AuthState.authenticated(User(username: 'username')));
    return;

    emit(const AuthState.loading());

    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> login(String username, String password) async {
    emit(const AuthState.loading());

    try {
      final user = await _repository.login(username, password);
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.error('Invalid username or password'));
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  void clearError() {
    emit(const AuthState.unauthenticated());
  }
}
