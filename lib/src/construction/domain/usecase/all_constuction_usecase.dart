import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/construction/domain/entity/paginated_construction_site.dart';
import 'package:manshan/src/construction/domain/repository/construction_repository.dart';

class ConstructionSiteParams {
  final int page;
  final int limit;
  const ConstructionSiteParams({required this.page, required this.limit});
}

class AllConstructionSitesUsecase {
  final ConstructionRepository repository;
  AllConstructionSitesUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<PaginatedConstructionSite>>> call(
    ConstructionSiteParams params,
  ) {
    return repository.getAllConstructionSites(
      page: params.page,
      limit: params.limit,
    );
  }
}
