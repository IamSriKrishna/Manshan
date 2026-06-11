class ConstructionSite {
  final int id;
  final int userId;
  final String siteName;
  final String location;
  final String clientName;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final DateTime createdAt;

  const ConstructionSite({
    this.id = 0,
    this.userId = 0,
    this.siteName = "",
    this.location = "",
    this.clientName = "",
    required this.startDate,
    required this.endDate,
    this.status = "",
    required this.createdAt,
  });

  factory ConstructionSite.initial() {
    return ConstructionSite(
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }
}
