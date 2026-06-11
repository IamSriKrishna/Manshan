class CreateSiteEntryRequestModel {
  final int constructionSiteId;
  final String expenseType;
  final String itemName;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final DateTime purchaseDate;
  final String vendorName;
  final String notes;

  const CreateSiteEntryRequestModel({
    this.constructionSiteId = 0,
    this.expenseType = "",
    this.itemName = "",
    this.quantity = 1,
    this.unit = "",
    this.pricePerUnit = 1,
    required this.purchaseDate,
    this.vendorName = "",
    this.notes = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "construction_site_id": constructionSiteId,
      "expense_type": expenseType,
      "item_name": itemName,
      "quantity": quantity,
      "unit": unit,
      "price_per_unit": pricePerUnit,
      "purchase_date": purchaseDate.toUtc().toIso8601String(),
      "vendor_name": vendorName,
      "notes": notes,
    };
  }
}