// import 'dart:developer';
// import '../../generated/models/authmodel.dart';
// import '../../services/authapi_service.dart';
// import '../../services/google_auth_service.dart';
// import 'storage_repository.dart';
// import 'package:get/get.dart';
//
// class AuthRepo {
//   final GoogleAuthService _googleAuthService = GoogleAuthService();
//   final AuthApiService _authApiService = AuthApiService();
//
//   /// Google Login - Complete Flow
//   Future<AuthResponse> loginWithGoogle() async {
//     try {
//       log("🔵 Starting Google Login Flow...");
//
//       // Step 1: Get ID Token from Google
//       final idToken = await _googleAuthService.signInWithGoogle();
//
//       if (idToken == null) {
//         throw Exception('Google sign-in cancelled or failed');
//       }
//
//       log("✅ ID Token received from Google");
//
//       // Step 2: Send ID Token to Backend
//       final authResponse = await _authApiService.googleLogin(idToken);
//
//       log("✅ Backend authentication successful");
//       log("👤 User: ${authResponse.user.name} (${authResponse.user.email})");
//
//       // Step 3: Save tokens and user data
//       await Get.find<StorageRepository>().saveAccessToken(authResponse.accessToken);
//       //
//       // if (authResponse.refreshToken != null) {
//       //   await Get.find<StorageRepository>().saveRefreshToken(authResponse.refreshToken!);
//       // }
//
//       // await Get.find<StorageRepository>().saveUser(authResponse.user);
//
//       return authResponse;
//
//     } catch (e, s) {
//       log("❌ Google login flow error: $e", stackTrace: s);
//       rethrow;
//     }
//   }
//
//   /// Email/Password Login
//   Future<UserModel> login(String email, String password) async {
//     try {
//       final authResponse = await _authApiService.login(email, password);
//
//       // Save tokens and user
//       await Get.find<StorageRepository>().saveAccessToken(authResponse.accessToken);
//
//       // if (authResponse.refreshToken != null) {
//       //   await Get.find<StorageRepository>().saveRefreshToken(authResponse.refreshToken!);
//       // }
//
//       // await Get.find<StorageRepository>().saveUser(authResponse.user);
//
//       return authResponse.user;
//     } catch (e) {
//       log("❌ Login error: $e");
//       rethrow;
//     }
//   }
//
//   /// Register
//   Future<UserModel> register({
//     required String name,
//     required String email,
//     required String password,
//     String? phone,
//     String? language,
//   }) async {
//     try {
//       final authResponse = await _authApiService.register(
//         name: name,
//         email: email,
//         password: password,
//         phone: phone,
//         language: language,
//       );
//
//       // Save tokens and user
//       await Get.find<StorageRepository>().saveAccessToken(authResponse.accessToken);
//
//       // if (authResponse.refreshToken != null) {
//       //   await Get.find<StorageRepository>().saveRefreshToken(authResponse.refreshToken!);
//       // }
//
//       // await Get.find<StorageRepository>().saveUser(authResponse.user);
//
//       return authResponse.user;
//     } catch (e) {
//       log("❌ Register error: $e");
//       rethrow;
//     }
//   }
//
//   /// Logout
//   Future<void> logout() async {
//     try {
//       final accessToken = Get.find<StorageRepository>().getAccessToken();
//
//       if (accessToken != null) {
//         await _authApiService.logout(accessToken);
//       }
//
//       // Sign out from Google
//       await _googleAuthService.signOut();
//
//       // Clear local storage
//       await Get.find<StorageRepository>().clearAllUserData();
//
//       log("✅ Logout successful");
//     } catch (e) {
//       log("❌ Logout error: $e");
//       // Clear local data even if API call fails
//       await Get.find<StorageRepository>().clearAllUserData();
//     }
//   }
//
//   /// Get Current User from API
//   Future<UserModel> getCurrentUser() async {
//     try {
//       final accessToken = Get.find<StorageRepository>().getAccessToken();
//
//       if (accessToken == null) {
//         throw Exception('No access token found');
//       }
//
//       return await _authApiService.getCurrentUser(accessToken);
//     } catch (e) {
//       log("❌ Get current user error: $e");
//       rethrow;
//     }
//   }
//
//   /// Refresh Access Token
//
//   /// Check if user is logged in
//   bool isLoggedIn() {
//     final accessToken = Get.find<StorageRepository>().getAccessToken();
//     return accessToken != null && accessToken.isNotEmpty;
//   }
// }