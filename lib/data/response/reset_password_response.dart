import '../../generated/models/responses/base_response.dart';

class ResetPasswordResponse extends BaseResponse {
  ResetPasswordResponse({
    super.statusCode,
    super.message,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
    );
  }
}