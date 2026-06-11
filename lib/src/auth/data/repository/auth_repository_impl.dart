import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/core/util/server_exception.dart';
import 'package:manshan/src/auth/data/datasource/auth_remote_datasource.dart';
import 'package:manshan/src/auth/data/model/signin_request_model.dart';
import 'package:manshan/src/auth/data/model/signup_request_model.dart';
import 'package:manshan/src/auth/domain/entity/auth_token.dart';
import 'package:manshan/src/auth/domain/entity/auth_user.dart';
import 'package:manshan/src/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, ApiResponse<AuthUser>>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDatasource.signUp(
        SignupRequestModel(email: email, name: name, password: password),
      );

      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return const Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<AuthToken>>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDatasource.signIn(
        SigninRequestModel(email: email, password: password),
      );

      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return const Left(Failure("Unexpected Error"));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<AuthUser>>> authMe() async {
    try {
      final response = await remoteDatasource.authMe();

      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return const Left(Failure("Unexpected Error"));
    }
  }
}
