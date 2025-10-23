// import 'dart:convert';
//
// import 'package:get_storage/get_storage.dart';
//
// import '../../generated/models/responses/auth/login_response.dart';
//
// class StorageRepository {
//   final _prefs = GetStorage();
//   static const String _accessTokenKey = 'access-token';
//   static const String _userDataKey = 'user-data';
//
//   Future<void> saveUser(User user) async {
//     await _prefs.write(_userDataKey, jsonEncode(user.toJson()));
//   }
//
//   User? getUser() {
//     final json = _prefs.read(_userDataKey);
//     if (json != null) {
//       return User.fromJson(jsonDecode(json));
//     }
//     return null;
//   }
//
//   String? getAccessToken() => _prefs.read(_accessTokenKey);
//
//   Future<void> saveAccessToken(String token) async =>
//       _prefs.write(_accessTokenKey, token);
//
//   Future<void> clearAllUserData() async => await _prefs.erase();
// }
//
//
// lib/data/repositories/storage_repository.dart

import 'dart:convert';
import 'package:game_app/data/network/app_url.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../generated/models/responses/auth/login_response.dart';

class StorageRepository extends GetxService {
  final _prefs = GetStorage();

  static const String _accessTokenKey = 'access-token';



  static const String _userDataKey = 'user-data';
  static const String _baseUrlKey = 'base-url';
  static const String _defaultBaseUrl = '${AppUrls.baseUrl}';

  // Initialize method for GetX
  Future<StorageRepository> init() async {
    await GetStorage.init();
    return this;
  }

  // User methods
  Future<void> saveUser(User user) async {
    await _prefs.write(_userDataKey, jsonEncode(user.toJson()));
  }

  User? getUser() {
    final json = _prefs.read(_userDataKey);
    if (json != null) {
      return User.fromJson(jsonDecode(json));
    }
    return null;
  }

  // Token methods
  String? getAccessToken() => _prefs.read(_accessTokenKey);

  Future<void> saveAccessToken(String token) async =>
      _prefs.write(_accessTokenKey, token);

  // Base URL methods
  Future<String> getBaseUrl() async {
    try {
      final url = _prefs.read<String>(_baseUrlKey);
      return url ?? _defaultBaseUrl;
    } catch (e) {
      return _defaultBaseUrl;
    }
  }

  Future<void> setBaseUrl(String url) async {
    await _prefs.write(_baseUrlKey, url);
  }

  String getBaseUrlSync() {
    try {
      return _prefs.read<String>(_baseUrlKey) ?? _defaultBaseUrl;
    } catch (e) {
      return _defaultBaseUrl;
    }
  }

  // Clear data
  Future<void> clearAllUserData() async => await _prefs.erase();

  Future<void> clearAccessToken() async => await _prefs.remove(_accessTokenKey);

  Future<void> clearUser() async => await _prefs.remove(_userDataKey);
}