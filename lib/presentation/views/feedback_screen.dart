// lib/presentation/views/feedback/feedback_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart' as key_result_models;
import '../../generated/models/requests/campaign_mode/feedback_evaluation_model.dart';
import '../../services/shared_preference.dart';
import '../../view_model/bonus_score.dart';
import '../../view_model/campaign_mode/feedback_evaluation_view_model.dart';
import '../widgets/campaign_mode_widgets/campaign_progress_service.dart';
import '../widgets/custom_button2.dart';
import '../widgets/custom_home_navbar.dart';
import '../widgets/game_complete_widgets/custom_score_card.dart';
import '../widgets/screens_unique_parts/custom_background.dart';
import '../widgets/screens_unique_parts/custom_header.dart';

class FeedbackScreen extends StatelessWidget {
  final List<key_result_models.KeyResult> selectedKeyResults;

  const FeedbackScreen({super.key, required this.selectedKeyResults});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(FeedbackEvaluationViewModel());
    final bonusController = Get.put(BonusScoreController());

    // Trigger evaluation when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewModel.evaluateSelectedKeyResults(selectedKeyResults);

      // Check if we should submit bonus score
      final shouldSubmitBonus = await bonusController.shouldSubmitBonusScore();
      if (shouldSubmitBonus) {
        print('🎯 Bonus mode detected - will submit bonus score after evaluation');
      }
    });

    return Scaffold(
      body: CustomBackground(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 14.w),
                child: Column(
                  children: [
                    CustomHeader(
                      title: 'okr'.tr,
                      highlightedText: "feedback".tr,
                      onBackTap: () => Get.back(),
                    ),
                    SizedBox(height: 20.h),
                    Obx(() {
                      if (viewModel.isLoadingData) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 100.h),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (!viewModel.hasData) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 100.h),
                            child: Text('no_feedback_data_available'.tr),
                          ),
                        );
                      }

                      final feedback = viewModel.evaluationResult!;

                      // ✅ BONUS MODE: Submit bonus score when evaluation is complete
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        final shouldSubmit = await bonusController.shouldSubmitBonusScore();
                        if (shouldSubmit && !bonusController.isLoading.value) {
                          _submitBonusScore(bonusController, feedback);
                        }
                      });

                      return Column(
                        children: [
                          // ✅ BONUS MODE INDICATOR
                          Obx(() {
                            if (bonusController.isLoading.value) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 16.w,
                                      height: 16.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'submitting_bonus_score'.tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (bonusController.hasSubmittedBonus.value) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.stars, color: Colors.white, size: 20.sp),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'bonus_score_submitted'.trParams({'score': feedback.overallScore.toString()}),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return FutureBuilder<bool>(
                              future: bonusController.isBonusMode(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data == true && !bonusController.hasSubmittedBonus.value) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.stars, color: Colors.white, size: 20.sp),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'bonus_mode_active'.tr,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            );
                          }),

                          CustomScoreCard(
                            title: "",
                            score: feedback.overallScore,
                            showBackground: false,
                          ),
                          SizedBox(height: 4.h),
                          Padding(
                            padding: EdgeInsets.all(8.w),
                            child: _buildScoreBreakdown(feedback),
                          ),
                          SizedBox(height: 4.h),
                          Padding(
                            padding: EdgeInsets.all(12.w),
                            child: _buildFeedbackCard(feedback),
                          ),
                          SizedBox(height: 24.h),

                          // ✅ UPDATED: Navigation based on game mode
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: CustomButton2(
                              text: 'continue'.tr,
                              onPressed: () => _navigateBasedOnGameMode(),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * -0.07,
              top: MediaQuery.of(context).size.height * 0.50,
              child: const CustomHomeNavBar(),
            ),
          ],
        ),
      ),
    );
  }

