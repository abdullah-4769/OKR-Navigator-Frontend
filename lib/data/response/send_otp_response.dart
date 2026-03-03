import '../../generated/models/responses/base_response.dart';

class SendOtpResponse extends BaseResponse {
  SendOtpResponse({
    super.statusCode,
    super.message,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
    );
  }
}