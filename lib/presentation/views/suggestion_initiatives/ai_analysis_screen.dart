// lib/view_model/challange_view_models/adaptation_ai_analysis-viewmodel.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_dimensions.dart';
import '../../../data/network/network_api_services.dart';
import '../../../data/response/api_response.dart';
import '../../../generated/models/requests/adaptation_analysis_model.dart';
import '../../../generated/models/responses/evaluate_initiative/evaluate_initiative_model.dart';
import '../../../services/shared_preference.dart';
import '../../../view_model/challange_view_models/adaptation_ai_analysis-viewmodel.dart';
import '../../routes/app_routes.dart';
import '../../widgets/campaign_mode_widgets/campaign_progress_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
// lib/presentation/views/suggestion_initiatives/ai_analysis_screen.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_dimensions.dart';
import '../../../data/network/network_api_services.dart';
import '../../../data/response/api_response.dart';
import '../../../generated/models/responses/evaluate_initiative/evaluate_initiative_model.dart';
import '../../../services/shared_preference.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';


class AIAnalysisShowScreen extends StatefulWidget {
  const AIAnalysisShowScreen({super.key});

  @override
  State<AIAnalysisShowScreen> createState() => _AIAnalysisShowScreenState();
}

class _AIAnalysisShowScreenState extends State<AIAnalysisShowScreen> {
  late final AdaptationAIAnalysisViewModel _viewModel;

  String _safeTranslate(String? key, {String fallback = ''}) {
    if (key == null) return fallback;
    try {
      return key.tr;
    } catch (e) {
      return fallback;
    }
  }

  @override
  void initState() {
    super.initState();
    _viewModel = Get.put(AdaptationAIAnalysisViewModel());
    _handleAnalysisBasedOnSource();
  }

  void _handleAnalysisBasedOnSource() async {
    try {
      final dynamic arguments = Get.arguments;

      if (arguments is Map<String, dynamic>) {
        final source = arguments['source'] ?? '';
        final adaptationRequest = arguments['adaptationRequest'];

        print('📍 Analysis Source: $source');
        print('📦 Has Adaptation Request: ${adaptationRequest != null}');

        // Handle BOTH sources properly
        if (source == 'challenge_adjustment' && adaptationRequest != null) {
          print('🔄 Running adaptation analysis from challenge adjustment...');
          await _runAdaptationAnalysis(adaptationRequest);
        } else if (source == 'contextual_challenge') {
          print('🔄 Analysis from contextual challenge - skipping adaptation');
          // Don't run analysis again, data should already be available
        } else {
          print('ℹ️ No adaptation analysis needed for source: $source');
        }
      }
    } catch (e) {
      print('❌ Error in analysis handling: $e');
    }
  }
  // void _handleAnalysisBasedOnSource() async {
  //   try {
  //     final dynamic arguments = Get.arguments;
  //
  //     if (arguments is Map<String, dynamic>) {
  //       final source = arguments['source'] ?? '';
  //       final adaptationRequest = arguments['adaptationRequest'];
  //
  //       if (source == 'challenge_adjustment' && adaptationRequest != null) {
  //         print('🔄 Running adaptation analysis from challenge adjustment...');
  //         await _runAdaptationAnalysis(adaptationRequest);
  //       }
  //     }
  //   } catch (e) {
  //     print('❌ Error in analysis handling: $e');
  //   }
  // }

// Replace the _runAdaptationAnalysis method in AIAnalysisShowScreen

  Future<void> _runAdaptationAnalysis(dynamic adaptationRequest) async {
    try {
      if (adaptationRequest == null) {
        print('❌ Adaptation request is null');
        return;
      }

      // Check if it's already an AdaptationAnalysisRequest object
      if (adaptationRequest is AdaptationAnalysisRequest) {
        print('✅ Calling submitAdaptationAnalysis with extracted fields');
        await _viewModel.submitAdaptationAnalysis(
          strategy: adaptationRequest.strategy,
          objective: adaptationRequest.objective,
          keyResult: adaptationRequest.keyResult,
          challenge: adaptationRequest.challenge,
          proposal: adaptationRequest.proposal,
        );
      }
      // Check if it's a Map
      else if (adaptationRequest is Map<String, dynamic>) {
        print('✅ Calling submitAdaptationAnalysis from Map');
        await _viewModel.submitAdaptationAnalysis(
          strategy: adaptationRequest['strategy'] ?? '',
          objective: adaptationRequest['objective'] ?? '',
          keyResult: adaptationRequest['keyResult'] ?? '',
          challenge: adaptationRequest['challenge'] ?? '',
          proposal: adaptationRequest['proposal'] ?? '',
        );
      }
      else {
        print('❌ Unknown adaptationRequest type: ${adaptationRequest.runtimeType}');
      }

      print('✅ Adaptation analysis completed');
    } catch (e, stackTrace) {
      print('❌ Error running adaptation analysis: $e');
      print('Stack trace: $stackTrace');
    }
  }


