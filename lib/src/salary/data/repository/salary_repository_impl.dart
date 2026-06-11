import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/core/util/server_exception.dart';
import 'package:manshan/src/employee/domain/entity/paginated_employee.dart';
import 'package:manshan/src/salary/data/datasource/salary_remote_datasource.dart';
import 'package:manshan/src/salary/data/model/create_bulk_salary_request_model.dart';
import 'package:manshan/src/salary/domain/entity/paginated_salary_transaction.dart';
import 'package:manshan/src/salary/domain/entity/salary_transaction.dart';
import 'package:manshan/src/salary/domain/repository/salary_repository.dart';

class SalaryRepositoryImpl implements SalaryRepository {
  final SalaryRemoteDatasource remoteDatasource;

  const SalaryRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, ApiResponse<PaginatedEmployee>>> getAllEmployees({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await remoteDatasource.getAllEmployees(
        page: page,
        limit: limit,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<List<SalaryTransaction>>>>
  createBulkSalary({required CreateBulkSalaryRequestModel request}) async {
    try {
      final response = await remoteDatasource.createBulkSalary(
        request: request,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<PaginatedSalaryTransaction>>>
  getTransactionHistory({required int page, required int limit}) async {
    try {
      final response = await remoteDatasource.getTransactionHistory(
        page: page,
        limit: limit,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }
}
