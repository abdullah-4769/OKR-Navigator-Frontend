import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_app/data/repositories/auth_repository.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';
import '../../utils/snackbar_helper.dart';
import '../services/google_auth_service.dart';

class LoginController extends GetxController {
  // Email & Password Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final AuthRepository _authRepo = AuthRepository();
  final isGoogleLoading = false.obs;
  // Password visibility
  final RxBool isPasswordVisible = false.obs;
  final RxBool rememberMe = false.obs;
  final RxBool isLoading = false.obs;

  // Toggle Password Visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Toggle Remember Me
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  // Form Validation
  bool validateLoginForm() => formKey.currentState?.validate() ?? false;

  // Regular Email/Password Login
  Future<void> login() async {
    if (!validateLoginForm()) return;

    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final user = await Get.find<AuthRepository>().login(email, password);

      if (rememberMe.value) {
        await Get.find<StorageRepository>().saveUser(user);
      }

      SnackbarHelper.success('login_successful'.tr);
      await Get.offAllNamed(AppRoutes.start);

    } catch (e, s) {
      log('Login Error: $e', stackTrace: s);

      if (e.toString().toLowerCase().contains('invalid credentials') ||
          e.toString().toLowerCase().contains('wrong password') ||
          e.toString().toLowerCase().contains('user not found')) {
        SnackbarHelper.error('email_or_password_incorrect'.tr);
      } else if (e.toString().toLowerCase().contains('network') ||
          e.toString().toLowerCase().contains('connection')) {
        SnackbarHelper.error('network_error'.tr);
      } else {
        SnackbarHelper.error('login_failed'.tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Google Sign-In with Firebase
  Future<void> loginWithGoogle() async {
    if (isGoogleLoading.value) return;
    isGoogleLoading.value = true;

    try {
      final firebaseUser = await _googleAuthService.signInWithGoogle();
      if (firebaseUser != null) {
        final appUser = Get.find<StorageRepository>().firebaseUserToAppUser(firebaseUser);
        await Get.find<StorageRepository>().saveUser(appUser);
        Get.offAllNamed(AppRoutes.start);
      }


    } catch (e, s) {
      log("Error: $e", stackTrace: s);
      SnackbarHelper.error("google_signin_error".tr);
    } finally {
      isGoogleLoading.value = false;
    }
  }
  // Logout
  Future<void> logout() async {
    try {
      await _googleAuthService.signOut();
      await _authRepo.logout();
      SnackbarHelper.success("logout_successful".tr);
      Get.offAllNamed(AppRoutes.login);
    } catch (e, s) {
      log('Logout Error: $e', stackTrace: s);
      SnackbarHelper.error("logout_error".tr);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:game_app/data/repositories/auth_repository.dart';
// import 'package:game_app/data/repositories/storage_repository.dart';
// import 'package:game_app/presentation/routes/app_routes.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../utils/snackbar_helper.dart';
// import '../data/datasources/auth_api.dart';
// import '../generated/models/requests/register_request.dart';
// import '../generated/models/responses/auth/login_response.dart';
// import '../generated/network.dart';
// import '../services/google_auth_service.dart';
// import '../services/shared_preference.dart';
//
// class LoginController extends GetxController {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   final GoogleAuthService _googleAuthService = GoogleAuthService();
//   final AuthRepository _authRepo = AuthRepository();
//
//   final RxBool isPasswordVisible = false.obs;
//   final RxBool rememberMe = false.obs;
//   final isLoading = false.obs;
//
//   void togglePasswordVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }
//
//   void toggleRememberMe(bool? value) {
//     rememberMe.value = value ?? false;
//   }
//
//   bool validateLoginForm() => formKey.currentState?.validate() ?? false;
//
//   Future<void> login() async {
//     if (!validateLoginForm()) return;
//
//     isLoading.value = true;
//     try {
//       final email = emailController.text.trim();
//       final password = passwordController.text.trim();
//
//       final user = await Get.find<AuthRepository>().login(email, password);
//
//       if (rememberMe.value) {
//         await Get.find<StorageRepository>().saveUser(user);
//       }
//
//       SnackbarHelper.success('login_successful'.tr);
//       await Get.offAllNamed(AppRoutes.start);
//
//     } catch (e, s) {
//       log('Login Error: $e', stackTrace: s);
//
//       if (e.toString().toLowerCase().contains('invalid credentials') ||
//           e.toString().toLowerCase().contains('wrong password') ||
//           e.toString().toLowerCase().contains('user not found')) {
//         SnackbarHelper.error('email_or_password_incorrect'.tr);
//       } else if (e.toString().toLowerCase().contains('network') ||
//           e.toString().toLowerCase().contains('connection')) {
//         SnackbarHelper.error('network_error'.tr);
//       } else {
//         SnackbarHelper.error('login_failed'.tr);
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ✅ FIXED: Extract idToken from the Map returned by signInWithGoogle
//   Future<void> loginWithGoogle() async {
//     isLoading.value = true;
//
//     try {
//       // This returns Map<String, String>? with idToken, accessToken, etc.
//       final googleAuthData = await _googleAuthService.signInWithGoogle();
//
//       if (googleAuthData == null) {
//         Get.snackbar("Cancelled", "Google Sign-In cancelled by user");
//         return;
//       }
//
//       // ✅ Extract the idToken from the map
//       final idToken = googleAuthData['idToken'];
//
//       if (idToken == null || idToken.isEmpty) {
//         Get.snackbar("Error", "Failed to get ID token from Google");
//         return;
//       }
//
//       // Now pass the string idToken to the repository
//       final success = await _authRepo.loginWithGoogle(idToken);
//
//       if (success) {
//         Get.snackbar("Success", "Logged in successfully!");
//         await Get.offAllNamed(AppRoutes.start);
//       } else {
//         Get.snackbar("Error", "Failed to login via Google");
//       }
//     } catch (e, s) {
//       log('Google login error: $e', stackTrace: s);
//       Get.snackbar("Error", "An error occurred during Google sign-in");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> logout() async {
//     await _googleAuthService.signOut();
//     Get.snackbar("Success", "Logged out from Google");
//   }
//
//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }
// }
//
//
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
//
//     log('I am reaching here!');
//
//     if (response.accessToken == null || response.user == null) {
//       throw Exception('Invalid credentials');
//     }
//
//     await Get.find<StorageRepository>().saveAccessToken(response.accessToken!);
//
//     if (response.user!.id != null) {
//       await SharedPrefs.saveUserId(response.user!.id!);
//       log('✅ User ID saved: ${response.user!.id}');
//     }
//
//     if (response.user!.name != null) {
//       await SharedPrefs.saveUserName(response.user!.name!);
//     }
//
//     return response.user!;
//   }
//
//   Future<void> logout() async {
//     await SharedPrefs.clearAll();
//     log('✅ User logged out');
//   }
//
//   // ✅ FIXED: Corrected HTTP implementation
//   Future<bool> loginWithGoogle(String idToken) async {
//     try {
//       // ✅ Use http.post correctly with proper Uri and headers
//       final response = await http.post(
//         Uri.parse("https://okr-navigator-backend.onrender.com/auth/google/login"), // Fixed: removed double slash
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           'id_token': idToken, // Match your backend's expected field name
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         log("Backend login successful: ${response.body}");
//
//         // ✅ Parse the response and save tokens
//         final data = json.decode(response.body);
//
//         // Save access token if your backend returns it
//         if (data['access_token'] != null) {
//           await Get.find<StorageRepository>().saveAccessToken(data['access_token']);
//         }
//
//         // Save user data if needed
//         if (data['user'] != null && data['user']['id'] != null) {
//           await SharedPrefs.saveUserId(data['user']['id']);
//         }
//
//         return true;
//       } else {
//         log("Backend login failed: ${response.statusCode} - ${response.body}");
//         return false;
//       }
//     } catch (e, s) {
//       log("Backend login error: $e", stackTrace: s);
//       return false;
//     }
//   }
// }
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:game_app/data/repositories/auth_repository.dart';
// import 'package:game_app/data/repositories/storage_repository.dart';
// import 'package:game_app/presentation/routes/app_routes.dart';
// import 'package:get/get.dart';
//
// import '../../utils/snackbar_helper.dart';
// import '../services/google_auth_service.dart';
//
// class LoginController extends GetxController {
//
//   // Email & Password Controllers
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   final GoogleAuthService _googleAuthService = GoogleAuthService();
//   final AuthRepository _authRepo = AuthRepository();
//
//   // Password visibility
//   final RxBool isPasswordVisible = false.obs;
//
//   // Remember Me Checkbox State
//   final RxBool rememberMe = false.obs;
//   final isLoading = false.obs;
//
//   // Toggle Password Visibility
//   void togglePasswordVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }
//
//   // Toggle Remember Me
//   void toggleRememberMe(bool? value) {
//     rememberMe.value = value ?? false;
//   }
//
//   // Form Validation
//   bool validateLoginForm() => formKey.currentState?.validate() ?? false;
//
//   Future<void> login() async {
//     if (!validateLoginForm()) return;
//
//     isLoading.value = true;
//     try {
//       final email = emailController.text.trim();
//       final password = passwordController.text.trim();
//
//       // Call the actual login API
//       final user = await Get.find<AuthRepository>().login(email, password);
//
//       // Save credentials if remember me is checked
//       if (rememberMe.value) {
//         await Get.find<StorageRepository>().saveUser(user);
//       }
//
//       SnackbarHelper.success('login_successful'.tr);
//
//       // Navigate to home screen after successful login
//       await Get.offAllNamed(AppRoutes.start);
//
//     } catch (e, s) {
//       log('Login Error: $e', stackTrace: s);
//
//       // Handle specific error messages from API
//       if (e.toString().toLowerCase().contains('invalid credentials') ||
//           e.toString().toLowerCase().contains('wrong password') ||
//           e.toString().toLowerCase().contains('user not found')) {
//         SnackbarHelper.error('email_or_password_incorrect'.tr);
//       } else if (e.toString().toLowerCase().contains('network') ||
//           e.toString().toLowerCase().contains('connection')) {
//         SnackbarHelper.error('network_error'.tr);
//       } else {
//         SnackbarHelper.error('login_failed'.tr);
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }
//   Future<void> loginWithGoogle() async {
//     isLoading.value = true;
//
//     try {
//       final idToken = await _googleAuthService.signInWithGoogle();
//       if (idToken == null) {
//         Get.snackbar("Cancelled", "Google Sign-In cancelled by user");
//         return;
//       }
//
//       final success = await _authRepo.loginWithGoogle(idToken);
//       if (success) {
//         Get.snackbar("Success", "Logged in successfully!");
//         // Navigate to home screen
//       } else {
//         Get.snackbar("Error", "Failed to login via Google");
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> logout() async {
//     await _googleAuthService.signOut();
//     Get.snackbar("Success", "Logged out from Google");
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
