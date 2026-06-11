import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/auth/domain/entity/auth_token.dart';
import 'package:manshan/src/auth/domain/entity/auth_user.dart';

class AuthState {
  final AuthStatus signupStatus;
  final AuthStatus signinStatus;
  final AuthStatus authMeStatus;
  final AuthUser user;
  final AuthToken? token;
  final String message;
  final String errorMessage;

  const AuthState({
    required this.signupStatus,
    required this.signinStatus,
    required this.authMeStatus,
    required this.user,
    this.token,
    this.message = "",
    this.errorMessage = "",
  });

  factory AuthState.initial() {
    return AuthState(
      signupStatus: AuthStatus.initial,
      signinStatus: AuthStatus.initial,
      authMeStatus: AuthStatus.initial,
      user: AuthUser.initial(),
      token: null,
      message: "",
      errorMessage: "",
    );
  }

  AuthState copyWith({
    AuthStatus? signupStatus,
    AuthStatus? signinStatus,
    AuthStatus? authMeStatus,
    AuthUser? user,
    AuthToken? token,
    String? message,
    String? errorMessage,
  }) {
    return AuthState(
      signupStatus: signupStatus ?? this.signupStatus,
      signinStatus: signinStatus ?? this.signinStatus,
      authMeStatus: authMeStatus ?? this.authMeStatus,
      user: user ?? this.user,
      token: token ?? this.token,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
