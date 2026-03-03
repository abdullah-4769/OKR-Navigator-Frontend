// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../controllers/register_controller.dart';
// import '../../../core/app_assets.dart';
// import '../../../core/app_colors.dart';
// import '../../../utils/validator.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_svg.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../controllers/login_controller.dart';
import '../../../controllers/register_controller.dart';
import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../utils/validator.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterController controller;
  final googlelogin = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    // Only put controller if it doesn't exist
    if (!Get.isRegistered<RegisterController>()) {
      controller = Get.put(RegisterController());
    } else {
      controller = Get.find<RegisterController>();
    }
  }
  // @override
  // void initState() {
  //   super.initState();
  //   controller = Get.put(RegisterController(), permanent: false);
  // }



  // @override
  // void dispose() {
  //   // Safely dispose controller and its TextEditingControllers
  //   if (Get.isRegistered<RegisterController>()) {
  //     Get.delete<RegisterController>();
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) => OrientationBuilder(
    builder: (context, orientation) {
      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final screenWidth = mediaQuery.size.width;
      final isPortrait = orientation == Orientation.portrait;
      final isTablet = screenWidth > 600;
      final isDesktop = screenWidth > 900;

      final maxContentWidth = _getMaxContentWidth(screenWidth);
      final horizontalPadding = _getHorizontalPadding(screenWidth);
      final theme = Theme.of(context);

      return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Center(
            child: Container(
              width: maxContentWidth,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: _getResponsiveSpacing(screenHeight, 0.04),
                      ),
                      _buildTopLogo(screenWidth, isPortrait, isTablet),
                      SizedBox(
                        height: _getResponsiveSpacing(screenHeight, 0.025),
                      ),
                      _buildTitleSection(
                        theme,
                        screenWidth,
                        isPortrait,
                        isTablet,
                      ),
                      SizedBox(
                        height: _getResponsiveSpacing(screenHeight, 0.015),
                      ),
                      _buildSubtitleSection(
                          screenWidth, isTablet, isDesktop),
                      SizedBox(
                        height: _getResponsiveSpacing(screenHeight, 0.04),
                      ),
                      _buildInputFieldsSection(
                        screenHeight,
                        screenWidth,
                        isTablet,
                        context,
                      ),
                      SizedBox(
                        height: _getResponsiveSpacing(screenHeight, 0.04),
                      ),
                      _buildSignUpButton(isTablet),
                      SizedBox(
                        height: _getResponsiveSpacing(screenHeight, 0.04),
                      ),
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
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     print("=== GOOGLE SIGN-IN TEST ===");
                      //
                      //     try {
                      //       // Test 1: Simple Google Sign-In
                      //       final GoogleSignIn googleSignIn = GoogleSignIn();
                      //       final account = await googleSignIn.signIn();
                      //
                      //       if (account == null) {
                      //         print("User cancelled");
                      //         return;
                      //       }
                      //
                      //       print("Success! User: ${account.email}");
                      //       print("Display Name: ${account.displayName}");
                      //
                      //       final auth = await account.authentication;
                      //       print("ID Token length: ${auth.idToken?.length ?? 0}");
                      //       print("Access Token: ${auth.accessToken != null}");
                      //
                      //     } catch (e, stackTrace) {
                      //       print("ERROR: $e");
                      //       print("Stack: $stackTrace");
                      //     }
                      //   },
                      //   child: Text("Test Google Sign-In"),
                      // ),
                      SizedBox(
                        height: _getResponsiveSpacing(screenHeight, 0.025),
                      ),
                      _buildSignInPrompt(
                        theme,
                        screenWidth,
                        isPortrait,
                        isTablet,
                      ),
                      SizedBox(
                        height: _getResponsiveSpacing(screenHeight, 0.03),
                      ),
                      _buildBottomLogo(screenWidth, isTablet),
                      SizedBox(
                        height: _getResponsiveSpacing(screenHeight, 0.02),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  // ================= UI BUILDERS =================

  Widget _buildTopLogo(double screenWidth, bool isPortrait, bool isTablet) {
    final logoSize = _getLogoSize(screenWidth, isPortrait, isTablet, isTop: true);
    return CustomSvg(
      assetPath: AppAssets.okrLogo,
      width: logoSize,
      height: logoSize,
      semanticsLabel: 'okr_logo'.tr,
    );
  }

  Widget _buildTitleSection(
      ThemeData theme,
      double screenWidth,
      bool isPortrait,
      bool isTablet,
      ) {
    final titleSize = _getTitleSize(screenWidth, isPortrait, isTablet);
    return Text(
      'enter_arena'.tr,
      style: theme.textTheme.headlineLarge?.copyWith(
        fontSize: titleSize,
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w700,
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitleSection(
      double screenWidth, bool isTablet, bool isDesktop) {
    final subtitleSize = _getSubtitleSize(screenWidth, isTablet, isDesktop);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? screenWidth * 0.1 : screenWidth * 0.05,
      ),
      child: Text(
        'sign_up_navigator'.tr,

        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: "GothamMedium",
          fontSize: subtitleSize,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildInputFieldsSection(
      double screenHeight, double screenWidth, bool isTablet, BuildContext context) {
    final fieldSpacing = _getFieldSpacing(screenHeight, isTablet);
    final iconSize = screenWidth * 0.05;

    return Column(
      children: [
        CustomTextField(
          controller: controller.nameController,
          hint: 'enter_name'.tr,
          validator: (value) => Validators.isRequired(value, 'name_required'.tr),
          textCapitalization: TextCapitalization.words,
          prefixIcon: Icon(Icons.person_outline,
              color: AppColors.textSecondary, size: iconSize),
        ),
        SizedBox(height: fieldSpacing),
        CustomTextField(
          controller: controller.emailController,
          hint: 'enter_email'.tr,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
          prefixIcon: Icon(Icons.email_outlined,
              color: AppColors.textSecondary, size: iconSize),
        ),
        SizedBox(height: fieldSpacing),
        CustomTextField(
          controller: controller.phoneController,
          hint: 'enter_phone'.tr,
          keyboardType: TextInputType.phone,
          validator: Validators.phone,
          prefixIcon: Icon(Icons.phone_outlined,
              color: AppColors.textSecondary, size: iconSize),
        ),
        SizedBox(height: fieldSpacing),
        Obx(
              () => CustomTextField(
            controller: controller.passwordController,
            hint: 'enter_password'.tr,
            obscureText: !controller.isPasswordVisible.value,
            validator: Validators.password,
            prefixIcon: Icon(Icons.lock_outlined,
                color: AppColors.textSecondary, size: iconSize),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
                size: iconSize,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
        ),
        SizedBox(height: fieldSpacing),
        Obx(
              () => CustomTextField(
            controller: controller.confirmPasswordController,
            hint: 'confirm_password'.tr,
            obscureText: !controller.isConfirmPasswordVisible.value,
            validator: (value) => Validators.confirmPassword(
                controller.passwordController.text, value),
            prefixIcon: Icon(Icons.lock_outlined,
                color: AppColors.textSecondary, size: iconSize),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isConfirmPasswordVisible.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
                size: iconSize,
              ),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(bool isTablet) {
    return Obx(
          () => SizedBox(
        width: isTablet ? 350.0 : double.infinity,
        child: CustomButton(
          text: 'sign_up'.tr,
          onPressed: controller.register,
          isLoading: controller.isLoading.value,
        ),
      ),
    );
  }

  Widget _buildSignInPrompt(
      ThemeData theme,
      double screenWidth,
      bool isPortrait,
      bool isTablet,
      ) {
    final promptTextSize =
    _getPromptTextSize(screenWidth, isPortrait, isTablet);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'already_have_account'.tr,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: promptTextSize,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(width: screenWidth * 0.015),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.login),
          child: Text(
            'sign_in'.tr,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: promptTextSize,
              color: AppColors.accentRed,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.accentRed,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomLogo(double screenWidth, bool isTablet) {
    final logoSize = _getLogoSize(screenWidth, true, isTablet, isTop: false);
    return CustomSvg(
      assetPath: 'assets/images/logo.svg',
      width: logoSize,
      height: logoSize,
      semanticsLabel: 'bottom_logo'.tr,
    );
  }

  // ================= HELPER METHODS =================

  double _getMaxContentWidth(double screenWidth) {
    if (screenWidth > 1200) return 500.0;
    if (screenWidth > 900) return 450.0;
    if (screenWidth > 600) return 400.0;
    return double.infinity;
  }

  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth > 900) return 40.0;
    if (screenWidth > 600) return 32.0;
    return screenWidth * 0.06;
  }

  double _getResponsiveSpacing(double screenHeight, double factor) =>
      screenHeight * factor;

  double _getLogoSize(double screenWidth, bool isPortrait, bool isTablet,
      {required bool isTop}) {
    if (isTablet) {
      if (isTop) return isPortrait ? screenWidth * 0.12 : screenWidth * 0.08;
      return screenWidth * 0.06;
    } else {
      if (isTop) return isPortrait ? screenWidth * 0.15 : screenWidth * 0.1;
      return screenWidth * 0.09;
    }
  }

  double _getTitleSize(double screenWidth, bool isPortrait, bool isTablet) {
    if (screenWidth > 900) return 32.0;
    if (isTablet) return isPortrait ? 28.0 : 24.0;
    return isPortrait ? screenWidth * 0.06 : screenWidth * 0.045;
  }

  double _getSubtitleSize(double screenWidth, bool isTablet, bool isDesktop) {
    if (isDesktop) return 18.0;
    if (isTablet) return 17.0;
    if (screenWidth > 400) return 16.0;
    return 15.0;
  }

  double _getFieldSpacing(double screenHeight, bool isTablet) {
    final baseSpacing = screenHeight * 0.02;
    return isTablet ? baseSpacing * 1.2 : baseSpacing;
  }

  double _getPromptTextSize(
      double screenWidth, bool isPortrait, bool isTablet) {
    if (isTablet) return 16.0;
    return isPortrait ? screenWidth * 0.035 : screenWidth * 0.03;
  }
  // @override
  // void dispose() {
  //   // Only delete if this is the last instance
  //   if (Get.isRegistered<RegisterController>() &&
  //       Get.find<RegisterController>().nameController.text.isEmpty) {
  //     Get.delete<RegisterController>();
  //   }
  //   super.dispose();
  // }
}