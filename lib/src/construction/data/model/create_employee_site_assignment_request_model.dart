class CreateEmployeeSiteAssignmentRequestModel {
  final int employeeId;
  final int constructionSiteId;
  final DateTime fromDate;
  final DateTime toDate;
  final String workType;
  final String notes;

  const CreateEmployeeSiteAssignmentRequestModel({
    this.employeeId = 0,
    this.constructionSiteId = 0,
    required this.fromDate,
    required this.toDate,
    this.workType = "",
    this.notes = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "employee_id": employeeId,
      "construction_site_id": constructionSiteId,
      "from_date": fromDate.toUtc().toIso8601String(),
      "to_date": toDate.toUtc().toIso8601String(),
      "work_type": workType,
      "notes": notes,
    };
  }
}
