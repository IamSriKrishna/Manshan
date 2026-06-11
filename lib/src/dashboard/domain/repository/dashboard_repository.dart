import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/dashboard/domain/entity/dashboard.dart';
import 'package:manshan/src/dashboard/domain/entity/paginated_last_transaction.dart';

abstract class DashboardRepository {
  Future<Either<Failure, ApiResponse<Dashboard>>> dashboard();
  Future<Either<Failure, ApiResponse<PaginatedLastTransaction>>> lastTransaction();
}
