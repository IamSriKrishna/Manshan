import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/grant/domain/entity/grant_access.dart';

class GrantAccessModel extends GrantAccess {
  const GrantAccessModel({
    required super.id,
    required super.userId,
    required super.accessedUserId,
    required super.userName,
    required super.accessedUserName,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory GrantAccessModel.fromJson(Map<String, dynamic> json) {
    return GrantAccessModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      accessedUserId: json['accessed_user_id'] as int? ?? 0,
      userName: json['user_name'] as String? ?? '',
      accessedUserName: json['accessed_user_name'] as String? ?? '',
      status: stringToAccessStatus(json['status'] as String? ?? 'pending'),
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
              DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
              DateTime.now(),
    );
  }
}