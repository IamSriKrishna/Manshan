import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/employee/domain/entity/paginated_employee.dart';
import 'package:manshan/src/salary/data/model/create_bulk_salary_request_model.dart';
import 'package:manshan/src/salary/domain/entity/paginated_salary_transaction.dart';
import 'package:manshan/src/salary/domain/entity/salary_transaction.dart';

abstract class SalaryRepository {
  Future<Either<Failure, ApiResponse<PaginatedEmployee>>> getAllEmployees({
    required int page,
    required int limit,
  });

  Future<Either<Failure, ApiResponse<List<SalaryTransaction>>>>
  createBulkSalary({required CreateBulkSalaryRequestModel request});

  Future<Either<Failure, ApiResponse<PaginatedSalaryTransaction>>>
  getTransactionHistory({required int page, required int limit});
}
