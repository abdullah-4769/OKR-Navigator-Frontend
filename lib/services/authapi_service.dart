// data/services/auth_api_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../data/network/app_url.dart';
import '../generated/models/authmodel.dart';

class AuthApiService {
  Future<AuthResponse> googleLogin(String idToken) async {
    final url = Uri.parse('${AppUrls.baseUrl}/auth/google/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );

    log("Google API Response: ${response.statusCode}");
    log("Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      // Your backend returns: { "user": { ... } } → NOT wrapped in "data"
      final Map<String, dynamic> payload = json['data'] ?? json;

      // This returns AuthResponse object → NOT true/false!
      return AuthResponse.fromJson(payload);
    }

    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? 'Google login failed');
  }}