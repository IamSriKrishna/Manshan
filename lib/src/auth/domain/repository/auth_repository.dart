import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/src/auth/domain/entity/auth_token.dart';
import 'package:manshan/src/auth/domain/entity/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, ApiResponse<AuthUser>>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, ApiResponse<AuthToken>>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, ApiResponse<AuthUser>>> authMe();
}
