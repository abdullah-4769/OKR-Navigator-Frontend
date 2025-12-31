// import 'dart:convert';
// import 'dart:developer';
// import 'package:game_app/data/network/app_url.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb;
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '../../generated/models/authmodel.dart'; // Email login User
// import '../../generated/models/responses/auth/login_response.dart'; // Google login models
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
//   /// Save joined challenge ID
//   Future<void> saveJoinedChallengeId(String challengeId) async {
//     try {
//       await _prefs.write('joined_challenge_id', challengeId);
//       log("✅ Saved joined challenge ID: $challengeId");
//     } catch (e) {
//       log("❌ Error saving joined challenge ID: $e");
//       rethrow;
//     }
//   }
//
//   /// Get joined challenge ID
//   String? getJoinedChallengeId() {
//     try {
//       return _prefs.read('joined_challenge_id');
//     } catch (e) {
//       log("❌ Error getting joined challenge ID: $e");
//       return null;
//     }
//   }
//
//   /// Clear joined challenge ID
//   Future<void> clearJoinedChallengeId() async {
//     await _prefs.remove('joined_challenge_id');
//   }
//   /// Save user from GOOGLE login (login_response.dart)
//   Future<void> saveGoogleUser(GoogleUser user) async {
//     // Check if SaveUser (which has avatarPicId)
//     String? avatarPicId;
//     if (user is SaveUser) {
//       avatarPicId = user.avatarPicId;
//     }
//
//     final userMap = {
//       'id': user.id,
//       'name': user.name,
//       'email': user.email,
//       'phone': user.phone,
//       'language': user.language,
//       'avatarPicId': avatarPicId, // Save avatar URL from Google
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
//
//
//   Future<void> clearAllUserData() async {
//     await _prefs.erase();
//   }
// }
// // import 'dart:convert';
// // import 'dart:developer';
// // import 'package:game_app/data/network/app_url.dart';
// // import 'package:firebase_auth/firebase_auth.dart' as fb;
// // import 'package:get/get.dart';
// // import 'package:get_storage/get_storage.dart';
// // import '../../generated/models/authmodel.dart'; // Email login User
// // import '../../generated/models/responses/auth/login_response.dart';
// //
// // class StorageRepository extends GetxService {
// //   final _prefs = GetStorage();
// //
// //   static const String _accessTokenKey = 'access-token';
// //   static const String _userDataKey = 'user-data';
// //   static const String _baseUrlKey = 'base-url';
// //   static const String _defaultBaseUrl = '${AppUrls.baseUrl}';
// //   static const String _fcmTokenKey = 'fcm-token';
// //
// //   Future<StorageRepository> init() async {
// //     await GetStorage.init();
// //     return this;
// //   }
// //
// //   // ------------------------------
// //   // User Methods - UNIFIED APPROACH
// //   // ------------------------------
// //
// //   /// Save user from EMAIL login (authmodel.dart)
// //   Future<void> saveUser(User user) async {
// //     final userMap = {
// //       'id': user.id,
// //       'name': user.name,
// //       'email': user.email,
// //       'phone': user.phone,
// //       'language': user.language,
// //     };
// //     log("Saving EMAIL user: $userMap");
// //     await _prefs.write(_userDataKey, jsonEncode(userMap));
// //   }
// //
// //   /// Save user from GOOGLE login (login_response.dart)
// //   Future<void> saveGoogleUser(GoogleUser user) async {
// //     final userMap = {
// //       'id': user.id,
// //       'name': user.name,
// //       'email': user.email,
// //       'phone': user.phone,
// //       'language': user.language,
// //     };
// //     log("Saving GOOGLE user: $userMap");
// //     await _prefs.write(_userDataKey, jsonEncode(userMap));
// //   }
// //
// //   /// Get saved user - WORKS FOR BOTH EMAIL AND GOOGLE
// //   User? getUser() {
// //     try {
// //       final json = _prefs.read(_userDataKey);
// //       if (json != null) {
// //         log("Retrieved user JSON: $json");
// //         final decoded = jsonDecode(json);
// //         return User.fromJson(decoded);
// //       }
// //       log("No user data found in storage");
// //       return null;
// //     } catch (e) {
// //       log("Error retrieving user: $e");
// //       return null;
// //     }
// //   }
// //
// //   /// Get user ID directly (more reliable)
// //   String? getUserId() {
// //     try {
// //       final json = _prefs.read(_userDataKey);
// //       if (json != null) {
// //         final decoded = jsonDecode(json);
// //         final id = decoded['id']?.toString();
// //         log("Retrieved user ID: $id");
// //         return id;
// //       }
// //       log("No user ID found in storage");
// //       return null;
// //     } catch (e) {
// //       log("Error retrieving user ID: $e");
// //       return null;
// //     }
// //   }
// //
// //   /// Check if user is logged in
// //   bool isLoggedIn() {
// //     final userId = getUserId();
// //     return userId != null && userId.isNotEmpty;
// //   }
// //
// //   /// Clear saved user
// //   Future<void> clearUser() async => await _prefs.remove(_userDataKey);
// //
// //   /// Convert Firebase User to app User model
// //   User firebaseUserToAppUser(fb.User firebaseUser) {
// //     return User(
// //       id: firebaseUser.uid,
// //       name: firebaseUser.displayName ?? '',
// //       email: firebaseUser.email ?? '',
// //     );
// //   }
// //
// //   // ------------------------------
// //   // Token Methods
// //   // ------------------------------
// //
// //   Future<void> saveAccessToken(String token) async {
// //     await _prefs.write(_accessTokenKey, token);
// //   }
// //
// //   String? getAccessToken() => _prefs.read(_accessTokenKey);
// //
// //   Future<void> clearAccessToken() async => await _prefs.remove(_accessTokenKey);
// //
// //   // ------------------------------
// //   // Base URL Methods
// //   // ------------------------------
// //
// //   Future<String> getBaseUrl() async {
// //     try {
// //       final url = _prefs.read<String>(_baseUrlKey);
// //       return url ?? _defaultBaseUrl;
// //     } catch (e) {
// //       return _defaultBaseUrl;
// //     }
// //   }
// //
// //   Future<void> setBaseUrl(String url) async {
// //     await _prefs.write(_baseUrlKey, url);
// //   }
// //
// //   String getBaseUrlSync() {
// //     try {
// //       return _prefs.read<String>(_baseUrlKey) ?? _defaultBaseUrl;
// //     } catch (e) {
// //       return _defaultBaseUrl;
// //     }
// //   }
// //
// //   // ------------------------------
// //   // FCM Token Methods
// //   // ------------------------------
// //
// //   Future<void> saveFCMToken(String token) async =>
// //       await _prefs.write(_fcmTokenKey, token);
// //
// //   String? getFCMToken() => _prefs.read(_fcmTokenKey);
// //
// //   Future<void> clearFCMToken() async => await _prefs.remove(_fcmTokenKey);
// //
// //   // ------------------------------
// //   // Clear All Data
// //   // ------------------------------
// //
// //   Future<void> clearAllUserData() async {
// //     await _prefs.erase();
// //   }
// // }
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
      'avatarPicId': user.avatarPicId ?? '', // ✅ Save avatar if available
    };
    log("💾 Saving EMAIL user: $userMap");
    await _prefs.write(_userDataKey, jsonEncode(userMap));
  }

  /// Save joined challenge ID
  Future<void> saveJoinedChallengeId(String challengeId) async {
    try {
      await _prefs.write('joined_challenge_id', challengeId);
      log("✅ Saved joined challenge ID: $challengeId");
    } catch (e) {
      log("❌ Error saving joined challenge ID: $e");
      rethrow;
    }
  }

  /// Get joined challenge ID
  String? getJoinedChallengeId() {
    try {
      return _prefs.read('joined_challenge_id');
    } catch (e) {
      log("❌ Error getting joined challenge ID: $e");
      return null;
    }
  }

  /// Clear joined challenge ID
  Future<void> clearJoinedChallengeId() async {
    await _prefs.remove('joined_challenge_id');
  }

  /// Save user from GOOGLE login (login_response.dart)
  Future<void> saveGoogleUser(GoogleUser user) async {
    // Check if SaveUser (which has avatarPicId)
    String? avatarPicId;
    if (user is SaveUser) {
      avatarPicId = user.avatarPicId;
      log("🔍 SaveUser detected with avatarPicId: $avatarPicId");
    }

    final userMap = {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'language': user.language,
      'avatarPicId': avatarPicId ?? '', // ✅ Save avatar URL from Google
    };
    log("💾 Saving GOOGLE user: $userMap");
    await _prefs.write(_userDataKey, jsonEncode(userMap));
  }
  Map<String, dynamic>? getRawUserData() {
    try {
      final raw = _prefs.read(_userDataKey);
      if (raw == null) return null;

      if (raw is String) {
        return jsonDecode(raw) as Map<String, dynamic>?;
      } else if (raw is Map) {
        return Map<String, dynamic>.from(raw);
      }
      return null;
    } catch (e) {
      print('Error reading raw user-data: $e');
      return null;
    }
  }
  /// Update user avatar in storage
  Future<void> updateUserAvatar(String avatarPicId) async {
    try {
      final json = _prefs.read(_userDataKey);
      if (json != null) {
        // Handle both Map and String formats
        Map<String, dynamic> decoded;
        if (json is String) {
          decoded = jsonDecode(json);
        } else if (json is Map) {
          decoded = Map<String, dynamic>.from(json);
        } else {
          throw Exception("Unexpected type: ${json.runtimeType}");
        }

        decoded['avatarPicId'] = avatarPicId;
        await _prefs.write(_userDataKey, jsonEncode(decoded));
        log("✅ Updated user avatar in storage: $avatarPicId");
      }
    } catch (e) {
      log("❌ Error updating user avatar: $e");
    }
  }

  /// Get saved user - WORKS FOR BOTH EMAIL AND GOOGLE
  User? getUser() {
    try {
      final json = _prefs.read(_userDataKey);
      if (json != null) {
        log("📖 Retrieved user data: $json");

        // Handle both Map and String formats
        Map<String, dynamic> decoded;
        if (json is String) {
          decoded = jsonDecode(json);
        } else if (json is Map) {
          decoded = Map<String, dynamic>.from(json);
        } else {
          throw Exception("Unexpected type: ${json.runtimeType}");
        }

        return User.fromJson(decoded);
      }
      log("⚠️ No user data found in storage");
      return null;
    } catch (e) {
      log("❌ Error retrieving user: $e");
      return null;
    }
  }

  /// Get user ID directly (more reliable)
  String? getUserId() {
    try {
      final json = _prefs.read(_userDataKey);
      if (json != null) {
        // Handle both Map and String formats
        Map<String, dynamic> decoded;
        if (json is String) {
          decoded = jsonDecode(json);
        } else if (json is Map) {
          decoded = Map<String, dynamic>.from(json);
        } else {
          return null;
        }

        final id = decoded['id']?.toString();
        log("🆔 Retrieved user ID: $id");
        return id;
      }
      log("⚠️ No user ID found in storage");
      return null;
    } catch (e) {
      log("❌ Error retrieving user ID: $e");
      return null;
    }
  }

  /// Get user avatar directly
  String? getUserAvatar() {
    try {
      final json = _prefs.read(_userDataKey);
      if (json != null) {
        // Handle both Map and String formats
        Map<String, dynamic> decoded;
        if (json is String) {
          decoded = jsonDecode(json);
        } else if (json is Map) {
          decoded = Map<String, dynamic>.from(json);
        } else {
          return null;
        }

        final avatar = decoded['avatarPicId']?.toString();
        log("🖼️ Retrieved user avatar: $avatar");
        return avatar;
      }
      log("⚠️ No user avatar found in storage");
      return null;
    } catch (e) {
      log("❌ Error retrieving user avatar: $e");
      return null;
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    final userId = getUserId();
    return userId != null && userId.isNotEmpty;
  }

  /// Clear saved user
  Future<void> clearUser() async {
    await _prefs.remove(_userDataKey);
    log("🗑️ Cleared user data");
  }

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
    log("💾 Saved access token");
  }

  String? getAccessToken() => _prefs.read(_accessTokenKey);

  Future<void> clearAccessToken() async {
    await _prefs.remove(_accessTokenKey);
    log("🗑️ Cleared access token");
  }

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
    log("💾 Saved base URL: $url");
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

  Future<void> saveFCMToken(String token) async {
    await _prefs.write(_fcmTokenKey, token);
    log("💾 Saved FCM token");
  }

  String? getFCMToken() => _prefs.read(_fcmTokenKey);

  Future<void> clearFCMToken() async {
    await _prefs.remove(_fcmTokenKey);
    log("🗑️ Cleared FCM token");
  }

  // ------------------------------
  // Clear All Data
  // ------------------------------

  Future<void> clearAllUserData() async {
    await _prefs.erase();
    log("🗑️ Cleared all user data");
  }
}