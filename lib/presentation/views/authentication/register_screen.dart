import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/register_controller.dart';
import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../utils/validator.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  final controller = Get.find<RegisterController>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;
        final screenHeight = mediaQuery.size.height;
        final screenWidth = mediaQuery.size.width;

        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight -
                      mediaQuery.padding.top -
                      mediaQuery.padding.bottom,
                ),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.04),

                      /// Top Logo
                      CustomSvg(
                        assetPath: AppAssets.okrLogo,
                        width: isPortrait
                            ? screenWidth * 0.15
                            : screenWidth * 0.18,
                        height: isPortrait
                            ? screenWidth * 0.15
                            : screenWidth * 0.08,
                        semanticsLabel: 'okr_logo'.tr,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      /// Title
                      Center(
                        child: Text(
                          'enter_arena'.tr,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: isPortrait
                                ? screenWidth * 0.06
                                : screenWidth * 0.045,
                            color: AppColors.primaryBlue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      /// Subtitle
                      Center(
                        child: Text(
                          'Sign up to step into the role of a strategic Navigator.'.tr,
                          style:TextStyle(
                            fontWeight:FontWeight.w400,
                            fontFamily: "GothamMedium",
                            fontSize: 16.sp,
                          ),
                          textAlign: TextAlign.center,
                      ),),
                      SizedBox(height: screenHeight * 0.04),

                      /// Input Fields
                      CustomTextField(
                        controller: controller.nameController,
                        hint: 'enter_name'.tr,
                        validator: (value) =>
                            Validators.isRequired(value, 'name_required'.tr),
                        textCapitalization: TextCapitalization.words,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      CustomTextField(
                        controller: controller.emailController,
                        hint: 'enter_email'.tr,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      CustomTextField(
                        controller: controller.phoneController,
                        hint: 'enter_phone'.tr,
                        keyboardType: TextInputType.phone,
                        validator: Validators.phone,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      CustomTextField(
                        controller: controller.passwordController,
                        hint: 'enter_password'.tr,
                        obscureText: true,
                        validator: Validators.password,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      CustomTextField(
                        controller: controller.confirmPasswordController,
                        hint: 'confirm_password'.tr,
                        obscureText: true,
                        validator: (value) => Validators.confirmPassword(
                          controller.passwordController.text,
                          value,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      /// Sign Up Button
                      Obx(
                            () => CustomButton(
                          text: 'sign_up'.tr,
                          onPressed: controller.register,
                          isLoading: controller.isLoading.value,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      /// Sign In Prompt
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'already_have_account'.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: isPortrait
                                  ? screenWidth * 0.035
                                  : screenWidth * 0.03,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.login),
                            child: Text(
                              'sign_in'.tr,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: isPortrait
                                    ? screenWidth * 0.035
                                    : screenWidth * 0.03,
                                color: AppColors.accentRed,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      /// Bottom Logo
                      Center(
                        child: CustomSvg(
                          assetPath: 'assets/images/logo.svg',
                          width: screenWidth * 0.09,
                          height: screenWidth * 0.09,
                          semanticsLabel: 'bottom_logo'.tr,
                        ),
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
