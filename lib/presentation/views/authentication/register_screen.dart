import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) => OrientationBuilder(
    builder: (context, orientation) {
      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final screenWidth = mediaQuery.size.width;
      final isPortrait = orientation == Orientation.portrait;
      final isTablet = screenWidth > 600;
      final isDesktop = screenWidth > 900;

      // Responsive calculations
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
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                    screenHeight -
                        mediaQuery.padding.top -
                        mediaQuery.padding.bottom,
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.04),
                        ),

                        /// Top Logo
                        _buildTopLogo(screenWidth, isPortrait, isTablet),

                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.025),
                        ),

                        /// Title Section
                        _buildTitleSection(
                          theme,
                          screenWidth,
                          isPortrait,
                          isTablet,
                        ),

                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.015),
                        ),

                        /// Subtitle
                        _buildSubtitleSection(screenWidth, isTablet, isDesktop),

                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.04),
                        ),

                        /// Input Fields Section
                        _buildInputFieldsSection(
                            screenHeight,
                            screenWidth,
                            isTablet,
                            context
                        ),

                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.04),
                        ),

                        /// Sign Up Button
                        _buildSignUpButton(isTablet),

                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.025),
                        ),

                        /// Sign In Prompt
                        _buildSignInPrompt(
                          theme,
                          screenWidth,
                          isPortrait,
                          isTablet,
                        ),

                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.03),
                        ),

                        /// Bottom Logo
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
        ),
      );
    },
  );

  /// Build top logo with responsive sizing
  Widget _buildTopLogo(double screenWidth, bool isPortrait, bool isTablet) {
    final logoSize = _getLogoSize(
      screenWidth,
      isPortrait,
      isTablet,
      isTop: true,
    );

    return CustomSvg(
      assetPath: AppAssets.okrLogo,
      width: logoSize,
      height: logoSize,
      semanticsLabel: 'okr_logo'.tr,
    );
  }

  /// Build title section with responsive typography
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

  /// Build subtitle section with responsive text
  Widget _buildSubtitleSection(
      double screenWidth,
      bool isTablet,
      bool isDesktop,
      ) {
    final subtitleSize = _getSubtitleSize(screenWidth, isTablet, isDesktop);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? screenWidth * 0.1 : screenWidth * 0.05,
      ),
      child: Text(
        'Sign up to step into the role of a strategic Navigator.'.tr,
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

  /// Build input fields section with responsive spacing and password visibility
  Widget _buildInputFieldsSection(
      double screenHeight,
      double screenWidth,
      bool isTablet,
      BuildContext context
      ) {
    final fieldSpacing = _getFieldSpacing(screenHeight, isTablet);
    final iconSize = screenWidth * 0.05;

    return Column(
      children: [
        CustomTextField(
          controller: controller.nameController,
          hint: 'enter_name'.tr,
          validator: (value) =>
              Validators.isRequired(value, 'name_required'.tr),
          textCapitalization: TextCapitalization.words,
          prefixIcon: Icon(
            Icons.person_outline,
            color: AppColors.textSecondary,
            size: iconSize,
          ),
        ),
        SizedBox(height: fieldSpacing),

        CustomTextField(
          controller: controller.emailController,
          hint: 'enter_email'.tr,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: AppColors.textSecondary,
            size: iconSize,
          ),
        ),
        SizedBox(height: fieldSpacing),

        CustomTextField(
          controller: controller.phoneController,
          hint: 'enter_phone'.tr,
          keyboardType: TextInputType.phone,
          validator: Validators.phone,
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: AppColors.textSecondary,
            size: iconSize,
          ),
        ),
        SizedBox(height: fieldSpacing),

        /// Password Field with Visibility Toggle
        Obx(() => CustomTextField(
          controller: controller.passwordController,
          hint: 'enter_password'.tr,
          obscureText: !controller.isPasswordVisible.value,
          validator: Validators.password,
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: AppColors.textSecondary,
            size: iconSize,
          ),
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
        )),
        SizedBox(height: fieldSpacing),

        /// Confirm Password Field with Visibility Toggle
        Obx(() => CustomTextField(
          controller: controller.confirmPasswordController,
          hint: 'confirm_password'.tr,
          obscureText: !controller.isConfirmPasswordVisible.value,
          validator: (value) => Validators.confirmPassword(
            controller.passwordController.text,
            value,
          ),
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: AppColors.textSecondary,
            size: iconSize,
          ),
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
        )),
      ],
    );
  }

  /// Build sign up button with responsive width
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

  /// Build sign in prompt with responsive text
  Widget _buildSignInPrompt(
      ThemeData theme,
      double screenWidth,
      bool isPortrait,
      bool isTablet,
      ) {
    final promptTextSize = _getPromptTextSize(
      screenWidth,
      isPortrait,
      isTablet,
    );

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

  /// Build bottom logo with responsive sizing
  Widget _buildBottomLogo(double screenWidth, bool isTablet) {
    final logoSize = _getLogoSize(screenWidth, true, isTablet, isTop: false);

    return CustomSvg(
      assetPath: 'assets/images/logo.svg',
      width: logoSize,
      height: logoSize,
      semanticsLabel: 'bottom_logo'.tr,
    );
  }

  // 🔹 RESPONSIVE HELPER METHODS

  /// Get maximum content width for larger screens
  double _getMaxContentWidth(double screenWidth) {
    if (screenWidth > 1200) return 500.0; // Desktop
    if (screenWidth > 900) return 450.0; // Large tablet
    if (screenWidth > 600) return 400.0; // Tablet
    return double.infinity; // Mobile
  }

  /// Get horizontal padding based on screen width
  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth > 900) return 40.0;
    if (screenWidth > 600) return 32.0;
    return screenWidth * 0.06;
  }

  /// Get responsive spacing
  double _getResponsiveSpacing(double screenHeight, double factor) {
    return screenHeight * factor;
  }

  /// Get logo size based on screen dimensions
  double _getLogoSize(
      double screenWidth,
      bool isPortrait,
      bool isTablet, {
        required bool isTop,
      }) {
    if (isTablet) {
      if (isTop) {
        return isPortrait ? screenWidth * 0.12 : screenWidth * 0.08;
      } else {
        return screenWidth * 0.06;
      }
    } else {
      if (isTop) {
        return isPortrait ? screenWidth * 0.15 : screenWidth * 0.1;
      } else {
        return screenWidth * 0.09;
      }
    }
  }

  /// Get title font size
  double _getTitleSize(double screenWidth, bool isPortrait, bool isTablet) {
    if (screenWidth > 900) return 32.0;
    if (isTablet) return isPortrait ? 28.0 : 24.0;
    return isPortrait ? screenWidth * 0.06 : screenWidth * 0.045;
  }

  /// Get subtitle font size
  double _getSubtitleSize(double screenWidth, bool isTablet, bool isDesktop) {
    if (isDesktop) return 18.0;
    if (isTablet) return 17.0;
    if (screenWidth > 400) return 16.0;
    return 15.0;
  }

  /// Get field spacing
  double _getFieldSpacing(double screenHeight, bool isTablet) {
    final baseSpacing = screenHeight * 0.02;
    if (isTablet) return baseSpacing * 1.2;
    return baseSpacing;
  }

  /// Get prompt text size
  double _getPromptTextSize(
      double screenWidth,
      bool isPortrait,
      bool isTablet,
      ) {
    if (isTablet) return 16.0;
    return isPortrait ? screenWidth * 0.035 : screenWidth * 0.03;
  }
}












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
// import '../../widgets/custom_textfield.dart';
//
// class RegisterScreen extends StatelessWidget {
//   final controller = Get.find<RegisterController>();
//
//   RegisterScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) => OrientationBuilder(
//     builder: (context, orientation) {
//       final mediaQuery = MediaQuery.of(context);
//       final screenHeight = mediaQuery.size.height;
//       final screenWidth = mediaQuery.size.width;
//       final isPortrait = orientation == Orientation.portrait;
//       final isTablet = screenWidth > 600;
//       final isDesktop = screenWidth > 900;
//
//       // Responsive calculations
//       final maxContentWidth = _getMaxContentWidth(screenWidth);
//       final horizontalPadding = _getHorizontalPadding(screenWidth);
//       final theme = Theme.of(context);
//
//       return Scaffold(
//         backgroundColor: AppColors.white,
//         body: SafeArea(
//           child: Center(
//             child: Container(
//               width: maxContentWidth,
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     minHeight:
//                         screenHeight -
//                         mediaQuery.padding.top -
//                         mediaQuery.padding.bottom,
//                   ),
//                   child: Form(
//                     key: controller.formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: _getResponsiveSpacing(screenHeight, 0.04),
//                         ),
//
//                         /// Top Logo
//                         _buildTopLogo(screenWidth, isPortrait, isTablet),
//
//                         SizedBox(
//                           height: _getResponsiveSpacing(screenHeight, 0.025),
//                         ),
//
//                         /// Title Section
//                         _buildTitleSection(
//                           theme,
//                           screenWidth,
//                           isPortrait,
//                           isTablet,
//                         ),
//
//                         SizedBox(
//                           height: _getResponsiveSpacing(screenHeight, 0.015),
//                         ),
//
//                         /// Subtitle
//                         _buildSubtitleSection(screenWidth, isTablet, isDesktop),
//
//                         SizedBox(
//                           height: _getResponsiveSpacing(screenHeight, 0.04),
//                         ),
//
//                         /// Input Fields Section
//                         _buildInputFieldsSection(screenHeight, isTablet),
//
//                         SizedBox(
//                           height: _getResponsiveSpacing(screenHeight, 0.04),
//                         ),
//
//                         /// Sign Up Button
//                         _buildSignUpButton(isTablet),
//
//                         SizedBox(
//                           height: _getResponsiveSpacing(screenHeight, 0.025),
//                         ),
//
//                         /// Sign In Prompt
//                         _buildSignInPrompt(
//                           theme,
//                           screenWidth,
//                           isPortrait,
//                           isTablet,
//                         ),
//
//                         SizedBox(
//                           height: _getResponsiveSpacing(screenHeight, 0.03),
//                         ),
//
//                         /// Bottom Logo
//                         _buildBottomLogo(screenWidth, isTablet),
//
//                         SizedBox(
//                           height: _getResponsiveSpacing(screenHeight, 0.02),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//   );
//
//   /// Build top logo with responsive sizing
//   Widget _buildTopLogo(double screenWidth, bool isPortrait, bool isTablet) {
//     final logoSize = _getLogoSize(
//       screenWidth,
//       isPortrait,
//       isTablet,
//       isTop: true,
//     );
//
//     return CustomSvg(
//       assetPath: AppAssets.okrLogo,
//       width: logoSize,
//       height: logoSize,
//       semanticsLabel: 'okr_logo'.tr,
//     );
//   }
//
//   /// Build title section with responsive typography
//   Widget _buildTitleSection(
//     ThemeData theme,
//     double screenWidth,
//     bool isPortrait,
//     bool isTablet,
//   ) {
//     final titleSize = _getTitleSize(screenWidth, isPortrait, isTablet);
//
//     return Text(
//       'enter_arena'.tr,
//       style: theme.textTheme.headlineLarge?.copyWith(
//         fontSize: titleSize,
//         color: AppColors.primaryBlue,
//         fontWeight: FontWeight.w700,
//       ),
//       textAlign: TextAlign.center,
//       maxLines: 2,
//       overflow: TextOverflow.ellipsis,
//     );
//   }
//
//   /// Build subtitle section with responsive text
//   Widget _buildSubtitleSection(
//     double screenWidth,
//     bool isTablet,
//     bool isDesktop,
//   ) {
//     final subtitleSize = _getSubtitleSize(screenWidth, isTablet, isDesktop);
//
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: isTablet ? screenWidth * 0.1 : screenWidth * 0.05,
//       ),
//       child: Text(
//         'Sign up to step into the role of a strategic Navigator.'.tr,
//         style: TextStyle(
//           fontWeight: FontWeight.w400,
//           fontFamily: "GothamMedium",
//           fontSize: subtitleSize,
//           color: AppColors.textSecondary,
//           height: 1.4,
//         ),
//         textAlign: TextAlign.center,
//         maxLines: 3,
//         overflow: TextOverflow.ellipsis,
//       ),
//     );
//   }
//
//   /// Build input fields section with responsive spacing
//   Widget _buildInputFieldsSection(double screenHeight, bool isTablet) {
//     final fieldSpacing = _getFieldSpacing(screenHeight, isTablet);
//
//     return Column(
//       children: [
//         CustomTextField(
//           controller: controller.nameController,
//           hint: 'enter_name'.tr,
//           validator: (value) =>
//               Validators.isRequired(value, 'name_required'.tr),
//           textCapitalization: TextCapitalization.words,
//         ),
//         SizedBox(height: fieldSpacing),
//
//         CustomTextField(
//           controller: controller.emailController,
//           hint: 'enter_email'.tr,
//           keyboardType: TextInputType.emailAddress,
//           validator: Validators.email,
//         ),
//         SizedBox(height: fieldSpacing),
//
//         CustomTextField(
//           controller: controller.phoneController,
//           hint: 'enter_phone'.tr,
//           keyboardType: TextInputType.phone,
//           validator: Validators.phone,
//         ),
//         SizedBox(height: fieldSpacing),
//
//         CustomTextField(
//           controller: controller.passwordController,
//           hint: 'enter_password'.tr,
//           obscureText: true,
//           validator: Validators.password,
//         ),
//         SizedBox(height: fieldSpacing),
//
//         CustomTextField(
//           controller: controller.confirmPasswordController,
//           hint: 'confirm_password'.tr,
//           obscureText: true,
//           validator: (value) => Validators.confirmPassword(
//             controller.passwordController.text,
//             value,
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Build sign up button with responsive width
//   Widget _buildSignUpButton(bool isTablet) {
//     return Obx(
//       () => SizedBox(
//         width: isTablet ? 350.0 : double.infinity,
//         child: CustomButton(
//           text: 'sign_up'.tr,
//           onPressed: controller.register,
//           isLoading: controller.isLoading.value,
//         ),
//       ),
//     );
//   }
//
//   /// Build sign in prompt with responsive text
//   Widget _buildSignInPrompt(
//     ThemeData theme,
//     double screenWidth,
//     bool isPortrait,
//     bool isTablet,
//   ) {
//     final promptTextSize = _getPromptTextSize(
//       screenWidth,
//       isPortrait,
//       isTablet,
//     );
//
//     return Wrap(
//       alignment: WrapAlignment.center,
//       crossAxisAlignment: WrapCrossAlignment.center,
//       children: [
//         Text(
//           'already_have_account'.tr,
//           style: theme.textTheme.bodyMedium?.copyWith(
//             fontSize: promptTextSize,
//             color: AppColors.textSecondary,
//           ),
//         ),
//         SizedBox(width: screenWidth * 0.015),
//         GestureDetector(
//           onTap: () => Get.toNamed(AppRoutes.login),
//           child: Text(
//             'sign_in'.tr,
//             style: theme.textTheme.bodyMedium?.copyWith(
//               fontSize: promptTextSize,
//               color: AppColors.accentRed,
//               fontWeight: FontWeight.bold,
//               decoration: TextDecoration.underline,
//               decorationColor: AppColors.accentRed,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Build bottom logo with responsive sizing
//   Widget _buildBottomLogo(double screenWidth, bool isTablet) {
//     final logoSize = _getLogoSize(screenWidth, true, isTablet, isTop: false);
//
//     return CustomSvg(
//       assetPath: 'assets/images/logo.svg',
//       width: logoSize,
//       height: logoSize,
//       semanticsLabel: 'bottom_logo'.tr,
//     );
//   }
//
//   // 🔹 RESPONSIVE HELPER METHODS
//
//   /// Get maximum content width for larger screens
//   double _getMaxContentWidth(double screenWidth) {
//     if (screenWidth > 1200) return 500.0; // Desktop
//     if (screenWidth > 900) return 450.0; // Large tablet
//     if (screenWidth > 600) return 400.0; // Tablet
//     return double.infinity; // Mobile
//   }
//
//   /// Get horizontal padding based on screen width
//   double _getHorizontalPadding(double screenWidth) {
//     if (screenWidth > 900) return 40.0;
//     if (screenWidth > 600) return 32.0;
//     return screenWidth * 0.06;
//   }
//
//   /// Get responsive spacing
//   double _getResponsiveSpacing(double screenHeight, double factor) {
//     return screenHeight * factor;
//   }
//
//   /// Get logo size based on screen dimensions
//   double _getLogoSize(
//     double screenWidth,
//     bool isPortrait,
//     bool isTablet, {
//     required bool isTop,
//   }) {
//     if (isTablet) {
//       if (isTop) {
//         return isPortrait ? screenWidth * 0.12 : screenWidth * 0.08;
//       } else {
//         return screenWidth * 0.06;
//       }
//     } else {
//       if (isTop) {
//         return isPortrait ? screenWidth * 0.15 : screenWidth * 0.1;
//       } else {
//         return screenWidth * 0.09;
//       }
//     }
//   }
//
//   /// Get title font size
//   double _getTitleSize(double screenWidth, bool isPortrait, bool isTablet) {
//     if (screenWidth > 900) return 32.0;
//     if (isTablet) return isPortrait ? 28.0 : 24.0;
//     return isPortrait ? screenWidth * 0.06 : screenWidth * 0.045;
//   }
//
//   /// Get subtitle font size
//   double _getSubtitleSize(double screenWidth, bool isTablet, bool isDesktop) {
//     if (isDesktop) return 18.0;
//     if (isTablet) return 17.0;
//     if (screenWidth > 400) return 16.0;
//     return 15.0;
//   }
//
//   /// Get field spacing
//   double _getFieldSpacing(double screenHeight, bool isTablet) {
//     final baseSpacing = screenHeight * 0.02;
//     if (isTablet) return baseSpacing * 1.2;
//     return baseSpacing;
//   }
//
//   /// Get prompt text size
//   double _getPromptTextSize(
//     double screenWidth,
//     bool isPortrait,
//     bool isTablet,
//   ) {
//     if (isTablet) return 16.0;
//     return isPortrait ? screenWidth * 0.035 : screenWidth * 0.03;
//   }
// }
