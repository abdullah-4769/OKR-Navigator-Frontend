import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';

/// Achievement Summary
class AchievementSummary extends StatelessWidget {
  final List<String> achievements;
  const AchievementSummary({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 400;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.03),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        border: Border.all(color: AppColors.primaryRed),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Heading with icon
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: AppColors.primaryRed,
                size: isSmallScreen ? 24.sp : 28.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  "achievement_summary".tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                    fontSize: isSmallScreen ? 16.sp : 18.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          /// Achievements list with divider
          ...List.generate(achievements.length, (index) {
            final a = achievements[index];
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: isSmallScreen ? 18.sp : 20.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        a,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: isSmallScreen ? 14.sp : 16.sp,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (index < achievements.length - 1) // divider except last
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Divider(
                      color: AppColors.grey.withOpacity(0.3),
                      thickness: 1,
                      height: 1,
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}