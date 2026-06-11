import 'package:manshan/src/salary/domain/entity/salary_transaction.dart';

class SalaryTransactionModel extends SalaryTransaction {
  const SalaryTransactionModel({
    required super.id,
    required super.userId,
    required super.employeeId,
    required super.constructionSiteId,
    required super.salaryDate,
    required super.salaryType,
    required super.defaultSalary,
    required super.enteredAmount,
    required super.paymentStatus,
    required super.paymentMode,
    required super.notes,
    required super.createdAt,
  });

  factory SalaryTransactionModel.fromJson(Map<String, dynamic> json) {
    return SalaryTransactionModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      employeeId: json['employee_id'] as int? ?? 0,
      constructionSiteId: json['construction_site_id'] as int? ?? 0,
      salaryDate:
          DateTime.tryParse(json['salary_date'] as String? ?? '') ??
          DateTime.now(),
      salaryType: json['salary_type'] as String? ?? '',
      defaultSalary: json['default_salary']?.toString() ?? '',
      enteredAmount: json['entered_amount']?.toString() ?? '',
      paymentStatus: json['payment_status'] as String? ?? '',
      paymentMode: json['payment_mode'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
