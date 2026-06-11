import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/core/util/server_exception.dart';
import 'package:manshan/src/grant/data/datasource/grant_remote_datasource.dart';
import 'package:manshan/src/grant/data/model/grant_request_model.dart';
import 'package:manshan/src/grant/domain/entity/grant_access.dart';
import 'package:manshan/src/grant/domain/repository/grant_repository.dart';
import 'package:manshan/src/grant/domain/entity/paginated_grant_user.dart';

class GrantRepositoryImpl implements GrantRepository {
  final GrantRemoteDatasource remoteDatasource;

  const GrantRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, ApiResponse<GrantAccess>>> grantAccess({
    required int accessedUserId,
  }) async {
    try {
      final response = await remoteDatasource.grantAccess(
        request: GrantRequestModel(accessedUserId: accessedUserId),
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<Map<String, dynamic>>>> revokeAccess({
    required int accessedUserId,
  }) async {
    try {
      final response = await remoteDatasource.revokeAccess(
        request: GrantRequestModel(accessedUserId: accessedUserId),
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<List<GrantAccess>>>> getMyAccesses() async {
    try {
      final response = await remoteDatasource.getMyAccesses();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<PaginatedGrantUser>>> getUsers({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await remoteDatasource.getUsers(page: page, limit: limit);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<GrantAccess>>> acceptRequest({
    required int accessedUserId,
  }) async {
    try {
      final response = await remoteDatasource.acceptRequest(
        request: GrantRequestModel(accessedUserId: accessedUserId),
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<GrantAccess>>> rejectRequest({
    required int accessedUserId,
  }) async {
    try {
      final response = await remoteDatasource.rejectRequest(
        request: GrantRequestModel(accessedUserId: accessedUserId),
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<List<GrantAccess>>>> getRequestsReceived() async {
    try {
      final response = await remoteDatasource.getRequestsReceived();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<List<GrantAccess>>>> getRequestsSent() async {
    try {
      final response = await remoteDatasource.getRequestsSent();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure("Unexpected Error"));
    }
  }
}