import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_colors.dart';

class CustomProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const CustomProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep / totalSteps).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Progress bar
        Container(
          width: double.infinity,
          height: 8.h,
          decoration: BoxDecoration(
            color: AppColors.grey, // background
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress, // % filled
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
        ),

        SizedBox(height: 8.h),

        /// 🔹 Digits Row (steps)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSteps, (index) {
            final stepNumber = index + 1;
            final isCompleted = stepNumber <= currentStep;

            return Text(
              "$stepNumber",
              style: TextStyle(
                color: isCompleted ? AppColors.primaryRed : AppColors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            );
          }),
        ),
      ],
    );
  }
}
