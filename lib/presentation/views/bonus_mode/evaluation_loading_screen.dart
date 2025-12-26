// // lib/presentation/views/bonus_mode/evaluation_loading_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:game_app/presentation/views/bonus_mode/score_breakdown_screen.dart';
// import 'package:get/Get.dart';
// import '../../../core/app_colors.dart';
// import '../../../view_model/bonus_controller/bonus_controller.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
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
//   // Future<void> _startEvaluation() async {
//   //   try {
//   //     print('🔍 _startEvaluation شروع ہوا');
//   //     print('   Objective: ${widget.objective}');
//   //     print('   KR1: ${widget.kr1}');
//   //     print('   KR2: ${widget.kr2}');
//   //     print('   Initiative: ${widget.initiative}');
//   //
//   //     // API call کریں
//   //     await controller.evaluateUserResponse(
//   //       objective: widget.objective,
//   //       keyResults: '${widget.kr1}, ${widget.kr2}',
//   //       initiative: widget.initiative,
//   //     );
//   //
//   //     print('✅ API Response ملا');
//   //     print('   Score: ${controller.evaluationScore.value}');
//   //     print('   Badge: ${controller.badgeName.value}');
//   //     print('   Objective Score: ${controller.objectiveScore.value}');
//   //
//   //     // Check کریں کہ evaluation successful ہے
//   //     if (controller.evaluationScore.value > 0) {
//   //       print('🎉 Evaluation successful, 2 سیکنڈ انتظار کریں');
//   //
//   //       if (mounted) {
//   //         // 2 سیکنڈ انتظار کریں
//   //         await Future.delayed(const Duration(seconds: 2));
//   //
//   //         if (mounted) {
//   //           print('🚀 ScoringBreakdownScreen پر navigate ہو رہے ہیں');
//   //           // Screen switch کریں
//   //           Get.off(() => ScoringBreakdownScreen());
//   //         }
//   //       }
//   //     } else {
//   //       print('❌ Evaluation failed - Score 0 ہے');
//   //       if (mounted) {
//   //         Get.snackbar(
//   //           'Error',
//   //           'Could not evaluate response. Score is 0',
//   //           backgroundColor: Colors.red,
//   //           colorText: Colors.white,
//   //         );
//   //         Get.back();
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print('❌ Exception: $e');
//   //     print('   Type: ${e.runtimeType}');
//   //
//   //     if (mounted) {
//   //       Get.snackbar(
//   //         'Evaluation Error',
//   //         'Error: $e',
//   //         backgroundColor: Colors.red,
//   //         colorText: Colors.white,
//   //         duration: const Duration(seconds: 5),
//   //       );
//   //
//   //       // 2 سیکنڈ بعد واپس جائیں
//   //       await Future.delayed(const Duration(seconds: 2));
//   //       Get.back();
//   //     }
//   //   }
//   // }
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
//       // === REMOVE the > 0 check — always show result
//       print('✅ Evaluation done. Navigating to result...');
//
//       await Future.delayed(const Duration(seconds: 2)); // Dramatic pause
//
//       if (mounted) {
//         Get.off(() => ScoringBreakdownScreen());
//       }
//     } catch (e) {
//       print('❌ Evaluation failed: $e');
//       if (mounted) {
//         Get.snackbar('Error', 'Evaluation failed: $e', backgroundColor: Colors.red);
//         Get.back();
//       }
//     }
//   }
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
//
// lib/presentation/views/bonus_mode/evaluation_loading_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/views/bonus_mode/score_breakdown_screen.dart';
import 'package:get/Get.dart';
import '../../../core/app_colors.dart';
import '../../../view_model/bonus_controller/bonus_controller.dart';
import '../../widgets/custom_home_navbar.dart';
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
    // Evaluation کو async طریقے سے start کریں
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

      await Future.delayed(const Duration(seconds: 2)); // Dramatic pause

      if (mounted) {
        _routeBasedOnBadge();
      }
    } catch (e) {
      print('❌ Evaluation failed: $e');
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

  /// ✅ Route based on badge earned
  void _routeBasedOnBadge() {
    final badge = controller.badgeName.value.toLowerCase().trim();
    final score = controller.evaluationScore.value;

    print('🎯 Badge-based routing:');
    print('   Badge: $badge');
    print('   Score: $score');

    // اگر کوئی badge نہیں ملا (score < 60) یا badge 'none' ہے
    if (badge == 'none' ||
        badge.isEmpty ||
        score < 60) {
      print('❌ No badge earned (score < 60) - Going to TrainingCompleteScreen');
      Get.off(() => TrainingCompleteScreen());
    }
    // Badge ملا (Gold, Silver, Bronze)
    else {
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