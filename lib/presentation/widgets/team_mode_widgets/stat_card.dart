import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_colors.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String assetPath;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) => Container(
      width: 100.w,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Image.asset(assetPath, height: 50.h, width: 60.w),
          SizedBox(height: 6.h),
          Text(value,
              style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp)),
          Text(label,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp)),
        ],
      ),
    );
}
