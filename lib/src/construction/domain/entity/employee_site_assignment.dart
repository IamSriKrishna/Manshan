class EmployeeSiteAssignment {
  final int id;
  final int employeeId;
  final int constructionSiteId;
  final DateTime fromDate;
  final DateTime toDate;
  final String workType;
  final String notes;
  final DateTime createdAt;

  const EmployeeSiteAssignment({
    this.id = 0,
    this.employeeId = 0,
    this.constructionSiteId = 0,
    required this.fromDate,
    required this.toDate,
    this.workType = "",
    this.notes = "",
    required this.createdAt,
  });

  factory EmployeeSiteAssignment.initial() {
    return EmployeeSiteAssignment(
      fromDate: DateTime.now(),
      toDate: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }
}
