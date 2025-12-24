import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:game_app/core/app_colors.dart';
import 'package:game_app/presentation/widgets/custom_button2.dart';
import 'package:game_app/presentation/widgets/screens_unique_parts/custom_background.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/view_model/bonus_controller/bonus_controller.dart';

class TrainingCompleteScreen extends StatefulWidget {
  const TrainingCompleteScreen({super.key});

  @override
  State<TrainingCompleteScreen> createState() => _TrainingCompleteScreenState();
}

class _TrainingCompleteScreenState extends State<TrainingCompleteScreen>
    with SingleTickerProviderStateMixin {
  final BonusModeController controller = Get.find();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    // Show a nice snackbar with today's score
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showScoreSnackbar();
    });
  }

  void _showScoreSnackbar() {
    final score = controller.evaluationScore.value;
    final badge = controller.badgeName.value;

    Get.snackbar(
      '🎉 Today Score'.tr,
      'Score: $score/100\nBadge: $badge\nStreak: ${controller.streakDays.value} days',
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

    print('✅ Snackbar shown with score: $score');
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
  Widget build(BuildContext context) {
    return Scaffold(
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
                                'Today Score'.tr,
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
                                'Obtainer Score'.tr,
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
                      child: Row(
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
                                'Streak'.tr,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                '${controller.streakDays.value} days',
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
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'see_you_tomorrow'.tr,
                      style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                    ),
                    SizedBox(height: 60.h),
                    CustomButton2(
                      text: 'back_to_home'.tr,
                      onPressed: () {
                        // پہلے تمام data reset کریں
                        // controller.resetAll();
                        Get.offAllNamed(AppRoutes.home);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}