import 'package:dio/dio.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/dio_handler.dart';
import 'package:manshan/core/util/server_exception.dart';
import 'package:manshan/src/dashboard/data/model/dashboard_model.dart';
import 'package:manshan/src/dashboard/data/model/paginated_last_transaction_model.dart';

abstract class DashboardRemoteDatasource {
  Future<ApiResponse<DashboardModel>> dashboard();
  Future<ApiResponse<PaginatedLastTransactionModel>> lastTransaction();
}

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final Dio dio;

  const DashboardRemoteDatasourceImpl({required this.dio});

  @override
  Future<ApiResponse<DashboardModel>> dashboard() async {
    try {
      final response = await dio.get("/dashboard/");
      return ApiResponse<DashboardModel>.fromJson(
        response.data,
        (data) => DashboardModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<PaginatedLastTransactionModel>> lastTransaction() async {
    try {
      final response = await dio.get("/employee-salary-entry/");
      return ApiResponse<PaginatedLastTransactionModel>.fromJson(
        response.data,
        (data) => PaginatedLastTransactionModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }
}
