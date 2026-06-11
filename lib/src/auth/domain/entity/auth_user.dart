class AuthUser {
  final int id;
  final String name;
  final String email;
  final bool isActive;
  final String createdAt;

  const AuthUser({
    this.id = 0,
    this.name = "",
    this.email = "",
    this.isActive = false,
    this.createdAt = "",
  });

  factory AuthUser.initial(){
    return AuthUser();
  }
}