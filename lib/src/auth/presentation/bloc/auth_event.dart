abstract class AuthEvent {}

class SignupRequestedEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignupRequestedEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

class SignInRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  SignInRequestedEvent({required this.email, required this.password});
}

class AuthMeRequestedEvent extends AuthEvent {
  AuthMeRequestedEvent();
}
