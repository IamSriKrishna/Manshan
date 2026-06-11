import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/core/util/usecase.dart';
import 'package:manshan/src/dashboard/domain/entity/paginated_last_transaction.dart';
import 'package:manshan/src/dashboard/domain/repository/dashboard_repository.dart';

class LastTransactionUsecase
    extends Usecase<ApiResponse<PaginatedLastTransaction>, NoParams> {
  final DashboardRepository repository;

  LastTransactionUsecase({required this.repository});

  @override
  Future<Either<Failure, ApiResponse<PaginatedLastTransaction>>> call(NoParams _) {
    return repository.lastTransaction();
  }
}
