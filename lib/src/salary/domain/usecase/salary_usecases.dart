import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/employee/domain/entity/paginated_employee.dart';
import 'package:manshan/src/salary/data/model/create_bulk_salary_request_model.dart';
import 'package:manshan/src/salary/domain/entity/paginated_salary_transaction.dart';
import 'package:manshan/src/salary/domain/entity/salary_transaction.dart';
import 'package:manshan/src/salary/domain/repository/salary_repository.dart';

class GetAllEmployeesForSalaryUsecase {
  final SalaryRepository repository;
  GetAllEmployeesForSalaryUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<PaginatedEmployee>>> call({
    required int page,
    required int limit,
  }) => repository.getAllEmployees(page: page, limit: limit);
}

class CreateBulkSalaryUsecase {
  final SalaryRepository repository;
  CreateBulkSalaryUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<List<SalaryTransaction>>>> call({
    required CreateBulkSalaryRequestModel request,
  }) => repository.createBulkSalary(request: request);
}

class GetTransactionHistoryUsecase {
  final SalaryRepository repository;
  GetTransactionHistoryUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<PaginatedSalaryTransaction>>> call({
    required int page,
    required int limit,
  }) => repository.getTransactionHistory(page: page, limit: limit);
}
