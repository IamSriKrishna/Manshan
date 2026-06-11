import 'package:manshan/src/construction/data/model/employee_site_assignment_model.dart';
import 'package:manshan/src/construction/domain/entity/paginated_employee_site_assignment.dart';

class PaginatedEmployeeSiteAssignmentModel
    extends PaginatedEmployeeSiteAssignment {
  const PaginatedEmployeeSiteAssignmentModel({
    required super.data,
    required super.total,
    required super.page,
    required super.limit,
  });

  factory PaginatedEmployeeSiteAssignmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaginatedEmployeeSiteAssignmentModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => EmployeeSiteAssignmentModel.fromJson(e))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}