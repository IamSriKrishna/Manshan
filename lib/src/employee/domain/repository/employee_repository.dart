import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/employee/data/model/create_employee_request_model.dart';
import 'package:manshan/src/employee/domain/entity/employee.dart';
import 'package:manshan/src/employee/domain/entity/paginated_employee.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, ApiResponse<PaginatedEmployee>>> getAllEmployee({
    required int page,
    required int limit,
  });

  Future<Either<Failure, ApiResponse<Employee>>> createEmployee({
    required CreateEmployeeRequestModel request,
  });
}