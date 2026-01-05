// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:game_app/presentation/views/bonus_mode/score_breakdown_screen.dart';
// import 'package:get/Get.dart';
// import '../../../core/app_colors.dart';
// import '../../../view_model/bonus_controller/bonus_controller.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import 'training_complete_screen.dart';
//
// class EvaluationLoadingScreen extends StatefulWidget {
//   final String objective;
//   final String kr1;
//   final String kr2;
//   final String initiative;
//
//   const EvaluationLoadingScreen({
//     required this.objective,
//     required this.kr1,
//     required this.kr2,
//     required this.initiative,
//     super.key,
//   });
//
//   @override
//   State<EvaluationLoadingScreen> createState() => _EvaluationLoadingScreenState();
// }
//
// class _EvaluationLoadingScreenState extends State<EvaluationLoadingScreen>
//     with SingleTickerProviderStateMixin {
//   final BonusModeController controller = Get.find();
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimation();
//     // Evaluation کو async طریقے سے start کریں
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _startEvaluation();
//     });
//   }
//
//   void _initializeAnimation() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat(reverse: true);
//
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }
//
//   Future<void> _startEvaluation() async {
//     try {
//       print('🔍 Starting evaluation...');
//
//       await controller.evaluateUserResponse(
//         objective: widget.objective,
//         keyResults: '${widget.kr1}, ${widget.kr2}',
//         initiative: widget.initiative,
//       );
//
//       print('✅ Evaluation done');
//       print('   Score: ${controller.evaluationScore.value}');
//       print('   Badge: ${controller.badgeName.value}');
//
//       await Future.delayed(const Duration(seconds: 2)); // Dramatic pause
//
//       if (mounted) {
//         _routeBasedOnBadge();
//       }
//     } catch (e) {
//       print('❌ Evaluation failed: $e');
//       if (mounted) {
//         Get.snackbar(
//           'Error',
//           'Evaluation failed: $e',
//           backgroundColor: Colors.red,
//         );
//         Get.back();
//       }
//     }
//   }
//
//   /// ✅ Route based on badge earned
//   void _routeBasedOnBadge() {
//     final badge = controller.badgeName.value.toLowerCase().trim();
//     final score = controller.evaluationScore.value;
//
//     print('🎯 Badge-based routing:');
//     print('   Badge: $badge');
//     print('   Score: $score');
//
//     // اگر کوئی badge نہیں ملا (score < 60) یا badge 'none' ہے
//     if (badge == 'none' ||
//         badge.isEmpty ||
//         score < 60) {
//       print('❌ No badge earned (score < 60) - Going to TrainingCompleteScreen');
//       Get.off(() => TrainingCompleteScreen());
//     }
//     // Badge ملا (Gold, Silver, Bronze)
//     else {
//       print('🏅 Badge earned: $badge - Going to ScoringBreakdownScreen');
//       Get.off(() => ScoringBreakdownScreen());
//     }
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomBackground(
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.all(32.w),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ScaleTransition(
//                   scale: _scaleAnimation,
//                   child: Container(
//                     padding: EdgeInsets.all(40.w),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.9),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.primaryRed.withOpacity(0.3),
//                           blurRadius: 20,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: CircularProgressIndicator(
//                       color: AppColors.primaryRed,
//                       strokeWidth: 6,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 50.h),
//                 Text(
//                   'ai_evaluating_okr'.tr,
//                   style: TextStyle(
//                     fontSize: 26.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20.h),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Text(
//                     'checking_quality_alignment_relevance'.tr,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       color: Colors.black87,
//                       height: 1.4,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/views/bonus_mode/score_breakdown_screen.dart';
import 'package:get/Get.dart';
import '../../../core/app_colors.dart';
import '../../../view_model/bonus_controller/bonus_controller.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import 'training_complete_screen.dart';

class EvaluationLoadingScreen extends StatefulWidget {
  final String objective;
  final String kr1;
  final String kr2;
  final String initiative;

  const EvaluationLoadingScreen({
    required this.objective,
    required this.kr1,
    required this.kr2,
    required this.initiative,
    super.key,
  });

  @override
  State<EvaluationLoadingScreen> createState() => _EvaluationLoadingScreenState();
}

class _EvaluationLoadingScreenState extends State<EvaluationLoadingScreen>
    with SingleTickerProviderStateMixin {
  final BonusModeController controller = Get.find();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startEvaluation();
    });
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _startEvaluation() async {
    try {
      print('🔍 Starting evaluation...');

      await controller.evaluateUserResponse(
        objective: widget.objective,
        keyResults: '${widget.kr1}, ${widget.kr2}',
        initiative: widget.initiative,
      );

      print('✅ Evaluation done');
      print('   Score: ${controller.evaluationScore.value}');
      print('   Badge: ${controller.badgeName.value}');

      // ✅ STOP TIMER AFTER EVALUATION
      controller.stopCountdownTimer();
      print('⏱️ Timer stopped after evaluation');

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        _routeBasedOnBadge();
      }
    } catch (e) {
      print('❌ Evaluation failed: $e');
      // ✅ STOP TIMER ON ERROR
      controller.stopCountdownTimer();
      if (mounted) {
        Get.snackbar(
          'Error',
          'Evaluation failed: $e',
          backgroundColor: Colors.red,
        );
        Get.back();
      }
    }
  }

  void _routeBasedOnBadge() {
    final badge = controller.badgeName.value.toLowerCase().trim();
    final score = controller.evaluationScore.value;

    print('🎯 Badge-based routing:');
    print('   Badge: $badge');
    print('   Score: $score');

    if (badge == 'none' || badge.isEmpty || score < 60) {
      print('❌ No badge earned (score < 60) - Going to TrainingCompleteScreen');
      Get.off(() => TrainingCompleteScreen());
    } else {
      print('🏅 Badge earned: $badge - Going to ScoringBreakdownScreen');
      Get.off(() => ScoringBreakdownScreen());
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: EdgeInsets.all(40.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryRed.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: CircularProgressIndicator(
                      color: AppColors.primaryRed,
                      strokeWidth: 6,
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
                Text(
                  'ai_evaluating_okr'.tr,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'checking_quality_alignment_relevance'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}