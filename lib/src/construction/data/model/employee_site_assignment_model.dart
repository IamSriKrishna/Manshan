import 'package:manshan/src/construction/domain/entity/employee_site_assignment.dart';

class EmployeeSiteAssignmentModel extends EmployeeSiteAssignment {
  const EmployeeSiteAssignmentModel({
    required super.id,
    required super.employeeId,
    required super.constructionSiteId,
    required super.fromDate,
    required super.toDate,
    required super.workType,
    required super.notes,
    required super.createdAt,
  });

  factory EmployeeSiteAssignmentModel.fromJson(Map<String, dynamic> json) {
    return EmployeeSiteAssignmentModel(
      id: json['id'] as int? ?? 0,
      employeeId: json['employee_id'] as int? ?? 0,
      constructionSiteId: json['construction_site_id'] as int? ?? 0,
      fromDate:
          DateTime.tryParse(json['from_date'] as String? ?? '') ??
          DateTime.now(),
      toDate:
          DateTime.tryParse(json['to_date'] as String? ?? '') ?? DateTime.now(),
      workType: json['work_type'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
