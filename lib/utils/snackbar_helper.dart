import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/app_colors.dart';
import '../core/app_dimensions.dart';

class SnackbarHelper {
  // Common Snackbar Method
  static void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: duration,
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.d16.w,
        vertical: AppDimensions.d12.h,
      ),
      borderRadius: AppDimensions.d12.r,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.d16.w,
        vertical: AppDimensions.d12.h,
      ),
      icon: Icon(icon, color: Colors.white, size: 24.sp),
      shouldIconPulse: true,
      forwardAnimationCurve: Curves.easeOutBack,
      barBlur: 2, // Adds a subtle glassmorphism effect
    );
  }

  /// Success Snackbar
  static void success(String message, {String title = "Success"}) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: AppColors.sucessColor,
      icon: Icons.check_circle_rounded,
    );
  }

  /// Error Snackbar
  static void error(String message, {String title = "Error"}) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: AppColors.primaryRed,
      icon: Icons.error_rounded,
    );
  }

  /// Info Snackbar
  static void info(String message, {String title = "Info"}) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: AppColors.primaryBlue,
      icon: Icons.info_outline_rounded,
    );
  }

  /// Warning Snackbar
  static void warning(String message, {String title = "Warning"}) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.orange.shade700,
      icon: Icons.warning_amber_rounded,
    );
  }
}
