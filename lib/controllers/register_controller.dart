import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:game_app/controllers/language_controller.dart';
import 'package:game_app/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

import '../../core/app_strings.dart';
import '../../utils/snackbar_helper.dart';

class RegisterController extends GetxController {
  // Form Key
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Loading State
  final isLoading = false.obs;

  bool validateRegisterForm() => formKey.currentState?.validate() ?? false;

  Future<void> register() async {
    if (!validateRegisterForm()) return;

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      SnackbarHelper.error(AppStrings.passwordMismatch.tr);
      return;
    }

    isLoading.value = true;
    try {
      await Get.find<AuthRepository>().register(
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        password: passwordController.text.trim(),
        phone: phoneController.text.trim(),
        language: Get.find<LanguageController>().currentLanguage.code,
      );
      SnackbarHelper.success('registration_successful'.tr);

      await Get.offAllNamed('/login');
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      SnackbarHelper.error('registration_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