// ✅ BONUS SCORE SUBMISSION - FIXED FOR 30-POINT SCALE
  void _submitBonusScore(BonusScoreController bonusController, FeedbackEvaluationModel feedback) async {
    try {
      final breakdown = feedback.breakdown;

      // ✅ CORRECT SCORE CONVERSION: Each category out of 30, overall out of 30
      // Convert each score from 40-point to 30-point scale
      final strategyScore30 = (breakdown.strategyAlignment.score * 30 / 30).round();
      final objectiveScore30 = (breakdown.objectiveAlignment.score * 30 / 30).round();
      final keyResultScore30 = (breakdown.keyResultQuality.score * 30 / 40).round();

      // ✅ CORRECT OVERALL SCORE: Calculate weighted average, not sum
      // Each category contributes equally to overall score out of 30
      final overallScore30 = ((strategyScore30 + objectiveScore30 + keyResultScore30) * 30 / 90).round();

      // Alternative: Use the normalized score from the API response if available
      // final overallScore30 = _parseNormalizedScore(feedback.normalizedScore);

      // Create normalized score string (e.g., "25.5/30")
      final normalizedScore = '$overallScore30/30';

      // Calculate points based on converted overall score
      String points;
      if (overallScore30 >= 25) {
        points = "3/3";
      } else if (overallScore30 >= 20) {
        points = "2/3";
      } else {
        points = "1/3";
      }

      // Determine title based on converted overall score
      String title;
      if (overallScore30 >= 27) {
        title = "Perfect".tr;
      } else if (overallScore30 >= 24) {
        title = "Excellent".tr;
      } else if (overallScore30 >= 21) {
        title = "Good".tr;
      } else if (overallScore30 >= 18) {
        title = "Average".tr;
      } else {
        title = "Needs Improvement".tr;
      }

      print('🎯 Converting scores for bonus mode:');
      print('   - Strategy: ${breakdown.strategyAlignment.score}/40 → $strategyScore30/30');
      print('   - Objective: ${breakdown.objectiveAlignment.score}/40 → $objectiveScore30/30');
      print('   - Key Results: ${breakdown.keyResultQuality.score}/40 → $keyResultScore30/30');
      print('   - Overall: $overallScore30/30, Points: $points, Title: $title');

      final success = await bonusController.submitBonusScore(
        overallScore: overallScore30,
        normalizedScore: normalizedScore,
        points: points,
        title: title,
        feedback: feedback.feedback,
        strategyAlignmentTitle: breakdown.strategyAlignment.title,
        strategyAlignmentScore: strategyScore30,
        strategyAlignmentSuggestion: breakdown.strategyAlignment.suggestion,
        objectiveAlignmentTitle: breakdown.objectiveAlignment.title,
        objectiveAlignmentScore: objectiveScore30,
        objectiveAlignmentSuggestion: breakdown.objectiveAlignment.suggestion,
        keyResultQualityTitle: breakdown.keyResultQuality.title,
        keyResultQualityScore: keyResultScore30,
        keyResultQualitySuggestion: breakdown.keyResultQuality.suggestion,
      );

      if (success) {
        print('🎉 Bonus score submitted successfully!');
      } else {
        print('⚠️ Failed to submit bonus score: ${bonusController.errorMessage.value}');
      }
    } catch (e) {
      print('❌ Error in bonus score submission: $e');
    }
  }

