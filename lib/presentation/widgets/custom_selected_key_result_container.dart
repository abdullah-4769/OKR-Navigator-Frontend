import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/key_results_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomSelectedKeyResultsContainer extends StatelessWidget {
  const CustomSelectedKeyResultsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final KeyResultsController controller = Get.find<KeyResultsController>();

    return Obx(() {
      final int remaining = controller.requiredCount.value - controller.selectedCount.value;
      final String remainingText = remaining <= 0
          ? "All key results selected!"
          : remaining == 1
          ? "1 more needed"
          : "$remaining more needed";

      return Container(
        margin: EdgeInsets.symmetric(
            horizontal: AppDimensions.d18.w, vertical: AppDimensions.d16.h),
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
                  '${controller.selectedCount.value}', // Shows 0 if nothing selected
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
                      color: Colors.white.withOpacity(0.9),
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
