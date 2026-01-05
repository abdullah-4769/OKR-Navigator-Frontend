import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/controllers/journey_controller.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/widgets/custom_journey_map.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../generated/models/responses/game_complete_model/game_complete_model.dart';
import '../../../services/shared_preference.dart';
import '../../../view_model/game_complete/game_complete_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/game_complete_widgets/achievement_summary.dart';
import '../../widgets/game_complete_widgets/custom_score_card.dart';
import '../../widgets/game_complete_widgets/performance_breakdown.dart';
import '../../widgets/game_complete_widgets/rewards_unlocked.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class GameCompleteScreen extends StatelessWidget {
  const GameCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final JourneyController journeyController = Get.find<JourneyController>();

    // Use Get.put to create or reuse existing instance
    final GameCompleteViewModel viewModel = Get.put(GameCompleteViewModel());

    // Get user ID and mode from SharedPreferences
    final String? userId = SharedPrefs.getUserId();
    final String? savedMode = SharedPrefs.getGameMode();

    print('🎮 [Screen] GameCompleteScreen loaded');
    print('   - User ID: $userId');
    print('   - Game Mode: $savedMode');

    // Auto-fetch data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userId != null && userId.isNotEmpty) {
        print('🚀 Auto-fetching game data for user: $userId');
        viewModel.fetchLatestGameScore(userId);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: OrientationBuilder(
          builder: (context, orientation) => Stack(
            children: [
              /// Scrollable content
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: height * 0.015),
                  child: Column(
                    children: [
                      /// Header
                      CustomHeader(
                        title: 'game'.tr,
                        highlightedText: 'complete'.tr,
                        subtitle: '',
                        onBackTap: () => Get.back(),
                      ),

                      SizedBox(height: height * 0.0025),

                      /// User ID Check
                      if (userId == null || userId.isEmpty)
                        _buildNoUserIdCard(),

                      /// Main Content
                      Obx(() {
                        // Show loading/error/content only if user ID is available
                        if (userId == null || userId.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        if (viewModel.isLoading.value) {
                          return _buildLoadingCard();
                        }

                        if (viewModel.errorMessage.value.isNotEmpty) {
                          return _buildErrorCard(
                            viewModel.errorMessage.value,
                            viewModel.apiDebugInfo.value,
                                () => viewModel.fetchLatestGameScore(userId!),
                                () => viewModel.loadMockDataForTesting(),
                          );
                        }

                        final gameData = viewModel.gameCompleteData.value;
                        if (gameData == null) {
                          return _buildNoDataCard(
                                () => viewModel.fetchLatestGameScore(userId!),
                          );
                        }

                        return _buildGameCompleteContent(
                          gameData,
                          viewModel,
                          journeyController,
                          height,
                          context,
                          savedMode,
                        );
                      }),

                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),

              /// Home Navbar
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

  // ──────────────────────────────────────────────
  // Helper Widgets
  // ──────────────────────────────────────────────

  Widget _buildNoUserIdCard() {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.orange),
        ),
        child: Column(
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              'User ID not found. Please login again.',
              style: TextStyle(
                color: Colors.orange[800],
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            CustomButton(
              text: "go_to_login".tr,
              onPressed: () => Get.offAllNamed(AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Padding(
      padding: EdgeInsets.all(20.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primaryRed),
            SizedBox(height: 16.h),
            Text(
              'Loading your game results...',
              style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(
      String errorMessage,
      String debugInfo,
      VoidCallback onRetry,
      VoidCallback onLoadMockData,
      ) {
    return Padding(
      padding: EdgeInsets.all(20.h),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
          SizedBox(height: 16.h),
          Text(
            'Failed to load game data',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            errorMessage,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (debugInfo.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                debugInfo,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'monospace',
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
          SizedBox(height: 16.h),
          CustomButton(text: "retry".tr, onPressed: onRetry),
          SizedBox(height: 8.h),
          TextButton(
            onPressed: onLoadMockData,
            child: Text(
              'Load Test Data (For UI Testing)',
              style: TextStyle(fontSize: 12.sp, color: AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataCard(VoidCallback onLoadData) {
    return Padding(
      padding: EdgeInsets.all(20.h),
      child: Column(
        children: [
          Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 48.sp),
          SizedBox(height: 16.h),
          Text(
            'No game data available',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          CustomButton(text: "load_game_data".tr, onPressed: onLoadData),
        ],
      ),
    );
  }

  Widget _buildGameCompleteContent(
      GameCompleteModel gameData,
      GameCompleteViewModel viewModel,
      JourneyController journeyController,
      double height,
      BuildContext context,
      String? savedMode,
      ) {
    return Column(
      children: [
        /// Score Card
        CustomScoreCard(
          score: gameData.score ?? 0,
          title: viewModel.getScoreTitle(),
          description: gameData.scor ?? "Complete your first game to see results!",
        ),

        SizedBox(height: height * 0.025),

        /// Performance Breakdown
        PerformanceBreakdown(
          points: _calculatePoints(gameData.totalPoints),
          totalPoints: 10,
          items: viewModel.getBreakdownItems(),
        ),

        SizedBox(height: height * 0.025),

        /// Rewards Unlocked
        RewardsUnlocked(
          badgeImage: "assets/images/badge.png",
          badgeName: gameData.badge ?? "New Player",
          titleImage: "assets/images/game.png",
          titleName: viewModel.getScoreTitle(),
          trophyImage: "assets/images/trophy.png",
          trophyName: gameData.trophy?.isNotEmpty == true ? gameData.trophy! : "First Steps",
        ),

        SizedBox(height: height * 0.025),

        /// Journey Map – FIXED Obx usage
        Obx(() => CustomJourneyMap(
          progress: journeyController.progress.value,
          steps: journeyController.steps,              // ← .value added
          completedSteps: journeyController.completedSteps.value, // ← .value added
          onToggle: journeyController.toggleJourneyDetails,
          showDetails: journeyController.showDetails.value,
        )),

        SizedBox(height: height * 0.025),

        /// Achievement Summary
        AchievementSummary(
          achievements: _getAchievements(gameData),
        ),

        SizedBox(height: height * 0.04),

        /// Action Buttons
        _buildActionButtons(gameData, context, savedMode),
      ],
    );
  }

  Widget _buildActionButtons(GameCompleteModel gameData, BuildContext context, String? savedMode) {
    return Column(
      children: [
        if (savedMode == 'campaign') ...[
          CustomButton(
            text: "start_certificate_mode".tr,
            icon: Icons.verified_outlined,
            backgroundColor: AppColors.primaryGreen,
            onPressed: () => Get.offAllNamed(AppRoutes.campaignModeScreen),
          ),
          SizedBox(height: 12.h),
        ],

        CustomButton(
          text: "play_again".tr,
          icon: Icons.play_arrow,
          onPressed: () {
            if (savedMode == 'campaign') {
              Get.offAllNamed(AppRoutes.teamStrategySelection);
            } else {
              Get.offAllNamed(AppRoutes.roleSelection);
            }
          },
        ),

        SizedBox(height: 12.h),

        CustomButton(
          text: "view_badges".tr,
          icon: Icons.badge_outlined,
          onPressed: () => Get.offAllNamed(AppRoutes.personalAchievementScreen),
        ),

        SizedBox(height: 12.h),

        CustomButton(
          text: "share_score".tr,
          icon: Icons.score,
          onPressed: () => _shareScore(gameData),
        ),

        SizedBox(height: 16.h),

        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.strategyJourneyScreen),
          child: Text(
            "view_your_journey".tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: AppDimensions.d14.sp,
              color: AppColors.primaryBlue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Helper Methods
  // ──────────────────────────────────────────────

  int _calculatePoints(String? totalPoints) {
    if (totalPoints == null || totalPoints.isEmpty) return 0;
    try {
      final parts = totalPoints.split('/');
      if (parts.length == 2) {
        return int.tryParse(parts[0].trim()) ?? 0;
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

  List<String> _getAchievements(GameCompleteModel gameData) {
    final achievements = <String>[];
    final score = gameData.score ?? 0;

    achievements.add("completed_strategic_cycle".tr);

    if (score >= 70) {
      achievements.add("adapted_market_challenge".tr);
    }
    if (score >= 80) {
      achievements.add("demonstrated_thinking_excellence".tr);
    }
    if (score >= 90) {
      achievements.add("earned_strategic_master".tr);
    } else if (score >= 80) {
      achievements.add("earned_strategic_architect".tr);
    } else if (score >= 70) {
      achievements.add("earned_strategic_thinker".tr);
    }

    return achievements;
  }

  void _shareScore(GameCompleteModel gameData) {
    final shareText = '''
🎮 Game Complete!
Score: ${gameData.score}/100
Badge: ${gameData.badge ?? "None"}
Trophy: ${gameData.trophy?.isNotEmpty == true ? gameData.trophy : "No Trophy"}

${gameData.scor ?? "Great performance!"}
    '''.trim();

    Get.snackbar(
      'Share',
      'Share functionality would open here',
      snackPosition: SnackPosition.BOTTOM,
      messageText: Text(
        shareText,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 5),
    );
  }
}







// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
// import '../../../presentation/routes/app_routes.dart';
// import '../../../presentation/widgets/custom_journey_map.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/game_complete_widgets/achievement_summary.dart';
// import '../../widgets/game_complete_widgets/custom_score_card.dart';
// import '../../widgets/game_complete_widgets/performance_breakdown.dart';
// import '../../widgets/game_complete_widgets/rewards_unlocked.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
//
// // If you don't have this class yet, add it (adjust fields as per your real model)
// class BreakdownItem {
//   final String title;
//   final int score;
//   final int maxScore;
//
//   BreakdownItem(this.title, this.score, this.maxScore);
// }
//
// class GameCompleteScreen extends StatelessWidget {
//   const GameCompleteScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
//
//     // ── Static / hardcoded values ───────────────────────────────────────────
//     const int staticScore = 88;
//     const String staticBadge = "Strategic Master";
//     const String staticTrophy = "Environmental Champion";
//     const String staticDescription = "Outstanding performance in sustainability strategy!";
//     const String staticMode = "solo";
//
//     // Mock journey data
//     const double mockProgress = 0.75;
//     final List<String> mockSteps = [
//       "Strategy",
//       "Objective",
//       "Key Results",
//       "Initiatives",
//       "Evaluation",
//       "Complete",
//     ];
//     final List<bool> mockCompleted = [true, true, true, true, true, false];
//
//     // Mock breakdown items (type-safe)
//     final List<BreakdownItem> mockBreakdownItems = [
//       BreakdownItem("Strategy Alignment", 9, 10),
//       BreakdownItem("Objective Clarity", 9, 10),
//       BreakdownItem("Key Results Quality", 10, 10),
//     ];
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
//                       // Header
//                       CustomHeader(
//                         title: 'game'.tr,
//                         highlightedText: 'complete'.tr,
//                         subtitle: '',
//                         onBackTap: () => Get.back(),
//                       ),
//
//                       SizedBox(height: height * 0.025),
//
//                       CustomScoreCard(
//                         score: staticScore,
//                         title: "Excellent",
//                         description: staticDescription,
//                       ),
//
//                       SizedBox(height: height * 0.025),
//
//                       PerformanceBreakdown(
//                         points: 28,
//                         totalPoints: 30, items: [],
//                         // items: mockBreakdownItems, // Now type-safe
//                       ),
//
//                       SizedBox(height: height * 0.025),
//
//                       RewardsUnlocked(
//                         badgeImage: "assets/images/badge.png",
//                         badgeName: staticBadge,
//                         titleImage: "assets/images/game.png",
//                         titleName: "Sustainability Leader",
//                         trophyImage: "assets/images/trophy.png",
//                         trophyName: staticTrophy,
//                       ),
//
//                       SizedBox(height: height * 0.025),
//
//                       // Static journey map (no RxBool)
//                       CustomJourneyMap(
//                         progress: mockProgress,
//                         steps: mockSteps,
//                         completedSteps: mockCompleted,
//                         onToggle: () {}, // empty callback
//                         showDetails: false, // plain bool, no .obs
//                       ),
//
//                       SizedBox(height: height * 0.025),
//
//                       AchievementSummary(
//                         achievements: [
//                           "completed_strategic_cycle".tr,
//                           "adapted_market_challenge".tr,
//                           "demonstrated_thinking_excellence".tr,
//                           "earned_strategic_architect".tr,
//                         ],
//                       ),
//
//                       SizedBox(height: height * 0.04),
//
//                       _buildActionButtons(staticMode),
//                     ],
//                   ),
//                 ),
//               ),
//
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
//
//   Widget _buildActionButtons(String mode) {
//     return Column(
//       children: [
//         if (mode == 'campaign') ...[
//           CustomButton(
//             text: "start_certificate_mode".tr,
//             icon: Icons.verified_outlined,
//             backgroundColor: AppColors.primaryGreen,
//             onPressed: () => Get.offAllNamed(AppRoutes.campaignModeScreen),
//           ),
//           SizedBox(height: 12.h),
//         ],
//         CustomButton(
//           text: "play_again".tr,
//           icon: Icons.play_arrow,
//           onPressed: () {
//             if (mode == 'campaign') {
//               Get.offAllNamed(AppRoutes.teamStrategySelection);
//             } else {
//               Get.offAllNamed(AppRoutes.roleSelection);
//             }
//           },
//         ),
//         SizedBox(height: 12.h),
//         CustomButton(
//           text: "view_badges".tr,
//           icon: Icons.badge_outlined,
//           onPressed: () => Get.offAllNamed(AppRoutes.personalAchievementScreen),
//         ),
//         SizedBox(height: 12.h),
//         CustomButton(
//           text: "share_score".tr,
//           icon: Icons.share,
//           onPressed: () {
//             Get.snackbar(
//               'Share',
//               'Score: 88/100\nBadge: Strategic Master\nTrophy: Environmental Champion',
//               snackPosition: SnackPosition.BOTTOM,
//             );
//           },
//         ),
//         SizedBox(height: 16.h),
//         Text(
//           "view_your_journey".tr,
//           style: TextStyle(
//             fontSize: AppDimensions.d14.sp,
//             color: AppColors.primaryBlue,
//             decoration: TextDecoration.underline,
//           ),
//         ),
//       ],
//     );
//   }
// }