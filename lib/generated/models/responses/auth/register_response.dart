import '../base_response.dart';

class RegisterResponse extends BaseResponse {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String language;
  final String? avatarPicId;

  RegisterResponse({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.language,
    this.avatarPicId,
    super.statusCode,
    super.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        statusCode: json['statusCode'] as int?,
        message: json['message'],
        id: json['id'] as String? ?? '',  // Make it nullable with default
        email: json['email'] as String? ?? '',
        name: json['name'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        language: json['language'] as String? ?? '',
        avatarPicId: json['avatarPicId'] as String?,
      );
}
