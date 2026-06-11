import 'package:manshan/src/construction/domain/entity/site_entry.dart';

class SiteEntryModel extends SiteEntry {
  const SiteEntryModel({
    required super.id,
    required super.userId,
    required super.constructionSiteId,
    required super.expenseType,
    required super.itemName,
    required super.quantity,
    required super.unit,
    required super.pricePerUnit,
    required super.totalAmount,
    required super.purchaseDate,
    required super.vendorName,
    required super.notes,
    required super.createdAt,
  });

  factory SiteEntryModel.fromJson(Map<String, dynamic> json) {
    return SiteEntryModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      constructionSiteId: json['construction_site_id'] as int? ?? 0,
      expenseType: json['expense_type'] as String? ?? '',
      itemName: json['item_name'] as String? ?? '',
      quantity: json['quantity']?.toString() ?? '',
      unit: json['unit'] as String? ?? '',
      pricePerUnit: json['price_per_unit']?.toString() ?? '',
      totalAmount: json['total_amount']?.toString() ?? '',
      purchaseDate:
          DateTime.tryParse(json['purchase_date'] as String? ?? '') ??
          DateTime.now(),
      vendorName: json['vendor_name'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
