import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/construction/data/model/create_construction_site_request_model.dart';
import 'package:manshan/src/construction/data/model/create_employee_site_assignment_request_model.dart';
import 'package:manshan/src/construction/data/model/create_site_entry_request_model.dart';
import 'package:manshan/src/construction/domain/entity/construction_site.dart';
import 'package:manshan/src/construction/domain/entity/employee_site_assignment.dart';
import 'package:manshan/src/construction/domain/entity/paginated_construction_site.dart';
import 'package:manshan/src/construction/domain/entity/paginated_employee_site_assignment.dart';
import 'package:manshan/src/construction/domain/entity/paginated_site_entry.dart';
import 'package:manshan/src/construction/domain/entity/site_entry.dart';

abstract class ConstructionRepository {
  Future<Either<Failure, ApiResponse<PaginatedConstructionSite>>>
  getAllConstructionSites({required int page, required int limit});

  Future<Either<Failure, ApiResponse<ConstructionSite>>>
  createConstructionSite({required CreateConstructionSiteRequestModel request});

  Future<Either<Failure, ApiResponse<EmployeeSiteAssignment>>>
  createEmployeeSiteAssignment({
    required CreateEmployeeSiteAssignmentRequestModel request,
  });

  Future<Either<Failure, ApiResponse<SiteEntry>>> createSiteEntry({
    required CreateSiteEntryRequestModel request,
  });

  Future<Either<Failure, ApiResponse<PaginatedEmployeeSiteAssignment>>>
  getSiteAssignments({
    required int siteId,
    required int page,
    required int limit,
  });

  Future<Either<Failure, ApiResponse<PaginatedSiteEntry>>> getSiteEntries({
    required int siteId,
    required int page,
    required int limit,
  });
}