  //// In AIAnalysisShowScreen class, replace _navigateBasedOnGameMode with:
  // void _navigateBasedOnGameMode() async {
  //   try {
  //     // Prevent multiple navigations
  //     if (_isNavigating) return;
  //     _isNavigating = true;
  //
  //     final savedMode = await SharedPrefs.getGameMode();
  //     print('🎮 Navigation - Game Mode: $savedMode');
  //
  //     final dynamic arguments = Get.arguments;
  //     String source = 'initiative_analysis';
  //     if (arguments is Map<String, dynamic>) {
  //       source = arguments['source'] ?? 'initiative_analysis';
  //     }
  //
  //     // Use offAllNamed to remove all previous routes and prevent stack overflow
  //     switch (savedMode) {
  //       case 'solo':
  //         print('➡️ Navigating to Game Complete Screen');
  //         Get.offAllNamed(AppRoutes.gameCompleteScreen);
  //         break;
  //       case 'challenge':
  //         print('➡️ Navigating to Game Result Screen');
  //         // Use a small delay to ensure previous screen is disposed
  //         await Future.delayed(const Duration(milliseconds: 100));
  //         Get.offAllNamed(AppRoutes.gameResultScreen);
  //         break;
  //       case 'campaign':
  //         print('➡️ Navigating based on source: $source');
  //         if (source == 'contextual_challenge') {
  //           print('➡️ Navigating to Campaign Mode Screen');
  //           Get.offAllNamed(AppRoutes.campaignModeScreen);
  //         } else {
  //           print('➡️ Default navigation to Game Complete Screen for campaign mode');
  //           Get.offAllNamed(AppRoutes.gameCompleteScreen);
  //         }
  //         break;
  //       default:
  //         print('➡️ Default navigation to Game Complete Screen');
  //         Get.offAllNamed(AppRoutes.gameCompleteScreen);
  //         break;
  //     }
  //   } catch (e) {
  //     print('❌ Error in navigation: $e');
  //     // Fallback navigation
  //     Get.offAllNamed(AppRoutes.gameCompleteScreen);
  //   } finally {
  //     _isNavigating = false;
  //   }
  // }
  //
  // bool _isNavigating = false; // Add this class variable
  void _navigateBasedOnGameMode() async {
    try {
      final savedMode = await SharedPrefs.getGameMode();
      print('🎮 Navigation - Game Mode: $savedMode');

      final dynamic arguments = Get.arguments;
      String source = 'initiative_analysis';
      if (arguments is Map<String, dynamic>) {
        source = arguments['source'] ?? 'initiative_analysis';
      }

      print('📋 Navigation Source: $source');

      // Use offAllNamed to clear navigation stack
      switch (savedMode) {
        case 'solo':
          print('➡️ Navigating to Game Complete Screen');
          Get.offAllNamed(AppRoutes.gameCompleteScreen);
          break;

        case 'challenge':
          print('➡️ Navigating to Game Result Screen for Challenge Mode');

          // Get challenge ID from SharedPreferences
          final challengeId = await SharedPrefs.getChallengeId();
          final userId = SharedPrefs.getUserId();

          if (challengeId == null || challengeId.isEmpty) {
            print('❌ Challenge ID not found, using fallback');

          }

          if (userId == null || userId.isEmpty) {
            print('❌ User ID not found');
            Get.snackbar(
              'Error',
              'User ID not found',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }

          print('✅ Challenge ID: $challengeId, User ID: $userId');

          // Navigate to game result screen with challenge context
          Get.offAllNamed(
            AppRoutes.gameResultScreen,
            arguments: {
              'challengeId': challengeId,
              'userId': userId,
              'source': 'challenge_mode',
            },
          );
          break;

        case 'campaign':
          print('➡️ Campaign Mode - Source: $source');
          if (source == 'contextual_challenge' || source == 'challenge_adjustment') {
            print('➡️ Navigating to Campaign Mode Screen from contextual challenge');

            // Mark levels as completed
            await CampaignProgressService.completeLevel(1);
            await CampaignProgressService.completeLevel(2);
            await CampaignProgressService.completeLevel(3);

            Get.offAllNamed(AppRoutes.gameCompleteScreen);
          } else {
            print('➡️ Default navigation to Campaign Mode Screen');
            Get.offAllNamed(AppRoutes.campaignModeScreen);
          }
          break;

        default:
          print('➡️ Default navigation to Game Complete Screen');
          await CampaignProgressService.completeLevel(3);
          Get.offAllNamed(AppRoutes.gameCompleteScreen);
          break;
      }
    } catch (e, stackTrace) {
      print('❌ Error in navigation: $e');
      print('Stack trace: $stackTrace');

      Get.snackbar(
        'Navigation Error',
        'Failed to navigate: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Fallback navigation
      Get.offAllNamed(AppRoutes.gameCompleteScreen);
    }
  }
// lib/presentation/views/suggestion_initiatives/ai_analysis_screen.dart
// Only the changed part
//   void _navigateBasedOnGameMode() async {
//     try {
//       final savedMode = await SharedPrefs.getGameMode();
//       print('🎮 Navigation - Game Mode: $savedMode');
//
//       switch (savedMode) {
//         case 'solo':
//           print('➡️ Navigating to Game Complete Screen');
//           Get.offAllNamed(AppRoutes.gameCompleteScreen);
//           break;
//         case 'challenge':
//           print('➡️ Navigating to Game Result Screen');
//           final challengeId = await SharedPrefs.getChallengeId();
//           Get.offAllNamed(AppRoutes.gameResultScreen, arguments: {
//             'challengeId': int.tryParse(challengeId ?? '0') ?? 0,
//           });
//           break;
//         default:
//           print('➡️ Default navigation to Game Complete Screen');
//           Get.offAllNamed(AppRoutes.gameCompleteScreen);
//           break;
//       }
//     } catch (e) {
//       print('❌ Error in navigation: $e');
//       Get.offAllNamed(AppRoutes.gameCompleteScreen);
//     }
//   }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: AppDimensions.d18.h),
                  child: Obx(() {
                    final dynamic arguments = Get.arguments;

                    EvaluateInitiativeModel? evaluationData;
                    String source = 'initiative_analysis';

                    if (arguments is EvaluateInitiativeModel) {
                      evaluationData = arguments;
                      source = 'initiative_analysis';
                    } else if (arguments is Map<String, dynamic>) {
                      if (_viewModel.evaluationData.value != null) {
                        final adaptationData = _viewModel.evaluationData.value!;
                        evaluationData = EvaluateInitiativeModel(
                          score: adaptationData.score,
                          decision: _getDecisionFromScore(adaptationData.score),
                          explanation: adaptationData.feedback,
                        );
                        source = 'challenge_adjustment';
                      } else if (arguments['analysisData'] != null) {
                        evaluationData = arguments['analysisData'];
                        source = arguments['source'] ?? 'challenge_adjustment';
                      }
                    }

                    final bool hasData = evaluationData != null || _viewModel.evaluationData.value != null;
                    final int score = evaluationData?.score ?? _viewModel.evaluationData.value?.score ?? 0;
                    final String decision = evaluationData?.decision ?? _getDecisionFromScore(score);
                    final String explanation = evaluationData?.explanation ??
                        _viewModel.evaluationData.value?.feedback ??
                        'No analysis available';
                    final bool isAccepted = decision.toLowerCase() == 'accepted';
                    final bool isHighScore = score >= 80;
                    final bool isMediumScore = score >= 50 && score < 80;
                    final int percentage = score;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.03),
                        CustomHeader(
                          title: _getHeaderTitle(source),
                          highlightedText: _getHeaderHighlight(source),
                          subtitle: '',
                          onBackTap: () => Get.back(),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        if (_viewModel.isSubmitting.value)
                          _buildLoadingCard()
                        else if (hasData)
                          _buildAnalysisContainer(
                            percentage: percentage,
                            decision: decision,
                            explanation: explanation,
                            isAccepted: isAccepted,
                            isHighScore: isHighScore,
                            isMediumScore: isMediumScore,
                            source: source,
                          )
                        else
                          _buildLoadingCard(),
                        SizedBox(height: screenHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildNavigationButton(source, hasData),
                        ),
                        SizedBox(height: screenHeight * 0.001),
                      ],
                    );
                  }),
                ),
              ),
              Positioned(
                right: screenWidth * -0.07,
                top: screenHeight * 0.50,
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
    if (score >= 50) return 'Review Required';
    return 'Rejected';
  }

  String _getHeaderTitle(String source) {
    switch (source) {
      case 'challenge_adjustment':
        return 'adaptation'.tr;
      case 'initiative_analysis':
      default:
        return 'suggestion'.tr;
    }
  }

  String _getHeaderHighlight(String source) {
    switch (source) {
      case 'challenge_adjustment':
        return 'analysis'.tr;
      case 'initiative_analysis':
      default:
        return 'of_initiatives'.tr;
    }
  }

  Widget _buildNavigationButton(String source, bool hasData) {
    if (_viewModel.isSubmitting.value) {
      return CustomButton(
        text: 'analyzing'.tr,
        onPressed: () {},
      );
    }

    switch (source) {
      case 'initiative_analysis':
        return CustomButton(
          text: 'check_contextual_challenge'.tr,
          onPressed: hasData
              ? () => Get.toNamed(
            AppRoutes.contextualChallenge,
            arguments: {
              'analysisData': Get.arguments,
              'source': 'initiative_analysis',
            },
          )
              : () {},
        );
      case 'challenge_adjustment':
        return CustomButton(
          text: 'proceed_to_results'.tr,
          onPressed: _navigateBasedOnGameMode,
        );
      default:
        return CustomButton(
          text: 'continue'.tr,
          onPressed: () => Get.back(),
        );
    }
  }

  Widget _buildAnalysisContainer({
    required int percentage,
    required String decision,
    required String explanation,
    required bool isAccepted,
    required bool isHighScore,
    required bool isMediumScore,
    required String source,
  }) {
    Color containerColor;
    Color percentageBarColor;
    Color iconColor;
    IconData statusIcon;

    if (isHighScore) {
      containerColor = const Color(0xff8DC046);
      percentageBarColor = const Color(0xFFA3B800);
      iconColor = const Color(0xFF2D5016);
      statusIcon = Icons.sentiment_very_satisfied;
    } else if (isMediumScore) {
      containerColor = Colors.orange;
      percentageBarColor = Colors.orange.shade700;
      iconColor = Colors.orange.shade900;
      statusIcon = Icons.sentiment_neutral;
    } else {
      containerColor = Colors.red.shade400;
      percentageBarColor = Colors.red.shade700;
      iconColor = Colors.red.shade900;
      statusIcon = Icons.sentiment_dissatisfied;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xff8DC046),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xff8DC046),
              ),
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Column(
                children: [
                  SvgPicture.asset(
                    "assets/images/robot.svg",
                    height: 100.h,
                    width: 100.w,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _getAnalysisTitle(source),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: const BoxDecoration(
                color: Color(0xffC8CD37),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    statusIcon,
                    color: Colors.black,
                    size: 32.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: const BoxDecoration(
                color: Color(0xffC8CD37),
              ),
              child: Text(
                _safeTranslate('relevance_threshold') + ': >80%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: containerColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isAccepted ? Icons.lightbulb : Icons.warning_amber_rounded,
                            color: containerColor,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            decision,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      explanation,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.sp,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAnalysisTitle(String source) {
    switch (source) {
      case 'challenge_adjustment':
        return 'Adaptation Analysis Results';
      case 'initiative_analysis':
      default:
        return 'Initiative Analysis Results';
    }
  }

  Widget _buildLoadingCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(40.w),
        decoration: BoxDecoration(
          color: const Color(0xFFBFD200),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/images/robot.svg",
              height: 100.h,
              width: 100.w,
            ),
            SizedBox(height: 20.h),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            SizedBox(height: 20.h),
            Text(
              _viewModel.isSubmitting.value
                  ? 'Running Adaptation Analysis...'
                  : _safeTranslate('loading_analysis', fallback: 'Analyzing initiatives...'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}