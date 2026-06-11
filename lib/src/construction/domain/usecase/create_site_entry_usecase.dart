import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/construction/data/model/create_site_entry_request_model.dart';
import 'package:manshan/src/construction/domain/entity/site_entry.dart';
import 'package:manshan/src/construction/domain/repository/construction_repository.dart';

class CreateSiteEntryUsecase {
  final ConstructionRepository repository;
  CreateSiteEntryUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<SiteEntry>>> call({
    required CreateSiteEntryRequestModel request,
  }) {
    return repository.createSiteEntry(request: request);
  }
}