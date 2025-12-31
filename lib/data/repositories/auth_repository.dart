// import 'dart:convert';
// import 'dart:developer';
// import 'package:game_app/generated/models/responses/auth/login_response.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
//
// import '../../generated/models/authmodel.dart';
// import '../../generated/models/responses/auth/login_response.dart' hide User;
// import '../datasources/auth_api.dart';
// import 'storage_repository.dart';
// import '../../services/shared_preference.dart';
// import '../../generated/models/requests/register_request.dart';
//
// class AuthRepository {
//   final AuthApi _authApi; // non-nullable now
//
//   AuthRepository(this._authApi);
//
//   // ==================== EMAIL LOGIN ====================
//   Future<User> login(String email, String password) async {
//     if (_authApi == null) throw Exception("AuthApi not provided");
//
//     final response = await _authApi!.login({
//       'email': email,
//       'password': password,
//     });
//
//     if (response.accessToken == null || response.user == null) {
//       throw Exception('Invalid credentials');
//     }
//
//     await Get.find<StorageRepository>().saveAccessToken(response.accessToken!);
//     await Get.find<StorageRepository>().saveUser(response.user!);
//
//     if (response.user!.id!.isNotEmpty) {
//       // await SharedPrefs.saveUserId(response!.user!.id);
//       // await SharedPrefs.saveUserName(response.user!.name);
//     }
//
//     return response.user!;
//   }
//
//   // ==================== GOOGLE LOGIN (FIXED) ====================
//   // Future<GoogleUser> loginWithGoogle(String idToken) async {
//   //   try {
//   //     log("Sending Google idToken to backend...");
//   //
//   //     final response = await http.post(
//   //       Uri.parse('https://okr-navigator-backend.onrender.com/auth/google/login'),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode({'idToken': idToken}),
//   //     );
//   //
//   //     log("Google Login: ${response.statusCode} | ${response.body}");
//   //
//   //     if (response.statusCode == 200 || response.statusCode == 201) {
//   //       final Map<String, dynamic> json = jsonDecode(response.body);
//   //       final Map<String, dynamic> payload = json['data'] ?? json;
//   //
//   //       final user = SaveUser.fromJson(payload['user']);
//   //
//   //       // Now SaveUser IS A User → No casting needed!
//   //       // await Get.find<StorageRepository>().saveUser(user);
//   //
//   //       return user;
//   //     } else {
//   //       final error = jsonDecode(response.body);
//   //       throw Exception(error['message'] ?? 'Google login failed');
//   //     }
//   //   } catch (e, s) {
//   //     log("Google login error: $e", stackTrace: s);
//   //     rethrow;
//   //   }
//   // }
// // ==================== GOOGLE LOGIN (FIXED) ====================
//   Future<GoogleUser> loginWithGoogle(String idToken) async {
//     try {
//       log("Sending Google idToken to backend...");
//
//       final response = await http.post(
//         Uri.parse('https://okr-navigator-backend.onrender.com/auth/google/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'idToken': idToken}),
//       );
//
//       log("Google Login: ${response.statusCode} | ${response.body}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final Map<String, dynamic> json = jsonDecode(response.body);
//         final Map<String, dynamic> payload = json['data'] ?? json;
//
//         final user = SaveUser.fromJson(payload['user']);
//
//         // ✅ CRITICAL FIX: Save the user to StorageRepository
//         await Get.find<StorageRepository>().saveGoogleUser(user);
//
//         // ✅ Also save access token if provided
//         if (payload['accessToken'] != null) {
//           await Get.find<StorageRepository>().saveAccessToken(payload['accessToken']);
//         }
//
//         log("✅ Google user saved: ${user.id}");
//         return user;
//       } else {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'Google login failed');
//       }
//     } catch (e, s) {
//       log("Google login error: $e", stackTrace: s);
//       rethrow;
//     }
//   }
//   // ==================== OTHER METHODS (unchanged) ====================
//   Future<void> register({
//     required String name,
//     required String phone,
//     required String email,
//     required String password,
//     required String language,
//   }) async {
//     if (_authApi == null) throw Exception("AuthApi not provided");
//
//     final response = await _authApi!.register(
//       RegisterRequest(
//         name: name,
//         email: email,
//         password: password,
//         phone: phone,
//         language: language,
//       ),
//     );
//
//     if (response.statusCode != 200 && response.statusCode != 201) {
//       throw Exception(response.message ?? 'Registration failed');
//     }
//   }
//
//   Future<void> logout() async {
//     await SharedPrefs.clearAll();
//     await Get.find<StorageRepository>().clearUser();
//     await Get.find<StorageRepository>().clearAccessToken();
//     log("Logged out & data cleared");
//   }
// }
import 'dart:convert';
import 'dart:developer';
import 'package:game_app/generated/models/responses/auth/login_response.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../generated/models/authmodel.dart';
import '../../generated/models/forget_and_send_otp.dart';
import '../../generated/models/responses/auth/login_response.dart' hide User;
import '../datasources/auth_api.dart';
import 'storage_repository.dart';
import '../../services/shared_preference.dart';
import '../../generated/models/requests/register_request.dart';

