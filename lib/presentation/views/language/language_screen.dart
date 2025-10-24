import 'package:flutter/material.dart';
import 'package:game_app/generated/assets.dart';
import 'package:get/get.dart';

import '../../../controllers/language_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../generated/models/enums/language_enum.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController controller = Get.find<LanguageController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          final mediaQuery = MediaQuery.of(context);
          final screenHeight = mediaQuery.size.height;
          final screenWidth = mediaQuery.size.width;

          // Responsive breakpoints
          final isTablet = screenWidth > 600;
          final isDesktop = screenWidth > 900;
          final isLandscape = orientation == Orientation.landscape;

          // Content width constraints for larger screens
          final maxContentWidth = isDesktop
              ? 600.0
              : (isTablet ? screenWidth * 0.8 : double.infinity);

          // Responsive typography
          final titleStyle =
              (theme.textTheme.headlineLarge ?? const TextStyle(fontSize: 22))
                  .copyWith(
                    fontSize: _getResponsiveTitleSize(screenWidth, isLandscape),
                    fontWeight: FontWeight.w600,
                  );

          final tileTitleStyle =
              (theme.textTheme.bodyLarge ?? const TextStyle(fontSize: 16))
                  .copyWith(fontSize: _getResponsiveTileSize(screenWidth));

          final tileSubtitleStyle =
              (theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14))
                  .copyWith(fontSize: _getResponsiveSubtitleSize(screenWidth));

          return CustomBackground(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Center(
                        child: Container(
                          width: maxContentWidth,
                          padding: EdgeInsets.symmetric(
                            horizontal: _getResponsivePadding(screenWidth),
                            vertical: screenHeight * 0.013,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: _getResponsiveSpacing(
                                  screenHeight,
                                  0.03,
                                ),
                              ),

                              /// 🔹 TITLE SECTION
                              _buildTitleSection(
                                screenHeight,
                                screenWidth,
                                titleStyle,
                                isLandscape,
                              ),

                              SizedBox(
                                height: _getResponsiveSpacing(
                                  screenHeight,
                                  0.025,
                                ),
                              ),

                              /// 🔹 LANGUAGE LIST
                              _buildLanguageList(
                                controller,
                                tileTitleStyle,
                                tileSubtitleStyle,
                                screenWidth,
                                isTablet,
                              ),

                              SizedBox(
                                height: _getResponsiveSpacing(
                                  screenHeight,
                                  0.03,
                                ),
                              ),

                              /// 🔹 CONTINUE BUTTON
                              _buildContinueButton(screenWidth, isTablet),

                              SizedBox(
                                height: _getResponsiveSpacing(
                                  screenHeight,
                                  0.035,
                                ),
                              ),

                              /// 🔹 BOTTOM LOGO
                              _buildBottomLogo(screenWidth),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🔹 Title section with responsive image and text
  Widget _buildTitleSection(
    double screenHeight,
    double screenWidth,
    TextStyle titleStyle,
    bool isLandscape,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Assets.imagesLanguageImage,
          height: _getResponsiveImageHeight(
            screenHeight,
            screenWidth,
            isLandscape,
          ),
          fit: BoxFit.contain,
        ),
        SizedBox(width: _getResponsiveSpacing(screenWidth, 0.013)),
        Flexible(
          child: Text(
            'choose_language'.tr,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: titleStyle.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// 🔹 Language list with responsive layout
  Widget _buildLanguageList(
    LanguageController controller,
    TextStyle tileTitleStyle,
    TextStyle tileSubtitleStyle,
    double screenWidth,
    bool isTablet,
  ) {
    final languages = SupportedLanguage.values;

    // For tablets and larger screens in landscape, use grid layout
    if (isTablet && screenWidth > 800) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4.0,
          crossAxisSpacing: AppDimensions.d6,
          mainAxisSpacing: AppDimensions.d6,
        ),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final lang = languages[index];
          return _buildLanguageTile(
            lang,
            controller,
            tileTitleStyle,
            tileSubtitleStyle,
            screenWidth,
          );
        },
      );
    }

    // Default column layout for mobile and smaller tablets
    return Column(
      children: languages
          .map(
            (lang) => _buildLanguageTile(
              lang,
              controller,
              tileTitleStyle,
              tileSubtitleStyle,
              screenWidth,
            ),
          )
          .toList(),
    );
  }

  /// 🔹 Continue button with responsive width
  Widget _buildContinueButton(double screenWidth, bool isTablet) => SizedBox(
    width: isTablet ? 300 : double.infinity,
    child: CustomButton(
      text: 'continue'.tr,
      onPressed: () => Get.offAllNamed(AppRoutes.register),
      backgroundColor: AppColors.primaryRed,
    ),
  );

  /// 🔹 Bottom logo with responsive sizing
  Widget _buildBottomLogo(double screenWidth) => Center(
    child: CustomSvg(
      assetPath: 'assets/images/logo.svg',
      width: _getResponsiveLogoSize(screenWidth),
      height: _getResponsiveLogoSize(screenWidth),
      semanticsLabel: 'App Logo',
    ),
  );

  /// 🔹 Language tile widget with responsive design
  Widget _buildLanguageTile(
    SupportedLanguage supportedLang,
    LanguageController controller,
    TextStyle tileTitleBase,
    TextStyle tileSubtitleBase,
    double screenWidth,
  ) => Obx(() {
    final isSelected = controller.selectedLanguage.value == supportedLang;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.d6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.d8),
        border: Border.all(
          color: isSelected ? AppColors.primaryRed : AppColors.borderGrey,
          width: AppDimensions.d2,
        ),
        color: isSelected ? AppColors.selectedBg : AppColors.white,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primaryRed.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: _getResponsiveTilePadding(screenWidth),
          vertical: AppDimensions.d4,
        ),
        leading: Text(
          supportedLang.flag,
          style: tileTitleBase.copyWith(
            fontSize: _getResponsiveFlagSize(screenWidth),
          ),
        ),
        title: Text(
          supportedLang.nativeName,
          overflow: TextOverflow.ellipsis,
          style: tileTitleBase.copyWith(
            color: isSelected ? AppColors.primaryRed : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        subtitle: Text(
          supportedLang.name,
          overflow: TextOverflow.ellipsis,
          style: tileSubtitleBase.copyWith(color: AppColors.textSecondary),
        ),
        trailing: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isSelected
              ? const Icon(
                  Icons.check_circle,
                  color: AppColors.primaryRed,
                  key: ValueKey('selected'),
                )
              : const SizedBox.shrink(key: ValueKey('unselected')),
        ),
        onTap: () => controller.changeLanguage(supportedLang),
      ),
    );
  });

  // 🔹 RESPONSIVE HELPER METHODS

  /// Get responsive title font size
  double _getResponsiveTitleSize(double screenWidth, bool isLandscape) {
    if (screenWidth > 900) return 32;
    if (screenWidth > 600) return 28;
    if (isLandscape && screenWidth > 500) return 24;
    return 22;
  }

  /// Get responsive tile title size
  double _getResponsiveTileSize(double screenWidth) {
    if (screenWidth > 900) return 18;
    if (screenWidth > 600) return 17;
    return 16;
  }

  /// Get responsive subtitle size
  double _getResponsiveSubtitleSize(double screenWidth) {
    if (screenWidth > 900) return 16;
    if (screenWidth > 600) return 15;
    return 14;
  }

  /// Get responsive flag emoji size
  double _getResponsiveFlagSize(double screenWidth) {
    if (screenWidth > 900) return 24;
    if (screenWidth > 600) return 22;
    return 20;
  }

  /// Get responsive horizontal padding
  double _getResponsivePadding(double screenWidth) {
    if (screenWidth > 900) return 48;
    if (screenWidth > 600) return 32;
    return screenWidth * 0.04;
  }

  /// Get responsive tile padding
  double _getResponsiveTilePadding(double screenWidth) {
    if (screenWidth > 600) return 20;
    return 16;
  }

  /// Get responsive spacing
  double _getResponsiveSpacing(double dimension, double factor) {
    return dimension * factor;
  }

  /// Get responsive image height
  double _getResponsiveImageHeight(
    double screenHeight,
    double screenWidth,
    bool isLandscape,
  ) {
    if (isLandscape) {
      return screenHeight * 0.08;
    }
    if (screenWidth > 900) return screenHeight * 0.07;
    if (screenWidth > 600) return screenHeight * 0.065;
    return screenHeight * 0.06;
  }

  /// Get responsive logo size
  double _getResponsiveLogoSize(double screenWidth) {
    if (screenWidth > 900) return screenWidth * 0.03;
    if (screenWidth > 600) return screenWidth * 0.04;
    return screenWidth * 0.10;
  }
}
