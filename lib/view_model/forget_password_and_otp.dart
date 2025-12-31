import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/snackbar_helper.dart';
import '../../data/repositories/auth_repository.dart';
import '../generated/models/forget_and_send_otp.dart';
import '../presentation/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  late final AuthRepository authRepo = Get.find<AuthRepository>();

  // Step 1: Email
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Step 2: OTP
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  // Step 3: Password
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordFormKey = GlobalKey<FormState>();

  // State Management
  final currentStep = 0.obs; // 0: Email, 1: OTP, 2: Password
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final remainingSeconds = 0.obs;
  final isOtpExpired = false.obs;

  // Response models
  SendOtpResponse? _sendOtpResponse;
  ResetPasswordResponse? _resetPasswordResponse;

  Timer? _countdownTimer;
  static const int otpTimeoutSeconds = 60; // 5 minutes

  @override
  void onInit() {
    super.onInit();
    log('🔐 ForgotPasswordController initialized');
  }

  // ============ STEP 1: Send OTP ============
  Future<void> sendOtp() async {
    if (!_validateEmail()) return;

    isLoading.value = true;
    try {
      log('📧 Initiating OTP send process...');

      final response = await authRepo.sendOtp(emailController.text.trim());

      _sendOtpResponse = response;

      log('✅ ${response.message}');
      SnackbarHelper.success(response.message ?? 'OTP sent to your email');

      currentStep.value = 1; // Move to OTP step
      startOtpTimer();
    } catch (e) {
      log("❌ Send OTP error: $e");
      SnackbarHelper.error("Failed to send OTP: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // ============ STEP 2: Verify OTP & Reset Password ============
  Future<void> resetPassword() async {
    if (!_validateOtp()) {
      SnackbarHelper.error("Please enter all 6 OTP digits");
      return;
    }
    if (!_validatePassword()) return;

    isLoading.value = true;
    try {
      final otp = otpControllers.map((c) => c.text).join();

      log('🔐 Initiating password reset...');

      final response = await authRepo.resetPassword(
        email: emailController.text.trim(),
        otp: otp,
        newPassword: newPasswordController.text,
      );

      _resetPasswordResponse = response;

      log('✅ ${response.message}');
      SnackbarHelper.success(response.message ?? 'Password reset successfully');

      // Delay slightly for snackbar to be visible
      await Future.delayed(const Duration(milliseconds: 500));

      Get.toNamed(AppRoutes.home); // Navigate back to login
      clearAllControllers();
    } catch (e) {
      log("❌ Reset password error: $e");
      SnackbarHelper.error("Password reset failed: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // ============ OTP TIMER ============
  void startOtpTimer() {
    remainingSeconds.value = otpTimeoutSeconds;
    isOtpExpired.value = false;

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        isOtpExpired.value = true;
        _countdownTimer?.cancel();
        log('⏱️ OTP expired');
      }
    });
  }

  void resendOtp() {
    log('🔄 Resending OTP...');
    clearOtpFields();
    sendOtp();
  }

  String getFormattedTime() {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  // ============ OTP INPUT HANDLING ============
  void onOtpFieldChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        otpFocusNodes[index + 1].requestFocus();
      } else {
        otpFocusNodes[index].unfocus();
      }
    }
  }

  void onOtpFieldBackspace(String value, int index) {
    if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  // ============ VALIDATIONS ============
  bool _validateEmail() {
    if (emailController.text.trim().isEmpty) {
      SnackbarHelper.error("Please enter email");
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      SnackbarHelper.error("Please enter valid email");
      return false;
    }
    return true;
  }

  bool _validateOtp() {
    return otpControllers.every((c) => c.text.isNotEmpty);
  }

  bool _validatePassword() {
    if (newPasswordController.text.isEmpty) {
      SnackbarHelper.error("Please enter password");
      return false;
    }
    if (newPasswordController.text.length < 6) {
      SnackbarHelper.error("Password must be at least 6 characters");
      return false;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      SnackbarHelper.error("Passwords do not match");
      return false;
    }
    return true;
  }

  // ============ UI HELPERS ============
  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  void goBackStep() {
    if (currentStep.value > 0) {
      if (currentStep.value == 1) {
        _countdownTimer?.cancel();
      }
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  // ============ CLEANUP ============
  void clearOtpFields() {
    for (var controller in otpControllers) {
      controller.clear();
    }
  }

  void clearAllControllers() {
    emailController.clear();
    clearOtpFields();
    newPasswordController.clear();
    confirmPasswordController.clear();
    currentStep.value = 0;
  }

  @override
  void onClose() {
    log('🗑️ Closing ForgotPasswordController');
    _countdownTimer?.cancel();
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}