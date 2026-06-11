import 'package:manshan/src/grant/domain/entity/grant_user.dart';

class GrantUserModel extends GrantUser {
  const GrantUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.isActive,
    required super.createdAt,
  });

  factory GrantUserModel.fromJson(Map<String, dynamic> json) {
    return GrantUserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
