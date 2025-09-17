import 'package:flutter/material.dart';
import 'package:game_app/generated/assets.dart';
import 'package:get/get.dart';
import '../../../controllers/language_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_svg.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController controller = Get.find<LanguageController>();
    final theme = Theme.of(context);

    // 🔹 Use OrientationBuilder for responsiveness
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          final mediaQuery = MediaQuery.of(context);
          final screenHeight = mediaQuery.size.height;
          final screenWidth = mediaQuery.size.width;

          final titleStyle =
              theme.textTheme.headlineLarge ?? const TextStyle(fontSize: 22);
          final tileTitleStyle =
              theme.textTheme.bodyLarge ?? const TextStyle(fontSize: 16);
          final tileSubtitleStyle =
              theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14);

          return Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.015,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: AppDimensions.d28),

                              /// 🔹 TITLE
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                 Image.asset(Assets.imagesLanguageImage,scale: 2.5,),
                                  SizedBox(width: AppDimensions.d6),
                                  Flexible(
                                    child: Text(
                                      'select_language'.tr,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: titleStyle.copyWith(
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: AppDimensions.d16),

                              /// 🔹 LANGUAGE LIST
                              Column(
                                children: controller.supportedLanguages
                                    .map(
                                      (lang) => _buildLanguageTile(
                                    lang['nativeName']!,
                                    lang['name']!,
                                    lang['flag']!,
                                    lang['code']!,
                                    controller,
                                    tileTitleStyle,
                                    tileSubtitleStyle,
                                  ),
                                )
                                    .toList(),
                              ),

                              SizedBox(height: AppDimensions.d20),

                              /// 🔹 CONTINUE BUTTON
                              CustomButton(
                                text: 'continue'.tr,
                                onPressed: () =>
                                    Get.offAllNamed(AppRoutes.register),
                                backgroundColor: AppColors.primaryRed,
                              ),

                              SizedBox(height: AppDimensions.d24),

                              /// 🔹 BOTTOM LOGO
                              Center(
                                child: CustomSvg(
                                  assetPath: 'assets/images/logo.svg',
                                  width: screenWidth * 0.09,
                                  height: screenWidth * 0.09,
                                  semanticsLabel: '',
                                ),
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
      ),
    );
  }

  /// 🔹 Language tile widget (GetX reactive)
  Widget _buildLanguageTile(
      String title,
      String subtitle,
      String flag,
      String languageCode,
      LanguageController controller,
      TextStyle tileTitleBase,
      TextStyle tileSubtitleBase,
      ) => Obx(() {
      final isSelected = controller.selectedLanguage.value == languageCode;

      return Container(
        margin: EdgeInsets.symmetric(vertical: AppDimensions.d6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.d8),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.borderGrey,
            width: AppDimensions.d2,
          ),
          color: isSelected ? AppColors.selectedBg : AppColors.white,
        ),
        child: ListTile(
          leading: Text(flag, style: tileTitleBase),
          title: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: tileTitleBase.copyWith(
              color: isSelected ? AppColors.primaryRed : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            style: tileSubtitleBase.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          trailing:
          isSelected ? const Icon(Icons.check, color: AppColors.primaryRed) : null,
          onTap: () => controller.changeLanguage(languageCode),
        ),
      );
    });
}
