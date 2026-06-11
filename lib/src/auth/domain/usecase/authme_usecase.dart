import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/core/util/usecase.dart';
import 'package:manshan/src/auth/domain/entity/auth_user.dart';
import 'package:manshan/src/auth/domain/repository/auth_repository.dart';

class AuthmeUsecase extends Usecase<ApiResponse<AuthUser>, NoParams> {
  final AuthRepository repository;
  AuthmeUsecase({required this.repository});

  @override
  Future<Either<Failure, ApiResponse<AuthUser>>> call(NoParams _) {
    return repository.authMe();
  }
}
