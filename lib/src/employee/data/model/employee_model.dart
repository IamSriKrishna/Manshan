import 'package:manshan/src/employee/domain/entity/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.phone,
    required super.role,
    required super.image,
    required super.salaryType,
    required super.defaultSalary,
    required super.joiningDate,
    required super.status,
    required super.createdAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? '',
      image: json['image'] as String? ?? '',
      salaryType: json['salary_type'] as String? ?? '',
      defaultSalary: json['default_salary'] as String? ?? '',
      joiningDate:
          DateTime.tryParse(json['joining_date'] as String? ?? '') ??
          DateTime.now(),
      status: json['status'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  factory EmployeeModel.initial() => EmployeeModel(
    id: 0,
    userId: 0,
    name: '',
    phone: '',
    role: '',
    image: '',
    salaryType: '',
    defaultSalary: '',
    joiningDate: DateTime.now(),
    status: '',
    createdAt: DateTime.now(),
  );
}
