class CreateConstructionSiteRequestModel {
  final String siteName;
  final String location;
  final String clientName;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  const CreateConstructionSiteRequestModel({
    this.siteName = "",
    this.location = "",
    this.clientName = "",
    required this.startDate,
    required this.endDate,
    this.status = "ONGOING",
  });

  Map<String, dynamic> toJson() {
    return {
      "site_name": siteName,
      "location": location,
      "client_name": clientName,
      "start_date": startDate.toUtc().toIso8601String(),
      "end_date": endDate.toUtc().toIso8601String(),
      "status": status,
    };
  }
}
