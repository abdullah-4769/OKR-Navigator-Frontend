// widgets/custom_achievement_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';


class CustomAchievementBanner extends StatelessWidget {
  final int rank;
  final String category;

  const CustomAchievementBanner({
    super.key,
    required this.rank,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.d16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBlue.withOpacity(0.8),
            AppColors.primaryRed.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.d16.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.emoji_events,
            color: Colors.white,
            size: AppDimensions.d24.sp,
          ),
          SizedBox(width: AppDimensions.d12.w),
          Expanded(
            child: Text(
              "I'm ranked #$rank in $category this week!",
              style: TextStyle(
                color: Colors.white,
                fontSize: AppDimensions.d16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}