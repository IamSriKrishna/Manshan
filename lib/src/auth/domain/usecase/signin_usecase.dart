import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/core/util/usecase.dart';
import 'package:manshan/src/auth/domain/entity/auth_token.dart';
import 'package:manshan/src/auth/domain/repository/auth_repository.dart';

class SigninParams {
  final String email;
  final String password;

  SigninParams({
    required this.email,
    required this.password,
  });
}

class SigninUsecase extends Usecase<ApiResponse<AuthToken>, SigninParams> {
  final AuthRepository repository;
  SigninUsecase({required this.repository});

  @override
  Future<Either<Failure, ApiResponse<AuthToken>>> call(SigninParams params) {
    return repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}
