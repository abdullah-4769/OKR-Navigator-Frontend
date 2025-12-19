import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';
import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../utils/validator.dart';
import '../../../view_model/profile_controller.dart';
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

      final maxContentWidth = _getMaxContentWidth(screenWidth);
      final horizontalPadding = _getHorizontalPadding(screenWidth);
      final theme = Theme.of(context);

      return Scaffold(
          backgroundColor: AppColors.white,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
              child: Obx(
                      () => controller.isLoading.value && controller.user.value == null
                      ? _buildLoadingState()
                      : controller.errorMessage.value.isNotEmpty
                      ? _buildErrorState(context, theme)
                      : Center(
                      child: Container(
                          width: maxContentWidth,
                          child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight: constraints.maxHeight,
                                      ),
                                      child: IntrinsicHeight(
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
                                              _buildTitleSection(theme, screenWidth, isPortrait, isTablet),
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
                                                context,
                                              ),
                                              SizedBox(
                                                height: _getResponsiveSpacing(screenHeight, 0.04),
                                              ),

                                              /// Action Buttons (Edit/Update or Logout)
                                              Obx(
                                                    () => controller.isEditMode.value
                                                    ? _buildUpdateCancelButtons(isTablet)
                                                    : _buildEditLogoutButtons(isTablet),
                                              ),
                                              SizedBox(
                                                height: _getResponsiveSpacing(screenHeight, 0.025),
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
                                    ) );

                          },
  ),
  ),
  ),
  ),
  ),
  );
},
);

/// Loading State
Widget _buildLoadingState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          'Loading profile...',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    ),
  );
}

/// Error State
Widget _buildErrorState(BuildContext context, ThemeData theme) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          color: AppColors.accentRed,
          size: 64,
        ),
        const SizedBox(height: 16),
        Text(
          'Error Loading Profile',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Obx(
              () => Text(
            controller.errorMessage.value,
            style: TextStyle(color: AppColors.accentRed),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => controller.refreshProfile(),
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}

/// Top Logo
Widget _buildTopLogo(double screenWidth, bool isPortrait, bool isTablet) {
  final logoSize = _getLogoSize(screenWidth, isPortrait, isTablet, isTop: true);
  return CustomSvg(
    assetPath: AppAssets.okrLogo,
    width: logoSize,
    height: logoSize,
    semanticsLabel: 'okr_logo'.tr,
  );
}

/// Title Section
Widget _buildTitleSection(
    ThemeData theme,
    double screenWidth,
    bool isPortrait,
    bool isTablet,
    ) {
  final titleSize = _getTitleSize(screenWidth, isPortrait, isTablet);
  return Text(
    'my_profile'.tr,
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

/// Subtitle Section
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

/// Input Fields Section
Widget _buildInputFieldsSection(
    double screenHeight,
    double screenWidth,
    bool isTablet,
    BuildContext context,
    ) {
  final fieldSpacing = _getFieldSpacing(screenHeight, isTablet);
  final iconSize = screenWidth * 0.05;

  return Obx(
        () => Column(
      children: [
        /// Avatar Section
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryBlue.withOpacity(0.1),
            image: controller.user.value?.avatarPicId?.isNotEmpty == true
                ? DecorationImage(
              image: NetworkImage(controller.user.value!.avatarPicId),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: controller.user.value?.avatarPicId?.isEmpty == true
              ? Icon(
            Icons.person,
            size: 50,
            color: AppColors.primaryBlue,
          )
              : null,
        ),
        SizedBox(height: fieldSpacing * 1.5),

        /// Name Field
        CustomTextField(
          controller: controller.nameController,
          hint: 'enter_name'.tr,
          enabled: controller.isEditMode.value,
          textCapitalization: TextCapitalization.words,
          // validator: (value) => Validator.validateName(value),
          prefixIcon: Icon(
            Icons.person_outline,
            color: AppColors.textSecondary,
            size: iconSize,
          ),
        ),
        SizedBox(height: fieldSpacing),

        /// Email Field (Read-only)
        CustomTextField(
          controller: controller.emailController,
          hint: 'enter_email'.tr,
          enabled: false,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: AppColors.textSecondary,
            size: iconSize,
          ),
        ),
        SizedBox(height: fieldSpacing),

        /// Phone Field
        CustomTextField(
          controller: controller.phoneController,
          hint: 'enter_phone'.tr,
          enabled: controller.isEditMode.value,
          keyboardType: TextInputType.phone,
          // validator: (value) => Validator.validatePhone(value),
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: AppColors.textSecondary,
            size: iconSize,
          ),
        ),
      ],
    ),
  );
}

/// Update and Cancel Buttons (in edit mode)
Widget _buildUpdateCancelButtons(bool isTablet) {
  return Column(
    children: [
      Obx(
            () => SizedBox(
          width: isTablet ? 350.0 : double.infinity,
          child: CustomButton(
            text: 'update_profile'.tr,
            onPressed: controller.updateProfile,
            isLoading: controller.isLoading.value,
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: isTablet ? 350.0 : double.infinity,
        child: OutlinedButton(
          onPressed: controller.toggleEditMode,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primaryBlue),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text(
            'cancel'.tr,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  );
}

/// Edit and Logout Buttons (normal mode)
Widget _buildEditLogoutButtons(bool isTablet) {
  return Column(
    children: [
      SizedBox(
        width: isTablet ? 350.0 : double.infinity,
        child: CustomButton(
          text: 'edit_profile'.tr,
          onPressed: controller.toggleEditMode,
        ),
      ),
      const SizedBox(height: 12),
      Obx(
            () => SizedBox(
          width: isTablet ? 350.0 : double.infinity,
          child: CustomButton(
            text: 'logout'.tr,
            onPressed: controller.logout,
            isLoading: controller.isLoading.value,
            backgroundColor: AppColors.accentRed,
          ),
        ),
      ),
    ],
  );
}

/// Bottom Logo
Widget _buildBottomLogo(double screenWidth, bool isTablet) {
  final logoSize = _getLogoSize(screenWidth, true, isTablet, isTop: false);
  return CustomSvg(
    assetPath: 'assets/images/logo.svg',
    width: logoSize,
    height: logoSize,
    semanticsLabel: 'bottom_logo'.tr,
  );
}

// ========== RESPONSIVE HELPER METHODS ==========

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

double _getResponsiveSpacing(double screenHeight, double factor) {
  return screenHeight * factor;
}

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
  if (isTablet) return baseSpacing * 1.2;
  return baseSpacing;
}
}