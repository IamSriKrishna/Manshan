import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/core/util/server_exception.dart';
import 'package:manshan/src/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:manshan/src/dashboard/domain/entity/dashboard.dart';
import 'package:manshan/src/dashboard/domain/entity/paginated_last_transaction.dart';
import 'package:manshan/src/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource remoteDatasource;
  const DashboardRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, ApiResponse<Dashboard>>> dashboard() async {
    try {
      final response = await remoteDatasource.dashboard();

      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return const Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<PaginatedLastTransaction>>> lastTransaction() async {
    try {
      final response = await remoteDatasource.lastTransaction();

      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return const Left(Failure("Unexpected Error"));
    }
  }
}
