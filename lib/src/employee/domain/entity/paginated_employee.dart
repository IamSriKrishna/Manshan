import 'package:manshan/src/employee/domain/entity/employee.dart';

class PaginatedEmployee {
  final List<Employee> data;
  final int total;
  final int page;
  final int limit;

  const PaginatedEmployee({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedEmployee.initial() {
    return const PaginatedEmployee(data: [], total: 0, page: 0, limit: 0);
  }
}
