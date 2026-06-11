import 'package:manshan/src/dashboard/data/model/last_transaction_model.dart';
import 'package:manshan/src/dashboard/domain/entity/paginated_last_transaction.dart';

class PaginatedLastTransactionModel extends PaginatedLastTransaction {
  const PaginatedLastTransactionModel({
    required super.data,
    required super.total,
    required super.page,
    required super.limit,
  });

  factory PaginatedLastTransactionModel.fromJson(Map<String, dynamic> json) {
    return PaginatedLastTransactionModel(
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((e) => LastTransactionModel.fromJson(e))
              .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}