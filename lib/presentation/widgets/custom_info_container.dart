import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class CustomInfoContainer extends StatelessWidget {
  final double percentage;
  final String robotAsset; // Can be PNG or SVG
  final String title;
  final String description;
  final Color percentageBarColor;
  final IconData icon;

  const CustomInfoContainer({
    super.key,
    required this.percentage,
    required this.robotAsset,
    required this.title,
    required this.description,
    required this.percentageBarColor,
    this.icon = Icons.lightbulb_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.d24.w,
        vertical: AppDimensions.d16.h,
      ),
      padding: EdgeInsets.symmetric(vertical: AppDimensions.d16.h),
      decoration: BoxDecoration(
        color: Colors.lightGreen,
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
        children: [
          /// Robot SVG/PNG
          Center(
            child: _buildRobotImage(),
          ),

          SizedBox(height: AppDimensions.d12.h),

          /// Percentage bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: AppDimensions.d12.h),
            color: percentageBarColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      percentage < 80 ? "😟" : "😊",
                      style: TextStyle(fontSize: AppDimensions.d20.sp),
                    ),
                    SizedBox(width: AppDimensions.d8.w),
                    Text(
                      "${percentage.toStringAsFixed(0)}%",
                      style: TextStyle(
                        fontFamily: "Gotham-Bold",
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.d22.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.d4.h),
                Text(
                  "Relevance threshold: >80%",
                  style: TextStyle(
                    fontSize: AppDimensions.d14.sp,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppDimensions.d16.h),

          /// White inner box with tips
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
            padding: EdgeInsets.all(AppDimensions.d16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.d12.r),
              border: Border.all(color: percentageBarColor.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Row with icon + title
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryRed,
                      child: Icon(
                        icon,
                        size: AppDimensions.d24.w,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(width: AppDimensions.d10.w),
                    Expanded(
                      child: Text(
                        title,
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

                /// Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: AppDimensions.d14.sp,
                    color: AppColors.textSecondary,
                    fontFamily: 'Gotham',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Determines whether to use SVG or PNG/JPG
  Widget _buildRobotImage() {
    if (robotAsset.toLowerCase().endsWith(".svg")) {
      return SvgPicture.asset(
        robotAsset,
        height: AppDimensions.d90.h,
        width: AppDimensions.d80.w,
      );
    } else {
      return Image.asset(
        robotAsset,
        height: AppDimensions.d90.h,
        width: AppDimensions.d80.w,
        fit: BoxFit.contain,
      );
    }
  }
}
