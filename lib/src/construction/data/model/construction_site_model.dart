import 'package:manshan/src/construction/domain/entity/construction_site.dart';

class ConstructionSiteModel extends ConstructionSite {
  const ConstructionSiteModel({
    required super.id,
    required super.userId,
    required super.siteName,
    required super.location,
    required super.clientName,
    required super.startDate,
    required super.endDate,
    required super.status,
    required super.createdAt,
  });

  factory ConstructionSiteModel.fromJson(Map<String, dynamic> json) {
    return ConstructionSiteModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      siteName: json['site_name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      clientName: json['client_name'] as String? ?? '',
      startDate:
          DateTime.tryParse(json['start_date'] as String? ?? '') ??
          DateTime.now(),
      endDate:
          DateTime.tryParse(json['end_date'] as String? ?? '') ??
          DateTime.now(),
      status: json['status'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}