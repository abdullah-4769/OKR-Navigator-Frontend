// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
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
//   // One clean instance
//   final AuthRepository authRepo = AuthRepository();
//
//   final isGoogleLoading = false.obs;
//   final isPasswordVisible = false.obs;
//   final rememberMe = false.obs;
//   final isLoading = false.obs;
//
//   final StorageRepository _storageRepo = Get.find<StorageRepository>();
//
//   void togglePasswordVisibility() => isPasswordVisible.toggle();
//   void toggleRememberMe(bool? value) => rememberMe.value = value ?? false;
//
//   bool validateLoginForm() => formKey.currentState?.validate() ?? false;
//
//   Future<void> login() async {
//     if (!validateLoginForm()) return;
//
//     isLoading.value = true;
//     try {
//       final user = await authRepo.login(
//         emailController.text.trim(),
//         passwordController.text,
//       );
//
//       if (rememberMe.value) {
//         await _storageRepo.saveUser(user);
//       }
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
//   Future<void> loginWithGoogle() async {
//     if (isGoogleLoading.value) return;
//
//     isGoogleLoading.value = true;
//     try {
//       final idToken = await _googleAuthService.signInWithGoogle();
//       if (idToken == null) {
//         SnackbarHelper.error("Google Sign-In cancelled");
//         return;
//       }
//
//       final user = await authRepo.loginWithGoogle(idToken);
//
//       SnackbarHelper.success("Welcome ${user.name.split(' ').first}!");
//       Get.offAllNamed(AppRoutes.start);
//     } catch (e) {
//       log("Google login failed: $e");
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
// controllers/login_controller.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // Ab GetX se inject hoga → No manual creation
  late final AuthRepository authRepo = Get.find<AuthRepository>();
  late final StorageRepository _storageRepo = Get.find<StorageRepository>();

  final isGoogleLoading = false.obs;
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleRememberMe(bool? value) => rememberMe.value = value ?? false;

  bool validateLoginForm() => formKey.currentState?.validate() ?? false;

  // EMAIL LOGIN – AB 100% CHALEGA
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

  // GOOGLE LOGIN – KOI CHANGE NAHI (already perfect)
  Future<void> loginWithGoogle() async {
    if (isGoogleLoading.value) return;
    isGoogleLoading.value = true;
    try {
      final idToken = await _googleAuthService.signInWithGoogle();
      if (idToken == null) {
        SnackbarHelper.error("Google Sign-In cancelled");
        return;
      }
      final user = await authRepo.loginWithGoogle(idToken);
      SnackbarHelper.success("Welcome ${user.name.split(' ').first}!");
      Get.offAllNamed(AppRoutes.start);
    } catch (e) {
      SnackbarHelper.error("Google login failed");
    } finally {
      isGoogleLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}