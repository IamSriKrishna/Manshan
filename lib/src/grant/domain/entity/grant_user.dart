class GrantUser {
  final int id;
  final String name;
  final String email;
  final bool isActive;
  final DateTime createdAt;

  const GrantUser({
    this.id = 0,
    this.name = '',
    this.email = '',
    this.isActive = false,
    required this.createdAt,
  });

  factory GrantUser.initial() => GrantUser(createdAt: DateTime.now());
}
