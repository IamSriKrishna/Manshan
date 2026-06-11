import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/construction/domain/entity/paginated_employee_site_assignment.dart';
import 'package:manshan/src/construction/domain/repository/construction_repository.dart';

class SiteAssignmentParams {
  final int siteId;
  final int page;
  final int limit;
  const SiteAssignmentParams({
    required this.siteId,
    required this.page,
    required this.limit,
  });
}

class GetSiteAssignmentsUsecase {
  final ConstructionRepository repository;
  GetSiteAssignmentsUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<PaginatedEmployeeSiteAssignment>>> call(
    SiteAssignmentParams params,
  ) {
    return repository.getSiteAssignments(
      siteId: params.siteId,
      page: params.page,
      limit: params.limit,
    );
  }
}
