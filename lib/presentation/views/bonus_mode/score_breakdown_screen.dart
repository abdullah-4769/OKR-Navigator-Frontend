// lib/presentation/views/bonus_mode/scoring_breakdown_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/Get.dart';
import '../../../core/app_colors.dart';
import '../../../view_model/bonus_controller/bonus_controller.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../feedback_screen.dart';
import 'feed_back_bonus.dart';


class ScoringBreakdownScreen extends StatelessWidget {
  final BonusModeController controller = Get.find();

  ScoringBreakdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
          children: [
            CustomHeader(
              title: 'evaluation_results'.tr,
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Obx(() => Column(
                    children: [
                      SizedBox(height: 32.h),
                      _buildOverallScoreCard(),
                      SizedBox(height: 32.h),
                      _buildDetailedScoresCard(),
                      SizedBox(height: 50.h),
                      CustomButton2(
                        text: 'see_feedback'.tr,
                        onPressed: () => Get.to(() => FeedbackBonusScreen()),
                      ),
                    ],
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallScoreCard() {
    final score = controller.evaluationScore.value;
    Color scoreColor = score >= 80 ? Colors.green : (score >= 60 ? Colors.orange : Colors.red);

    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scoreColor.withOpacity(0.7), scoreColor.withOpacity(0.5)],
        ),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withOpacity(0.4),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.stars, color: Colors.white, size: 48.sp),
          SizedBox(height: 12.h),
          Text(
            'overall_score'.tr,
            style: TextStyle(fontSize: 20.sp, color: Colors.white70, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),
          Text(
            '$score',
            style: TextStyle(fontSize: 80.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            score >= 80 ? 'excellent_performance'.tr : 'good_performance'.tr,
            style: TextStyle(fontSize: 18.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedScoresCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'detailed_breakdown'.tr,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: 20.h),
          _buildScoreBar('objective_quality'.tr, controller.objectiveScore.value),
          _buildScoreBar('key_results_quality'.tr, controller.krScore.value),
          _buildScoreBar('initiative_impact'.tr, controller.initiativeScore.value),
          _buildScoreBar('global_alignment'.tr, controller.alignmentScore.value),
          _buildScoreBar('contextual_relevance'.tr, controller.relevanceScore.value),
        ],
      ),
    );
  }

  Widget _buildScoreBar(String label, int value) {
    Color color = value >= 80 ? Colors.green : (value >= 60 ? Colors.orange : Colors.red);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 16.sp, color: Colors.black87, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '$value%',
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 10.h,
            ),
          ),
        ],
      ),
    );
  }
}
