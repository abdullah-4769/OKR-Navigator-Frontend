import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';

/// Performance Breakdown
class PerformanceBreakdown extends StatelessWidget {
  final int points;
  final int totalPoints;
  final List<BreakdownItem> items;
  const PerformanceBreakdown({
    super.key,
    required this.points,
    required this.totalPoints,
    required this.items,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.symmetric(horizontal: 20.w),
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.r),
      color: Colors.white,
      border: Border.all(color: AppColors.primaryRed),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header Row
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryRed,
              child: Icon(
                Icons.bar_chart,
                color: AppColors.white,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text("performance_breakdown".tr,
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        SizedBox(height: 12.h),

        /// Items with divider
        ...List.generate(items.length, (index) {
          final e = items[index];
          return Column(
            children: [
              _buildItem(e, context),
              if (index < items.length - 1) // divider except last item
                Divider(
                  color: AppColors.grey.withOpacity(0.3),
                  thickness: 1,
                  height: 12.h,
                ),
            ],
          );
        }),

        SizedBox(height: 16.h),
        Center(
          child: Text(
            "${"total_points".tr} $points/$totalPoints",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildItem(BreakdownItem e, BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(e.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            )),
        Row(
          children: [
            Text(e.score,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryRed,
                )),
            SizedBox(width: 8.w),
            Icon(
              e.success ? Icons.check_circle : Icons.remove_circle,
              color: e.success ? Colors.green : Colors.orange,
              size: 20.sp,
            ),
          ],
        ),
      ],
    ),
  );
}

class BreakdownItem {
  final String title;
  final String score;
  final bool success;
  BreakdownItem(this.title, this.score, this.success);
}
