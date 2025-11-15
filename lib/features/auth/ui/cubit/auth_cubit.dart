import 'package:chart_example_flutter/features/auth/ui/cubit/auth_state.dart';
import 'package:chart_example_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState());

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final user = await _repository.getCurrentUser();
      emit(state.copyWith(user: user, isLoading: false, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> login(String username, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final user = await _repository.login(username, password);
      if (user != null) {
        emit(state.copyWith(user: user, isLoading: false, errorMessage: null));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Invalid username or password',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      emit(const AuthState());
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
