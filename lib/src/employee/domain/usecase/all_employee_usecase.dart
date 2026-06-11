import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/core/util/usecase.dart';
import 'package:manshan/src/employee/domain/entity/paginated_employee.dart';
import 'package:manshan/src/employee/domain/repository/employee_repository.dart';

class EmployeeParams {
  final int page;
  final int limit;

  const EmployeeParams({required this.page, required this.limit});
}

class AllEmployeeUsecase
    extends Usecase<ApiResponse<PaginatedEmployee>, EmployeeParams> {
  final EmployeeRepository repository;

  AllEmployeeUsecase({required this.repository});

  @override
  Future<Either<Failure, ApiResponse<PaginatedEmployee>>> call(
    EmployeeParams params,
  ) {
    return repository.getAllEmployee(page: params.page, limit: params.limit);
  }
}
