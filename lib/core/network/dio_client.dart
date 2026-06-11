import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:manshan/core/service/storage_service.dart';

class DioClient {
  static Dio createDio(StorageService storage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: "http://192.168.122.1:8000",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = storage.token;
          debugPrint("TOKEN FROM STORAGE: $token");
          if (token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          debugPrint("HEADERS: ${options.headers}");
          handler.next(options);
        },
      ),
    );
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );

    return dio;
  }
}
