import 'package:manshan/src/salary/data/model/salary_transaction_model.dart';
import 'package:manshan/src/salary/domain/entity/paginated_salary_transaction.dart';

class PaginatedSalaryTransactionModel extends PaginatedSalaryTransaction {
  const PaginatedSalaryTransactionModel({
    required super.data,
    required super.total,
    required super.page,
    required super.limit,
  });

  factory PaginatedSalaryTransactionModel.fromJson(Map<String, dynamic> json) {
    return PaginatedSalaryTransactionModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .map(
            (e) => SalaryTransactionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}
