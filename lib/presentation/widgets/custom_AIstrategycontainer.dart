import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class CustomAIStrategyContainer extends StatelessWidget {
  const CustomAIStrategyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Row(
            children: [
              SvgPicture.asset(
                "assets/images/robot.svg",
                height: AppDimensions.d50.h,
                width: AppDimensions.d50.w,
              ),
              SizedBox(width: AppDimensions.d12.w),
              Text(
                "AI Strategic Analysis",
                style: TextStyle(
                  fontFamily: 'Gotham-Bold',
                  fontSize: AppDimensions.d20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.d20.h),

          /// Inner White Box
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.d16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.d12.r),
              border: Border.all(color: AppColors.primaryRed.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics_outlined,
                    size: AppDimensions.d40.w, color: AppColors.primaryRed),
                SizedBox(height: AppDimensions.d12.h),
                Text(
                  "Submit your initiatives for AI analysis",
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
                  "Feedback will appear here",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.d12.sp,
                    color: AppColors.textSecondary.withOpacity(0.7),
                    fontFamily: 'Gotham',
                  ),
                ),
                // Removed the Submit button
              ],
            ),
          ),
        ],
      ),
    );
  }
}



