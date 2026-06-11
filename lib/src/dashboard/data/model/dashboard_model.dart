import 'package:manshan/src/dashboard/domain/entity/dashboard.dart';

class DashboardModel extends Dashboard {
  DashboardModel({
    required super.completedSites,
    required super.totalCost,
    required super.salaryCost,
    required super.materialCost,
    required super.totalEmployee,
    required super.totalSites,
    required super.ongoingSites,
    required super.otherExpenses,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      completedSites: json['completed_sites'] as int? ?? 0,
      totalCost: json['total_cost'] as String? ?? "",
      salaryCost: json['salary_cost'] as String? ?? "",
      materialCost: json['material_cost'] as String? ?? "",
      totalEmployee: json['total_employees'] as int? ?? 0,
      totalSites: json['total_sites'] as int? ?? 0,
      ongoingSites: json['ongoing_sites'] as int? ?? 0,
      otherExpenses: json['other_expense'] as String? ?? "",
    );
  }
}
