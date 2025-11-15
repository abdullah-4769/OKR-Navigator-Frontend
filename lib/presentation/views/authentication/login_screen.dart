import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/login_controller.dart';
import '../../../controllers/register_controller.dart';
import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../utils/snackbar_helper.dart';
import '../../../utils/validator.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  final controller = Get.find<LoginController>();
  final googlelogin = Get.find<LoginController>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;
        final mediaQuery = MediaQuery.of(context);
        final screenHeight = mediaQuery.size.height;
        final screenWidth = mediaQuery.size.width;

        // Responsive paddings & sizes
        final horizontalPadding = screenWidth * 0.06;
        final logoSize = isPortrait ? screenWidth * 0.22 : screenWidth * 0.15;

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Form(
                key: controller.formKey,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight -
                        mediaQuery.padding.top -
                        mediaQuery.padding.bottom,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.05),

                      /// -------- LOGO --------
                      CustomSvg(
                        assetPath: AppAssets.okrLogo,
                        width: logoSize,
                        height: logoSize,
                        semanticsLabel: 'okr_logo'.tr,
                      ),
                      SizedBox(height: screenHeight * 0.05),

                      /// -------- TITLE --------
                      Text(
                        'rejoin_operation'.tr,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize:
                          isPortrait ? screenWidth * 0.06 : screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),

                      /// -------- SUBTITLE --------
                      Text(
                        'strategy_awaits'.tr,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize:
                          isPortrait ? screenWidth * 0.04 : screenWidth * 0.03,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      /// -------- EMAIL FIELD --------
                      CustomTextField(
                        controller: controller.emailController,
                        hint: 'enter_email'.tr,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.textSecondary,
                          size: screenWidth * 0.05,
                        ),
                        validator: Validators.email,
                      ),
                      SizedBox(height: screenHeight * 0.025),

                      /// -------- PASSWORD FIELD WITH VISIBILITY TOGGLE --------
                      Obx(() => CustomTextField(
                        controller: controller.passwordController,
                        hint: 'enter_password'.tr,
                        obscureText: !controller.isPasswordVisible.value,
                        prefixIcon: Icon(
                          Icons.lock_outlined,
                          color: AppColors.textSecondary,
                          size: screenWidth * 0.05,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                            size: screenWidth * 0.05,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        validator: Validators.password,
                      )),
                      SizedBox(height: screenHeight * 0.02),

                      /// -------- REMEMBER ME + FORGOT PASSWORD --------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                                () => Row(
                              children: [
                                Checkbox(
                                  value: controller.rememberMe.value,
                                  onChanged: controller.toggleRememberMe,
                                  activeColor: AppColors.primaryRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.d4,
                                    ),
                                  ),
                                ),
                                Text(
                                  'remember_me'.tr,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: screenWidth * 0.035,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                SnackbarHelper.info('password_reset_coming'.tr),
                            child: Text(
                              'forget_password'.tr,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: screenWidth * 0.035,
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis

                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      /// -------- SIGN IN BUTTON --------
                      Obx(
                            () => CustomButton(
                          text: 'sign_in'.tr,
                          onPressed: controller.login,
                          isLoading: controller.isLoading.value,
                          backgroundColor: AppColors.primaryRed,
                          height: screenHeight * 0.065,
                        ),
                      ),

// Replace the Google Sign-In button section in your LoginScreen with this:

                      SizedBox(height: screenHeight * 0.04),

                      /// -------- GOOGLE SIGN IN BUTTON --------
                      /// -------- GOOGLE SIGN IN BUTTON --------
                      Obx(() => InkWell(
                        onTap: googlelogin.isGoogleLoading.value
                            ? null
                            : () => googlelogin.loginWithGoogle(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 45.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: googlelogin.isGoogleLoading.value
                                  ? AppColors.border.withOpacity(0.5)
                                  : AppColors.border,
                            ),
                            color: googlelogin.isGoogleLoading.value
                                ? Colors.grey.shade100
                                : Colors.white,
                          ),
                          child: googlelogin.isGoogleLoading.value
                              ? const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                              ),
                            ),
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/google.png",
                                height: 20,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.g_mobiledata, size: 24);
                                },
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "continue_with_google".tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                      SizedBox(height: screenHeight * 0.04),

                      SizedBox(height: screenHeight * 0.04),

                      /// -------- SIGN UP PROMPT --------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'want_a_navigator'.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: screenWidth * 0.035,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: screenWidth * 0.015),
                          TextButton(
                            onPressed: () {
                              if (!Get.isRegistered<RegisterController>()) {
                                Get.put(RegisterController());
                              }
                              Get.toNamed(AppRoutes.register);
                            },
                            child: Text(
                              'sign_up'.tr,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: screenWidth * 0.035,
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      /// -------- BOTTOM LOGO --------
                      CustomSvg(
                        assetPath: 'assets/images/logo.svg',
                        width: screenWidth * 0.08,
                        height: screenWidth * 0.08,
                        semanticsLabel: 'bottom_logo'.tr,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}








