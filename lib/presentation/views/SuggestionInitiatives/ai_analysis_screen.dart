import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../controllers/custom_ai_startegy_controller.dart';

class AIAnalysisScreen extends StatelessWidget {
  final AIStrategyController controller = Get.put(AIStrategyController());

  AIAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        title: Text(
          "AI Strategic Analysis",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Gotham-Bold',
            fontSize: AppDimensions.d18.sp,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.d20.w),
        child: Obx(() {
          final bool isAnalysisDone = controller.isAnalysisDone.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Header with Icon + Title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    "assets/images/robot.svg",
                    height: AppDimensions.d50.h,
                    width: AppDimensions.d50.w,
                  ),
                  SizedBox(width: AppDimensions.d12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AI Strategic Analysis",
                          style: TextStyle(
                            fontFamily: 'Gotham-Bold',
                            fontSize: AppDimensions.d20.sp,
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppDimensions.d4.h),
                        Text(
                          "Relevance threshold: >${controller.threshold.value}%",
                          style: TextStyle(
                            fontSize: AppDimensions.d12.sp,
                            color: AppColors.textSecondary,
                            fontFamily: 'Gotham',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppDimensions.d20.h),

              // ✅ AI Analysis Container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppDimensions.d16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.d12.r),
                  border: Border.all(
                    color: isAnalysisDone
                        ? AppColors.successGreen.withOpacity(0.5)
                        : AppColors.primaryRed.withOpacity(0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: isAnalysisDone
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "AI Feedback",
                      style: TextStyle(
                        fontSize: AppDimensions.d16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                        fontFamily: 'Gotham-Bold',
                      ),
                    ),
                    SizedBox(height: AppDimensions.d8.h),
                    Text(
                      controller.feedback.value,
                      style: TextStyle(
                        fontSize: AppDimensions.d14.sp,
                        color: AppColors.textSecondary,
                        fontFamily: 'Gotham',
                      ),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    Icon(
                      Icons.analytics,
                      size: AppDimensions.d40.w,
                      color: AppColors.primaryRed,
                    ),
                    SizedBox(height: AppDimensions.d12.h),
                    Text(
                      "Submit your initiatives for AI analysis",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimensions.d14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        fontFamily: 'Gotham',
                      ),
                    ),
                    SizedBox(height: AppDimensions.d8.h),
                    Text(
                      "Feedback will appear here",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimensions.d12.sp,
                        color: AppColors.textSecondary.withOpacity(0.7),
                        fontFamily: 'Gotham',
                      ),
                    ),
                    SizedBox(height: AppDimensions.d16.h),

                    // ✅ Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.submitForAnalysis,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: AppDimensions.d14.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(AppDimensions.d8.r),
                          ),
                        ),
                        child: Text(
                          "Submit for Analysis",
                          style: TextStyle(
                            fontSize: AppDimensions.d16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Gotham',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