// Helper method to parse normalized score from API response
  int _parseNormalizedScore(String normalizedScore) {
    try {
      // Extract the score part from "25.5/30"
      final scorePart = normalizedScore.split('/').first;
      return double.parse(scorePart).round();
    } catch (e) {
      print('❌ Error parsing normalized score: $e');
      return 25; // Default fallback
    }
  }
  void _markLevelComplete() async {
    try {
      final savedMode = await SharedPrefs.getGameMode();
      if (savedMode == 'campaign') {
        final currentLevelStr = await SharedPrefs.getString('current_campaign_level') ?? '1';
        final currentLevel = int.tryParse(currentLevelStr) ?? 1;

        await CampaignProgressService.completeLevel(currentLevel);

        print('✅ Campaign Level $currentLevel marked as completed!');

        Get.snackbar(
          "Level Completed!".tr,
          "Organization ${currentLevel == 1 ? 'A' : currentLevel == 2 ? 'B' : 'C'} completed!".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Error marking level complete: $e');
    }
  }

  void _navigateBasedOnGameMode() async {
    try {
      final savedMode = await SharedPrefs.getGameMode();
      final bonusController = Get.find<BonusScoreController>();

      if (savedMode == 'campaign') {
        _markLevelComplete();
      }

      // For bonus mode, we stay on feedback screen until user continues
      if (savedMode == 'bonus') {
        // Bonus mode ends here - show completion message
        Get.snackbar(
          "bonus_mode_completed".tr,
          "bonus_mode_completion_message".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFFFFD700),
          colorText: Colors.black,
          duration: Duration(seconds: 3),
        );

        // Navigate to home after bonus completion
        Future.delayed(Duration(seconds: 2), () {
          Get.offAllNamed(AppRoutes.home);
        });
        return;
      }

      // Rest of navigation logic for other modes
      switch (savedMode) {
        case 'solo':
        case 'challenge':
          Get.toNamed(AppRoutes.suggestionInitiativeScreen);
          break;
        case 'campaign':
          Get.offAllNamed(AppRoutes.campaignModeScreen);
          break;
        default:
          Get.toNamed(AppRoutes.suggestionInitiativeScreen);
          break;
      }
    } catch (e) {
      print('❌ Error in navigation: $e');
      Get.toNamed(AppRoutes.suggestionInitiativeScreen);
    }
  }

  Widget _buildScoreBreakdown(FeedbackEvaluationModel feedback) {
    final breakdown = feedback.breakdown;

    // Use normalized score for display
    final normalizedScore = feedback.normalizedScore;

    final scores = [
      {'score': '${breakdown.strategyAlignment.score}/30', 'label': 'strategy_alignment'.tr},
      {'score': '${breakdown.objectiveAlignment.score}/30', 'label': 'objective_alignment'.tr},
      {'score': '${breakdown.keyResultQuality.score}/40', 'label': 'key_result_quality'.tr},
    ];

    return Column(
      children: [
        // Overall normalized score
        Text(
          'score'.tr.replaceFirst('${0}', normalizedScore.toString()),
          style: TextStyle(
            fontFamily: 'GothamBold',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        SizedBox(height: 12.h),

        // FIXED: Breakdown scores - Use Wrap or Flexible to prevent overflow
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: scores.map((item) {
            return Flexible( // FIX: Use Flexible to allow wrapping
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w), // Reduced margin
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 4.w), // Reduced padding
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['score']!,
                      style: TextStyle(
                        fontFamily: 'GothamBold',
                        fontSize: 18.sp, // Slightly smaller font
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      item['label']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Gotham',
                        fontSize: 9.sp, // Smaller font
                        color: Colors.black87,
                      ),
                      maxLines: 2, // Allow text to wrap
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFeedbackCard(FeedbackEvaluationModel feedback) {
    final breakdown = feedback.breakdown;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFFCC4A2E),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFCC4A2E),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.thumb_up,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'okr_evaluation_feedback'.tr,
                style: TextStyle(
                  fontFamily: 'GothamBold',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Overall Feedback
          Text(
            feedback.feedback,
            style: TextStyle(
              fontFamily: 'Gotham',
              fontSize: 14.sp,
              color: Colors.black54,
              height: 1.5,
            ),
          ),

          SizedBox(height: 20.h),

          // Strategy Alignment
          _buildFeedbackItem(
            title: 'strategy_alignment'.tr,
            rating: breakdown.strategyAlignment.title.tr,
            ratingColor: _getRatingColor(breakdown.strategyAlignment.title),
            description: breakdown.strategyAlignment.suggestion,
          ),

          SizedBox(height: 16.h),

          // Objective Alignment
          _buildFeedbackItem(
            title: 'objective_alignment'.tr,
            rating: breakdown.objectiveAlignment.title,
            ratingColor: _getRatingColor(breakdown.objectiveAlignment.title),
            description: breakdown.objectiveAlignment.suggestion,
          ),

          SizedBox(height: 16.h),

          // Key Result Quality
          _buildFeedbackItem(
            title: 'key_result_quality'.tr,
            rating: breakdown.keyResultQuality.title,
            ratingColor: _getRatingColor(breakdown.keyResultQuality.title),
            description: breakdown.keyResultQuality.suggestion,
          ),
        ],
      ),
    );
  }

  /// This function keeps logic in English (API values)
  /// and UI translations are handled separately (.tr)
  Color _getRatingColor(String rating) {
    final r = rating.toLowerCase().trim();

    if (r == 'perfect'.tr) {
      return const Color(0xFFCC4A2E); // Red
    }
    if (r == 'excellent'.tr) {
      return const Color(0xFF4CAF50); // Green
    }
    if (r == 'good'.tr) {
      return const Color(0xFF2196F3); // Blue
    }
    if (r == 'average'.tr) {
      return const Color(0xFFFF9800); // Orange
    }

    return const Color(0xFF9E9E9E); // Grey (default)
  }

  Widget _buildFeedbackItem({
    required String title,
    required String rating,
    required Color ratingColor,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.tr,
              style: TextStyle(
                fontFamily: 'GothamBold',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4.h), // Small spacing between title and rating
            Text(
              rating.tr,  // Translate to French if locale is FR
              style: TextStyle(
                fontFamily: 'GothamBold',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: ratingColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          description,
          style: TextStyle(
            fontFamily: 'Gotham',
            fontSize: 14.sp,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
      ],
    );
  }
  Widget _buildCertificationButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to certification test
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFCC4A2E),
          borderRadius: BorderRadius.circular(50.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCC4A2E).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'start_certification_test'.tr,
              style: TextStyle(
                fontFamily: 'GothamBold',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:game_app/presentation/routes/app_routes.dart';
// import 'package:get/get.dart';
// import 'package:game_app/generated/models/responses/key_results/key_results_response.dart' as key_result_models;
// import '../../generated/models/requests/campaign_mode/feedback_evaluation_model.dart';
// import '../../services/shared_preference.dart';
// import '../../view_model/bonus_score.dart';
// import '../../view_model/campaign_mode/feedback_evaluation_view_model.dart';
// import '../widgets/campaign_mode_widgets/campaign_progress_service.dart';
// import '../widgets/custom_button2.dart';
// import '../widgets/custom_home_navbar.dart';
// import '../widgets/game_complete_widgets/custom_score_card.dart';
// import '../widgets/screens_unique_parts/custom_background.dart';
// import '../widgets/screens_unique_parts/custom_header.dart';
//
// class FeedbackScreen extends StatelessWidget {
//   final List<key_result_models.KeyResult> selectedKeyResults;
//
//   const FeedbackScreen({super.key, required this.selectedKeyResults});
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Get.put(FeedbackEvaluationViewModel());
//     final bonusController = Get.put(BonusScoreController());
//
//     // Trigger evaluation when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       viewModel.evaluateSelectedKeyResults(selectedKeyResults);
//
//       // Check if we should submit bonus score
//       final shouldSubmitBonus = await bonusController.shouldSubmitBonusScore();
//       if (shouldSubmitBonus) {
//         print('🎯 Bonus mode detected - will submit bonus score after evaluation');
//       }
//     });
//
//     return Scaffold(
//       body: CustomBackground(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(vertical: 14.w),
//                 child: Column(
//                   children: [
//                     CustomHeader(
//                       title: 'okr'.tr,
//                       highlightedText: "feedback".tr,
//                       onBackTap: () => Get.back(),
//                     ),
//                     SizedBox(height: 20.h),
//                     Obx(() {
//                       if (viewModel.isLoadingData) {
//                         return Center(
//                           child: Padding(
//                             padding: EdgeInsets.only(top: 100.h),
//                             child: CircularProgressIndicator(),
//                           ),
//                         );
//                       }
//
//                       if (!viewModel.hasData) {
//                         return Center(
//                           child: Padding(
//                             padding: EdgeInsets.only(top: 100.h),
//                             child: Text('no_feedback_data_available'.tr),
//                           ),
//                         );
//                       }
//
//                       final feedback = viewModel.evaluationResult!;
//
//                       // ✅ BONUS MODE: Submit bonus score when evaluation is complete
//                       WidgetsBinding.instance.addPostFrameCallback((_) async {
//                         final shouldSubmit = await bonusController.shouldSubmitBonusScore();
//                         if (shouldSubmit && !bonusController.isLoading.value) {
//                           _submitBonusScore(bonusController, feedback);
//                         }
//                       });
//
//                       return Column(
//                         children: [
//                           // ✅ BONUS MODE INDICATOR
//                           Obx(() {
//                             if (bonusController.isLoading.value) {
//                               return Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                                 padding: EdgeInsets.all(12.w),
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//                                   ),
//                                   borderRadius: BorderRadius.circular(12.r),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       width: 16.w,
//                                       height: 16.h,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                       ),
//                                     ),
//                                     SizedBox(width: 8.w),
//                                     Text(
//                                       'submitting_bonus_score'.tr,
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14.sp,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }
//
//                             if (bonusController.hasSubmittedBonus.value) {
//                               return Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                                 padding: EdgeInsets.all(12.w),
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
//                                   ),
//                                   borderRadius: BorderRadius.circular(12.r),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(Icons.stars, color: Colors.white, size: 20.sp),
//                                     SizedBox(width: 8.w),
//                                     Text(
//                                       'bonus_score_submitted'.trParams({'score': feedback.overallScore.toString()}),
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14.sp,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }
//
//                             return FutureBuilder<bool>(
//                               future: bonusController.isBonusMode(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData && snapshot.data == true && !bonusController.hasSubmittedBonus.value) {
//                                   return Container(
//                                     margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                                     padding: EdgeInsets.all(12.w),
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//                                       ),
//                                       borderRadius: BorderRadius.circular(12.r),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Icon(Icons.stars, color: Colors.white, size: 20.sp),
//                                         SizedBox(width: 8.w),
//                                         Text(
//                                           'bonus_mode_active'.tr,
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 14.sp,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }
//                                 return SizedBox.shrink();
//                               },
//                             );
//                           }),
//
//                           CustomScoreCard(
//                             title: "",
//                             score: feedback.overallScore,
//                             showBackground: false,
//                           ),
//                           SizedBox(height: 4.h),
//                           Padding(
//                             padding: EdgeInsets.all(8.w),
//                             child: _buildScoreBreakdown(feedback),
//                           ),
//                           SizedBox(height: 4.h),
//                           Padding(
//                             padding: EdgeInsets.all(12.w),
//                             child: _buildFeedbackCard(feedback),
//                           ),
//                           SizedBox(height: 24.h),
//
//                           // ✅ UPDATED: Navigation based on game mode
//                           Padding(
//                             padding: EdgeInsets.all(16.w),
//                             child: CustomButton2(
//                               text: 'continue'.tr,
//                               onPressed: () => _navigateBasedOnGameMode(),
//                             ),
//                           ),
//                           SizedBox(height: 20.h),
//                         ],
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               right: MediaQuery.of(context).size.width * -0.07,
//               top: MediaQuery.of(context).size.height * 0.50,
//               child: const CustomHomeNavBar(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ✅ BONUS SCORE SUBMISSION
//   void _submitBonusScore(BonusScoreController bonusController, FeedbackEvaluationModel feedback) async {
//     try {
//       final breakdown = feedback.breakdown;
//
//       // Calculate points based on score
//       String points = "3/3";
//       if (feedback.overallScore >= 80) {
//         points = "3/3";
//       } else if (feedback.overallScore >= 60) {
//         points = "2/3";
//       } else {
//         points = "1/3";
//       }
//
//       // Determine title based on score
//       String title;
//       if (feedback.overallScore >= 90) {
//         title = "Perfect";
//       } else if (feedback.overallScore >= 80) {
//         title = "Excellent";
//       } else if (feedback.overallScore >= 70) {
//         title = "Good";
//       } else if (feedback.overallScore >= 60) {
//         title = "Average";
//       } else {
//         title = "Needs Improvement";
//       }
//
//       final success = await bonusController.submitBonusScore(
//         overallScore: feedback.overallScore,
//         normalizedScore: feedback.normalizedScore,
//         points: points,
//         title: title,
//         feedback: feedback.feedback,
//         strategyAlignmentTitle: breakdown.strategyAlignment.title,
//         strategyAlignmentScore: breakdown.strategyAlignment.score,
//         strategyAlignmentSuggestion: breakdown.strategyAlignment.suggestion,
//         objectiveAlignmentTitle: breakdown.objectiveAlignment.title,
//         objectiveAlignmentScore: breakdown.objectiveAlignment.score,
//         objectiveAlignmentSuggestion: breakdown.objectiveAlignment.suggestion,
//         keyResultQualityTitle: breakdown.keyResultQuality.title,
//         keyResultQualityScore: breakdown.keyResultQuality.score,
//         keyResultQualitySuggestion: breakdown.keyResultQuality.suggestion,
//       );
//
//       if (success) {
//         print('🎉 Bonus score submitted successfully!');
//       } else {
//         print('⚠️ Failed to submit bonus score: ${bonusController.errorMessage.value}');
//       }
//     } catch (e) {
//       print('❌ Error in bonus score submission: $e');
//     }
//   }
//
//   void _markLevelComplete() async {
//     try {
//       final savedMode = await SharedPrefs.getGameMode();
//       if (savedMode == 'campaign') {
//         final currentLevelStr = await SharedPrefs.getString('current_campaign_level') ?? '1';
//         final currentLevel = int.tryParse(currentLevelStr) ?? 1;
//
//         await CampaignProgressService.completeLevel(currentLevel);
//
//         print('✅ Campaign Level $currentLevel marked as completed!');
//
//         Get.snackbar(
//           "Level Completed!".tr,
//           "Organization ${currentLevel == 1 ? 'A' : currentLevel == 2 ? 'B' : 'C'} completed!".tr,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       print('❌ Error marking level complete: $e');
//     }
//   }
//
//   void _navigateBasedOnGameMode() async {
//     try {
//       final savedMode = await SharedPrefs.getGameMode();
//       final bonusController = Get.find<BonusScoreController>();
//
//       if (savedMode == 'campaign') {
//         _markLevelComplete();
//       }
//
//       // For bonus mode, we stay on feedback screen until user continues
//       if (savedMode == 'bonus') {
//         // Bonus mode ends here - show completion message
//         Get.snackbar(
//           "bonus_mode_completed".tr,
//           "bonus_mode_completion_message".tr,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Color(0xFFFFD700),
//           colorText: Colors.black,
//           duration: Duration(seconds: 3),
//         );
//
//         // Navigate to home after bonus completion
//         Future.delayed(Duration(seconds: 2), () {
//           Get.offAllNamed(AppRoutes.home);
//         });
//         return;
//       }
//
//       // Rest of navigation logic for other modes
//       switch (savedMode) {
//         case 'solo':
//         case 'challenge':
//           Get.toNamed(AppRoutes.suggestionInitiativeScreen);
//           break;
//         case 'campaign':
//           Get.offAllNamed(AppRoutes.campaignModeScreen);
//           break;
//         default:
//           Get.toNamed(AppRoutes.suggestionInitiativeScreen);
//           break;
//       }
//     } catch (e) {
//       print('❌ Error in navigation: $e');
//       Get.toNamed(AppRoutes.suggestionInitiativeScreen);
//     }
//   }
//
//   Widget _buildScoreBreakdown(FeedbackEvaluationModel feedback) {
//     final breakdown = feedback.breakdown;
//
//     // Use normalized score for display
//     final normalizedScore = feedback.normalizedScore;
//
//     final scores = [
//       {'score': '${breakdown.strategyAlignment.score}/40', 'label': 'strategy_alignment'.tr},
//       {'score': '${breakdown.objectiveAlignment.score}/40', 'label': 'objective_alignment'.tr},
//       {'score': '${breakdown.keyResultQuality.score}/40', 'label': 'key_result_quality'.tr},
//     ];
//
//     return Column(
//       children: [
//         // Overall normalized score
//         Text(
//           'score'.tr.replaceFirst('${0}', normalizedScore.toString()),
//           style: TextStyle(
//             fontFamily: 'GothamBold',
//             fontSize: 18.sp,
//             fontWeight: FontWeight.bold,
//             color: const Color(0xFF1E3A8A),
//           ),
//         ),
//         SizedBox(height: 12.h),
//
//         // FIXED: Breakdown scores - Use Wrap or Flexible to prevent overflow
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: scores.map((item) {
//             return Flexible( // FIX: Use Flexible to allow wrapping
//               child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 4.w), // Reduced margin
//                 padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 4.w), // Reduced padding
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF5F5F5),
//                   borderRadius: BorderRadius.circular(16.r),
//                   border: Border.all(
//                     color: const Color(0xFFE0E0E0),
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       item['score']!,
//                       style: TextStyle(
//                         fontFamily: 'GothamBold',
//                         fontSize: 18.sp, // Slightly smaller font
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF1E3A8A),
//                       ),
//                     ),
//                     SizedBox(height: 6.h),
//                     Text(
//                       item['label']!,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontFamily: 'Gotham',
//                         fontSize: 9.sp, // Smaller font
//                         color: Colors.black87,
//                       ),
//                       maxLines: 2, // Allow text to wrap
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFeedbackCard(FeedbackEvaluationModel feedback) {
//     final breakdown = feedback.breakdown;
//
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.r),
//         border: Border.all(
//           color: const Color(0xFFCC4A2E),
//           width: 2,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8.w),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFCC4A2E),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.thumb_up,
//                   color: Colors.white,
//                   size: 20.sp,
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               Text(
//                 'okr_evaluation_feedback'.tr,
//                 style: TextStyle(
//                   fontFamily: 'GothamBold',
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF1E3A8A),
//                 ),
//               ),
//             ],
//           ),
//
//           SizedBox(height: 20.h),
//
//           // Overall Feedback
//           Text(
//             feedback.feedback,
//             style: TextStyle(
//               fontFamily: 'Gotham',
//               fontSize: 14.sp,
//               color: Colors.black54,
//               height: 1.5,
//             ),
//           ),
//
//           SizedBox(height: 20.h),
//
//           // Strategy Alignment
//           _buildFeedbackItem(
//             title: 'strategy_alignment'.tr,
//             rating: breakdown.strategyAlignment.title.tr,
//             ratingColor: _getRatingColor(breakdown.strategyAlignment.title),
//             description: breakdown.strategyAlignment.suggestion,
//           ),
//
//           SizedBox(height: 16.h),
//
//           // Objective Alignment
//           _buildFeedbackItem(
//             title: 'objective_alignment'.tr,
//             rating: breakdown.objectiveAlignment.title,
//             ratingColor: _getRatingColor(breakdown.objectiveAlignment.title),
//             description: breakdown.objectiveAlignment.suggestion,
//           ),
//
//           SizedBox(height: 16.h),
//
//           // Key Result Quality
//           _buildFeedbackItem(
//             title: 'key_result_quality'.tr,
//             rating: breakdown.keyResultQuality.title,
//             ratingColor: _getRatingColor(breakdown.keyResultQuality.title),
//             description: breakdown.keyResultQuality.suggestion,
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// This function keeps logic in English (API values)
//   /// and UI translations are handled separately (.tr)
//   Color _getRatingColor(String rating) {
//     final r = rating.toLowerCase().trim();
//
//     if (r == 'perfect'.tr) {
//       return const Color(0xFFCC4A2E); // Red
//     }
//     if (r == 'excellent'.tr) {
//       return const Color(0xFF4CAF50); // Green
//     }
//     if (r == 'good'.tr) {
//       return const Color(0xFF2196F3); // Blue
//     }
//     if (r == 'average'.tr) {
//       return const Color(0xFFFF9800); // Orange
//     }
//
//     return const Color(0xFF9E9E9E); // Grey (default)
//   }
//
//   Widget _buildFeedbackItem({
//     required String title,
//     required String rating,
//     required Color ratingColor,
//     required String description,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title.tr,
//               style: TextStyle(
//                 fontFamily: 'GothamBold',
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             Text(
//               rating.tr,  // Translate to French if locale is FR
//               style: TextStyle(
//                 fontFamily: 'GothamBold',
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.bold,
//                 color: ratingColor,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 8.h),
//         Text(
//           description,
//           style: TextStyle(
//             fontFamily: 'Gotham',
//             fontSize: 14.sp,
//             color: Colors.black54,
//             height: 1.5,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCertificationButton() {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to certification test
//       },
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(vertical: 16.h),
//         decoration: BoxDecoration(
//           color: const Color(0xFFCC4A2E),
//           borderRadius: BorderRadius.circular(50.r),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFFCC4A2E).withOpacity(0.3),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.play_arrow,
//               color: Colors.white,
//               size: 24.sp,
//             ),
//             SizedBox(width: 8.w),
//             Text(
//               'start_certification_test'.tr,
//               style: TextStyle(
//                 fontFamily: 'GothamBold',
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
