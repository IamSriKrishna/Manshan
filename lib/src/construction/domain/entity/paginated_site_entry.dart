import 'package:manshan/src/construction/domain/entity/site_entry.dart';

class PaginatedSiteEntry {
  final List<SiteEntry> data;
  final int total;
  final int page;
  final int limit;

  const PaginatedSiteEntry({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedSiteEntry.initial() {
    return const PaginatedSiteEntry(data: [], total: 0, page: 0, limit: 0);
  }
}
