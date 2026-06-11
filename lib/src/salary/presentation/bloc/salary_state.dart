import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/employee/domain/entity/employee.dart';
import 'package:manshan/src/employee/domain/entity/paginated_employee.dart';
import 'package:manshan/src/salary/domain/entity/paginated_salary_transaction.dart';

class SalaryState {
  final EmployeeStatus employeeLoadStatus;
  final EmployeeStatus submitStatus;
  final EmployeeStatus historyStatus;
  final EmployeeStatus historyPaginationStatus;
  final PaginatedEmployee employees;
  final List<Employee> selectedEmployees;
  final String amount;
  final String paymentMode;
  final String salaryType;
  final DateTime? fromDate;
  final DateTime? toDate;
  final PaginatedSalaryTransaction transactionHistory;
  final bool hasMoreHistory;
  final String message;
  final String errorMessage;

  const SalaryState({
    required this.employeeLoadStatus,
    required this.submitStatus,
    required this.historyStatus,
    required this.historyPaginationStatus,
    required this.employees,
    required this.selectedEmployees,
    required this.amount,
    required this.paymentMode,
    required this.salaryType,
    this.fromDate,
    this.toDate,
    required this.transactionHistory,
    required this.hasMoreHistory,
    required this.message,
    required this.errorMessage,
  });

  factory SalaryState.initial() => SalaryState(
        employeeLoadStatus: EmployeeStatus.initial,
        submitStatus: EmployeeStatus.initial,
        historyStatus: EmployeeStatus.initial,
        historyPaginationStatus: EmployeeStatus.initial,
        employees: PaginatedEmployee.initial(),
        selectedEmployees: const [],
        amount: "",
        paymentMode: "CASH",
        salaryType: "DAILY",
        fromDate: null,
        toDate: null,
        transactionHistory: PaginatedSalaryTransaction.initial(),
        hasMoreHistory: true,
        message: "",
        errorMessage: "",
      );

  SalaryState copyWith({
    EmployeeStatus? employeeLoadStatus,
    EmployeeStatus? submitStatus,
    EmployeeStatus? historyStatus,
    EmployeeStatus? historyPaginationStatus,
    PaginatedEmployee? employees,
    List<Employee>? selectedEmployees,
    String? amount,
    String? paymentMode,
    String? salaryType,
    DateTime? fromDate,
    DateTime? toDate,
    PaginatedSalaryTransaction? transactionHistory,
    bool? hasMoreHistory,
    String? message,
    String? errorMessage,
  }) =>
      SalaryState(
        employeeLoadStatus: employeeLoadStatus ?? this.employeeLoadStatus,
        submitStatus: submitStatus ?? this.submitStatus,
        historyStatus: historyStatus ?? this.historyStatus,
        historyPaginationStatus:
            historyPaginationStatus ?? this.historyPaginationStatus,
        employees: employees ?? this.employees,
        selectedEmployees: selectedEmployees ?? this.selectedEmployees,
        amount: amount ?? this.amount,
        paymentMode: paymentMode ?? this.paymentMode,
        salaryType: salaryType ?? this.salaryType,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        transactionHistory: transactionHistory ?? this.transactionHistory,
        hasMoreHistory: hasMoreHistory ?? this.hasMoreHistory,
        message: message ?? this.message,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}