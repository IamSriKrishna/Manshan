import 'package:dio/dio.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/dio_handler.dart';
import 'package:manshan/core/util/server_exception.dart';
import 'package:manshan/src/employee/data/model/create_employee_request_model.dart';
import 'package:manshan/src/employee/data/model/employee_model.dart';
import 'package:manshan/src/employee/data/model/paginated_employee_model.dart';

abstract class EmployeeRemoteDatasource {
  Future<ApiResponse<PaginatedEmployeeModel>> getAllEmployee({
    required int page,
    required int limit,
  });

  Future<ApiResponse<EmployeeModel>> createEmployee({
    required CreateEmployeeRequestModel request,
  });
}

class EmployeeRemoteDatasourceImpl implements EmployeeRemoteDatasource {
  final Dio _dio;

  const EmployeeRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<ApiResponse<PaginatedEmployeeModel>> getAllEmployee({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        "/employee/my",
        queryParameters: {"page": page, "limit": limit},
      );
      return ApiResponse<PaginatedEmployeeModel>.fromJson(
        response.data,
        (data) => PaginatedEmployeeModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<EmployeeModel>> createEmployee({
    required CreateEmployeeRequestModel request,
  }) async {
    try {
      final response = await _dio.post(
        "/employee/create",
        data: request.toJson(),
      );
      return ApiResponse<EmployeeModel>.fromJson(
        response.data,
        (data) => EmployeeModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }
}