import 'package:manshan/src/dashboard/domain/entity/last_transaction.dart';

class PaginatedLastTransaction {
  final List<LastTransaction> data;
  final int total;
  final int page;
  final int limit;

  const PaginatedLastTransaction({
    required this.data,
    required this.page,
    required this.total,
    required this.limit,
  });

  factory PaginatedLastTransaction.initial() {
    return PaginatedLastTransaction(data: [], page: 0, total: 0, limit: 0);
  }
}
