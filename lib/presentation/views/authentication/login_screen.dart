import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/login_controller.dart';
import '../../../controllers/register_controller.dart';
import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/custom_textfield.dart';
import '../../../utils/snackbar_helper.dart';
import '../../../utils/validator.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    body: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              SizedBox(height: AppDimensions.d40.h),

              /// -------- LOGO --------
              CustomSvg(
                assetPath: AppAssets.okrLogo,
                width: AppDimensions.d80.w,
                height: AppDimensions.d80.h,
                semanticsLabel: 'okr_logo'.tr,
              ),
              SizedBox(height: AppDimensions.d16.h),
              SizedBox(height: AppDimensions.d40.h),

              /// -------- TITLE --------
              Text(
                'rejoin_operation'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimensions.d24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gotham',
                  color: AppColors.primaryBlue,
                ),
              ),
              SizedBox(height: AppDimensions.d12.h),

              /// -------- SUBTITLE --------
              Text(
                'strategy_awaits'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimensions.d16.sp,
                  fontFamily: 'Gotham',
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: AppDimensions.d40.h),

              /// -------- EMAIL FIELD --------
              CustomTextField(
                controller: controller.emailController,
                hint: 'enter_email'.tr,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.textSecondary,
                  size: AppDimensions.d20.sp,
                ),
                validator: Validators.email,
              ),
              SizedBox(height: AppDimensions.d20.h),

              /// -------- PASSWORD FIELD --------
              CustomTextField(
                controller: controller.passwordController,
                hint: 'enter_password'.tr,
                obscureText: true,
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: AppColors.textSecondary,
                  size: AppDimensions.d20.sp,
                ),
                validator: Validators.password,
              ),
              SizedBox(height: AppDimensions.d16.h),

              /// -------- REMEMBER ME + FORGOT PASSWORD --------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                        () => Row(
                      children: [
                        Transform.scale(
                          scale: 1.0,
                          child: Checkbox(
                            value: controller.rememberMe.value,
                            onChanged: controller.toggleRememberMe,
                            activeColor: AppColors.primaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.d4.r,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'remember_me'.tr,
                          style: TextStyle(
                            fontSize: AppDimensions.d14.sp,
                            color: AppColors.textSecondary,
                            fontFamily: 'Gotham',
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => SnackbarHelper.info(
                      'password_reset_coming'.tr,
                    ),
                    child: Text(
                      'forget_password'.tr,
                      style: TextStyle(
                        fontSize: AppDimensions.d14.sp,
                        color: AppColors.primaryRed,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppDimensions.d32.h),

              /// -------- SIGN IN BUTTON --------
              Obx(
                    () => CustomButton(
                  text: 'sign_in'.tr,
                  onPressed: controller.login,
                  isLoading: controller.isLoading.value,
                  backgroundColor: AppColors.primaryRed,
                  height: AppDimensions.d50.h,
                ),
              ),

              SizedBox(height: AppDimensions.d32.h),

              /// -------- SIGN UP PROMPT --------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'want_a_navigator'.tr,
                    style: TextStyle(
                      fontSize: AppDimensions.d14.sp,
                      color: AppColors.textSecondary,
                      fontFamily: 'Gotham',
                    ),
                  ),
                  SizedBox(width: AppDimensions.d4.w),
                  TextButton(
                    onPressed: () {
                      // ✅ Initialize RegisterController before navigating
                      if (!Get.isRegistered<RegisterController>()) {
                        Get.put(RegisterController());
                      }
                      Get.toNamed(AppRoutes.register);
                    },
                    child: Text(
                      'sign_up'.tr,
                      style: TextStyle(
                        fontSize: AppDimensions.d14.sp,
                        color: AppColors.primaryRed,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppDimensions.d40.h),

              /// -------- BOTTOM LOGO --------
              Center(
                child: CustomSvg(
                  assetPath: 'assets/images/logo.svg',
                  width: AppDimensions.d30.w,
                  height: AppDimensions.d30.h,
                  semanticsLabel: 'bottom_logo'.tr,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
