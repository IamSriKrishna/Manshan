import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manshan/core/service/service_locator.dart';
import 'package:manshan/core/service/storage_service.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/core/util/usecase.dart';
import 'package:manshan/src/auth/domain/usecase/authme_usecase.dart';
import 'package:manshan/src/auth/domain/usecase/signin_usecase.dart';
import 'package:manshan/src/auth/domain/usecase/signup_usecase.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_event.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUsecase _signupUsecase;
  final SigninUsecase _signinUsecase;
  final AuthmeUsecase _authmeUsecase;

  AuthBloc({
    required this._signupUsecase,
    required this._signinUsecase,
    required this._authmeUsecase,
  }) : super(AuthState.initial()) {
    on<SignupRequestedEvent>(_onSignupRequested);
    on<SignInRequestedEvent>(_onSignInRequested);
    on<AuthMeRequestedEvent>(_onAuthMeRequested);
  }

  Future<void> _onSignupRequested(
    SignupRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    final name = event.name.trim();
    final email = event.email.trim();
    final password = event.password;

    if (name.isEmpty) {
      emit(
        state.copyWith(
          signupStatus: AuthStatus.failed,
          errorMessage: "Name is required",
        ),
      );
      return;
    }

    if (email.isEmpty) {
      emit(
        state.copyWith(
          signupStatus: AuthStatus.failed,
          errorMessage: "Email is required",
        ),
      );
      return;
    }

    if (password.length < 8) {
      emit(
        state.copyWith(
          signupStatus: AuthStatus.failed,
          errorMessage: "Password must be at least 8 characters",
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        signupStatus: AuthStatus.loading,
        message: "",
        errorMessage: "",
      ),
    );

    final result = await _signupUsecase.call(
      SignupParams(name: name, email: email, password: password),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            signupStatus: AuthStatus.failed,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        if (!response.success || response.data == null) {
          emit(
            state.copyWith(
              signupStatus: AuthStatus.failed,
              errorMessage: response.message,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            signupStatus: AuthStatus.loaded,
            user: response.data,
            message: response.message,
            errorMessage: "",
          ),
        );
      },
    );
  }

  Future<void> _onSignInRequested(
    SignInRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    final email = event.email.trim();
    final password = event.password;

    if (email.isEmpty) {
      emit(
        state.copyWith(
          signinStatus: AuthStatus.failed,
          errorMessage: "Email is required",
        ),
      );
      return;
    }

    if (password.isEmpty) {
      emit(
        state.copyWith(
          signinStatus: AuthStatus.failed,
          errorMessage: "Password is required",
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        signinStatus: AuthStatus.loading,
        message: "",
        errorMessage: "",
      ),
    );

    final result = await _signinUsecase.call(
      SigninParams(email: email, password: password),
    );

    if (result.isLeft()) {
      final failure = result.fold((failure) => failure, (_) => null);

      emit(
        state.copyWith(
          signinStatus: AuthStatus.failed,
          errorMessage: failure!.message,
        ),
      );
      return;
    }

    final response = result.fold((_) => null, (response) => response);

    if (response == null || !response.success || response.data == null) {
      emit(
        state.copyWith(
          signinStatus: AuthStatus.failed,
          errorMessage: response?.message ?? "Invalid server response",
        ),
      );
      return;
    }

    final token = response.data!;

    await sl<StorageService>().saveToken(token.accessToken);

    emit(
      state.copyWith(
        signinStatus: AuthStatus.loaded,
        token: token,
        message: response.message,
        errorMessage: "",
      ),
    );
  }

  Future<void> _onAuthMeRequested(
    AuthMeRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        authMeStatus: AuthStatus.loading,
        message: "",
        errorMessage: "",
      ),
    );

    final result = await _authmeUsecase.call(NoParams());

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            authMeStatus: AuthStatus.failed,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        if (!response.success || response.data == null) {
          emit(
            state.copyWith(
              authMeStatus: AuthStatus.failed,
              errorMessage: response.message,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            authMeStatus: AuthStatus.loaded,
            message: response.message,
            user: response.data,
            errorMessage: "",
          ),
        );
      },
    );
  }
}
