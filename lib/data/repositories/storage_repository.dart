import 'dart:convert';
import 'dart:developer';
import 'package:game_app/data/network/app_url.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../generated/models/authmodel.dart'; // Email login User
import '../../generated/models/responses/auth/login_response.dart'; // Google login models

class StorageRepository extends GetxService {
  final _prefs = GetStorage();

  static const String _accessTokenKey = 'access-token';
  static const String _userDataKey = 'user-data';
  static const String _baseUrlKey = 'base-url';
  static const String _defaultBaseUrl = '${AppUrls.baseUrl}';
  static const String _fcmTokenKey = 'fcm-token';

  Future<StorageRepository> init() async {
    await GetStorage.init();
    return this;
  }

  // ------------------------------
  // User Methods - UNIFIED APPROACH
  // ------------------------------

  /// Save user from EMAIL login (authmodel.dart)
  Future<void> saveUser(User user) async {
    final userMap = {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'language': user.language,
    };
    log("Saving EMAIL user: $userMap");
    await _prefs.write(_userDataKey, jsonEncode(userMap));
  }

  /// Save user from GOOGLE login (login_response.dart)
  Future<void> saveGoogleUser(GoogleUser user) async {
    // Check if SaveUser (which has avatarPicId)
    String? avatarPicId;
    if (user is SaveUser) {
      avatarPicId = user.avatarPicId;
    }

    final userMap = {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'language': user.language,
      'avatarPicId': avatarPicId, // Save avatar URL from Google
    };
    log("Saving GOOGLE user: $userMap");
    await _prefs.write(_userDataKey, jsonEncode(userMap));
  }

  /// Get saved user - WORKS FOR BOTH EMAIL AND GOOGLE
  User? getUser() {
    try {
      final json = _prefs.read(_userDataKey);
      if (json != null) {
        log("Retrieved user JSON: $json");
        final decoded = jsonDecode(json);
        return User.fromJson(decoded);
      }
      log("No user data found in storage");
      return null;
    } catch (e) {
      log("Error retrieving user: $e");
      return null;
    }
  }

  /// Get user ID directly (more reliable)
  String? getUserId() {
    try {
      final json = _prefs.read(_userDataKey);
      if (json != null) {
        final decoded = jsonDecode(json);
        final id = decoded['id']?.toString();
        log("Retrieved user ID: $id");
        return id;
      }
      log("No user ID found in storage");
      return null;
    } catch (e) {
      log("Error retrieving user ID: $e");
      return null;
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    final userId = getUserId();
    return userId != null && userId.isNotEmpty;
  }

  /// Clear saved user
  Future<void> clearUser() async => await _prefs.remove(_userDataKey);

  /// Convert Firebase User to app User model
  User firebaseUserToAppUser(fb.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
    );
  }

  // ------------------------------
  // Token Methods
  // ------------------------------

  Future<void> saveAccessToken(String token) async {
    await _prefs.write(_accessTokenKey, token);
  }

  String? getAccessToken() => _prefs.read(_accessTokenKey);

  Future<void> clearAccessToken() async => await _prefs.remove(_accessTokenKey);

  // ------------------------------
  // Base URL Methods
  // ------------------------------

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



