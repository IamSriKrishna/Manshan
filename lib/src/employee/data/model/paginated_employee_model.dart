import 'package:manshan/src/employee/data/model/employee_model.dart';
import 'package:manshan/src/employee/domain/entity/paginated_employee.dart';

class PaginatedEmployeeModel extends PaginatedEmployee {
  const PaginatedEmployeeModel({
    required super.data,
    required super.total,
    required super.page,
    required super.limit,
  });

  factory PaginatedEmployeeModel.fromJson(Map<String, dynamic> json) {
    return PaginatedEmployeeModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => EmployeeModel.fromJson(e))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}
