import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.d12.h),
              child: Column(
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
                      // ❌ Removed Obx: translation key updates automatically
                      Text(
                        'select_language'.tr,
                        style: TextStyle(
                          fontSize: AppDimensions.d22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                          fontFamily: 'Gotham',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppDimensions.d12.h),

                  // Language List
                  Column(
                    children: controller.supportedLanguages
                        .map(
                          (lang) => _buildLanguageTile(
                        lang['nativeName']!,
                        lang['name']!,
                        lang['flag']!,
                        lang['code']!,
                        controller,
                      ),
                    )
                        .toList(),
                  ),

                  SizedBox(height: AppDimensions.d12.h),

                  // Continue Button
                  CustomButton(
                    text: 'continue'.tr,
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.register);
                    },
                    backgroundColor: AppColors.primaryRed,
                  ),

                  SizedBox(height: AppDimensions.d12.h),

                  // Bottom Logo
                  Center(
                    child: CustomSvg(
                      assetPath: 'assets/images/logo.svg',
                      width: AppDimensions.d30.w,
                      height: AppDimensions.d30.h,
                      semanticsLabel: '',
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
      String title,
      String subtitle,
      String flag,
      String languageCode,
      LanguageController controller,
      ) {
    // ✅ Wrap only the part that needs reactive updates
    return Obx(() {
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
            style: TextStyle(fontSize: AppDimensions.d26.sp),
          ),
          title: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppDimensions.d18.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primaryRed : AppColors.textPrimary,
              fontFamily: 'Gotham',
            ),
          ),
          subtitle: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppDimensions.d14.sp,
              color: AppColors.textSecondary,
              fontFamily: 'Gotham',
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check, color: AppColors.primaryRed)
              : null,
          onTap: () => controller.changeLanguage(languageCode),
        ),
      );
    });
  }
}


//
// class LanguageScreen extends StatelessWidget {
//   const LanguageScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final LanguageController controller = Get.find<LanguageController>();
//
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.all(AppDimensions.d12.h),
//               child: Column(
//                 children: [
//                   SizedBox(height: AppDimensions.d15.h),
//
//                   // Title Section
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.language,
//                         color: AppColors.primaryRed,
//                         size: AppDimensions.d28.r,
//                       ),
//                       SizedBox(width: AppDimensions.d6.w),
//                       Flexible(
//                         child: Obx(
//                               () => Text(
//                             'select_language'.tr,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: AppDimensions.d22.sp,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.primaryBlue,
//                               fontFamily: 'Gotham',
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   SizedBox(height: AppDimensions.d12.h),
//
//                   // Language List
//                   Obx(
//                         () => Column(
//                       children: controller.supportedLanguages
//                           .map((lang) => _buildLanguageTile(
//                         lang['nativeName']!,
//                         lang['name']!,
//                         lang['flag']!,
//                         lang['code']!,
//                         controller,
//                       ))
//                           .toList(),
//                     ),
//                   ),
//
//                   SizedBox(height: AppDimensions.d12.h),
//
//                   // Continue Button
//                   CustomButton(
//                     text: 'continue'.tr,
//                     onPressed: () {
//                       Get.offAllNamed(AppRoutes.register);
//                     },
//                     backgroundColor: AppColors.primaryRed,
//                   ),
//
//                   SizedBox(height: AppDimensions.d12.h),
//
//                   // Bottom Logo
//                   Center(
//                     child: CustomSvg(
//                       assetPath: 'assets/images/logo.svg',
//                       width: AppDimensions.d30.w,
//                       height: AppDimensions.d30.h,
//                       semanticsLabel: '',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLanguageTile(
//       String title,
//       String subtitle,
//       String flag,
//       String languageCode,
//       LanguageController controller,
//       ) {
//     final isSelected = controller.selectedLanguage.value == languageCode;
//
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: AppDimensions.d6.h),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(AppDimensions.d8.r),
//         border: Border.all(
//           color: isSelected ? AppColors.primaryRed : AppColors.borderGrey,
//           width: AppDimensions.d2.w,
//         ),
//         color: isSelected ? AppColors.selectedBg : AppColors.white,
//       ),
//       child: ListTile(
//         leading: Text(
//           flag,
//           style: TextStyle(fontSize: AppDimensions.d26.sp),
//         ),
//         title: Text(
//           title,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             fontSize: AppDimensions.d18.sp,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             color: isSelected ? AppColors.primaryRed : AppColors.textPrimary,
//             fontFamily: 'Gotham',
//           ),
//         ),
//         subtitle: Text(
//           subtitle,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             fontSize: AppDimensions.d14.sp,
//             color: AppColors.textSecondary,
//             fontFamily: 'Gotham',
//           ),
//         ),
//         trailing: isSelected
//             ? const Icon(Icons.check, color: AppColors.primaryRed)
//             : null,
//         onTap: () => controller.changeLanguage(languageCode),
//       ),
//     );
//   }
// }
