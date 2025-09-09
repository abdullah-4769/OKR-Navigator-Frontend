import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomJourneyMap extends StatelessWidget {
  final double progress;
  final List<String> steps;
  final List<bool> completedSteps;
  final VoidCallback onToggle;
  final bool showDetails;

  const CustomJourneyMap({
    super.key,
    required this.progress,
    required this.steps,
    required this.completedSteps,
    required this.onToggle,
    required this.showDetails,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
    padding: EdgeInsets.all(AppDimensions.d16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppDimensions.d12.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        // Title
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'journey'.tr + ' ',
                style: TextStyle(
                  fontFamily: 'Gotham-Bold',
                  fontSize: AppDimensions.d30.sp,
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '\n' + 'map'.tr,
                style: TextStyle(
                  fontFamily: 'Gotham-Bold',
                  fontSize: AppDimensions.d24.sp,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.d8.h),

        // Show Progress / Show Less
        GestureDetector(
          onTap: onToggle,
          child: Text(
            showDetails ? 'show_less'.tr : 'show_progress'.tr,
            style: TextStyle(
              fontSize: AppDimensions.d14.sp,
              color: AppColors.primaryBlue,
              fontFamily: 'Gotham',
              decoration: TextDecoration.underline,
            ),
          ),
        ),

        SizedBox(height: AppDimensions.d16.h),

        // Expandable Section
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: showDetails
              ? Column(
            children: [
              SizedBox(height: AppDimensions.d12.h),

              // Progress %
              Text(
                '${progress.toInt()}% ' + 'complete'.tr,
                style: TextStyle(
                  fontFamily: 'Gotham-Bold',
                  fontSize: AppDimensions.d20.sp,
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppDimensions.d8.h),

              // Progress bar
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: AppColors.textSecondary.withValues(alpha:0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryRed,
                ),
                minHeight: AppDimensions.d8.h,
                borderRadius: BorderRadius.circular(AppDimensions.d4.r),
              ),
              SizedBox(height: AppDimensions.d16.h),

              // Steps row
              _buildJourneySteps(),

              SizedBox(height: AppDimensions.d16.h),
            ],
          )
              : const SizedBox.shrink(),
        ),
      ],
    ),
  );

  Widget _buildJourneySteps() => Row(
    children: List.generate(steps.length, (index) {
      final isActive = completedSteps[index];

      return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: isActive
                    ? AppColors.primaryRed
                    : AppColors.textSecondary.withValues(alpha:0.4),
                size: AppDimensions.d24.sp,
              ),
              SizedBox(height: AppDimensions.d6.h),
              Text(
                steps[index].tr,
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppDimensions.d10.sp,
                  color: isActive
                      ? AppColors.primaryRed
                      : AppColors.textSecondary.withValues(alpha:0.5),
                  fontFamily: 'Gotham',
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }),
  );
}
