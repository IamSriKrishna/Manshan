import 'package:manshan/src/construction/data/model/construction_site_model.dart';
import 'package:manshan/src/construction/domain/entity/paginated_construction_site.dart';

class PaginatedConstructionSiteModel extends PaginatedConstructionSite {
  const PaginatedConstructionSiteModel({
    required super.data,
    required super.total,
    required super.page,
    required super.limit,
  });

  factory PaginatedConstructionSiteModel.fromJson(Map<String, dynamic> json) {
    return PaginatedConstructionSiteModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ConstructionSiteModel.fromJson(e))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}
