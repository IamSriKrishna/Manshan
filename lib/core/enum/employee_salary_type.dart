// ignore_for_file: constant_identifier_names

enum EmployeeSalaryType {
  DAILY,
  WEEKLY,
  MONTHLY;

  String get label {
    switch (this) {
      case EmployeeSalaryType.DAILY:
        return "Daily";
      case EmployeeSalaryType.WEEKLY:
        return "Weekly";
      case EmployeeSalaryType.MONTHLY:
        return "Monthly";
    }
  }

  String get value => name;
}
