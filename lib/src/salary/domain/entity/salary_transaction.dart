class SalaryTransaction {
  final int id;
  final int userId;
  final int employeeId;
  final int constructionSiteId;
  final DateTime salaryDate;
  final String salaryType;
  final String defaultSalary;
  final String enteredAmount;
  final String paymentStatus;
  final String paymentMode;
  final String notes;
  final DateTime createdAt;

  const SalaryTransaction({
    this.id = 0,
    this.userId = 0,
    this.employeeId = 0,
    this.constructionSiteId = 0,
    required this.salaryDate,
    this.salaryType = "",
    this.defaultSalary = "",
    this.enteredAmount = "",
    this.paymentStatus = "",
    this.paymentMode = "",
    this.notes = "",
    required this.createdAt,
  });

  factory SalaryTransaction.initial() =>
      SalaryTransaction(salaryDate: DateTime.now(), createdAt: DateTime.now());
}
