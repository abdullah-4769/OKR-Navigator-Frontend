import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_colors.dart';

class SuccessRateBar extends StatelessWidget {
  final int successRate;
  final double progressValue;

  const SuccessRateBar({
    super.key,
    required this.successRate,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$successRate% Success Rate',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primaryRed,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: 8.h,
            color: AppColors.primaryRed,
            backgroundColor: AppColors.textSecondary.withOpacity(0.12),
          ),
        ),
      ],
    );
  }
}
