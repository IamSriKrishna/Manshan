import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/core/util/usecase.dart';
import 'package:manshan/src/dashboard/domain/entity/dashboard.dart';
import 'package:manshan/src/dashboard/domain/repository/dashboard_repository.dart';

class DashboardUsecase extends Usecase<ApiResponse<Dashboard>, NoParams> {
  final DashboardRepository repository;

  DashboardUsecase({required this.repository});

  @override
  Future<Either<Failure, ApiResponse<Dashboard>>> call(NoParams _) {
    return repository.dashboard();
  }
}
