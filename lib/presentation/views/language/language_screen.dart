import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../controllers/language_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_svg.dart';


class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController controller = Get.find<LanguageController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundTop,
              AppColors.backgroundBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.d12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: AppDimensions.d15.h),

                  // Title Section with Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.language,
                        color: AppColors.primaryRed,
                        size: AppDimensions.d28.r,
                      ),
                      SizedBox(width: AppDimensions.d6.w),
                      Text(
                        'select_language'.tr,
                        style: TextStyle(
                          fontSize: AppDimensions.d22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                          fontFamily: 'Gothic',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppDimensions.d12.h),

                  // Language List using GetX Controller
                  Obx(() => Column(
                    children: [
                      _buildLanguageTile(
                          context,
                          'English',
                          'English',
                          "🇬🇧",
                          'en',
                          controller
                      ),
                      _buildLanguageTile(
                          context,
                          'Español',
                          'Spanish',
                          "🇪🇸",
                          'es',
                          controller
                      ),
                      _buildLanguageTile(
                          context,
                          'Français',
                          'French',
                          "🇫🇷",
                          'fr',
                          controller
                      ),
                      _buildLanguageTile(
                          context,
                          'Deutsch',
                          'German',
                          "🇩🇪",
                          'de',
                          controller
                      ),
                      _buildLanguageTile(
                          context,
                          'Italiano',
                          'Italian',
                          "🇮🇹",
                          'it',
                          controller
                      ),
                      _buildLanguageTile(
                          context,
                          'Русский',
                          'Russian',
                          "🇷🇺",
                          'ru',
                          controller
                      ),
                      _buildLanguageTile(
                          context,
                          'اردو',
                          'Urdu',
                          "🇵🇰",
                          'ur',
                          controller
                      ),
                    ],
                  )),

                  SizedBox(height: AppDimensions.d12.h),

                  // Continue Button
                  CustomButton(
                    text: 'continue'.tr,
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.register);
                    },
                    backgroundColor: AppColors.primaryRed,
                    borderRadius: AppDimensions.d30,
                  ),

                  SizedBox(height: AppDimensions.d12.h),

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
      ),
    );
  }

  Widget _buildLanguageTile(
      BuildContext context,
      String title,
      String subtitle,
      String flag,
      String languageCode,
      LanguageController controller
      ) {
    final isSelected = controller.selectedLanguage.value == languageCode;

    return Container(
      margin: EdgeInsets.symmetric(vertical: AppDimensions.d6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.d8.r),
        border: Border.all(
          color: isSelected ? AppColors.primaryRed : AppColors.borderGrey,
          width: AppDimensions.d2.w,
        ),
        color: isSelected ? AppColors.selectedBg : AppColors.white,
      ),
      child: ListTile(
        leading: Text(
            flag,
            style: TextStyle(fontSize: AppDimensions.d26.sp)
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: AppDimensions.d18.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.primaryRed : AppColors.textPrimary,
            fontFamily: 'Gothic',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: AppDimensions.d14.sp,
            color: AppColors.textSecondary,
            fontFamily: 'Gothic',
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check, color: AppColors.primaryRed)
            : null,
        onTap: () => controller.changeLanguage(languageCode),
      ),
    );
  }
}