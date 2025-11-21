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

  // GOOGLE LOGIN - Uses saveGoogleUser()
  Future<void> loginWithGoogle() async {
    if (isGoogleLoading.value) return;
    isGoogleLoading.value = true;
    try {
      final idToken = await _googleAuthService.signInWithGoogle();
      if (idToken == null) {
        SnackbarHelper.error("Google Sign-In cancelled");
        return;
      }

      // Backend se SaveUser milta hai
      final saveUser = await authRepo.loginWithGoogle(idToken);

      // SaveUser ko directly save karo using saveGoogleUser()
      await _storageRepo.saveGoogleUser(saveUser);

      SnackbarHelper.success("Welcome ${saveUser.name.split(' ').first}!");
      Get.offAllNamed(AppRoutes.start);
    } catch (e) {
      log("Google login error: $e");
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
