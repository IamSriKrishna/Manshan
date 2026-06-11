import 'package:manshan/src/construction/domain/entity/construction_site.dart';

class PaginatedConstructionSite {
  final List<ConstructionSite> data;
  final int total;
  final int page;
  final int limit;

  const PaginatedConstructionSite({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedConstructionSite.initial() {
    return const PaginatedConstructionSite(
      data: [],
      total: 0,
      page: 0,
      limit: 0,
    );
  }
}
