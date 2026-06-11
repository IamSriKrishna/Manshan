import 'package:manshan/src/construction/domain/entity/employee_site_assignment.dart';

class PaginatedEmployeeSiteAssignment {
  final List<EmployeeSiteAssignment> data;
  final int total;
  final int page;
  final int limit;

  const PaginatedEmployeeSiteAssignment({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedEmployeeSiteAssignment.initial() {
    return const PaginatedEmployeeSiteAssignment(
      data: [],
      total: 0,
      page: 0,
      limit: 0,
    );
  }
}