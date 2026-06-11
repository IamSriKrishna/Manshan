class Employee {
  final int id;
  final int userId;
  final String name;
  final String phone;
  final String role;
  final String image;
  final String salaryType;
  final String defaultSalary;
  final DateTime joiningDate;
  final String status;
  final DateTime createdAt;

  const Employee({
    this.id = 0,
    this.userId = 0,
    this.name = "",
    this.phone = "",
    this.role = "",
    this.image = "",
    this.salaryType = "",
    this.defaultSalary = "",
    required this.joiningDate,
    this.status = "",
    required this.createdAt,
  });

  factory Employee.initial() {
    return Employee(joiningDate: DateTime.now(), createdAt: DateTime.now());
  }
}
