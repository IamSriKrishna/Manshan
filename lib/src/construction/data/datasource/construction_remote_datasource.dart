
import 'package:dio/dio.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/dio_handler.dart';
import 'package:manshan/core/util/server_exception.dart';
import 'package:manshan/src/construction/data/model/construction_site_model.dart';
import 'package:manshan/src/construction/data/model/create_construction_site_request_model.dart';
import 'package:manshan/src/construction/data/model/create_employee_site_assignment_request_model.dart';
import 'package:manshan/src/construction/data/model/create_site_entry_request_model.dart';
import 'package:manshan/src/construction/data/model/employee_site_assignment_model.dart';
import 'package:manshan/src/construction/data/model/paginated_construction_site_model.dart';
import 'package:manshan/src/construction/data/model/paginated_employee_site_assignment_model.dart';
import 'package:manshan/src/construction/data/model/paginated_site_entry_model.dart';
import 'package:manshan/src/construction/data/model/site_entry_model.dart';

abstract class ConstructionRemoteDatasource {
  Future<ApiResponse<PaginatedConstructionSiteModel>> getAllConstructionSites({
    required int page,
    required int limit,
  });

  Future<ApiResponse<ConstructionSiteModel>> createConstructionSite({
    required CreateConstructionSiteRequestModel request,
  });

  Future<ApiResponse<EmployeeSiteAssignmentModel>> createEmployeeSiteAssignment({
    required CreateEmployeeSiteAssignmentRequestModel request,
  });

  Future<ApiResponse<SiteEntryModel>> createSiteEntry({
    required CreateSiteEntryRequestModel request,
  });

  Future<ApiResponse<PaginatedEmployeeSiteAssignmentModel>> getSiteAssignments({
    required int siteId,
    required int page,
    required int limit,
  });

  Future<ApiResponse<PaginatedSiteEntryModel>> getSiteEntries({
    required int siteId,
    required int page,
    required int limit,
  });
}

class ConstructionRemoteDatasourceImpl implements ConstructionRemoteDatasource {
  final Dio _dio;
  const ConstructionRemoteDatasourceImpl({required this._dio});

  @override
  Future<ApiResponse<PaginatedConstructionSiteModel>> getAllConstructionSites({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        "/construction-site/all",
        queryParameters: {"page": page, "limit": limit},
      );
      return ApiResponse<PaginatedConstructionSiteModel>.fromJson(
        response.data,
        (data) => PaginatedConstructionSiteModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<ConstructionSiteModel>> createConstructionSite({
    required CreateConstructionSiteRequestModel request,
  }) async {
    try {
      final response = await _dio.post(
        "/construction-site/create",
        data: request.toJson(),
      );
      return ApiResponse<ConstructionSiteModel>.fromJson(
        response.data,
        (data) => ConstructionSiteModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<EmployeeSiteAssignmentModel>> createEmployeeSiteAssignment({
    required CreateEmployeeSiteAssignmentRequestModel request,
  }) async {
    try {
      final response = await _dio.post(
        "/employee-site-assignment/create",
        data: request.toJson(),
      );
      return ApiResponse<EmployeeSiteAssignmentModel>.fromJson(
        response.data,
        (data) => EmployeeSiteAssignmentModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<SiteEntryModel>> createSiteEntry({
    required CreateSiteEntryRequestModel request,
  }) async {
    try {
      final response = await _dio.post(
        "/site-entry/create",
        data: request.toJson(),
      );
      return ApiResponse<SiteEntryModel>.fromJson(
        response.data,
        (data) => SiteEntryModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<PaginatedEmployeeSiteAssignmentModel>> getSiteAssignments({
    required int siteId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        "/employee-site-assignment/",
        queryParameters: {"page": page, "limit": limit, "site_id": siteId},
      );
      return ApiResponse<PaginatedEmployeeSiteAssignmentModel>.fromJson(
        response.data,
        (data) => PaginatedEmployeeSiteAssignmentModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<PaginatedSiteEntryModel>> getSiteEntries({
    required int siteId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        "/site-entry/constructions/$siteId",
        queryParameters: {"page": page, "limit": limit},
      );
      return ApiResponse<PaginatedSiteEntryModel>.fromJson(
        response.data,
        (data) => PaginatedSiteEntryModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }
}