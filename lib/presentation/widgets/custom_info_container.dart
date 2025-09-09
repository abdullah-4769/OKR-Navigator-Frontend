import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class CustomInfoContainer extends StatelessWidget {
  final Color backgroundColor;
  final String logoAsset;
  final String title;
  final String description;

  const CustomInfoContainer({
    super.key,
    required this.backgroundColor,
    required this.logoAsset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.symmetric(
      horizontal: AppDimensions.d24.w,
      vertical: AppDimensions.d16.h,
    ),
    padding: EdgeInsets.all(AppDimensions.d20.w),
    decoration: BoxDecoration(
      color: backgroundColor.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(AppDimensions.d16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        // 🔹 Logo/Icon at top
        Center(
          child: SvgPicture.asset(
            'assets/images/robot.svg',
            height: AppDimensions.d90.h,
            width: AppDimensions.d80.w,
          ),
        ),

        SizedBox(height: AppDimensions.d16.h),

        // 🔹 Title below logo
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Gotham-Bold',
            fontSize: AppDimensions.d20.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: AppDimensions.d20.h),

        /// Inner White Box with alert icon + "Strategic Tips"
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppDimensions.d16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.d12.r),
            border: Border.all(color: backgroundColor.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Row: Alert Icon + Title
              Row(
                children: [
                  Icon(
                    Icons.add_alert,
                    size: AppDimensions.d24.w,
                    color: AppColors.primaryRed,
                  ),
                  SizedBox(width: AppDimensions.d8.w),
                  Expanded(
                    child: Text(
                      'Strategic Tips.tr',
                      style: TextStyle(
                        fontSize: AppDimensions.d16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        fontFamily: 'Gotham-Bold',
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppDimensions.d12.h),

              // 🔹 Dynamic Description Text
              Text(
                description,
                style: TextStyle(
                  fontSize: AppDimensions.d14.sp,
                  color: AppColors.textSecondary,
                  fontFamily: 'Gotham',
                ),
                textAlign: TextAlign.start,
              ),

              // Placeholder for backend integration
              SizedBox(height: AppDimensions.d8.h),
              // TODO: Replace hardcoded description with backend data in future
            ],
          ),
        ),
      ],
    ),
  );
}
