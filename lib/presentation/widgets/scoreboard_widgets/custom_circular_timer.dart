import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';


class CustomCircularTimer extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final String label;

  const CustomCircularTimer({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final progress = remainingSeconds / totalSeconds;
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final formattedTime = '$minutes:${seconds.toString().padLeft(2, '0')}';

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              width: AppDimensions.d120.w,
              height: AppDimensions.d120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryRed.withOpacity(0.1),
              ),
            ),

            // Progress circle
            SizedBox(
              width: AppDimensions.d120.w,
              height: AppDimensions.d120.w,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: AppDimensions.d8.w,
                backgroundColor: AppColors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
              ),
            ),

            // Time text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: AppDimensions.d24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                ),
                Text(
                  label.tr,
                  style: TextStyle(
                    fontSize: AppDimensions.d12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}