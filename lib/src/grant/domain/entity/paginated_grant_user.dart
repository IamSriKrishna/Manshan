import 'package:manshan/src/grant/domain/entity/grant_user.dart';

class PaginatedGrantUser {
  final List<GrantUser> data;
  final int total;
  final int page;
  final int limit;

  const PaginatedGrantUser({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedGrantUser.initial() {
    return const PaginatedGrantUser(data: [], total: 0, page: 0, limit: 0);
  }
}
