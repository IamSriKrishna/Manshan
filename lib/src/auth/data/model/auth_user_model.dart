import 'package:manshan/src/auth/domain/entity/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    super.id,
    super.name,
    super.email,
    super.isActive,
    super.createdAt,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      isActive: json["is_active"] ?? false,
      createdAt: json["created_at"] ?? "",
    );
  }
}
