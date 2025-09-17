import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomJourneyMap extends StatelessWidget {
  final double progress;
  final List<String>? steps;
  final List<bool>? completedSteps;
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return OrientationBuilder(
      builder: (context, orientation) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
          padding: EdgeInsets.all(AppDimensions.d16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppDimensions.d12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              /// Title
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'journey'.tr + ' ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: (orientation == Orientation.portrait
                            ? AppDimensions.d26
                            : AppDimensions.d22)
                            .sp,
                        color: AppColors.primaryRed,

                      ),
                    ),
                    TextSpan(
                      text: '\n' + 'map'.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: (orientation == Orientation.portrait
                            ? AppDimensions.d22
                            : AppDimensions.d20)
                            .sp,
                        color: AppColors.primaryBlue,

                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.d8.h),

              /// Show Progress / Show Less
              GestureDetector(
                onTap: onToggle,
                child: Text(
                  showDetails ? 'show_less'.tr : 'show_progress'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: AppDimensions.d14.sp,
                    color: AppColors.primaryBlue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              SizedBox(height: AppDimensions.d16.h),

              /// Expandable Section
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: showDetails
                    ? Column(
                  children: [
                    SizedBox(height: AppDimensions.d12.h),

                    /// Progress %
                    Text(
                      '${progress.toInt()}% ' + 'complete'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.d18.sp,
                        color: AppColors.primaryRed,
                      ),
                    ),
                    SizedBox(height: AppDimensions.d8.h),

                    /// Progress bar
                    LinearProgressIndicator(
                      value: (progress.clamp(0, 100)) / 100,
                      backgroundColor: AppColors.textSecondary
                          .withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryRed,
                      ),
                      minHeight: AppDimensions.d8.h,
                      borderRadius:
                      BorderRadius.circular(AppDimensions.d4.r),
                    ),
                    SizedBox(height: AppDimensions.d16.h),

                    /// Steps row
                    _buildJourneySteps(context, width, height, orientation),
                    SizedBox(height: AppDimensions.d16.h),
                  ],
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJourneySteps(
      BuildContext context, double width, double height, Orientation orientation) {
    final safeSteps = steps ?? [];
    final safeCompleted = completedSteps ?? List.filled(safeSteps.length, false);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(safeSteps.length, (index) {
        final isActive = index < safeCompleted.length && safeCompleted[index];

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
                      : AppColors.textSecondary.withValues(alpha: 0.4),
                  size: (orientation == Orientation.portrait
                      ? AppDimensions.d22
                      : AppDimensions.d18)
                      .sp,
                ),
                SizedBox(height: AppDimensions.d6.h),
                Text(
                  safeSteps[index].tr,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: (orientation == Orientation.portrait
                        ? AppDimensions.d10
                        : AppDimensions.d8)
                        .sp,
                    color: isActive
                        ? AppColors.primaryRed
                        : AppColors.textSecondary.withValues(alpha: 0.5),
                    fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
