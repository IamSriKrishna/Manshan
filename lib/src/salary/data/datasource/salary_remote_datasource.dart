import 'package:dio/dio.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/dio_handler.dart';
import 'package:manshan/core/util/server_exception.dart';
import 'package:manshan/src/employee/data/model/paginated_employee_model.dart';
import 'package:manshan/src/salary/data/model/create_bulk_salary_request_model.dart';
import 'package:manshan/src/salary/data/model/paginated_salary_transaction_model.dart';
import 'package:manshan/src/salary/data/model/salary_transaction_model.dart';

abstract class SalaryRemoteDatasource {
  Future<ApiResponse<PaginatedEmployeeModel>> getAllEmployees({
    required int page,
    required int limit,
  });

  Future<ApiResponse<List<SalaryTransactionModel>>> createBulkSalary({
    required CreateBulkSalaryRequestModel request,
  });

  Future<ApiResponse<PaginatedSalaryTransactionModel>> getTransactionHistory({
    required int page,
    required int limit,
  });
}

class SalaryRemoteDatasourceImpl implements SalaryRemoteDatasource {
  final Dio _dio;

  const SalaryRemoteDatasourceImpl({required this._dio});

  @override
  Future<ApiResponse<PaginatedEmployeeModel>> getAllEmployees({
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
  Future<ApiResponse<List<SalaryTransactionModel>>> createBulkSalary({
    required CreateBulkSalaryRequestModel request,
  }) async {
    try {
      final response = await _dio.post(
        "/employee-salary-entry/bulk-create",
        data: request.toJson(),
      );
      return ApiResponse<List<SalaryTransactionModel>>.fromJson(
        response.data,
        (data) => (data as List<dynamic>)
            .map((e) => SalaryTransactionModel.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<PaginatedSalaryTransactionModel>> getTransactionHistory({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        "/employee-salary-entry/transactions",
        queryParameters: {"page": page, "limit": limit},
      );
      return ApiResponse<PaginatedSalaryTransactionModel>.fromJson(
        response.data,
        (data) => PaginatedSalaryTransactionModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }
}
