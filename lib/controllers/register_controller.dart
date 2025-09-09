import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_strings.dart';
import '../../utils/snackbar_helper.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;

  bool validateRegisterForm() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  Future<void> register() async {
    if (!validateRegisterForm()) return;

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      SnackbarHelper.error(AppStrings.passwordMismatch.tr);
      return;
    }

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API Call
      SnackbarHelper.success('registration_successful'.tr);
      // Navigate to login screen after successful registration
      await Get.offAllNamed('/login');
    } catch (e) {
      SnackbarHelper.error('registration_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
