class CreateBulkSalaryRequestModel {
  final List<int> employeeIds;
  final int constructionSiteId;
  final DateTime fromDate;
  final DateTime toDate;
  final String salaryType;
  final double enteredAmount;
  final String paymentStatus;
  final String paymentMode;
  final String notes;

  const CreateBulkSalaryRequestModel({
    required this.employeeIds,
    this.constructionSiteId = 0,
    required this.fromDate,
    required this.toDate,
    this.salaryType = "DAILY",
    this.enteredAmount = 0,
    this.paymentStatus = "PENDING",
    this.paymentMode = "CASH",
    this.notes = "",
  });

  Map<String, dynamic> toJson() => {
    "employee_ids": employeeIds,
    "construction_site_id": constructionSiteId,
    "from_date": fromDate.toUtc().toIso8601String(),
    "to_date": toDate.toUtc().toIso8601String(),
    "salary_type": salaryType,
    "entered_amount": enteredAmount,
    "payment_status": paymentStatus,
    "payment_mode": paymentMode,
    "notes": notes,
  };
}
