  class BaseResponse {
  final int? statusCode;
  final String? message;

  const BaseResponse({required this.statusCode, required this.message});

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      BaseResponse(statusCode: json['statusCode'], message: json['message']);
}
