import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/grant/domain/entity/grant_access.dart';
import 'package:manshan/src/grant/domain/entity/paginated_grant_user.dart';
import 'package:manshan/src/grant/domain/repository/grant_repository.dart';

class GrantAccessUsecase {
  final GrantRepository repository;
  GrantAccessUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<GrantAccess>>> call({
    required int accessedUserId,
  }) =>
      repository.grantAccess(accessedUserId: accessedUserId);
}

class RevokeAccessUsecase {
  final GrantRepository repository;
  RevokeAccessUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<Map<String, dynamic>>>> call({
    required int accessedUserId,
  }) =>
      repository.revokeAccess(accessedUserId: accessedUserId);
}

class GetMyAccessesUsecase {
  final GrantRepository repository;
  GetMyAccessesUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<List<GrantAccess>>>> call() =>
      repository.getMyAccesses();
}

class GetGrantUsersUsecase {
  final GrantRepository repository;
  GetGrantUsersUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<PaginatedGrantUser>>> call({
    required int page,
    required int limit,
  }) =>
      repository.getUsers(page: page, limit: limit);
}

class AcceptAccessRequestUsecase {
  final GrantRepository repository;
  AcceptAccessRequestUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<GrantAccess>>> call({
    required int accessedUserId,
  }) =>
      repository.acceptRequest(accessedUserId: accessedUserId);
}

class RejectAccessRequestUsecase {
  final GrantRepository repository;
  RejectAccessRequestUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<GrantAccess>>> call({
    required int accessedUserId,
  }) =>
      repository.rejectRequest(accessedUserId: accessedUserId);
}

class GetRequestsReceivedUsecase {
  final GrantRepository repository;
  GetRequestsReceivedUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<List<GrantAccess>>>> call() =>
      repository.getRequestsReceived();
}

class GetRequestsSentUsecase {
  final GrantRepository repository;
  GetRequestsSentUsecase({required this.repository});

  Future<Either<Failure, ApiResponse<List<GrantAccess>>>> call() =>
      repository.getRequestsSent();
}
