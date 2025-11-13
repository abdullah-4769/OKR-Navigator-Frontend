import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';
import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../utils/validator.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/custom_textfield.dart';

class ProfileScreen extends StatelessWidget {
  final controller = Get.find<ProfileController>();
  ProfileScreen({super.key});

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
        // ✅ FIX: This prevents white screen issue
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Center(
            child: Container(
              width: maxContentWidth,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    // ✅ FIX: Keyboard dismisses on drag
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: ConstrainedBox(
                      // ✅ FIX: Use constraints from LayoutBuilder
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Form(
                          key: controller.formKey, // Optional: if validation needed
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
                              /// Input Fields Section (Read-only for profile view)
                              _buildInputFieldsSection(
                                  screenHeight,
                                  screenWidth,
                                  isTablet,
                                  context
                              ),
                              SizedBox(
                                height: _getResponsiveSpacing(screenHeight, 0.04),
                              ),
                              /// Logout Button
                              _buildLogoutButton(isTablet),
                              SizedBox(
                                height: _getResponsiveSpacing(screenHeight, 0.025),
                              ),
                              /// Sign In Prompt (Optional: e.g., Edit Profile link)
                              _buildEditPrompt(
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
                              // ✅ FIX: Extra padding for keyboard
                              SizedBox(
                                height: _getResponsiveSpacing(screenHeight, 0.02),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
      'my_profile'.tr, // Assuming translation key for "My Profile"
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
        'view_manage_profile'.tr,
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

  /// Build input fields section with responsive spacing (read-only for profile)
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
          enabled: false, // Read-only
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
          enabled: false, // Read-only
          keyboardType: TextInputType.emailAddress,
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
          enabled: false, // Read-only
          keyboardType: TextInputType.phone,
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: AppColors.textSecondary,
            size: iconSize,
          ),
        ),
        // No password fields for profile view
      ],
    );
  }

  /// Build logout button with responsive width
  Widget _buildLogoutButton(bool isTablet) {
    return Obx(
          () => SizedBox(
        width: isTablet ? 350.0 : double.infinity,
        child: CustomButton(
          text: 'logout'.tr,
          onPressed: controller.logout, // Assuming logout method in ProfileController
          isLoading: controller.isLoading.value,
          // Optional: Use a different color for logout, e.g., backgroundColor: AppColors.accentRed
        ),
      ),
    );
  }

  /// Build edit prompt with responsive text (links to edit profile or login if needed)
  Widget _buildEditPrompt(
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
          'want_to_edit'.tr, // Assuming "Want to edit your profile?"
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: promptTextSize,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(width: screenWidth * 0.015),
        GestureDetector(
          onTap: () =>
              Get.toNamed(AppRoutes.register), // Assuming edit profile route
          child: Text(
            'edit_profile'.tr,
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

  // 🔹 RESPONSIVE HELPER METHODS (Same as RegisterScreen)
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