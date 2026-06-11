import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/grant/domain/entity/grant_access.dart';
import 'package:manshan/src/grant/domain/entity/paginated_grant_user.dart';

abstract class GrantRepository {
  Future<Either<Failure, ApiResponse<GrantAccess>>> grantAccess({
    required int accessedUserId,
  });

  Future<Either<Failure, ApiResponse<Map<String, dynamic>>>> revokeAccess({
    required int accessedUserId,
  });

  Future<Either<Failure, ApiResponse<List<GrantAccess>>>> getMyAccesses();
  
  Future<Either<Failure, ApiResponse<PaginatedGrantUser>>> getUsers({
    required int page,
    required int limit,
  });

  Future<Either<Failure, ApiResponse<GrantAccess>>> acceptRequest({
    required int accessedUserId,
  });

  Future<Either<Failure, ApiResponse<GrantAccess>>> rejectRequest({
    required int accessedUserId,
  });

  Future<Either<Failure, ApiResponse<List<GrantAccess>>>> getRequestsReceived();

  Future<Either<Failure, ApiResponse<List<GrantAccess>>>> getRequestsSent();
}
