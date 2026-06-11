import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/construction/domain/entity/paginated_site_entry.dart';
import 'package:manshan/src/construction/domain/repository/construction_repository.dart';

class SiteEntryParams {
  final int siteId;
  final int page;
  final int limit;
  const SiteEntryParams({
    required this.siteId,
    required this.page,
    required this.limit,
  });
}

class GetSiteEntriesUsecase {
  final ConstructionRepository repository;
  GetSiteEntriesUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<PaginatedSiteEntry>>> call(
    SiteEntryParams params,
  ) {
    return repository.getSiteEntries(
      siteId: params.siteId,
      page: params.page,
      limit: params.limit,
    );
  }
}