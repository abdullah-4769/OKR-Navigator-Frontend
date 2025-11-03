// lib/presentation/views/feedback/feedback_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/views/suggestion_Initiatives/suggestion_initiatives_creen.dart';
import 'package:get/get.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart' as key_result_models;
import '../../generated/models/requests/campaign_mode/feedback_evaluation_model.dart';
import '../../services/shared_preference.dart';
import '../../view_model/campaign_mode/feedback_evaluation_view_model.dart';
import '../widgets/campaign_mode_widgets/campaign_progress_service.dart';
import '../widgets/custom_button2.dart';
import '../widgets/custom_home_navbar.dart';
import '../widgets/game_complete_widgets/custom_score_card.dart';
import '../widgets/screens_unique_parts/custom_background.dart';
import '../widgets/screens_unique_parts/custom_header.dart';
import 'contextual_screen/contextual_c_adjsutment_screen.dart';

class FeedbackScreen extends StatelessWidget {
  final List<key_result_models.KeyResult> selectedKeyResults;

  const FeedbackScreen({super.key, required this.selectedKeyResults});
// lib/presentation/views/feedback/feedback_screen.dart
  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(FeedbackEvaluationViewModel());

    // Trigger evaluation when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.evaluateSelectedKeyResults(selectedKeyResults);
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

                      return Column(
                        children: [
                          CustomScoreCard(
                            title: feedback.title,
                            score: feedback.overallScore,
                            showBackground: false,
                          ),
                          SizedBox(height: 4.h),
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: _buildScoreBreakdown(feedback),
                          ),
                          SizedBox(height: 4.h),
                          Padding(
                            padding: EdgeInsets.all(16.w),
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
  // In your FeedbackScreen, add this when level is completed
  void _markLevelComplete() async {
    try {
      // Check if we're in campaign mode
      final savedMode = await SharedPrefs.getGameMode();
      if (savedMode == 'campaign') {
        // Get current level from storage or default to 1
        final currentLevelStr = await SharedPrefs.getString('current_campaign_level') ?? '1';
        final currentLevel = int.tryParse(currentLevelStr) ?? 1;

        // Mark level as completed
        await CampaignProgressService.completeLevel(currentLevel);

        print('✅ Campaign Level $currentLevel marked as completed!');

        // Show completion message
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
// In FeedbackScreen - update the _navigateBasedOnGameMode method
  void _navigateBasedOnGameMode() async {
    try {
      final savedMode = await SharedPrefs.getGameMode();

      if (savedMode == 'campaign') {
        _markLevelComplete();
      }

      //  Pass selectedKeyResults to ContextualCAdjustmentScreen
      switch (savedMode) {
        case 'solo':
        case 'challenge':
          Get.to(
                () => SuggestionInitiativesScreen(selectedKeyResults: selectedKeyResults),
            arguments: {
              'selectedKeyResults': selectedKeyResults,
              'challengeData': await _getChallengeData(),
              'existingInitiatives': await _getExistingInitiatives(),
            },
          );
          break;
        case 'campaign':

          Get.offAllNamed(AppRoutes.campaignModeScreen);
          break;
        default:
          Get.to(
                () => SuggestionInitiativesScreen(selectedKeyResults: selectedKeyResults),
            arguments: {
              'selectedKeyResults': selectedKeyResults,
              'challengeData': await _getChallengeData(),
              'existingInitiatives': await _getExistingInitiatives(),
            },
          );
          break;
      }
    } catch (e) {
      print('❌ Error in navigation: $e');
      Get.to(
            () => SuggestionInitiativesScreen(selectedKeyResults: selectedKeyResults),
        arguments: {
          'selectedKeyResults': selectedKeyResults,
          'challengeData': await _getChallengeData(),
          'existingInitiatives': await _getExistingInitiatives(),
        },
      );
    }
  }

// Helper methods to get additional data if needed
  Future<Map<String, dynamic>> _getChallengeData() async {
    try {
      // Get challenge data from SharedPreferences or wherever you store it
      return await SharedPrefs.getCurrentChallengeData() ?? {};
    } catch (e) {
      return {};
    }
  }

  Future<List<Map<String, String>>> _getExistingInitiatives() async {
    try {
      // Get existing initiatives from SharedPreferences or ViewModel
      final initiatives = SharedPrefs.getInitiatives();
      return [
        {
          'title': initiatives['firstTitle'] ?? '',
          'description': initiatives['firstDesc'] ?? '',
        },
        {
          'title': initiatives['secondTitle'] ?? '',
          'description': initiatives['secondDesc'] ?? '',
        },
      ];
    } catch (e) {
      return [];
    }
  }
  //
// // Call this method when user completes the feedback screen
// // Add this to your Continue button logic or when evaluation is successful
//   void _navigateBasedOnGameMode() async {
//     try {
//       final savedMode = await SharedPrefs.getGameMode();
//
//       if (savedMode == 'campaign') {
//         // Mark level as complete before navigating
//         _markLevelComplete();       }
//
//       // Rest of your navigation logic...
//       switch (savedMode) {
//         case 'solo':
//         case 'challenge':
//           Get.toNamed(AppRoutes.suggestionInitiativeScreen);
//           break;
//         case 'campaign':
//         // Go back to campaign screen to show updated progress
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

  Widget _buildScoreBreakdown(FeedbackEvaluationModel feedback) {
    final breakdown = feedback.breakdown;

    // Use normalized score for display
    final normalizedScore = feedback.normalizedScore;

    final scores = [
      {'score': '${breakdown.strategyAlignment.score}/40', 'label': 'strategy_alignment'.tr},
      {'score': '${breakdown.objectiveAlignment.score}/40', 'label': 'objective_alignment'.tr},
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

        // Breakdown scores
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: scores.map((item) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                padding: EdgeInsets.symmetric(vertical: 20.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      item['score']!,
                      style: TextStyle(
                        fontFamily: 'GothamBold',
                        fontSize: 20.sp, // Slightly smaller
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      item['label']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Gotham',
                        fontSize: 10.sp, // Smaller font
                        color: Colors.black87,
                      ),
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
            title: 'Strategy Alignment',
            rating: breakdown.strategyAlignment.title,
            ratingColor: _getRatingColor(breakdown.strategyAlignment.title),
            description: breakdown.strategyAlignment.suggestion,
          ),

          SizedBox(height: 16.h),

          // Objective Alignment
          _buildFeedbackItem(
            title: 'Objective Alignment',
            rating: breakdown.objectiveAlignment.title,
            ratingColor: _getRatingColor(breakdown.objectiveAlignment.title),
            description: breakdown.objectiveAlignment.suggestion,
          ),

          SizedBox(height: 16.h),

          // Key Result Quality
          _buildFeedbackItem(
            title: 'Key Result Quality',
            rating: breakdown.keyResultQuality.title,
            ratingColor: _getRatingColor(breakdown.keyResultQuality.title),
            description: breakdown.keyResultQuality.suggestion,
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(String rating) {
    switch (rating.toLowerCase()) {
      case 'perfect':
        return Color(0xFFCC4A2E);
      case 'excellent':
        return Color(0xFF4CAF50);
      case 'good':
        return Color(0xFF2196F3);
      case 'average':
        return Color(0xFFFF9800);
      default:
        return Color(0xFF9E9E9E);
    }
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'GothamBold',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              rating,
              style: TextStyle(
                fontFamily: 'GothamBold',
                fontSize: 16.sp,
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
              'Start Certification Test',
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