class AuthRepository {
  final AuthApi _authApi;
  static const String baseUrl = 'https://okr-navigator-backend.onrender.com';

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

  // ==================== GOOGLE LOGIN ====================
  Future<GoogleUser> loginWithGoogle(String idToken) async {
    try {
      log("Sending Google idToken to backend...");

      final response = await http.post(
        Uri.parse('$baseUrl/auth/google/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      log("Google Login: ${response.statusCode} | ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final Map<String, dynamic> payload = json['data'] ?? json;

        final user = SaveUser.fromJson(payload['user']);

        // ✅ Save the user to StorageRepository
        await Get.find<StorageRepository>().saveGoogleUser(user);

        // ✅ Also save access token if provided
        if (payload['accessToken'] != null) {
          await Get.find<StorageRepository>().saveAccessToken(payload['accessToken']);
        }

        log("✅ Google user saved: ${user.id}");
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

  // ==================== REGISTER ====================
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

  // ==================== FORGOT PASSWORD - SEND OTP ====================
  Future<SendOtpResponse> sendOtp(String email) async {
    try {
      log('📧 Sending OTP to: $email');

      final request = SendOtpRequest(email: email);

      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - unable to send OTP');
        },
      );

      log('📧 Send OTP Response: ${response.statusCode} | ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final otpResponse = SendOtpResponse.fromJson(json);

        log('✅ OTP sent successfully: ${otpResponse.message}');
        return otpResponse;
      } else {
        final error = jsonDecode(response.body);
        final errorMsg = error['message'] ?? 'Failed to send OTP';
        log('❌ Send OTP failed: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e, s) {
      log('❌ Send OTP error: $e', stackTrace: s);
      rethrow;
    }
  }

  // ==================== FORGOT PASSWORD - RESET PASSWORD ====================
  Future<ResetPasswordResponse> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      log('🔐 Resetting password for: $email');

      final request = ResetPasswordRequest(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - unable to reset password');
        },
      );

      log('🔐 Reset Password Response: ${response.statusCode} | ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final resetResponse = ResetPasswordResponse.fromJson(json);

        log('✅ Password reset successfully: ${resetResponse.message}');
        return resetResponse;
      } else {
        final error = jsonDecode(response.body);
        final errorMsg = error['message'] ?? 'Failed to reset password';

        // Handle specific error cases
        if (response.statusCode == 400) {
          log('❌ Invalid OTP or email');
          throw Exception('Invalid OTP or email address');
        } else if (response.statusCode == 404) {
          log('❌ Email not found');
          throw Exception('Email not registered');
        }

        log('❌ Reset password failed: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e, s) {
      log('❌ Reset password error: $e', stackTrace: s);
      rethrow;
    }
  }

  // ==================== LOGOUT ====================
  Future<void> logout() async {
    await SharedPrefs.clearAll();
    await Get.find<StorageRepository>().clearUser();
    await Get.find<StorageRepository>().clearAccessToken();
    log("Logged out & data cleared");
  }
}