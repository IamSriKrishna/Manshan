import 'package:flutter_bloc/flutter_bloc.dart';

class RuleState {
  final String password;
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasSpecialChar;

  const RuleState({
    this.password = "",
    this.hasMinLength = false,
    this.hasUppercase = false,
    this.hasLowercase = false,
    this.hasSpecialChar = false,
  });

  RuleState copyWith({
    String? password,
    bool? hasMinLength,
    bool? hasUppercase,
    bool? hasLowercase,
    bool? hasSpecialChar,
  }) {
    return RuleState(
      password: password ?? this.password,
      hasMinLength: hasMinLength ?? this.hasMinLength,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasLowercase: hasLowercase ?? this.hasLowercase,
      hasSpecialChar: hasSpecialChar ?? this.hasSpecialChar,
    );
  }
}

abstract class RuleEvent {}

class PasswordChanged extends RuleEvent {
  final String password;

  PasswordChanged(this.password);
}

class RuleBloc extends Bloc<RuleEvent, RuleState> {
  RuleBloc() : super(const RuleState()) {
    on<PasswordChanged>((event, emit) {
      final password = event.password;

      emit(
        state.copyWith(
          password: password,
          hasMinLength: password.length >= 8,
          hasUppercase: RegExp(r'[A-Z]').hasMatch(password),
          hasLowercase: RegExp(r'[a-z]').hasMatch(password),
          hasSpecialChar: RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
        ),
      );
    });
  }
}