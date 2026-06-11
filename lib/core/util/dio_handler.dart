import 'package:dio/dio.dart';

class DioHandler {
  static String handle(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response?.data as Map<String, dynamic>;
      if (data["detail"] != null) {
        return data["detail"].toString();
      }
      if (data["message"] != null) {
        return data["message"].toString();
      }
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout";
      case DioExceptionType.sendTimeout:
        return "Send timeout";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout";
      case DioExceptionType.badResponse:
        return "Server error";
      case DioExceptionType.cancel:
        return "Request cancelled";
      case DioExceptionType.connectionError:
        return "No internet connection";
      default:
        return "Something went wrong";
    }
  }
}
