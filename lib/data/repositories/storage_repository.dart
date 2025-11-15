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
  static const String _fcmTokenKey = 'fcm-token';

  /// Initialize GetStorage (call this at app startup)
  Future<StorageRepository> init() async {
    await GetStorage.init();
    return this;
  }

  // ------------------------------
  // User Methods
  // ------------------------------

  /// Save app user (email/password or Google login)
  Future<void> saveUser(User user) async {
    await _prefs.write(_userDataKey, jsonEncode(user.toJson()));
  }

  /// Get saved user
  User? getUser() {
    final json = _prefs.read(_userDataKey);
    if (json != null) {
      return User.fromJson(jsonDecode(json));
    }
    return null;
  }

  /// Clear saved user
  Future<void> clearUser() async => await _prefs.remove(_userDataKey);

  /// Convert Firebase User to app User model
  User firebaseUserToAppUser(firebaseUser) {
    return User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
    );
  }

  // ------------------------------
  // Token Methods
  // ------------------------------

  /// Get access token
  String? getAccessToken() => _prefs.read(_accessTokenKey);

  /// Save access token
  Future<void> saveAccessToken(String token) async =>
      await _prefs.write(_accessTokenKey, token);

  /// Clear access token
  Future<void> clearAccessToken() async => await _prefs.remove(_accessTokenKey);

  // ------------------------------
  // Base URL Methods
  // ------------------------------

  /// Get base URL (async)
  Future<String> getBaseUrl() async {
    try {
      final url = _prefs.read<String>(_baseUrlKey);
      return url ?? _defaultBaseUrl;
    } catch (e) {
      return _defaultBaseUrl;
    }
  }

  /// Set base URL
  Future<void> setBaseUrl(String url) async {
    await _prefs.write(_baseUrlKey, url);
  }

  /// Get base URL synchronously
  String getBaseUrlSync() {
    try {
      return _prefs.read<String>(_baseUrlKey) ?? _defaultBaseUrl;
    } catch (e) {
      return _defaultBaseUrl;
    }
  }

  // ------------------------------
  // FCM Token Methods
  // ------------------------------

  Future<void> saveFCMToken(String token) async =>
      await _prefs.write(_fcmTokenKey, token);

  String? getFCMToken() => _prefs.read(_fcmTokenKey);

  Future<void> clearFCMToken() async => await _prefs.remove(_fcmTokenKey);

  // ------------------------------
  // Clear All Data
  // ------------------------------

  Future<void> clearAllUserData() async => await _prefs.erase();
}