  Future<void> clearAllUserData() async {
    await _prefs.erase();
  }
}
// import 'dart:convert';
// import 'dart:developer';
// import 'package:game_app/data/network/app_url.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb;
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '../../generated/models/authmodel.dart'; // Email login User
// import '../../generated/models/responses/auth/login_response.dart';
//
// class StorageRepository extends GetxService {
//   final _prefs = GetStorage();
//
//   static const String _accessTokenKey = 'access-token';
//   static const String _userDataKey = 'user-data';
//   static const String _baseUrlKey = 'base-url';
//   static const String _defaultBaseUrl = '${AppUrls.baseUrl}';
//   static const String _fcmTokenKey = 'fcm-token';
//
//   Future<StorageRepository> init() async {
//     await GetStorage.init();
//     return this;
//   }
//
//   // ------------------------------
//   // User Methods - UNIFIED APPROACH
//   // ------------------------------
//
//   /// Save user from EMAIL login (authmodel.dart)
//   Future<void> saveUser(User user) async {
//     final userMap = {
//       'id': user.id,
//       'name': user.name,
//       'email': user.email,
//       'phone': user.phone,
//       'language': user.language,
//     };
//     log("Saving EMAIL user: $userMap");
//     await _prefs.write(_userDataKey, jsonEncode(userMap));
//   }
//
//   /// Save user from GOOGLE login (login_response.dart)
//   Future<void> saveGoogleUser(GoogleUser user) async {
//     final userMap = {
//       'id': user.id,
//       'name': user.name,
//       'email': user.email,
//       'phone': user.phone,
//       'language': user.language,
//     };
//     log("Saving GOOGLE user: $userMap");
//     await _prefs.write(_userDataKey, jsonEncode(userMap));
//   }
//
//   /// Get saved user - WORKS FOR BOTH EMAIL AND GOOGLE
//   User? getUser() {
//     try {
//       final json = _prefs.read(_userDataKey);
//       if (json != null) {
//         log("Retrieved user JSON: $json");
//         final decoded = jsonDecode(json);
//         return User.fromJson(decoded);
//       }
//       log("No user data found in storage");
//       return null;
//     } catch (e) {
//       log("Error retrieving user: $e");
//       return null;
//     }
//   }
//
//   /// Get user ID directly (more reliable)
//   String? getUserId() {
//     try {
//       final json = _prefs.read(_userDataKey);
//       if (json != null) {
//         final decoded = jsonDecode(json);
//         final id = decoded['id']?.toString();
//         log("Retrieved user ID: $id");
//         return id;
//       }
//       log("No user ID found in storage");
//       return null;
//     } catch (e) {
//       log("Error retrieving user ID: $e");
//       return null;
//     }
//   }
//
//   /// Check if user is logged in
//   bool isLoggedIn() {
//     final userId = getUserId();
//     return userId != null && userId.isNotEmpty;
//   }
//
//   /// Clear saved user
//   Future<void> clearUser() async => await _prefs.remove(_userDataKey);
//
//   /// Convert Firebase User to app User model
//   User firebaseUserToAppUser(fb.User firebaseUser) {
//     return User(
//       id: firebaseUser.uid,
//       name: firebaseUser.displayName ?? '',
//       email: firebaseUser.email ?? '',
//     );
//   }
//
//   // ------------------------------
//   // Token Methods
//   // ------------------------------
//
//   Future<void> saveAccessToken(String token) async {
//     await _prefs.write(_accessTokenKey, token);
//   }
//
//   String? getAccessToken() => _prefs.read(_accessTokenKey);
//
//   Future<void> clearAccessToken() async => await _prefs.remove(_accessTokenKey);
//
//   // ------------------------------
//   // Base URL Methods
//   // ------------------------------
//
//   Future<String> getBaseUrl() async {
//     try {
//       final url = _prefs.read<String>(_baseUrlKey);
//       return url ?? _defaultBaseUrl;
//     } catch (e) {
//       return _defaultBaseUrl;
//     }
//   }
//
//   Future<void> setBaseUrl(String url) async {
//     await _prefs.write(_baseUrlKey, url);
//   }
//
//   String getBaseUrlSync() {
//     try {
//       return _prefs.read<String>(_baseUrlKey) ?? _defaultBaseUrl;
//     } catch (e) {
//       return _defaultBaseUrl;
//     }
//   }
//
//   // ------------------------------
//   // FCM Token Methods
//   // ------------------------------
//
//   Future<void> saveFCMToken(String token) async =>
//       await _prefs.write(_fcmTokenKey, token);
//
//   String? getFCMToken() => _prefs.read(_fcmTokenKey);
//
//   Future<void> clearFCMToken() async => await _prefs.remove(_fcmTokenKey);
//
//   // ------------------------------
//   // Clear All Data
//   // ------------------------------
//
//   Future<void> clearAllUserData() async {
//     await _prefs.erase();
//   }
// }
