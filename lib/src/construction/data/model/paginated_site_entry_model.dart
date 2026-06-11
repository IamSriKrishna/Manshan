import 'package:manshan/src/construction/data/model/site_entry_model.dart';
import 'package:manshan/src/construction/domain/entity/paginated_site_entry.dart';

class PaginatedSiteEntryModel extends PaginatedSiteEntry {
  const PaginatedSiteEntryModel({
    required super.data,
    required super.total,
    required super.page,
    required super.limit,
  });

  factory PaginatedSiteEntryModel.fromJson(Map<String, dynamic> json) {
    return PaginatedSiteEntryModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SiteEntryModel.fromJson(e))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}