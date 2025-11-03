import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:game_app/data/repositories/auth_repository.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../utils/snackbar_helper.dart';

class LoginController extends GetxController {

  // Email & Password Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Password visibility
  final RxBool isPasswordVisible = false.obs;

  // Remember Me Checkbox State
  final RxBool rememberMe = false.obs;
  final isLoading = false.obs;

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

  Future<void> login() async {
    if (!validateLoginForm()) return;

    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      // Call the actual login API
      final user = await Get.find<AuthRepository>().login(email, password);

      // Save credentials if remember me is checked
      if (rememberMe.value) {
        await Get.find<StorageRepository>().saveUser(user);
      }

      SnackbarHelper.success('login_successful'.tr);

      // Navigate to home screen after successful login
      await Get.offAllNamed(AppRoutes.start);

    } catch (e, s) {
      log('Login Error: $e', stackTrace: s);

      // Handle specific error messages from API
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}










// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:game_app/data/repositories/auth_repository.dart';
// import 'package:game_app/data/repositories/storage_repository.dart';
// import 'package:game_app/presentation/routes/app_routes.dart';
// import 'package:get/get.dart';
//
// import '../../utils/snackbar_helper.dart';
//
// class LoginController extends GetxController {
//
//   // Email & Password Controllers
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//
//   // Storage for remember me functionality
//   // final _storage = GetStorage();
//   // final String _rememberMeKey = 'rememberMe';
//   // final String _emailKey = 'savedEmail';
//   // final String _passwordKey = 'savedPassword';
//
//   // Remember Me Checkbox State
//   final RxBool rememberMe = false.obs;
//   final isLoading = false.obs;
//
//   // @override
//   // void onInit() {
//   //   super.onInit();
//   //   _loadSavedCredentials();
//   // }
//
//   // Load saved credentials if remember me was enabled
//   // void _loadSavedCredentials() {
//   //   final savedRememberMe = _storage.read(_rememberMeKey) ?? false;
//   //   rememberMe.value = savedRememberMe;
//   //
//   //   if (savedRememberMe) {
//   //     emailController.text = _storage.read(_emailKey) ?? '';
//   //     passwordController.text = _storage.read(_passwordKey) ?? '';
//   //   }
//   // }
//
//   // Save credentials to local storage
//   // void _saveCredentials() {
//   //   _storage.write(_rememberMeKey, rememberMe.value);
//   //   if (rememberMe.value) {
//   //     _storage.write(_emailKey, emailController.text);
//   //     _storage.write(_passwordKey, passwordController.text);
//   //   } else {
//   //     _storage.remove(_emailKey);
//   //     _storage.remove(_passwordKey);
//   //   }
//   // }
//   //
//   // // Clear saved credentials
//   // void _clearCredentials() {
//   //   _storage.remove(_rememberMeKey);
//   //   _storage.remove(_emailKey);
//   //   _storage.remove(_passwordKey);
//   // }
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
//       // await Future.delayed(const Duration(seconds: 2)); // Simulate API Call
//
//       // Simulate login validation
//       final email = emailController.text.trim();
//       final password = passwordController.text.trim();
//
//       final user = await Get.find<AuthRepository>().login(email, password);
//
//       // // Demo validation - replace with actual API call
//       // if (email != 'test@example.com') {
//       //   SnackbarHelper.error('email_not_found'.tr);
//       //   return;
//       // }
//       //
//       // // Password validation
//       // if (password != 'Password123') {
//       //   SnackbarHelper.error('invalid_password'.tr);
//       //   return;
//       // }
//
//       // Save credentials if remember me is checked
//       if (rememberMe.value) {
//         await Get.find<StorageRepository>().saveUser(user);
//         // _saveCredentials();
//       }
//       // else {
//       //   _clearCredentials();
//       // }
//
//       SnackbarHelper.success('login_successful'.tr);
//
//       // Navigate to home screen after successful login
//       await Get.offAllNamed(AppRoutes.start);
//     } catch (e, s) {
//       log(e.toString(), stackTrace: s);
//       SnackbarHelper.error('login_failed'.tr);
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
// }
/*import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:game_app/data/repositories/auth_repository.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../utils/snackbar_helper.dart';

class LoginController extends GetxController {

  // Email & Password Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Storage for remember me functionality
  // final _storage = GetStorage();
  // final String _rememberMeKey = 'rememberMe';
  // final String _emailKey = 'savedEmail';
  // final String _passwordKey = 'savedPassword';

  // Remember Me Checkbox State
  final RxBool rememberMe = false.obs;
  final isLoading = false.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   _loadSavedCredentials();
  // }

  // Load saved credentials if remember me was enabled
  // void _loadSavedCredentials() {
  //   final savedRememberMe = _storage.read(_rememberMeKey) ?? false;
  //   rememberMe.value = savedRememberMe;
  //
  //   if (savedRememberMe) {
  //     emailController.text = _storage.read(_emailKey) ?? '';
  //     passwordController.text = _storage.read(_passwordKey) ?? '';
  //   }
  // }

  // Save credentials to local storage
  // void _saveCredentials() {
  //   _storage.write(_rememberMeKey, rememberMe.value);
  //   if (rememberMe.value) {
  //     _storage.write(_emailKey, emailController.text);
  //     _storage.write(_passwordKey, passwordController.text);
  //   } else {
  //     _storage.remove(_emailKey);
  //     _storage.remove(_passwordKey);
  //   }
  // }
  //
  // // Clear saved credentials
  // void _clearCredentials() {
  //   _storage.remove(_rememberMeKey);
  //   _storage.remove(_emailKey);
  //   _storage.remove(_passwordKey);
  // }

  // Toggle Remember Me
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  // Form Validation
  bool validateLoginForm() => formKey.currentState?.validate() ?? false;

  Future<void> login() async {
    if (!validateLoginForm()) return;

    isLoading.value = true;
    try {
      // await Future.delayed(const Duration(seconds: 2)); // Simulate API Call

      // Simulate login validation
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final user = await Get.find<AuthRepository>().login(email, password);

      // // Demo validation - replace with actual API call
      // if (email != 'test@example.com') {
      //   SnackbarHelper.error('email_not_found'.tr);
      //   return;
      // }
      //
      // // Password validation
      // if (password != 'Password123') {
      //   SnackbarHelper.error('invalid_password'.tr);
      //   return;
      // }

      // Save credentials if remember me is checked
      if (rememberMe.value) {
        await Get.find<StorageRepository>().saveUser(user);
        // _saveCredentials();
      }
      // else {
      //   _clearCredentials();
      // }

      SnackbarHelper.success('login_successful'.tr);

      // Navigate to home screen after successful login
      await Get.offAllNamed(AppRoutes.start);
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      SnackbarHelper.error('login_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}*/
