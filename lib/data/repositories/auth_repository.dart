import 'dart:developer';

import 'package:game_app/data/datasources/auth_api.dart';
import 'package:get/get.dart';

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
    await Get.find<StorageRepository>().saveAccessToken(response.accessToken!);
    return response.user!;
  }
}
