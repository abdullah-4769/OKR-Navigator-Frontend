import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomAIStrategyContainer extends StatefulWidget {
  const CustomAIStrategyContainer({super.key});

  @override
  State<CustomAIStrategyContainer> createState() =>
      _CustomAIStrategyContainerState();
}

class _CustomAIStrategyContainerState extends State<CustomAIStrategyContainer> {
  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.symmetric(
      horizontal: AppDimensions.d24.w,
      vertical: AppDimensions.d16.h,
    ),
    padding: EdgeInsets.all(AppDimensions.d20.w),
    decoration: BoxDecoration(
      color: AppColors.primaryRed,
      borderRadius: BorderRadius.circular(AppDimensions.d16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Robot Icon
          Center(
            child: SvgPicture.asset(
              'assets/images/robot.svg',
              height: AppDimensions.d90.h,
              width: AppDimensions.d80.w,
            ),
          ),

          /// Header Row
          Center(
            child: Row(
              children: [
                SizedBox(width: AppDimensions.d2.w),
                Center(
                  child: Text(
                    '\n${'ai_strategic_analysis'.tr}',
                    style: TextStyle(
                      fontFamily: 'Gotham-Bold',
                      fontSize: AppDimensions.d20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppDimensions.d20.h),

          /// Inner White Box
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.d16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.d12.r),
              border: Border.all(
                color: AppColors.primaryRed.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: AppDimensions.d40.w,
                  color: AppColors.primaryRed,
                ),
                SizedBox(height: AppDimensions.d12.h),
                Text(
                  'submit_initiatives_ai_analysis'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.d14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    fontFamily: 'Gotham',
                  ),
                ),
                SizedBox(height: AppDimensions.d8.h),
                Text(
                  'feedback_will_appear_here'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.d12.sp,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    fontFamily: 'Gotham',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
