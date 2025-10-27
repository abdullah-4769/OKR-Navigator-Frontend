import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/Other_screens_controllers/mini_simulation_play_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class CustomProgressPath extends StatelessWidget {
  /// Step labels like ["1","2","3","4","5"]
  final List<String> stepLabels;

  /// If provided, it will be used. Otherwise it will try using MiniSimulationPlayController
  final int? currentStep;

  /// Show circles or just digits text
  final bool showCircles;

  const CustomProgressPath({
    super.key,
    required this.stepLabels,
    this.currentStep,
    this.showCircles = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    if (currentStep == null && Get.isRegistered<MiniSimulationPlayController>()) {
      final controller = Get.find<MiniSimulationPlayController>();
      return Obx(() {
        return _buildProgressUI(
          context,
          screenWidth,
          isLandscape,
          controller.currentStep.value,
        );
      });
    }

    return _buildProgressUI(
        context, screenWidth, isLandscape, currentStep ?? 0);
  }

  Widget _buildProgressUI(
      BuildContext context, double screenWidth, bool isLandscape, int activeStep) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ======= Progress Line =======
        Stack(
          children: [
            Container(
              height: AppDimensions.d4.h,
              margin: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppDimensions.d2.r),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final progress = activeStep / (stepLabels.length - 1);
                final progressWidth = constraints.maxWidth * progress;

                return Container(
                  height: AppDimensions.d4.h,
                  margin: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                  width: progressWidth,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(AppDimensions.d2.r),
                  ),
                );
              },
            ),
          ],
        ),

        SizedBox(height: AppDimensions.d8.h),

        // ======= Step Items (Circles or Digits) =======
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(stepLabels.length, (index) {
            final isCompleted = index <= activeStep;

            return Expanded(
              child: Center(
                child: showCircles
                    ? Container(
                  width: isLandscape ? screenWidth * 0.08 : screenWidth * 0.14,
                  height: isLandscape ? screenWidth * 0.08 : screenWidth * 0.14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.primaryRed
                        : AppColors.grey.withOpacity(0.3),
                    border: index == activeStep
                        ? Border.all(color: AppColors.primaryRed, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isCompleted
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.d20.sp, // bigger font
                      ),
                    ),
                  ),
                )
                    : Text(
                  stepLabels[index],
                  style: TextStyle(
                    fontSize: AppDimensions.d22.sp, // bigger font
                    color: isCompleted
                        ? AppColors.black
                        : AppColors.textSecondary,
                    fontWeight: index == activeStep
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
