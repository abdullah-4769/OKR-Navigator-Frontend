import 'dart:convert';
import 'dart:developer';
import 'package:game_app/generated/models/responses/auth/login_response.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../generated/models/authmodel.dart';
import '../../generated/models/responses/auth/login_response.dart' hide User;
import '../datasources/auth_api.dart';
import 'storage_repository.dart';
import '../../services/shared_preference.dart';
import '../../generated/models/requests/register_request.dart';

class AuthRepository {
  final AuthApi _authApi; // non-nullable now

  AuthRepository(this._authApi);

  // ==================== EMAIL LOGIN ====================
  Future<User> login(String email, String password) async {
    if (_authApi == null) throw Exception("AuthApi not provided");

    final response = await _authApi!.login({
      'email': email,
      'password': password,
    });

    if (response.accessToken == null || response.user == null) {
      throw Exception('Invalid credentials');
    }

    await Get.find<StorageRepository>().saveAccessToken(response.accessToken!);
    await Get.find<StorageRepository>().saveUser(response.user!);

    if (response.user!.id!.isNotEmpty) {
      // await SharedPrefs.saveUserId(response!.user!.id);
      // await SharedPrefs.saveUserName(response.user!.name);
    }

    return response.user!;
  }

  // ==================== GOOGLE LOGIN (FIXED) ====================
  Future<GoogleUser> loginWithGoogle(String idToken) async {
    try {
      log("Sending Google idToken to backend...");

      final response = await http.post(
        Uri.parse('https://okr-navigator-backend.onrender.com/auth/google/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      log("Google Login: ${response.statusCode} | ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final Map<String, dynamic> payload = json['data'] ?? json;

        final user = SaveUser.fromJson(payload['user']);

        // Now SaveUser IS A User → No casting needed!
        // await Get.find<StorageRepository>().saveUser(user);

        return user;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Google login failed');
      }
    } catch (e, s) {
      log("Google login error: $e", stackTrace: s);
      rethrow;
    }
  }

  // ==================== OTHER METHODS (unchanged) ====================
  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String language,
  }) async {
    if (_authApi == null) throw Exception("AuthApi not provided");

    final response = await _authApi!.register(
      RegisterRequest(
        name: name,
        email: email,
        password: password,
        phone: phone,
        language: language,
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.message ?? 'Registration failed');
    }
  }

  Future<void> logout() async {
    await SharedPrefs.clearAll();
    await Get.find<StorageRepository>().clearUser();
    await Get.find<StorageRepository>().clearAccessToken();
    log("Logged out & data cleared");
  }
}