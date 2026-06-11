import 'package:manshan/src/auth/domain/entity/auth_token.dart';

class AuthTokenModel extends AuthToken {
  const AuthTokenModel({super.accessToken, super.tokenType});

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['access_token'] ?? "",
      tokenType: json['token_type'] ?? "",
    );
  }
}
