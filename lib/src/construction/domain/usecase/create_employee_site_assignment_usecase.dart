import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/construction/data/model/create_employee_site_assignment_request_model.dart';
import 'package:manshan/src/construction/domain/entity/employee_site_assignment.dart';
import 'package:manshan/src/construction/domain/repository/construction_repository.dart';

class CreateEmployeeSiteAssignmentUsecase {
  final ConstructionRepository repository;
  CreateEmployeeSiteAssignmentUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<EmployeeSiteAssignment>>> call({
    required CreateEmployeeSiteAssignmentRequestModel request,
  }) {
    return repository.createEmployeeSiteAssignment(request: request);
  }
}