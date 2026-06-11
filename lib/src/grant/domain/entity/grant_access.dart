import 'package:manshan/core/util/enums.dart';

class GrantAccess {
  final int id;
  final int userId;
  final int accessedUserId;
  final String userName;
  final String accessedUserName;
  final AccessStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GrantAccess({
    this.id = 0,
    this.userId = 0,
    this.accessedUserId = 0,
    this.userName = "",
    this.accessedUserName = "",
    this.status = AccessStatus.pending,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GrantAccess.initial() {
    final now = DateTime.now();
    return GrantAccess(createdAt: now, updatedAt: now);
  }
}
