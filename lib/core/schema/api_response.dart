class ApiResponse<T> {
  final T? data;
  final String message;
  final bool success;

  const ApiResponse({
    required this.data,
    required this.message,
    required this.success,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromData,
  ) {
    return ApiResponse(
      data: json['data'] != null ? fromData(json['data']) : null,
      message: json['message'] ?? "",
      success: json['success'] ?? false,
    );
  }
}
