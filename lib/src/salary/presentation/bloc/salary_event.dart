import 'package:manshan/src/employee/domain/entity/employee.dart';

abstract class SalaryEvent {}

class LoadEmployeesEvent extends SalaryEvent {}

class ToggleEmployeeSelectionEvent extends SalaryEvent {
  final Employee employee;
  ToggleEmployeeSelectionEvent(this.employee);
}

class AppendDigitEvent extends SalaryEvent {
  final String digit;
  AppendDigitEvent(this.digit);
}

class DeleteDigitEvent extends SalaryEvent {}

class ClearAmountEvent extends SalaryEvent {}

class UpdatePaymentModeEvent extends SalaryEvent {
  final String mode;
  UpdatePaymentModeEvent(this.mode);
}

class UpdateSalaryTypeEvent extends SalaryEvent {
  final String salaryType;
  UpdateSalaryTypeEvent(this.salaryType);
}

class UpdateDateRangeEvent extends SalaryEvent {
  final DateTime fromDate;
  final DateTime toDate;
  UpdateDateRangeEvent({required this.fromDate, required this.toDate});
}

class SubmitBulkSalaryEvent extends SalaryEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final int constructionSiteId;
  final String notes;

  SubmitBulkSalaryEvent({
    required this.fromDate,
    required this.toDate,
    this.constructionSiteId = 0,
    this.notes = "",
  });
}

class LoadTransactionHistoryEvent extends SalaryEvent {}

class LoadMoreTransactionHistoryEvent extends SalaryEvent {}