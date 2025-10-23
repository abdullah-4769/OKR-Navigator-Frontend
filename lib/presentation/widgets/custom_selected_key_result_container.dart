// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../controllers/campaign_mode_controllers/compaign_key_result_controller.dart';
// import '../../controllers/key_results_controller.dart';
// import '../../core/app_colors.dart';
// import '../../core/app_dimensions.dart';
//
// import '../views/campaign_mode_views/navigatorKey_results_screen.dart'; // For campaign mode
//
// class CustomSelectedKeyResultsContainer extends StatelessWidget {
//   const CustomSelectedKeyResultsContainer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // ✅ Dynamically detect which controller is active
//     late final dynamic controller;
//     bool isInputBasedController = false;
//
//     if (Get.isRegistered<NavigatorKeyResultController>()) {
//       controller = Get.find<NavigatorKeyResultController>();
//       isInputBasedController = true;
//     } else if (Get.isRegistered<NavigatorKeyResultController>()) {
//       controller = Get.find<NavigatorKeyResultController>();
//       isInputBasedController = true;
//     } else if (Get.isRegistered<KeyResultsController>()) {
//       controller = Get.find<KeyResultsController>();
//     } else if (Get.isRegistered<CampaignKeyResultsController>()) {
//       controller = Get.find<CampaignKeyResultsController>();
//     } else {
//       // Fallback to avoid crashes if no controller is found
//       return const SizedBox.shrink();
//     }
//
//     return Obx(() {
//       // Compute selectedCount for input-based controllers (NavigatorKeyResultController or AchievementController)
//       int selectedCount;
//       int requiredCount;
//
//       if (isInputBasedController) {
//         selectedCount = 0;
//         if (controller.firstKeyResultTitle.text.trim().isNotEmpty &&
//             controller.firstKeyResultDesc.text.trim().isNotEmpty) {
//           selectedCount++;
//         }
//         if (controller.secondKeyResultTitle.text.trim().isNotEmpty &&
//             controller.secondKeyResultDesc.text.trim().isNotEmpty) {
//           selectedCount++;
//         }
//         if (controller.thirdKeyResultTitle.text.trim().isNotEmpty &&
//             controller.thirdKeyResultDesc.text.trim().isNotEmpty) {
//           selectedCount++;
//         }
//         requiredCount = 3; // Fixed for three key results in input-based screens
//       } else {
//         // Use existing selectedCount and requiredCount for selection-based controllers
//         selectedCount = controller.selectedCount.value;
//         requiredCount = controller.requiredCount.value;
//       }
//
//       final int remaining = requiredCount - selectedCount;
//       final String remainingText = remaining <= 0
//           ? 'All key results selected!'
//           : remaining == 1
//           ? '1 more needed'
//           : '$remaining more needed';
//
//       return Container(
//         margin: EdgeInsets.symmetric(
//           horizontal: AppDimensions.d18.w,
//           vertical: AppDimensions.d16.h,
//         ),
//         padding: EdgeInsets.all(AppDimensions.d16.w),
//         decoration: BoxDecoration(
//           color: AppColors.primaryBlue,
//           borderRadius: BorderRadius.circular(AppDimensions.d12.r),
//         ),
//         child: Row(
//           children: [
//             // Circular counter
//             Container(
//               width: AppDimensions.d40.w,
//               height: AppDimensions.d40.w,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text(
//                   '$selectedCount', // Shows number of filled/selected key results
//                   style: TextStyle(
//                     fontSize: AppDimensions.d20.sp,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primaryBlue,
//                     fontFamily: 'Gotham-Bold',
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: AppDimensions.d12.w),
//             // Text content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Key Results Selected',
//                     style: TextStyle(
//                       fontSize: AppDimensions.d16.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       fontFamily: 'Gotham-Bold',
//                     ),
//                   ),
//                   SizedBox(height: AppDimensions.d4.h),
//                   Text(
//                     remainingText,
//                     style: TextStyle(
//                       fontSize: AppDimensions.d14.sp,
//                       color: Colors.white.withValues(alpha: 0.9),
//                       fontFamily: 'Gotham',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/key_results_controller.dart';
import '../../controllers/campaign_mode_controllers/compaign_key_result_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomSelectedKeyResultsContainer extends StatelessWidget {
  const CustomSelectedKeyResultsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Dynamically detect which controller is active
    late final dynamic controller;

    if (Get.isRegistered<KeyResultsController>()) {
      controller = Get.find<KeyResultsController>();
    } else if (Get.isRegistered<CampaignKeyResultsController>()) {
      controller = Get.find<CampaignKeyResultsController>();
    } else {
      // fallback to avoid crashes if neither found
      return const SizedBox.shrink();
    }

    return Obx(() {
      final int remaining =
          controller.requiredCount.value - controller.selectedCount.value;
      final String remainingText = remaining <= 0
          ? 'All key results selected!'
          : remaining == 1
          ? '1 more needed'
          : '$remaining more needed';

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppDimensions.d18.w,
          vertical: AppDimensions.d16.h,
        ),
        padding: EdgeInsets.all(AppDimensions.d16.w),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(AppDimensions.d12.r),
        ),
        child: Row(
          children: [
            // Circular counter
            Container(
              width: AppDimensions.d40.w,
              height: AppDimensions.d40.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${controller.selectedCount.value}', // shows 0 if nothing selected
                  style: TextStyle(
                    fontSize: AppDimensions.d20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                    fontFamily: 'Gotham-Bold',
                  ),
                ),
              ),
            ),

            SizedBox(width: AppDimensions.d12.w),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Results Selected',
                    style: TextStyle(
                      fontSize: AppDimensions.d16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Gotham-Bold',
                    ),
                  ),
                  SizedBox(height: AppDimensions.d4.h),
                  Text(
                    remainingText,
                    style: TextStyle(
                      fontSize: AppDimensions.d14.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontFamily: 'Gotham',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
