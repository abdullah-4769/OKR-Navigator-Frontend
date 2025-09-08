import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_strings.dart';

import '../../../utils/validator.dart';
import '../../controllers/register_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppDimensions.d30.h),

                // Top Logo
                CustomSvg(
                  assetPath: AppAssets.okrLogo,
                  width: AppDimensions.d70.w,
                  height: AppDimensions.d70.h, semanticsLabel: '',
                ),
                SizedBox(height: AppDimensions.d40.h),

                // Title
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    AppStrings.enterArena.tr,
                    style: TextStyle(
                      fontSize: AppDimensions.d24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                      fontFamily: 'Gothic',
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.d10.h),

                Center(

                  child: Text(
                    textAlign: TextAlign.center,

                    AppStrings.signUpRole.tr,
                    style: TextStyle(

                      fontSize: AppDimensions.d18.sp,
                      color: AppColors.primaryBlue,
                      fontFamily: 'Gothic',
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.d40.h),

                // Input Fields
                CustomTextField(
                  controller: controller.nameController,
                  hint: AppStrings.enterName.tr,
                  validator: (value) => Validators.isRequired(value, AppStrings.nameRequired.tr),
                  textCapitalization: TextCapitalization.words,
                ),
                SizedBox(height: AppDimensions.d14.h),

                CustomTextField(
                  controller: controller.emailController,
                  hint: AppStrings.enterEmail.tr,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                SizedBox(height: AppDimensions.d14.h),

                CustomTextField(
                  controller: controller.phoneController,
                  hint: AppStrings.enterPhone.tr,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                SizedBox(height: AppDimensions.d14.h),

                CustomTextField(
                  controller: controller.passwordController,
                  hint: AppStrings.enterPassword.tr,
                  obscureText: true,
                  validator: Validators.password,
                ),
                SizedBox(height: AppDimensions.d14.h),

                CustomTextField(
                  controller: controller.confirmPasswordController,
                  hint: AppStrings.confirmPassword.tr,
                  obscureText: true,
                  validator: (value) => Validators.confirmPassword(
                    controller.passwordController.text,
                    value,
                  ),
                ),

                SizedBox(height: AppDimensions.d30.h),

                // Sign Up Button
                Obx(() => CustomButton(
                  text: AppStrings.signUp.tr,
                  onPressed: controller.register,
                  isLoading: controller.isLoading.value,
                )),
                SizedBox(height: AppDimensions.d20.h),

                // Sign In Prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount.tr,
                      style: TextStyle(
                        fontSize: AppDimensions.d14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: AppDimensions.d4.w),
                    GestureDetector(
                      onTap: () => Get.offAllNamed(AppRoutes.login),
                      child: Text(
                        AppStrings.signIn.tr,
                        style: TextStyle(
                          fontSize: AppDimensions.d14.sp,
                          color: AppColors.accentRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.d40.h),


                // Bottom Logo
                // Bottom Logo
                Center(
                  child: CustomSvg(
                    assetPath: 'assets/images/logo.svg',
                    width: AppDimensions.d30.w,
                    height: AppDimensions.d30.h, semanticsLabel: '',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}