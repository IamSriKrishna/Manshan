abstract class ConstructionEvent {}

class GetAllConstructionSitesRequestEvent extends ConstructionEvent {
  final int page;
  final int limit;
  GetAllConstructionSitesRequestEvent({this.page = 1, this.limit = 10});
}

class LoadMoreConstructionSitesEvent extends ConstructionEvent {}

class CreateConstructionSiteRequestEvent extends ConstructionEvent {
  final String siteName;
  final String location;
  final String clientName;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  CreateConstructionSiteRequestEvent({
    required this.siteName,
    required this.location,
    required this.clientName,
    required this.startDate,
    required this.endDate,
    this.status = "ONGOING",
  });
}

class CreateEmployeeSiteAssignmentRequestEvent extends ConstructionEvent {
  final int employeeId;
  final int constructionSiteId;
  final DateTime fromDate;
  final DateTime toDate;
  final String workType;
  final String notes;

  CreateEmployeeSiteAssignmentRequestEvent({
    required this.employeeId,
    required this.constructionSiteId,
    required this.fromDate,
    required this.toDate,
    required this.workType,
    this.notes = "",
  });
}

class CreateSiteEntryRequestEvent extends ConstructionEvent {
  final int constructionSiteId;
  final String expenseType;
  final String itemName;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final DateTime purchaseDate;
  final String vendorName;
  final String notes;

  CreateSiteEntryRequestEvent({
    required this.constructionSiteId,
    required this.expenseType,
    required this.itemName,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.purchaseDate,
    this.vendorName = "",
    this.notes = "",
  });
}

class GetSiteAssignmentsRequestEvent extends ConstructionEvent {
  final int siteId;
  GetSiteAssignmentsRequestEvent({required this.siteId});
}

class LoadMoreSiteAssignmentsEvent extends ConstructionEvent {
  final int siteId;
  LoadMoreSiteAssignmentsEvent({required this.siteId});
}

class GetSiteEntriesRequestEvent extends ConstructionEvent {
  final int siteId;
  GetSiteEntriesRequestEvent({required this.siteId});
}

class LoadMoreSiteEntriesEvent extends ConstructionEvent {
  final int siteId;
  LoadMoreSiteEntriesEvent({required this.siteId});
}