import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/core/util/server_exception.dart';
import 'package:manshan/src/employee/data/datasource/employee_remote_datasource.dart';
import 'package:manshan/src/employee/data/model/create_employee_request_model.dart';
import 'package:manshan/src/employee/domain/entity/employee.dart';
import 'package:manshan/src/employee/domain/entity/paginated_employee.dart';
import 'package:manshan/src/employee/domain/repository/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDatasource remoteDatasource;

  const EmployeeRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, ApiResponse<PaginatedEmployee>>> getAllEmployee({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await remoteDatasource.getAllEmployee(
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
  Future<Either<Failure, ApiResponse<Employee>>> createEmployee({
    required CreateEmployeeRequestModel request,
  }) async {
    try {
      final response = await remoteDatasource.createEmployee(request: request);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }
}