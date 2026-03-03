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
  final isOtpVerified = false.obs;

  // Response models
  SendOtpResponse? _sendOtpResponse;
  ResetPasswordResponse? _resetPasswordResponse;
  String? _verifiedOtp;

  Timer? _countdownTimer;
  static const int otpTimeoutSeconds = 60;

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
      log('📧 Sending OTP to: ${emailController.text.trim()}');

      final response = await authRepo.sendOtp(emailController.text.trim());

      _sendOtpResponse = response;

      log('✅ OTP sent: ${response.message}');
      SnackbarHelper.success(response.message ?? 'otp_sent'.tr);

      currentStep.value = 1;
      startOtpTimer();
    } catch (e) {
      log('❌ Send OTP error: $e');
      SnackbarHelper.error('${'failed_to_send_otp'.tr}: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // ============ STEP 2: Verify OTP ============
  Future<void> verifyOtp() async {
    if (!_validateOtp()) {
      SnackbarHelper.error('enter_all_digits'.tr);
      return;
    }

    if (isOtpExpired.value) {
      SnackbarHelper.error('otp_expired'.tr);
      return;
    }

    if (isLoading.value) return;

    isLoading.value = true;
    try {
      final enteredOtp = otpControllers.map((c) => c.text).join();

      log('🔐 Verifying OTP: $enteredOtp for email: ${emailController.text.trim()}');

      final isValid = await authRepo.verifyOtp(
        email: emailController.text.trim(),
        otp: enteredOtp,
      );

      if (isValid) {
        log('✅ OTP verified successfully');
        isOtpVerified.value = true;
        _verifiedOtp = enteredOtp;
        _countdownTimer?.cancel();

        SnackbarHelper.success('otp_verified'.tr);
        currentStep.value = 2;
      } else {
        log('❌ Invalid OTP');
        SnackbarHelper.error('invalid_otp'.tr);

        isOtpVerified.value = false;
        _verifiedOtp = null;

        _clearOtpFields();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          otpFocusNodes[0].requestFocus();
        });
      }
    } catch (e) {
      log('❌ OTP verification error: $e');
      SnackbarHelper.error('${'otp_verification_failed'.tr}: ${e.toString()}');

      isOtpVerified.value = false;
      _verifiedOtp = null;
    } finally {
      isLoading.value = false;
    }
  }

  // ============ STEP 3: Reset Password ============
  Future<void> resetPassword() async {
    if (!_validatePassword()) return;

    if (!isOtpVerified.value) {
      SnackbarHelper.error('verify_otp_first'.tr);
      currentStep.value = 1;
      return;
    }

    isLoading.value = true;
    try {
      log('🔐 Resetting password for: ${emailController.text.trim()}');

      final response = await authRepo.resetPassword(
        email: emailController.text.trim(),
        otp: _verifiedOtp!,
        newPassword: newPasswordController.text,
      );

      log('✅ Password reset successful: ${response.message}');

      SnackbarHelper.success(
        'password_reset_success'.tr,
        duration: const Duration(seconds: 3),
      );

      clearAllControllers();

      // 🔥 FIX: Add delay before navigation to prevent white screen
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(AppRoutes.login);

    } catch (e) {
      log('❌ Reset password error: $e');

      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('invalid otp')) {
        SnackbarHelper.error('invalid_expired_otp'.tr);
        currentStep.value = 1;
      } else if (errorMsg.contains('already used') ||
          errorMsg.contains('previously used')) {
        SnackbarHelper.error(
          'password_already_used'.tr,
          duration: const Duration(seconds: 4),
        );
      } else {
        SnackbarHelper.error('${'password_reset_failed'.tr}: ${e.toString()}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ============ OTP TIMER ============
  void startOtpTimer() {
    remainingSeconds.value = otpTimeoutSeconds;
    isOtpExpired.value = false;
    isOtpVerified.value = false;

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
        log('⏱️ OTP timer: ${getFormattedTime()}');
      } else {
        isOtpExpired.value = true;
        _countdownTimer?.cancel();
        log('⏱️ OTP expired');
        SnackbarHelper.warning('otp_expired_warning'.tr);
      }
    });
  }

  Future<void> resendOtp() async {
    log('🔄 Resending OTP...');
    _clearOtpFields();
    isOtpVerified.value = false;
    await sendOtp();
  }

  String getFormattedTime() {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // ============ OTP INPUT HANDLING ============
  void onOtpFieldChanged(String value, int index) {
    log('✏️ OTP field $index: $value');
    if (value.isNotEmpty) {
      if (index < 5) {
        otpFocusNodes[index + 1].requestFocus();
      } else {
        otpFocusNodes[index].unfocus();
        if (!isOtpExpired.value && !isLoading.value) {
          verifyOtp();
        }
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
      SnackbarHelper.error('enter_email'.tr);
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      SnackbarHelper.error('valid_email'.tr);
      return false;
    }
    return true;
  }

  bool _validateOtp() {
    for (int i = 0; i < otpControllers.length; i++) {
      if (otpControllers[i].text.isEmpty || otpControllers[i].text.length != 1) {
        return false;
      }
    }
    return true;
  }

  bool _validatePassword() {
    if (newPasswordController.text.isEmpty) {
      SnackbarHelper.error('enter_new_password'.tr);
      return false;
    }

    if (newPasswordController.text.length < 6) {
      SnackbarHelper.error('password_min_length'.tr);
      return false;
    }

    if (!_isPasswordStrong(newPasswordController.text)) {
      SnackbarHelper.error('password_strict_requirements'.tr);
      return false;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      SnackbarHelper.error('password_mismatch'.tr);
      return false;
    }

    return true;
  }

  bool _isPasswordStrong(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    log('🔐 Password strength: Uppercase: $hasUppercase, Lowercase: $hasLowercase, Number: $hasNumber, Special: $hasSpecial');

    return hasUppercase && hasLowercase && hasNumber && hasSpecial;
  }

  // ============ UI HELPERS ============
  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  void goBackStep() {
    log('⬅️ Going back from step ${currentStep.value}');
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
  void _clearOtpFields() {
    for (var controller in otpControllers) {
      controller.clear();
    }
  }

  void clearAllControllers() {
    emailController.clear();
    _clearOtpFields();
    newPasswordController.clear();
    confirmPasswordController.clear();
    currentStep.value = 0;
    isOtpVerified.value = false;
    _verifiedOtp = null;
    _countdownTimer?.cancel();
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



// import 'dart:async';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../utils/snackbar_helper.dart';
// import '../../data/repositories/auth_repository.dart';
// import '../generated/models/forget_and_send_otp.dart';
// import '../presentation/routes/app_routes.dart';
//
// class ForgotPasswordController extends GetxController {
//   late final AuthRepository authRepo = Get.find<AuthRepository>();
//
//   // Step 1: Email
//   final emailController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//
//   // Step 2: OTP
//   final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
//   final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());
//
//   // Step 3: Password
//   final newPasswordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final passwordFormKey = GlobalKey<FormState>();
//
//   // State Management
//   final currentStep = 0.obs; // 0: Email, 1: OTP, 2: Password
//   final isLoading = false.obs;
//   final isPasswordVisible = false.obs;
//   final isConfirmPasswordVisible = false.obs;
//   final remainingSeconds = 0.obs;
//   final isOtpExpired = false.obs;
//   final isOtpVerified = false.obs; // ✅ Track OTP verification status
//
//   // Response models
//   SendOtpResponse? _sendOtpResponse;
//   ResetPasswordResponse? _resetPasswordResponse;
//   String? _verifiedOtp; // ✅ Store verified OTP
//
//   Timer? _countdownTimer;
//   static const int otpTimeoutSeconds = 60; // 5 minutes (300 seconds)
//
//   @override
//   void onInit() {
//     super.onInit();
//     log('🔐 ForgotPasswordController initialized');
//   }
//
//   // ============ STEP 1: Send OTP ============
//   Future<void> sendOtp() async {
//     if (!_validateEmail()) return;
//
//     isLoading.value = true;
//     try {
//       log('📧 Sending OTP to: ${emailController.text.trim()}');
//
//       final response = await authRepo.sendOtp(emailController.text.trim());
//
//       _sendOtpResponse = response;
//
//       log('✅ OTP sent: ${response.message}');
//       SnackbarHelper.success(response.message ?? 'OTP sent to your email');
//
//       currentStep.value = 1;
//       startOtpTimer();
//     } catch (e) {
//       log('❌ Send OTP error: $e');
//       SnackbarHelper.error('Failed to send OTP: ${e.toString()}');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
// // ============ STEP 2: Verify OTP ============
//   Future<void> verifyOtp() async {
//     if (!_validateOtp()) {
//       SnackbarHelper.error('Please enter all 6 digits');
//       return;
//     }
//
//     if (isOtpExpired.value) {
//       SnackbarHelper.error('OTP has expired. Please request a new one.');
//       return;
//     }
//
//     // Don't allow multiple simultaneous verification attempts
//     if (isLoading.value) return;
//
//     isLoading.value = true;
//     try {
//       final enteredOtp = otpControllers.map((c) => c.text).join();
//
//       log('🔐 Verifying OTP: $enteredOtp for email: ${emailController.text.trim()}');
//
//       // Call the actual API to verify OTP
//       final isValid = await authRepo.verifyOtp(
//         email: emailController.text.trim(),
//         otp: enteredOtp,
//       );
//
//       if (isValid) {
//         log('✅ OTP verified successfully');
//         isOtpVerified.value = true;
//         _verifiedOtp = enteredOtp;
//         _countdownTimer?.cancel();
//
//         SnackbarHelper.success('OTP verified successfully');
//         currentStep.value = 2; // Move to password reset step
//       } else {
//         log('❌ Invalid OTP');
//         SnackbarHelper.error('Invalid OTP. Please try again.');
//
//         // ✅ Important: Reset verification state
//         isOtpVerified.value = false;
//         _verifiedOtp = null;
//
//         // Clear fields for retry
//         _clearOtpFields();
//
//         // Focus on first field
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           otpFocusNodes[0].requestFocus();
//         });
//       }
//     } catch (e) {
//       log('❌ OTP verification error: $e');
//       SnackbarHelper.error('OTP verification failed: ${e.toString()}');
//
//       // Reset on error too
//       isOtpVerified.value = false;
//       _verifiedOtp = null;
//     } finally {
//       isLoading.value = false;
//     }
//   }
// // ============ STEP 3: Reset Password ============
//   Future<void> resetPassword() async {
//     if (!_validatePassword()) return;
//
//     if (!isOtpVerified.value) {
//       SnackbarHelper.error('Please verify OTP first');
//       currentStep.value = 1;
//       return;
//     }
//
//     isLoading.value = true;
//     try {
//       log('🔐 Resetting password for: ${emailController.text.trim()}');
//
//       final response = await authRepo.resetPassword(
//         email: emailController.text.trim(),
//         otp: _verifiedOtp!, // Use the verified OTP
//         newPassword: newPasswordController.text,
//       );
//
//       log('✅ Password reset successful: ${response.message}');
//
//       // Show success message
//       SnackbarHelper.success(
//         'Password reset successful! Please login with your new password.',
//         duration: const Duration(seconds: 3),
//       );
//
//       // Clear all data
//       clearAllControllers();
//
//       // Navigate to login after delay
//       await Future.delayed(const Duration(seconds: 2));
//       Get.offAllNamed(AppRoutes.login);
//
//     } catch (e) {
//       log('❌ Reset password error: $e');
//
//       // Check for specific error messages
//       final errorMsg = e.toString().toLowerCase();
//       if (errorMsg.contains('invalid otp')) {
//         SnackbarHelper.error('Invalid or expired OTP. Please request a new one.');
//         currentStep.value = 1; // Go back to OTP step
//       } else if (errorMsg.contains('already used') ||
//           errorMsg.contains('previously used')) {
//         SnackbarHelper.error(
//           'You have used this password before. Please choose a different password.',
//           duration: const Duration(seconds: 4),
//         );
//       } else {
//         SnackbarHelper.error('Password reset failed: ${e.toString()}');
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }
//   // ============ OTP TIMER ============
//   void startOtpTimer() {
//     remainingSeconds.value = otpTimeoutSeconds;
//     isOtpExpired.value = false;
//     isOtpVerified.value = false;
//
//     _countdownTimer?.cancel();
//     _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (remainingSeconds.value > 0) {
//         remainingSeconds.value--;
//         log('⏱️ OTP timer: ${getFormattedTime()}');
//       } else {
//         isOtpExpired.value = true;
//         _countdownTimer?.cancel();
//         log('⏱️ OTP expired');
//         SnackbarHelper.warning('OTP has expired. Please request a new one.');
//       }
//     });
//   }
//
//   Future<void> resendOtp() async {
//     log('🔄 Resending OTP...');
//     _clearOtpFields();
//     isOtpVerified.value = false;
//     await sendOtp(); // Reuse sendOtp method
//   }
//
//   String getFormattedTime() {
//     final minutes = remainingSeconds.value ~/ 60;
//     final seconds = remainingSeconds.value % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
//
//   // ============ OTP INPUT HANDLING ============
//   void onOtpFieldChanged(String value, int index) {
//     log('✏️ OTP field $index: $value');
//     if (value.isNotEmpty) {
//       if (index < 5) {
//         otpFocusNodes[index + 1].requestFocus();
//       } else {
//         otpFocusNodes[index].unfocus();
//         // Auto-verify when last digit is entered
//         if (!isOtpExpired.value && !isLoading.value) {
//           verifyOtp();
//         }
//       }
//     }
//   }
//
//   void onOtpFieldBackspace(String value, int index) {
//     if (value.isEmpty && index > 0) {
//       otpFocusNodes[index - 1].requestFocus();
//     }
//   }
//
//   // ============ VALIDATIONS ============
//   bool _validateEmail() {
//     if (emailController.text.trim().isEmpty) {
//       SnackbarHelper.error('Please enter your email');
//       return false;
//     }
//     if (!GetUtils.isEmail(emailController.text.trim())) {
//       SnackbarHelper.error('Please enter a valid email address');
//       return false;
//     }
//     return true;
//   }
//
//   bool _validateOtp() {
//     // Check if all fields have exactly one digit
//     for (int i = 0; i < otpControllers.length; i++) {
//       if (otpControllers[i].text.isEmpty || otpControllers[i].text.length != 1) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   bool _validatePassword() {
//     if (newPasswordController.text.isEmpty) {
//       SnackbarHelper.error('Please enter a new password');
//       return false;
//     }
//
//     if (newPasswordController.text.length < 6) {
//       SnackbarHelper.error('Password must be at least 6 characters long');
//       return false;
//     }
//
//     // Password strength validation
//     if (!_isPasswordStrong(newPasswordController.text)) {
//       SnackbarHelper.error(
//           'Password must contain at least one uppercase letter, '
//               'one lowercase letter, one number, and one special character'
//       );
//       return false;
//     }
//
//     if (newPasswordController.text != confirmPasswordController.text) {
//       SnackbarHelper.error('Passwords do not match');
//       return false;
//     }
//
//     return true;
//   }
//
//   bool _isPasswordStrong(String password) {
//     // At least one uppercase, one lowercase, one number, one special character
//     final hasUppercase = password.contains(RegExp(r'[A-Z]'));
//     final hasLowercase = password.contains(RegExp(r'[a-z]'));
//     final hasNumber = password.contains(RegExp(r'[0-9]'));
//     final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
//
//     log('🔐 Password strength: Uppercase: $hasUppercase, Lowercase: $hasLowercase, Number: $hasNumber, Special: $hasSpecial');
//
//     return hasUppercase && hasLowercase && hasNumber && hasSpecial;
//   }
//
//   // ============ UI HELPERS ============
//   void togglePasswordVisibility() => isPasswordVisible.toggle();
//   void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();
//
//   void goBackStep() {
//     log('⬅️ Going back from step ${currentStep.value}');
//     if (currentStep.value > 0) {
//       if (currentStep.value == 1) {
//         _countdownTimer?.cancel();
//       }
//       currentStep.value--;
//     } else {
//       Get.back();
//     }
//   }
//
//   // ============ CLEANUP ============
//   void _clearOtpFields() {
//     for (var controller in otpControllers) {
//       controller.clear();
//     }
//   }
//
//   void clearAllControllers() {
//     emailController.clear();
//     _clearOtpFields();
//     newPasswordController.clear();
//     confirmPasswordController.clear();
//     currentStep.value = 0;
//     isOtpVerified.value = false;
//     _verifiedOtp = null;
//     _countdownTimer?.cancel();
//   }
//
//   @override
//   void onClose() {
//     log('🗑️ Closing ForgotPasswordController');
//     _countdownTimer?.cancel();
//     emailController.dispose();
//     newPasswordController.dispose();
//     confirmPasswordController.dispose();
//     for (var controller in otpControllers) {
//       controller.dispose();
//     }
//     for (var node in otpFocusNodes) {
//       node.dispose();
//     }
//     super.onClose();
//   }
// }
//
//
