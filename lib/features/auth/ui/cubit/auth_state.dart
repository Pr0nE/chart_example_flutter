import 'package:chart_example_flutter/features/auth/domain/models/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _AuthState;

  const AuthState._();

  bool get isAuthenticated => user != null;
  bool get hasError => errorMessage != null;
  bool get isInitial => user == null && !isLoading && errorMessage == null;
}
