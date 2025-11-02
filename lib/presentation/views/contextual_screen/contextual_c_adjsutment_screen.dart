import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../services/shared_preference.dart';
import '../../../view_model/challange_view_models/adaptation_ai_analysis-viewmodel.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/custom_ai_strategy_container.dart';
import '../../../generated/models/responses/key_results/key_results_response.dart' hide Text;

class ContextualCAdjustmentScreen extends StatefulWidget {
  const ContextualCAdjustmentScreen({super.key});

  @override
  State<ContextualCAdjustmentScreen> createState() => _ContextualCAdjustmentScreenState();
}

class _ContextualCAdjustmentScreenState extends State<ContextualCAdjustmentScreen> {
  final int _maxRetries = 3;
  int _currentRetry = 0;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _loadRetryCount();
  }

  /// Load current retry count from SharedPreferences
  void _loadRetryCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentRetry = prefs.getInt('adaptation_retry_count') ?? 0;
      print('🔄 Current adaptation retry count: $_currentRetry/$_maxRetries');
    } catch (e) {
      print('❌ Error loading adaptation retry count: $e');
      _currentRetry = 0;
    }
  }

  /// Save retry count to SharedPreferences
  void _saveRetryCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('adaptation_retry_count', _currentRetry);
      print('💾 Saved adaptation retry count: $_currentRetry');
    } catch (e) {
      print('❌ Error saving adaptation retry count: $e');
    }
  }

  /// Reset retry count
  void _resetRetryCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('adaptation_retry_count', 0);
      _currentRetry = 0;
      print('🔄 Adaptation retry count reset to 0');
    } catch (e) {
      print('❌ Error resetting adaptation retry count: $e');
    }
  }

  /// Check if decision is accepted
  bool _isDecisionAccepted(String decision) {
    final lowerDecision = decision.toLowerCase();
    return lowerDecision.contains('accepted') ||
        lowerDecision.contains('approved') ||
        (lowerDecision.contains('review') && !lowerDecision.contains('rejected'));
  }

  /// Handle navigation based on decision and mode
  Future<void> _navigateBasedOnDecisionAndMode({
    required String decision,
    required bool hasData,
    required int score,
  }) async {
    if (_isNavigating) return;
    _isNavigating = true;

    try {
      final savedMode = await SharedPrefs.getGameMode() ?? 'solo';
      final isDecisionAccepted = _isDecisionAccepted(decision);

      print('🎯 Adaptation Navigation Decision:');
      print('   - Decision: $decision (Accepted: $isDecisionAccepted)');
      print('   - Score: $score');
      print('   - Game Mode: $savedMode');
      print('   - Retry Count: $_currentRetry/$_maxRetries');

      // 🚫 HANDLE REJECTED DECISION
      if (!isDecisionAccepted || score < 70) { // Using 70 as threshold for adaptation
        _currentRetry++;
        _saveRetryCount();

        if (_currentRetry >= _maxRetries) {
          print('❌ Max adaptation retries reached ($_maxRetries). Navigating to home screen.');
          await _showMaxRetriesDialog();
          _resetRetryCount();
          _navigateToHomeScreen();
        } else {
          print('🔄 Adaptation rejected. Retry $_currentRetry/$_maxRetries');
          await _showRetryDialog();
        }
        return;
      }

      // ✅ HANDLE ACCEPTED DECISION - Reset retry count and proceed
      _resetRetryCount();
      await _proceedWithAcceptedDecision(savedMode);
    } catch (e) {
      print('❌ Error in adaptation navigation: $e');
      Get.snackbar(
        'Navigation Error',
        'Failed to navigate: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isNavigating = false;
    }
  }

  /// Show retry dialog for rejected adaptations
  Future<void> _showRetryDialog() async {
    await Get.dialog(
      AlertDialog(
        title: Text('adaptation_needs_improvement'.tr),
        content: Text(
          '${'your_adaptation_strategy_needs_refinement'.tr}\n\n'
              '${'retry_count'.tr}: $_currentRetry/$_maxRetries\n'
              '${'suggest_review_strategy'.tr}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _navigateBackForRetry();
            },
            child: Text('try_again'.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Show max retries reached dialog
  Future<void> _showMaxRetriesDialog() async {
    await Get.dialog(
      AlertDialog(
        title: Text('max_retries_reached'.tr),
        content: Text(
          '${'max_adaptation_attempts_exceeded'.tr}\n\n'
              '${'returning_to_home_screen'.tr}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('understand'.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Navigate back for retry
  void _navigateBackForRetry() {
    print('🔄 Navigating back for adaptation retry');
    Get.back();
  }

  /// Navigate to home screen when max retries reached
  void _navigateToHomeScreen() {
    print('🏠 Max adaptation retries reached - Navigating to home screen');
    Get.offAllNamed(AppRoutes.home);
  }

  /// Proceed with accepted decision - Different paths for each mode
  Future<void> _proceedWithAcceptedDecision(String savedMode) async {
    print('✅ Adaptation accepted! Proceeding with navigation...');

    switch (savedMode) {
      case 'solo':
        print('➡️ Solo Mode: Navigating to Game Complete Screen');
        Get.offAllNamed(AppRoutes.gameCompleteScreen);
        break;

      case 'challenge':
        print('➡️ Challenge Mode: Navigating to Game Result Screen');
        await _navigateChallengeMode();
        break;

      case 'campaign':
        print('➡️ Campaign Mode: Navigating to Campaign Flow');
        await _navigateCampaignMode();
        break;

      default:
        print('➡️ Default Mode: Navigating to Game Complete Screen');
        Get.offAllNamed(AppRoutes.gameCompleteScreen);
        break;
    }
  }

  /// Challenge Mode Navigation
  Future<void> _navigateChallengeMode() async {
    final challengeId = await SharedPrefs.getChallengeId();
    final userId = SharedPrefs.getUserId();

    if (challengeId == null || challengeId.isEmpty || userId == null || userId.isEmpty) {
      print('❌ Challenge ID or User ID not found');
      Get.snackbar(
        'Error',
        'Challenge data not found',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    print('✅ Challenge ID: $challengeId, User ID: $userId');
    Get.offAllNamed(
      AppRoutes.gameResultScreen,
      arguments: {
        'challengeId': challengeId,
        'userId': userId,
        'source': 'challenge_mode',
      },
    );
  }

  /// Campaign Mode Navigation
  Future<void> _navigateCampaignMode() async {
    print('➡️ Campaign Mode: Completing levels and navigating to Game Complete');

    // Mark levels as completed for campaign
    // await CampaignProgressService.completeLevel(1);
    // await CampaignProgressService.completeLevel(2);
    // await CampaignProgressService.completeLevel(3);

    Get.offAllNamed(AppRoutes.gameCompleteScreen);
  }

  /// Test navigation based on mode
  Future<void> _testNavigationBasedOnMode() async {
    try {
      final savedMode = await SharedPrefs.getGameMode() ?? 'solo';

      print('🧪 TEST: Navigation for mode: $savedMode');

      switch (savedMode) {
        case 'solo':
          Get.toNamed(AppRoutes.gameCompleteScreen);
          break;
        case 'challenge':
          Get.toNamed(AppRoutes.gameResultScreen);
          break;
        case 'campaign':
          Get.toNamed(AppRoutes.gameCompleteScreen);
          break;
        default:
          Get.toNamed(AppRoutes.gameCompleteScreen);
          break;
      }
    } catch (e) {
      print('❌ Test navigation error: $e');
      Get.snackbar(
        'Test Error',
        'Failed test navigation: $e',
        backgroundColor: Colors.orange,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Initialize the view model
    final adaptationViewModel = Get.put(AdaptationAIAnalysisViewModel());

    // ✅ Get data from arguments
    final List<KeyResult> selectedKeyResults = Get.arguments?['selectedKeyResults'] ?? [];
    final KeyResult? randomKeyResult = _getRandomKeyResult(selectedKeyResults);
    final challengeData = Get.arguments?['challengeData'] ?? {};
    final existingInitiatives = Get.arguments?['existingInitiatives'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: OrientationBuilder(
          builder: (context, orientation) => Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: height * 0.015),
                  child: Column(
                    children: [
                      CustomHeader(
                        title: 'contextual'.tr,
                        highlightedText: 'adjustment'.tr,
                        subtitle: '',
                        onBackTap: () => Get.back(),
                      ),

                      SizedBox(height: height * 0.0025),

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "refine_strategy_address_challenge".tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.025),

                      // ✅ Display the random key result
                      if (randomKeyResult != null) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColors.grey.withOpacity(0.4)),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.flag, color: AppColors.primaryRed, size: 20.w),
                                    SizedBox(width: 8.w),
                                    Text(
                                      "key_result_for_evaluation".tr,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryRed,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  randomKeyResult.title?.tr ?? 'No title available',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                if (randomKeyResult.description != null) ...[
                                  SizedBox(height: 8.h),
                                  Text(
                                    randomKeyResult.description!.tr,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                      ],

                      // ✅ ADDITIONAL STRATEGIC ACTIONS INPUT (PROPOSAL)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppDimensions.d16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.grey.withOpacity(0.4),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "additional_strategic_actions".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextField(
                                controller: adaptationViewModel.strategicActionsController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'describe_strategic_actions'.tr,
                                  hintStyle: TextStyle(
                                    fontSize: width * 0.035,
                                    fontFamily: 'Gotham',
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.grey,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.02,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(AppDimensions.d10.r),
                                    borderSide: BorderSide(
                                      color: AppColors.grey.withValues(alpha: 0.3),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "new_initiatives_question".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.02),
                      const CustomAIStrategyContainer(),
                      SizedBox(height: height * 0.02),

                      // ✅ Submit Button with Proper API Call
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: width * 0.05.w,
                            horizontal: height * 0.05.h,
                          ),
                          child: Obx(() => CustomButton(
                            text: adaptationViewModel.isSubmitting.value
                                ? 'submitting'.tr
                                : 'submit_adaptations'.tr,
                            onPressed: adaptationViewModel.isSubmitting.value
                                ? () {}
                                : () async {
                              // ✅ PREPARE DATA FOR API CALL
                              final strategy = challengeData['strategy'] ?? await _getDefaultStrategy();
                              final objective = challengeData['objective'] ?? await _getDefaultObjective();
                              final keyResult = randomKeyResult?.title ?? 'Adapted Key Result';
                              final challenge = challengeData['challenge'] ?? 'Market Challenge';
                              final proposal = adaptationViewModel.strategicActionsController.text.isNotEmpty
                                  ? adaptationViewModel.strategicActionsController.text
                                  : 'Strategic adaptations to address market changes';

                              print('🚀 Submitting adaptation analysis with data:');
                              print('   Strategy: $strategy');
                              print('   Objective: $objective');
                              print('   Key Result: $keyResult');
                              print('   Challenge: $challenge');
                              print('   Proposal: $proposal');

                              // ✅ CALL THE API
                              await adaptationViewModel.submitAdaptationAnalysis(
                                strategy: strategy,
                                objective: objective,
                                keyResult: keyResult,
                                challenge: challenge,
                                proposal: proposal,
                              );

                              // ✅ NAVIGATE BASED ON RESULT
                              if (adaptationViewModel.hasData) {
                                final evaluationData = adaptationViewModel.evaluationData.value!;
                                final score = evaluationData.score;
                                final feedback = evaluationData.feedback;

                                print('🎉 Adaptation analysis completed:');
                                print('   - Score: $score');
                                print('   - Feedback: $feedback');

                                await _navigateBasedOnDecisionAndMode(
                                  decision: _getDecisionFromScore(score),
                                  hasData: true,
                                  score: score,
                                );
                              } else {
                                print('❌ No adaptation data available for navigation');
                                Get.snackbar(
                                  'Error'.tr,
                                  'No evaluation data received'.tr,
                                  backgroundColor: AppColors.primaryRed,
                                  colorText: Colors.white,
                                );
                              }
                            },
                          )),
                        ),
                      ),

                      // ✅ TEST BUTTON - For debugging navigation
                      SizedBox(height: height * 0.02),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: height * 0.05.h),
                          child: CustomButton(
                            text: "Test Navigation by Mode",
                            backgroundColor: AppColors.primaryGreen,
                            onPressed: _testNavigationBasedOnMode,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),

                      // ✅ Retry counter display
                      Obx(() {
                        final hasData = adaptationViewModel.evaluationData.value != null;
                        final score = adaptationViewModel.evaluationData.value?.score ?? 0;
                        final isAccepted = _isDecisionAccepted(_getDecisionFromScore(score));

                        if (!isAccepted && hasData) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.warning, color: Colors.orange, size: 16.sp),
                                  SizedBox(width: 8.w),
                                  Text(
                                    '${'attempt'.tr}: $_currentRetry/$_maxRetries',
                                    style: TextStyle(
                                      color: Colors.orange[800],
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: width * -0.07,
                top: height * 0.5,
                child: const CustomHomeNavBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDecisionFromScore(int score) {
    if (score >= 80) return 'Accepted';
    if (score >= 70) return 'Review Required';
    return 'Rejected';
  }

  KeyResult? _getRandomKeyResult(List<KeyResult> selectedKeyResults) {
    if (selectedKeyResults.isEmpty) return null;
    final shuffled = List<KeyResult>.from(selectedKeyResults)..shuffle();
    final randomKeyResult = shuffled.first;
    print('🎲 Random key result for adaptation: ${randomKeyResult.title}');
    return randomKeyResult;
  }

  Future<String> _getDefaultStrategy() async {
    try {
      final strategyData = await SharedPrefs.getSelectedStrategy();
      return strategyData?['title']?.toString() ?? 'CEO Strategy';
    } catch (e) {
      return 'CEO Strategy';
    }
  }

  Future<String> _getDefaultObjective() async {
    try {
      final objectiveData = await SharedPrefs.getSelectedObjective();
      return objectiveData?['title']?.toString() ?? 'Business Growth Objective';
    } catch (e) {
      return 'Business Growth Objective';
    }
  }
}








// // Update your ContextualCAdjustmentScreen
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
// import '../../../services/shared_preference.dart';
//
// import '../../../view_model/challange_view_models/adaptation_ai_analysis-viewmodel.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
// import '../../widgets/custom_ai_strategy_container.dart';
//
// class ContextualCAdjustmentScreen extends StatelessWidget {
//   const ContextualCAdjustmentScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
//
//     // Initialize the view model
//     final adaptationViewModel = Get.put(AdaptationAIAnalysisViewModel());
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomBackground(
//         child: OrientationBuilder(
//           builder: (context, orientation) => Stack(
//             children: [
//               Positioned.fill(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: EdgeInsets.only(bottom: height * 0.015),
//                   child: Column(
//                     children: [
//                       CustomHeader(
//                         title: 'contextual'.tr,
//                         highlightedText: 'adjustment'.tr,
//                         subtitle: '',
//                         onBackTap: () => Get.toNamed(AppRoutes.aiAnalysisShowScreen),
//                       ),
//
//                       SizedBox(height: height * 0.0025),
//
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             "refine_strategy_address_challenge".tr,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyLarge
//                                 ?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.black,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: height * 0.025),
//
//                       // Your existing adjustment container...
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: width * 0.05),
//                         child: Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.all(AppDimensions.d16.w),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12.r),
//                             border: Border.all(
//                               color: AppColors.grey.withOpacity(0.4),
//                             ),
//                             color: Colors.white,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "revised_key_result".tr,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyLarge
//                                     ?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.primaryRed,
//                                 ),
//                               ),
//                               SizedBox(height: 4.h),
//                               Text(
//                                 "adjust_revenue_target_question".tr,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium
//                                     ?.copyWith(
//                                   color: AppColors.textSecondary,
//                                 ),
//                               ),
//                               SizedBox(height: 8.h),
//                               Text(
//                                 "additional_strategic_actions".tr,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyLarge
//                                     ?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.primaryRed,
//                                 ),
//                               ),
//                               SizedBox(height: 4.h),
//                               Text(
//                                 "new_initiatives_question".tr,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium
//                                     ?.copyWith(
//                                   color: AppColors.textSecondary,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(height: height * 0.004),
//                       const CustomAIStrategyContainer(),
//                       SizedBox(height: height * 0.004),
//
//                       // Updated Submit Button with Real API Call
//                       Center(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: width * 0.05.w,
//                             horizontal: height * 0.05.h,
//                           ),
//                           child: Obx(() => CustomButton(
//                             text: adaptationViewModel.isSubmitting.value
//                                 ? 'submitting'.tr
//                                 : 'submit_adaptations'.tr,
//                             onPressed: adaptationViewModel.isSubmitting.value
//                                 ? () {}
//                                 : () async {
//                               // Save sample adaptation data (replace with real user input)
//                               await SharedPrefs.saveAdaptationData(
//                                 revisedKeyResult: "Adjust Q4 revenue target from \$2M to \$1.8M due to market volatility",
//                                 strategicActions: "Implement cost optimization measures and explore new market segments",
//                                 adaptationNotes: "Market analysis indicates 10% lower growth projections for Q4",
//                               );
//
//                               // Submit to API
//                               await adaptationViewModel.submitAdaptationAnalysis();
//
//                               // Navigate to results screen
//                               if (adaptationViewModel.hasData) {
//                                 Get.toNamed(
//                                   AppRoutes.aiAnalysisShowScreen,
//                                   arguments: {
//                                     'source': 'challenge_adjustment',
//                                     'analysisData': adaptationViewModel.evaluationData.value,
//                                   },
//                                 );
//                               }
//                             },
//                           )),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 right: width * -0.07,
//                 top: height * 0.5,
//                 child: const CustomHomeNavBar(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
// //both main problem last time we are facing is here ..
//
//
// //import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:get/get.dart';
// //
// // import '../../../core/app_colors.dart';
// // import '../../../core/app_dimensions.dart';
// // import '../../routes/app_routes.dart';
// // import '../../widgets/custom_button.dart';
// // import '../../widgets/custom_home_navbar.dart';
// // import '../../widgets/custom_journey_map.dart';
// // import '../../widgets/screens_unique_parts/custom_background.dart';
// // import '../../widgets/screens_unique_parts/custom_header.dart';
// // import '../../widgets/custom_ai_strategy_container.dart';
// // import '../../../controllers/journey_controller.dart';
// //
// // class ContextualCAdjustmentScreen extends StatelessWidget {
// //   const ContextualCAdjustmentScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //
// //     final size = MediaQuery.of(context).size;
// //     final width = size.width;
// //     final height = size.height;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: CustomBackground(
// //         child: OrientationBuilder(
// //           builder: (context, orientation) => Stack(
// //               children: [
// //                 /// Scrollable Content
// //                 Positioned.fill(
// //                   child: SingleChildScrollView(
// //                     physics: const BouncingScrollPhysics(),
// //                     padding: EdgeInsets.only(bottom: height * 0.015),
// //                     child: Column(
// //                       children: [
// //
// //
// //                         /// Header
// //                         CustomHeader(
// //                           title: 'contextual'.tr,
// //                           highlightedText: 'adjustment'.tr,
// //                           subtitle: ''.tr,
// //                           onBackTap: () =>
// //                               Get.toNamed(AppRoutes.aiAnalysisShowScreen),
// //                         ),
// //
// //                         SizedBox(height: height * 0.0025),
// //
// //                         Center(
// //                           child: Padding(
// //                             padding: const EdgeInsets.all(8.0),
// //                             child: Text(
// //                               "refine_strategy_address_challenge".tr,
// //                               style: Theme.of(context)
// //                                   .textTheme
// //                                   .bodyLarge
// //                                   ?.copyWith(
// //                                 fontWeight: FontWeight.bold,
// //                                 color: AppColors.black,
// //                               ),
// //                               textAlign: TextAlign.center,
// //                             ),
// //                           ),
// //                         ),
// //                         SizedBox(height: height * 0.025),
// //                         /// Single Main Adjustment Container
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(horizontal: width * 0.05),
// //                           child: Container(
// //                             width: double.infinity,
// //                             padding: EdgeInsets.all(AppDimensions.d16.w),
// //                             decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(12.r),
// //                               border: Border.all(
// //                                 color: AppColors.grey.withOpacity(0.4),
// //                               ),
// //                               color: Colors.white,
// //                             ),
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 /// Revised Key Result
// //                                 Text(
// //                                   "revised_key_result".tr,
// //                                   style: Theme.of(context)
// //                                       .textTheme
// //                                       .bodyLarge
// //                                       ?.copyWith(
// //                                     fontWeight: FontWeight.bold,
// //                                     color: AppColors.primaryRed,
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: 4.h),
// //                                 Text(
// //                                   "adjust_revenue_target_question".tr,
// //                                   style: Theme.of(context)
// //                                       .textTheme
// //                                       .bodyMedium
// //                                       ?.copyWith(
// //                                     color: AppColors.textSecondary,
// //                                   ),
// //                                 ),
// //
// //                                 SizedBox(height: 8.h),
// //
// //                                 /// Additional Strategic Actions
// //                                 Text(
// //                                   "additional_strategic_actions".tr,
// //                                   style: Theme.of(context)
// //                                       .textTheme
// //                                       .bodyLarge
// //                                       ?.copyWith(
// //                                     fontWeight: FontWeight.bold,
// //                                     color: AppColors.primaryRed,
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: 4.h),
// //                                 Text(
// //                                   "new_initiatives_question".tr,
// //                                   style: Theme.of(context)
// //                                       .textTheme
// //                                       .bodyMedium
// //                                       ?.copyWith(
// //                                     color: AppColors.textSecondary,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //
// //                         SizedBox(height: height * 0.004),
// //
// //
// //
// //                         /// AI Strategy Analysis Box
// //                         const CustomAIStrategyContainer(),
// //
// //                         SizedBox(height: height * 0.004),
// //
// //                         /// Propose Adjustment Button
// //                         Center(
// //                           child: Padding(
// //                             padding: EdgeInsets.symmetric(
// //                               vertical: width * 0.05.w,
// //                               horizontal: height * 0.05.h,
// //                             ),
// //                             child: CustomButton(
// //                               text: 'submit_adaptations'.tr,
// //                               onPressed: () {
// //                                 Get.toNamed(AppRoutes.gameCompleteScreen);
// //                               },
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //
// //                 /// Home Navbar
// //                 Positioned(
// //                   right: width * -0.07,
// //                   top: height * 0.5,
// //                   child: const CustomHomeNavBar(),
// //                 ),
// //               ],
// //             ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
//
