import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/core/util/server_exception.dart';
import 'package:manshan/src/construction/data/datasource/construction_remote_datasource.dart';
import 'package:manshan/src/construction/data/model/create_construction_site_request_model.dart';
import 'package:manshan/src/construction/data/model/create_employee_site_assignment_request_model.dart';
import 'package:manshan/src/construction/data/model/create_site_entry_request_model.dart';
import 'package:manshan/src/construction/domain/entity/construction_site.dart';
import 'package:manshan/src/construction/domain/entity/employee_site_assignment.dart';
import 'package:manshan/src/construction/domain/entity/paginated_construction_site.dart';
import 'package:manshan/src/construction/domain/entity/paginated_employee_site_assignment.dart';
import 'package:manshan/src/construction/domain/entity/paginated_site_entry.dart';
import 'package:manshan/src/construction/domain/entity/site_entry.dart';
import 'package:manshan/src/construction/domain/repository/construction_repository.dart';

class ConstructionRepositoryImpl implements ConstructionRepository {
  final ConstructionRemoteDatasource remoteDatasource;
  const ConstructionRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, ApiResponse<PaginatedConstructionSite>>>
  getAllConstructionSites({required int page, required int limit}) async {
    try {
      final r = await remoteDatasource.getAllConstructionSites(
        page: page,
        limit: limit,
      );
      return Right(r);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<ConstructionSite>>>
  createConstructionSite({
    required CreateConstructionSiteRequestModel request,
  }) async {
    try {
      final r = await remoteDatasource.createConstructionSite(request: request);
      return Right(r);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<EmployeeSiteAssignment>>>
  createEmployeeSiteAssignment({
    required CreateEmployeeSiteAssignmentRequestModel request,
  }) async {
    try {
      final r = await remoteDatasource.createEmployeeSiteAssignment(
        request: request,
      );
      return Right(r);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<SiteEntry>>> createSiteEntry({
    required CreateSiteEntryRequestModel request,
  }) async {
    try {
      final r = await remoteDatasource.createSiteEntry(request: request);
      return Right(r);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<PaginatedEmployeeSiteAssignment>>>
  getSiteAssignments({
    required int siteId,
    required int page,
    required int limit,
  }) async {
    try {
      final r = await remoteDatasource.getSiteAssignments(
        siteId: siteId,
        page: page,
        limit: limit,
      );
      return Right(r);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<PaginatedSiteEntry>>> getSiteEntries({
    required int siteId,
    required int page,
    required int limit,
  }) async {
    try {
      final r = await remoteDatasource.getSiteEntries(
        siteId: siteId,
        page: page,
        limit: limit,
      );
      return Right(r);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }
}
