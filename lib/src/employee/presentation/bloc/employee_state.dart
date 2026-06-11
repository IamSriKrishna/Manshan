import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/employee/domain/entity/paginated_employee.dart';

class EmployeeState {
  final EmployeeStatus employeeStatus;
  final EmployeeStatus paginationStatus;
  final EmployeeStatus createStatus;
  final PaginatedEmployee allEmployee;
  final String message;
  final String errorMessage;
  final bool hasMore;

  const EmployeeState({
    required this.employeeStatus,
    required this.paginationStatus,
    required this.createStatus,
    required this.allEmployee,
    required this.message,
    required this.errorMessage,
    required this.hasMore,
  });

  factory EmployeeState.initial() {
    return EmployeeState(
      employeeStatus: EmployeeStatus.initial,
      paginationStatus: EmployeeStatus.initial,
      createStatus: EmployeeStatus.initial,
      allEmployee: PaginatedEmployee.initial(),
      message: "",
      errorMessage: "",
      hasMore: true,
    );
  }

  EmployeeState copyWith({
    EmployeeStatus? employeeStatus,
    EmployeeStatus? paginationStatus,
    EmployeeStatus? createStatus,
    PaginatedEmployee? allEmployee,
    String? message,
    String? errorMessage,
    bool? hasMore,
  }) {
    return EmployeeState(
      employeeStatus: employeeStatus ?? this.employeeStatus,
      paginationStatus: paginationStatus ?? this.paginationStatus,
      createStatus: createStatus ?? this.createStatus,
      allEmployee: allEmployee ?? this.allEmployee,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}