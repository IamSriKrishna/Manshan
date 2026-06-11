class SiteEntry {
  final int id;
  final int userId;
  final int constructionSiteId;
  final String expenseType;
  final String itemName;
  final String quantity;
  final String unit;
  final String pricePerUnit;
  final String totalAmount;
  final DateTime purchaseDate;
  final String vendorName;
  final String notes;
  final DateTime createdAt;

  const SiteEntry({
    this.id = 0,
    this.userId = 0,
    this.constructionSiteId = 0,
    this.expenseType = "",
    this.itemName = "",
    this.quantity = "",
    this.unit = "",
    this.pricePerUnit = "",
    this.totalAmount = "",
    required this.purchaseDate,
    this.vendorName = "",
    this.notes = "",
    required this.createdAt,
  });

  factory SiteEntry.initial() {
    return SiteEntry(purchaseDate: DateTime.now(), createdAt: DateTime.now());
  }
}
