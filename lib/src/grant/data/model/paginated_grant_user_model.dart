import 'package:manshan/src/grant/data/model/grant_user_model.dart';
import 'package:manshan/src/grant/domain/entity/paginated_grant_user.dart';

class PaginatedGrantUserModel extends PaginatedGrantUser {
  const PaginatedGrantUserModel({
    required super.data,
    required super.total,
    required super.page,
    required super.limit,
  });

  factory PaginatedGrantUserModel.fromJson(Map<String, dynamic> json) {
    return PaginatedGrantUserModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => GrantUserModel.fromJson(e))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}
