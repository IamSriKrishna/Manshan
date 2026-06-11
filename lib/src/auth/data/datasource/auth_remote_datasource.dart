import 'package:dio/dio.dart';
import 'package:manshan/core/schema/api_response.dart';
import 'package:manshan/core/util/dio_handler.dart';
import 'package:manshan/core/util/server_exception.dart';
import 'package:manshan/src/auth/data/model/auth_token_model.dart';
import 'package:manshan/src/auth/data/model/auth_user_model.dart';
import 'package:manshan/src/auth/data/model/signin_request_model.dart';
import 'package:manshan/src/auth/data/model/signup_request_model.dart';

abstract class AuthRemoteDatasource {
  Future<ApiResponse<AuthUserModel>> signUp(SignupRequestModel request);
  Future<ApiResponse<AuthTokenModel>> signIn(SigninRequestModel request);
  Future<ApiResponse<AuthUserModel>> authMe();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio dio;
  const AuthRemoteDatasourceImpl({required this.dio});

  @override
  Future<ApiResponse<AuthUserModel>> signUp(SignupRequestModel request) async {
    try {
      final response = await dio.post("/auth/register", data: request.toJson());

      return ApiResponse<AuthUserModel>.fromJson(
        response.data,
        (data) => AuthUserModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<AuthTokenModel>> signIn(SigninRequestModel request) async {
    try {
      final response = await dio.post("/auth/login", data: request.toJson());

      return ApiResponse<AuthTokenModel>.fromJson(
        response.data,
        (data) => AuthTokenModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }

  @override
  Future<ApiResponse<AuthUserModel>> authMe() async {
    try {
      final response = await dio.get("/auth/me");

      return ApiResponse<AuthUserModel>.fromJson(
        response.data,
        (data) => AuthUserModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw ServerException(DioHandler.handle(e));
    } catch (_) {
      throw const ServerException("Something went wrong");
    }
  }
}
