import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../view_model/bonus_controller/bonus_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../view_model/bonus_controller/bonus_controller.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';

class TrainingCompleteScreen extends StatefulWidget {
  const TrainingCompleteScreen({super.key});

  @override
  State<TrainingCompleteScreen> createState() => _TrainingCompleteScreenState();
}

class _TrainingCompleteScreenState extends State<TrainingCompleteScreen>
    with SingleTickerProviderStateMixin {
  final BonusModeController controller = Get.find();
  late AnimationController _animationController;
  final RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    // ✅ Load streak before showing screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStreakAndShowSnackbar();
    });
  }

  /// ✅ Load streak data first
  Future<void> _loadStreakAndShowSnackbar() async {
    try {
      print('📥 Loading streak data...');

      // ✅ Submit score first (even if score < 60)
      print('💾 Submitting score to backend...');
      await controller.submitBonusScore();
      print('✅ Score submitted');

      // Then load streak
      await controller.getStreakInfo();
      print('✅ Streak loaded: ${controller.streakDays.value} days');

      // Now show snackbar
      _showScoreSnackbar();
    } catch (e) {
      print('❌ Error: $e');
      _showScoreSnackbar(); // Fallback
    }
  }

  void _showScoreSnackbar() {
    final score = controller.evaluationScore.value;
    final badge = controller.badgeName.value;
    final streak = controller.streakDays.value;

    print('🎯 Showing snackbar:');
    print('   Score: $score');
    print('   Badge: $badge');
    print('   Streak: $streak days');

    // اگر score < 60 ہو تو message بدل دیں
    String streakMessage = '';
    if (score < 60) {
      streakMessage = 'Streak: $streak days (current)';
      print('⚠️ Low score - showing current streak');
    } else {
      streakMessage = 'Streak: $streak days';
      print('✅ Good score - showing new streak');
    }

    Get.snackbar(
      'today_score'.tr,
      'Score: $score/100\nBadge: $badge\n$streakMessage',
      backgroundColor: _getScoreColor(score),
      colorText: Colors.white,
      duration: const Duration(seconds: 6),
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.r,
      padding: EdgeInsets.all(16.w),
      boxShadows: [
        BoxShadow(
          color: _getScoreColor(score).withOpacity(0.4),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );

    print('✅ Snackbar shown with score: $score, streak: $streak');
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.blue;
    if (score >= 70) return Colors.orange;
    return Colors.grey;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SingleChildScrollView(
      child: CustomBackground(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.w),
            child: Obx(
                  () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Checkmark animation
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(32.w),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 120.sp,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // Completion text
                  Text(
                    'training_completed'.tr,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),

                  // Score Display Card
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getScoreColor(controller.evaluationScore.value)
                              .withOpacity(0.2),
                          _getScoreColor(controller.evaluationScore.value)
                              .withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: _getScoreColor(controller.evaluationScore.value)
                            .withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Score
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'today_score'.tr,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${controller.evaluationScore.value}/100',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(
                                    controller.evaluationScore.value),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Divider(color: Colors.black12),
                        SizedBox(height: 12.h),

                        // Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'obtained_score'.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black54,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getScoreColor(
                                    controller.evaluationScore.value),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                controller.badgeName.value,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Streak Display
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.withOpacity(0.2),
                          Colors.deepOrange.withOpacity(0.1)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.deepOrange,
                              size: 32.sp,
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'streak'.tr,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${controller.streakDays.value}',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      'days'.tr,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        // ✅ Conditional message based on score
                        SizedBox(height: 16.h),
                        if (controller.evaluationScore.value < 60)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              'low_score_streak_not_increment'.tr,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              'great_job_streak_increment'.tr,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Text(
                    'see_you_tomorrow'.tr,
                    style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                  ),
                  SizedBox(height: 60.h),

                  Obx(() {
                    if (isLoading.value) {
                      return const CircularProgressIndicator();
                    }

                    return CustomButton2(
                      text: 'back_to_home'.tr,
                      onPressed: () async {
                        isLoading.value = true;

                        // Optional delay to show loader smoothly
                        await Future.delayed(
                            const Duration(seconds: 1));

                        isLoading.value = false;
                        Get.offAllNamed(AppRoutes.home);
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}