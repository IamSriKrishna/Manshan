import 'package:dio/dio.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/dio_handler.dart';
import 'package:manshan/core/util/server_exception.dart';
import 'package:manshan/src/grant/data/model/grant_access_model.dart';
import 'package:manshan/src/grant/data/model/grant_request_model.dart';
import 'package:manshan/src/grant/data/model/paginated_grant_user_model.dart';

abstract class GrantRemoteDatasource {
  Future<ApiResponse<GrantAccessModel>> grantAccess({
    required GrantRequestModel request,
  });

  Future<ApiResponse<Map<String, dynamic>>> revokeAccess({
    required GrantRequestModel request,
  });

  Future<ApiResponse<List<GrantAccessModel>>> getMyAccesses();

  Future<ApiResponse<PaginatedGrantUserModel>> getUsers({
    required int page,
    required int limit,
  });

  Future<ApiResponse<GrantAccessModel>> acceptRequest({
    required GrantRequestModel request,
  });

  Future<ApiResponse<GrantAccessModel>> rejectRequest({
    required GrantRequestModel request,
  });

  Future<ApiResponse<List<GrantAccessModel>>> getRequestsReceived();

  Future<ApiResponse<List<GrantAccessModel>>> getRequestsSent();
}

class GrantRemoteDatasourceImpl implements GrantRemoteDatasource {
  final Dio _dio;

  const GrantRemoteDatasourceImpl({required this._dio});

  @override
  Future<ApiResponse<GrantAccessModel>> grantAccess({
    required GrantRequestModel request,
  }) async {
    try {
      final response = await _dio.post("/access/request", data: request.toJson());
      return ApiResponse<GrantAccessModel>.fromJson(
        response.data,
        (data) => GrantAccessModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> revokeAccess({
    required GrantRequestModel request,
  }) async {
    try {
      final response = await _dio.post(
        "/access/revoke",
        data: request.toJson(),
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<List<GrantAccessModel>>> getMyAccesses() async {
    try {
      final response = await _dio.get("/access/my-accesses");
      return ApiResponse<List<GrantAccessModel>>.fromJson(
        response.data,
        (data) => (data as List<dynamic>)
            .map((e) => GrantAccessModel.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<PaginatedGrantUserModel>> getUsers({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        "/access/users",
        queryParameters: {"page": page, "limit": limit},
      );
      return ApiResponse<PaginatedGrantUserModel>.fromJson(
        response.data,
        (data) => PaginatedGrantUserModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<GrantAccessModel>> acceptRequest({
    required GrantRequestModel request,
  }) async {
    try {
      final response = await _dio.post("/access/accept", data: request.toJson());
      return ApiResponse<GrantAccessModel>.fromJson(
        response.data,
        (data) => GrantAccessModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<GrantAccessModel>> rejectRequest({
    required GrantRequestModel request,
  }) async {
    try {
      final response = await _dio.post("/access/reject", data: request.toJson());
      return ApiResponse<GrantAccessModel>.fromJson(
        response.data,
        (data) => GrantAccessModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<List<GrantAccessModel>>> getRequestsReceived() async {
    try {
      final response = await _dio.get("/access/requests-received");
      return ApiResponse<List<GrantAccessModel>>.fromJson(
        response.data,
        (data) => (data as List<dynamic>)
            .map((e) => GrantAccessModel.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<List<GrantAccessModel>>> getRequestsSent() async {
    try {
      final response = await _dio.get("/access/requests-sent");
      return ApiResponse<List<GrantAccessModel>>.fromJson(
        response.data,
        (data) => (data as List<dynamic>)
            .map((e) => GrantAccessModel.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }
}
