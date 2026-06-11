import 'package:manshan/src/salary/domain/entity/salary_transaction.dart';

class PaginatedSalaryTransaction {
  final List<SalaryTransaction> data;
  final int total;
  final int page;
  final int limit;

  const PaginatedSalaryTransaction({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedSalaryTransaction.initial() =>
      const PaginatedSalaryTransaction(data: [], total: 0, page: 0, limit: 0);
}
