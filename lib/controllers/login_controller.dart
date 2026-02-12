import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/snackbar_helper.dart';
import '../services/google_auth_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/storage_repository.dart';
import '../../presentation/routes/app_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final GoogleAuthService _googleAuthService = GoogleAuthService();

  late final AuthRepository authRepo = Get.find<AuthRepository>();
  late final StorageRepository _storageRepo = Get.find<StorageRepository>();

  final isGoogleLoading = false.obs;
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleRememberMe(bool? value) => rememberMe.value = value ?? false;

  bool validateLoginForm() => formKey.currentState?.validate() ?? false;

  // EMAIL LOGIN - Uses saveUser()
  Future<void> login() async {
    if (!validateLoginForm()) return;
    isLoading.value = true;
    try {
      final user = await authRepo.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (rememberMe.value) await _storageRepo.saveUser(user);

      SnackbarHelper.success('Login successful');
      Get.offAllNamed(AppRoutes.start);
    } catch (e) {
      log("Login error: $e");
      SnackbarHelper.error("Login failed: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> loginWithGoogle() async {
    if (isGoogleLoading.value) return;
    isGoogleLoading.value = true;

    try {
      print("=== LOGIN WITH GOOGLE STARTED ===");

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("User cancelled");
        SnackbarHelper.error("Google Sign-In cancelled");
        return;
      }

      print("Got user: ${googleUser.email}");
      final auth = await googleUser.authentication;

      if (auth.idToken == null) {
        print("No ID token");
        SnackbarHelper.error("No ID token received");
        return;
      }

      // 🎯 DECODE AND CHECK TOKEN
      print("\n🔍 DECODING TOKEN:");
      final parts = auth.idToken!.split('.');
      if (parts.length == 3) {
        String payload = parts[1];
        // Add padding
        while (payload.length % 4 != 0) {
          payload += '=';
        }
        final decoded = utf8.decode(base64Url.decode(payload));
        final json = jsonDecode(decoded);

        print("aud (Audience): ${json['aud']}");
        print("iss (Issuer): ${json['iss']}");
        print("email: ${json['email']}");
        print("exp (Expires): ${DateTime.fromMillisecondsSinceEpoch(json['exp'] * 1000)}");
        print("iat (Issued At): ${DateTime.fromMillisecondsSinceEpoch(json['iat'] * 1000)}");

        print("\n📋 BACKEND MUST VERIFY WITH THIS CLIENT ID: ${json['aud']}");
      }

      print("Sending token to backend...");
      final saveUser = await authRepo.loginWithGoogle(auth.idToken!);

      await _storageRepo.saveGoogleUser(saveUser);

      SnackbarHelper.success("Welcome!");
      Get.offAllNamed(AppRoutes.start);

    } catch (e) {
      print("Login with Google Error: $e");
      SnackbarHelper.error("Backend can't verify token. Check backend Google Client ID.");
    } finally {
      isGoogleLoading.value = false;
    }
  }
  // // GOOGLE LOGIN - Uses saveGoogleUser()
  // Future<void> loginWithGoogle() async {
  //   if (isGoogleLoading.value) return;
  //   isGoogleLoading.value = true;
  //   try {
  //     final idToken = await _googleAuthService.signInWithGoogle();
  //     if (idToken == null) {
  //       SnackbarHelper.error("Google Sign-In cancelled");
  //       return;
  //     }
  //
  //     // Backend se SaveUser milta hai
  //     final saveUser = await authRepo.loginWithGoogle(idToken);
  //
  //     // SaveUser ko directly save karo using saveGoogleUser()
  //     await _storageRepo.saveGoogleUser(saveUser);
  //
  //     SnackbarHelper.success("Welcome ${saveUser.name.split(' ').first}!");
  //     Get.offAllNamed(AppRoutes.start);
  //   } catch (e) {
  //     log("Google login error: $e");
  //     SnackbarHelper.error("Google login failed");
  //   } finally {
  //     isGoogleLoading.value = false;
  //   }
  // }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }
}
// // controllers/login_controller.dart
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../utils/snackbar_helper.dart';
// import '../services/google_auth_service.dart';
// import '../../data/repositories/auth_repository.dart';
// import '../../data/repositories/storage_repository.dart';
// import '../../presentation/routes/app_routes.dart';
//
// class LoginController extends GetxController {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//
//   final GoogleAuthService _googleAuthService = GoogleAuthService();
//
//   late final AuthRepository authRepo = Get.find<AuthRepository>();
//   late final StorageRepository _storageRepo = Get.find<StorageRepository>();
//
//   final isGoogleLoading = false.obs;
//   final isPasswordVisible = false.obs;
//   final rememberMe = false.obs;
//   final isLoading = false.obs;
//
//   void togglePasswordVisibility() => isPasswordVisible.toggle();
//   void toggleRememberMe(bool? value) => rememberMe.value = value ?? false;
//
//   bool validateLoginForm() => formKey.currentState?.validate() ?? false;
//
//   // EMAIL LOGIN - Uses saveUser()
//   Future<void> login() async {
//     if (!validateLoginForm()) return;
//     isLoading.value = true;
//     try {
//       final user = await authRepo.login(
//         emailController.text.trim(),
//         passwordController.text,
//       );
//
//       if (rememberMe.value) await _storageRepo.saveUser(user);
//
//       SnackbarHelper.success('Login successful');
//       Get.offAllNamed(AppRoutes.start);
//     } catch (e) {
//       log("Login error: $e");
//       SnackbarHelper.error("Login failed: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // GOOGLE LOGIN - Uses saveGoogleUser()
//   Future<void> loginWithGoogle() async {
//     if (isGoogleLoading.value) return;
//     isGoogleLoading.value = true;
//     try {
//       final idToken = await _googleAuthService.signInWithGoogle();
//       if (idToken == null) {
//         SnackbarHelper.error("Google Sign-In cancelled");
//         return;
//       }
//
//       // Backend se SaveUser milta hai
//       final saveUser = await authRepo.loginWithGoogle(idToken);
//
//       // SaveUser ko directly save karo using saveGoogleUser()
//       await _storageRepo.saveGoogleUser(saveUser);
//
//       SnackbarHelper.success("Welcome ${saveUser.name.split(' ').first}!");
//       Get.offAllNamed(AppRoutes.start);
//     } catch (e) {
//       log("Google login error: $e");
//       SnackbarHelper.error("Google login failed");
//     } finally {
//       isGoogleLoading.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }
// }
