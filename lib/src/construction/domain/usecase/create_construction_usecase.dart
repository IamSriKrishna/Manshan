import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/construction/data/model/create_construction_site_request_model.dart';
import 'package:manshan/src/construction/domain/entity/construction_site.dart';
import 'package:manshan/src/construction/domain/repository/construction_repository.dart';

class CreateConstructionSiteUsecase {
  final ConstructionRepository repository;
  CreateConstructionSiteUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<ConstructionSite>>> call({
    required CreateConstructionSiteRequestModel request,
  }) {
    return repository.createConstructionSite(request: request);
  }
}
