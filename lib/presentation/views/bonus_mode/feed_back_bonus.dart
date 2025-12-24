// lib/presentation/views/bonus_mode/feedback_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/Get.dart';
import '../../../core/app_colors.dart';
import '../../../view_model/bonus_controller/bonus_controller.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import 'badge_reward_screen.dart';

class FeedbackBonusScreen extends StatelessWidget {
  final BonusModeController controller = Get.find();

  FeedbackBonusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
          children: [
            CustomHeader(
              title: 'ai_feedback'.tr,
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
                      _buildFeedbackCard(),
                      SizedBox(height: 28.h),
                      _buildStrengthsSection(),
                      SizedBox(height: 24.h),
                      _buildImprovementsSection(),
                      SizedBox(height: 50.h),
                      CustomButton2(
                        text: 'view_badge_reward'.tr,
                        onPressed: () => Get.to(() => BadgeRewardScreen()),
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

  Widget _buildFeedbackCard() {
    return Container(
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, size: 40.sp, color: AppColors.primaryRed),
          SizedBox(height: 16.h),
          Text(
            controller.feedbackText.value.tr,
            style: TextStyle(fontSize: 18.sp, color: Colors.black87, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsSection() {
    return _buildSection(
      'strengths'.tr,
      controller.strengths,
      Colors.green,
      Icons.check_circle,
    );
  }

  Widget _buildImprovementsSection() {
    return _buildSection(
      'improvements'.tr,
      controller.improvements,
      Colors.orange,
      Icons.lightbulb_outline,
    );
  }

  Widget _buildSection(String title, RxList<String> items, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28.sp),
              SizedBox(width: 12.w),
              Text(
                title.tr,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...items.map((item) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 6.h),
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    item.tr,
                    style: TextStyle(fontSize: 16.sp, color: Colors.black87, height: 1.5),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
