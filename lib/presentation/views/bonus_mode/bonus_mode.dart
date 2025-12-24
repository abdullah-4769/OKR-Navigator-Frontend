// lib/presentation/views/bonus_mode/daily_training_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/Get.dart';
import '../../../core/app_colors.dart';
import '../../../view_model/bonus_controller/bonus_controller.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import 'case_presentation_screen.dart';

class DailyTrainingHomeScreen extends StatefulWidget {
  const DailyTrainingHomeScreen({super.key});

  @override
  State<DailyTrainingHomeScreen> createState() => _DailyTrainingHomeScreenState();
}

class _DailyTrainingHomeScreenState extends State<DailyTrainingHomeScreen> {
  final BonusModeController controller = Get.put(BonusModeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.checkPlayedToday();
      controller.getStreakInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
          children: [
            CustomHeader(
              title: 'daily_okr_training'.tr,
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      Obx(() => Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.withOpacity(0.2),
                              Colors.deepOrange.withOpacity(0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.deepOrange,
                              size: 48.sp,
                            ),
                            SizedBox(width: 16.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'current_streak'.tr,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  '${controller.streakDays.value} ${'days'.tr}',
                                  style: TextStyle(
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                      SizedBox(height: 32.h),
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return _buildLoadingCard();
                          }
                          if (controller.hasPlayedToday.value) {
                            return _buildAlreadyPlayedCard();
                          }
                          return _buildChallengeCard();
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.primaryRed,
          AppColors.primaryRed.withOpacity(0.8),
        ],
      ),
      borderRadius: BorderRadius.circular(32.r),
    ),
    child: Center(
      child: CircularProgressIndicator(color: Colors.white),
    ),
  );

  Widget _buildAlreadyPlayedCard() => Container(
    padding: EdgeInsets.all(32.w),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.grey.shade600,
          Colors.grey.shade700,
        ],
      ),
      borderRadius: BorderRadius.circular(32.r),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: 64.sp, color: Colors.white),
        SizedBox(height: 24.h),
        Text(
          'already_played_today'.tr,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Text(
          'come_back_tomorrow'.tr,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildChallengeCard() => Container(
    padding: EdgeInsets.all(32.w),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.primaryRed, AppColors.primaryRed.withOpacity(0.8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(32.r),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryRed.withOpacity(0.4),
          blurRadius: 24,
          offset: Offset(0, 12),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.psychology,
            size: 64.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'todays_challenge'.tr,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            'apply_okr_principles'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ),
        SizedBox(height: 40.h),
        CustomButton2(
          text: 'start_training'.tr,
          onPressed: () => Get.to(() => CasePresentationScreen()),
        ),
      ],
    ),
  );
}
