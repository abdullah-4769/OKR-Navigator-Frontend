import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../../generated/models/responses/auth/login_response.dart';

class StorageRepository {
  final _prefs = GetStorage();
  static const String _accessTokenKey = 'access-token';
  static const String _userDataKey = 'user-data';

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

  String? getAccessToken() => _prefs.read(_accessTokenKey);

  Future<void> saveAccessToken(String token) async =>
      _prefs.write(_accessTokenKey, token);

  Future<void> clearAllUserData() async => await _prefs.erase();
}
