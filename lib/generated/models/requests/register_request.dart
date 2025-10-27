import 'base_request.dart';

class RegisterRequest extends BaseRequest {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String language;

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.language,
  });

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'phone': phone,
    'language': language,
  };
}
