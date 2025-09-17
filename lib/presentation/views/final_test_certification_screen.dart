import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/Other_screens_controllers/final_test_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../widgets/custom_home_navbar.dart';
import '../widgets/game_complete_widgets/custom_score_card.dart';
import '../widgets/screens_unique_parts/custom_background.dart';
import '../widgets/screens_unique_parts/custom_header.dart';
import '../widgets/custom_adjustment_container.dart';
import '../widgets/custom_button.dart';

class FinalTestCertificationScreen extends StatelessWidget {
  FinalTestCertificationScreen({super.key});

  final FinalTestController controller = Get.put(FinalTestController());

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final size = MediaQuery.of(context).size;
            final isPortrait = orientation == Orientation.portrait;

            return Stack(
              children: [
                /// Scrollable content
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: isPortrait ? size.height * 0.015 : size.height * 0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [


                        /// 🔹 Header
                        CustomHeader(
                          title: 'final_test'.tr,
                          highlightedText: 'certification'.tr,
                          subtitle: ''.tr,
                          onBackTap: () => Get.back(),
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.00001 : size.height * 0.00001),

                        /// 🔹 Test Completed Badge
                        Column(
                          children: [
                            Container(
                              height: isPortrait ? 120.w : 100.w,
                              width: isPortrait ? 120.w : 100.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.shade50,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  size: isPortrait ? 80.w : 70.w,
                                  color: Colors.green,
                                ),

                              ),

                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "ai_evaluation_progress".tr,
                                  style: TextStyle(
                                    fontSize: isPortrait ? 14.sp : 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: isPortrait ? 12.h : 8.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isPortrait ? 12.w : 10.w,
                                  vertical: isPortrait ? 6.h : 4.h
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                "test_completed".tr,
                                style: TextStyle(
                                  fontSize: isPortrait ? 14.sp : 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.03 : size.height * 0.02),

                        /// 🔹 AI Evaluation Focus
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                          child: CustomAdjustmentContainer(
                            icon: Icons.analytics,
                            iconColor: AppColors.primaryRed,
                            title: "ai_evaluation_focus".tr,
                            borderColor: AppColors.primaryRed,
                            children: [
                              _progressRow("strategy_alignment".tr, 0.12, isPortrait),
                              SizedBox(height: isPortrait ? 8.h : 6.h),
                              _progressRow("formulated_objective".tr, 0.14, isPortrait),
                              SizedBox(height: isPortrait ? 8.h : 6.h),
                              _progressRow("initiatives_per_rk".tr, 0.26, isPortrait),
                              SizedBox(height: isPortrait ? 8.h : 6.h),
                              _progressRow("overall_coherence".tr, 0.09, isPortrait),
                              SizedBox(height: isPortrait ? 8.h : 6.h),
                              _progressRow("key_results_count".tr, 0.27, isPortrait),
                            ],
                          ),
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.03 : size.height * 0.02),

                        /// 🔹 Final Score Card (using CustomScoreCard)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                          child: CustomScoreCard(
                            score: 78,
                            title: "strategic_architect".tr,
                            description: "strategic_architect_desc".tr,
                          ),
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.03 : size.height * 0.02),

                        /// 🔹 Achievement Medal (separate from score card)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                          child: Container(
                            padding: EdgeInsets.all(isPortrait ? 20.w : 16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.emoji_events,
                                    size: isPortrait ? 48.w : 40.w,
                                    color: AppColors.primaryBlue),
                                SizedBox(height: isPortrait ? 8.h : 6.h),
                                Text(
                                  "silver_level".tr,
                                  style: TextStyle(
                                    fontSize: isPortrait ? 20.sp : 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                Text(
                                  "achievement".tr,
                                  style: TextStyle(
                                    fontSize: isPortrait ? 16.sp : 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.03 : size.height * 0.02),

                        /// 🔹 AI Navigator Feedback
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                          child: CustomAdjustmentContainer(
                            icon: Icons.lightbulb,
                            iconColor: AppColors.primaryRed,
                            title: "ai_navigator_feedback".tr,
                            borderColor: AppColors.primaryRed,
                            children: [
                              _feedbackCard(
                                title: "strengths".tr,
                                description: "excellent_challenge_analysis".tr,
                                color: Colors.green.shade50,
                                isPortrait: isPortrait,
                              ),
                              SizedBox(height: isPortrait ? 12.h : 8.h),
                              _feedbackCard(
                                title: "areas_for_improvement".tr,
                                description: "innovative_approaches".tr,
                                color: Colors.orange.shade50,
                                isPortrait: isPortrait,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.04 : size.height * 0.03),

                        /// 🔹 Action Buttons
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
                          child: Column(
                            children: [
                              Obx(() => CustomButton(
                                text: "retake".tr,
                                onPressed: controller.retakeTest,
                                icon: Icons.refresh,
                                backgroundColor: AppColors.primaryRed,
                                isLoading: controller.isLoading.value,
                              )),
                              SizedBox(height: isPortrait ? 12.h : 8.h),
                              CustomButton(
                                text: "share_result".tr,
                                onPressed: controller.shareResults,
                                icon: Icons.share,
                                backgroundColor: Colors.amber,
                              ),
                              SizedBox(height: isPortrait ? 12.h : 8.h),
                              CustomButton(
                                text: "downloadable_pdf".tr,
                                onPressed: controller.downloadPDF,
                                icon: Icons.download,
                                backgroundColor: AppColors.primaryBlue,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.04 : size.height * 0.03),
                      ],
                    ),
                  ),
                ),

                /// 🔹 Home Navbar
                Positioned(
                  right: isPortrait ? size.width * -0.07 : size.width * -0.05,
                  top: isPortrait ? size.height * 0.5 : size.height * 0.4,
                  child: const CustomHomeNavBar(),
                ),
              ],
            );
          },
        ),
      ),
    );

  /// 🔹 Progress Row (for AI Evaluation Focus)
  Widget _progressRow(String label, double value, bool isPortrait) => Padding(
      padding: EdgeInsets.symmetric(vertical: isPortrait ? 6.h : 4.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: isPortrait ? 14.sp : 12.sp,
                  color: AppColors.textSecondary
              ),
            ),
          ),
          SizedBox(width: isPortrait ? 8.w : 6.w),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(AppColors.primaryRed),
              minHeight: isPortrait ? 6.h : 5.h,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(width: isPortrait ? 8.w : 6.w),
          Text(
            "${(value * 100).toInt()}%",
            style: TextStyle(
              fontSize: isPortrait ? 12.sp : 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryRed,
            ),
          ),
        ],
      ),
    );

  /// 🔹 Feedback Card
  Widget _feedbackCard({
    required String title,
    required String description,
    required Color color,
    required bool isPortrait,
  }) => Container(
      width: double.infinity,
      padding: EdgeInsets.all(isPortrait ? 12.w : 10.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isPortrait ? 14.sp : 12.sp,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: isPortrait ? 6.h : 4.h),
          Text(
            description,
            style: TextStyle(
                fontSize: isPortrait ? 13.sp : 11.sp,
                color: AppColors.textSecondary
            ),
          ),
        ],
      ),
    );
}