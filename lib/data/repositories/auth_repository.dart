import 'dart:convert';
import 'dart:developer';

import 'package:game_app/data/datasources/auth_api.dart';
import 'package:game_app/services/shared_preference.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as apiService;
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as _dio;

import '../../generated/models/requests/register_request.dart';
import '../../generated/models/responses/auth/login_response.dart';
import '../../generated/network.dart';
import 'storage_repository.dart';

class AuthRepository {
  final _authApi = AuthApi(dio);

  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String language,
  }) async {
    final response = await _authApi.register(
      RegisterRequest(
        name: name,
        email: email,
        password: password,
        phone: phone,
        language: language,
      ),
    );
    if (response.statusCode != null && response.statusCode != 200) {
      throw Exception(response.message ?? 'Something went wrong!');
    }
  }

  Future<User> login(String email, String password) async {
    final response = await _authApi.login({
      'email': email,
      'password': password,
    });

    log('I am reaching here!');

    if (response.accessToken == null || response.user == null) {
      throw Exception('Invalid credentials');
    }

    // ✅ Save access token
    await Get.find<StorageRepository>().saveAccessToken(response.accessToken!);

    if (response.user!.id != null) {
      await SharedPrefs.saveUserId(response.user!.id!);
      log('✅ User ID saved: ${response.user!.id}');
    }

    // ✅ Optionally save user name (if needed elsewhere in app)
    if (response.user!.name != null) {
      await SharedPrefs.saveUserName(response.user!.name!);
    }

    return response.user!;
  }

  /// ✅ Optional: Logout method
  Future<void> logout() async {
    await SharedPrefs.clearAll();
    //await Get.find<StorageRepository>().clearAccessToken();
    log('✅ User logged out');
  }

// Replace your loginWithGoogle method in AuthRepository with this:

  Future<bool> loginWithGoogle(String idToken) async {
    try {
      log('Sending Google token to backend...');

      final response = await http.post(
        Uri.parse(
            "https://okr-navigator-backend.onrender.com/auth/google/login"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id_token': idToken}),
      );

      log('Backend response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log("Backend login successful: $data");

        if (data['access_token'] != null) {
          await Get.find<StorageRepository>()
              .saveAccessToken(data['access_token']);
        }
        if (data['user'] != null) {
          if (data['user']['id'] != null) {
            await SharedPrefs.saveUserId(data['user']['id']);
          }
          if (data['user']['name'] != null) {
            await SharedPrefs.saveUserName(data['user']['name']);
          }
        }
        return true;
      } else {
        log("Backend login failed: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e, s) {
      log("Backend login error: $e", stackTrace: s);
      return false;
    }
  }
}











// this is  previous developer code

// import 'dart:developer';
//
// import 'package:game_app/data/datasources/auth_api.dart';
// import 'package:get/get.dart';
//
// import '../../generated/models/requests/register_request.dart';
// import '../../generated/models/responses/auth/login_response.dart';
// import '../../generated/network.dart';
// import 'storage_repository.dart';
//
// class AuthRepository {
//   final _authApi = AuthApi(dio);
//
//   Future<void> register({
//     required String name,
//     required String phone,
//     required String email,
//     required String password,
//     required String language,
//   }) async {
//     final response = await _authApi.register(
//       RegisterRequest(
//         name: name,
//         email: email,
//         password: password,
//         phone: phone,
//         language: language,
//       ),
//     );
//     if (response.statusCode != null && response.statusCode != 200) {
//       throw Exception(response.message ?? 'Something went wrong!');
//     }
//   }
//
//   Future<User> login(String email, String password) async {
//     final response = await _authApi.login({
//       'email': email,
//       'password': password,
//     });
//     log('I am reaching here!');
//     if (response.accessToken == null || response.user == null) {
//       throw Exception('Invalid credentials');
//     }
//     await Get.find<StorageRepository>().saveAccessToken(response.accessToken!);
//     return response.user!;
//   }
// }
