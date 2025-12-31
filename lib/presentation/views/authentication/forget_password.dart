import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/views/authentication/reset_password.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../utils/validator.dart';
import '../../../view_model/forget_password_and_otp.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'otp_verification.dart';


class ForgotPasswordScreen extends StatelessWidget {
  final controller = Get.put(ForgotPasswordController());

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PopScope(
        canPop: controller.currentStep.value == 0,
        onPopInvoked: (didPop) {
          if (!didPop) {
            controller.goBackStep();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.primaryBlue),
              onPressed: controller.goBackStep,
            ),
            title: Text(
              _getAppBarTitle(controller.currentStep.value),
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: _buildCurrentStep(controller),
            ),
          ),
        ),
      );
    });
  }

  String _getAppBarTitle(int step) {
    switch (step) {
      case 0:
        return 'Forgot Password';
      case 1:
        return 'Verify OTP';
      case 2:
        return 'Reset Password';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep(ForgotPasswordController ctrl) {
    switch (ctrl.currentStep.value) {
      case 0:
        return _buildEmailStep(ctrl);
      case 1:
        return OtpVerificationScreen(controller: ctrl);
      case 2:
        return ResetPasswordScreen(controller: ctrl);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildEmailStep(ForgotPasswordController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your email address',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'We\'ll send you an OTP to reset your password',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 32.h),
        CustomTextField(
          controller: ctrl.emailController,
          hint: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: AppColors.textSecondary,
            size: 20.sp,
          ),
          validator: Validators.email,
        ),
        SizedBox(height: 48.h),
        Obx(
              () => CustomButton(
            text: 'Send OTP',
            onPressed: ctrl.sendOtp,
            isLoading: ctrl.isLoading.value,
            backgroundColor: AppColors.primaryRed,
            height: 56.h,
          ),
        ),
      ],
    );
  }
}