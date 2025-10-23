import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_app/presentation/widgets/custom_svg.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class CustomRankContainer extends StatelessWidget {
  final int rank;
  final String name;
  final int level;
  final int points;
  final int score;
  final bool isHighlighted;

  const CustomRankContainer({
    super.key,
    required this.rank,
    required this.name,
    required this.level,
    required this.points,
    required this.score,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.d4.h, horizontal: AppDimensions.d14.w),
      margin: EdgeInsets.only(bottom: AppDimensions.d10.h),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.primaryRed : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.d48.r),
        border: Border.all(
          color: AppColors.primaryRed,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Rank Number
          Text(
            "$rank.",
            style: TextStyle(
              fontSize: AppDimensions.d16.sp,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? Colors.white : AppColors.textPrimary,
            ),
          ),
          SizedBox(width: AppDimensions.d12.w),

          // Avatar with red border + soft red background
          Container(
            padding: EdgeInsets.all(AppDimensions.d4.w),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryRed, width: 2),
            ),
            child: CustomSvg(
              assetPath: 'assets/images/solo.svg',
              semanticsLabel: '',
              height: AppDimensions.d28.w,
              width: AppDimensions.d28.w,
            ),
          ),
          SizedBox(width: AppDimensions.d8.w),

          // Name + level + points earned
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: AppDimensions.d16.sp,
                    fontWeight: FontWeight.bold,
                    color: isHighlighted ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppDimensions.d4.h),
                Text(
                  "Level $level | ${points} Points Earned",
                  style: TextStyle(
                    fontSize: AppDimensions.d12.sp,
                    color: isHighlighted ? Colors.white70 : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Score with star
          Row(
            children: [
              Icon(Icons.star, color: AppColors.primaryRed, size: AppDimensions.d18.sp),
              SizedBox(width: AppDimensions.d4.w),
              Text(
                "$score",
                style: TextStyle(
                  fontSize: AppDimensions.d18.sp,
                  fontWeight: FontWeight.bold,
                  color: isHighlighted ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
}
