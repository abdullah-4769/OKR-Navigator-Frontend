import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../utils/snackbar_helper.dart';

class LoginController extends GetxController {
  // Email & Password Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Storage for remember me functionality
  final _storage = GetStorage();
  final String _rememberMeKey = 'rememberMe';
  final String _emailKey = 'savedEmail';
  final String _passwordKey = 'savedPassword';

  // Remember Me Checkbox State
  final RxBool rememberMe = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  // Load saved credentials if remember me was enabled
  void _loadSavedCredentials() {
    final savedRememberMe = _storage.read(_rememberMeKey) ?? false;
    rememberMe.value = savedRememberMe;

    if (savedRememberMe) {
      emailController.text = _storage.read(_emailKey) ?? '';
      passwordController.text = _storage.read(_passwordKey) ?? '';
    }
  }

  // Save credentials to local storage
  void _saveCredentials() {
    _storage.write(_rememberMeKey, rememberMe.value);
    if (rememberMe.value) {
      _storage.write(_emailKey, emailController.text);
      _storage.write(_passwordKey, passwordController.text);
    } else {
      _storage.remove(_emailKey);
      _storage.remove(_passwordKey);
    }
  }

  // Clear saved credentials
  void _clearCredentials() {
    _storage.remove(_rememberMeKey);
    _storage.remove(_emailKey);
    _storage.remove(_passwordKey);
  }

  // Toggle Remember Me
  void toggleRememberMe(value) {
    rememberMe.value = value ?? false;
  }

  // Form Validation
  bool validateLoginForm() => formKey.currentState?.validate() ?? false;

  Future<void> login() async {
    if (!validateLoginForm()) return;

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API Call

      // Simulate login validation
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      // Demo validation - replace with actual API call
      if (email != 'test@example.com') {
        SnackbarHelper.error('email_not_found'.tr);
        return;
      }

      // Password validation
      if (password != 'Password123') {
        SnackbarHelper.error('invalid_password'.tr);
        return;
      }

      // Save credentials if remember me is checked
      if (rememberMe.value) {
        _saveCredentials();
      } else {
        _clearCredentials();
      }

      SnackbarHelper.success('login_successful'.tr);

      // Navigate to home screen after successful login
      await Get.offAllNamed('/start');
    } catch (e) {
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
}
