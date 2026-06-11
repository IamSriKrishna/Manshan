import 'package:dartz/dartz.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/failure.dart';
import 'package:manshan/core/util/usecase.dart';
import 'package:manshan/src/auth/domain/entity/auth_user.dart';
import 'package:manshan/src/auth/domain/repository/auth_repository.dart';

class SignupParams {
  final String name;
  final String email;
  final String password;

  SignupParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

class SignupUsecase extends Usecase<ApiResponse<AuthUser>, SignupParams> {
  final AuthRepository repository;
  SignupUsecase({required this.repository});

  @override
  Future<Either<Failure, ApiResponse<AuthUser>>> call(SignupParams params) {
    return repository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}
