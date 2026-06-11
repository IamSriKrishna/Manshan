import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/employee/data/model/create_employee_request_model.dart';
import 'package:manshan/src/employee/domain/entity/employee.dart';
import 'package:manshan/src/employee/domain/repository/employee_repository.dart';

class CreateEmployeeUsecase {
  final EmployeeRepository repository;

  CreateEmployeeUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<Employee>>> call({
    required CreateEmployeeRequestModel request,
  }) {
    return repository.createEmployee(request: request);
  }
}
