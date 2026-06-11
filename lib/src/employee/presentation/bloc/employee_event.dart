abstract class EmployeeEvent {}

class GetAllEmployeeRequestEvent extends EmployeeEvent {
  final int page;
  final int limit;
  GetAllEmployeeRequestEvent({this.page = 1, this.limit = 15});
}

class LoadMoreEmployeeEvent extends EmployeeEvent {}

class CreateEmployeeRequestEvent extends EmployeeEvent {
  final String name;
  final String phone;
  final String role;
  final String salaryType;
  final double defaultSalary;
  final DateTime joiningDate;

  CreateEmployeeRequestEvent({
    required this.name,
    required this.phone,
    required this.role,
    required this.salaryType,
    required this.defaultSalary,
    required this.joiningDate,
  });
}