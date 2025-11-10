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
                                () {
                              viewModel.fetchLatestGameScore(userId);
                            },
                                () {
                              viewModel.loadMockDataForTesting();
                            },
                          );
                        }

                        final gameData = viewModel.gameCompleteData.value;
                        if (gameData == null) {
                          return _buildNoDataCard(() {
                            viewModel.fetchLatestGameScore(userId);
                          });
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

  // 🔹 NO USER ID CARD
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

  // 🔹 LOADING CARD
  Widget _buildLoadingCard() {
    return Padding(
      padding: EdgeInsets.all(20.h),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(color: AppColors.primaryRed),
            SizedBox(height: 16.h),
            Text(
              'Loading your game results...',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 ERROR CARD - Enhanced with debug info and mock data option
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
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
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
          CustomButton(
            text: "retry".tr,
            onPressed: onRetry,
          ),
          SizedBox(height: 8.h),
          TextButton(
            onPressed: onLoadMockData,
            child: Text(
              'Load Test Data (For UI Testing)',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 NO DATA CARD
  Widget _buildNoDataCard(VoidCallback onLoadData) {
    return Padding(
      padding: EdgeInsets.all(20.h),
      child: Column(
        children: [
          Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 48.sp),
          SizedBox(height: 16.h),
          Text(
            'No game data available',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: "load_game_data".tr,
            onPressed: onLoadData,
          ),
        ],
      ),
    );
  }

  // 🔹 GAME COMPLETE CONTENT
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
        /// Score Card with actual data
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

        /// Rewards Unlocked with actual badges
        RewardsUnlocked(
          badgeImage: "assets/images/badge.png",
          badgeName: gameData.badge ?? "New Player",
          titleImage: "assets/images/game.png",
          titleName: viewModel.getScoreTitle(),
          trophyImage: "assets/images/trophy.png",
          trophyName: gameData.trophy?.isNotEmpty == true ? gameData.trophy! : "First Steps",
        ),

        SizedBox(height: height * 0.025),

        /// Journey Map
        Obx(() => CustomJourneyMap(
          progress: journeyController.progress.value,
          steps: journeyController.steps,
          completedSteps: journeyController.completedSteps,
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

  // 🔹 ACTION BUTTONS
  Widget _buildActionButtons(GameCompleteModel gameData, BuildContext context, String? savedMode) {
    return Column(
      children: [
        // Show "Start Certificate Mode" button only if current mode is campaign
        if (savedMode == 'campaign') ...[
          CustomButton(
            text: "start_certificate_mode".tr,
            icon: Icons.verified_outlined,
            backgroundColor: AppColors.primaryGreen,
            onPressed: () {
              Get.offAllNamed(AppRoutes.campaignModeScreen);
            },
          ),
          SizedBox(height: 12.h),
        ],

        // Regular action buttons
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
          onPressed: () {
            Get.offAllNamed(AppRoutes.personalAchievementScreen);
          },
        ),
        SizedBox(height: 12.h),
        CustomButton(
          text: "share_score".tr,
          icon: Icons.score,
          onPressed: () {
            _shareScore(gameData);
          },
        ),

        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.strategyJourneyScreen);
          },
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

  int _calculatePoints(String? totalPoints) {
    if (totalPoints == null) return 0;
    try {
      final parts = totalPoints.split('/');
      if (parts.length == 2) {
        return int.tryParse(parts[0]) ?? 0;
      }
      return 0;
    } catch (e) {
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
Badge: ${gameData.badge}
Trophy: ${gameData.trophy?.isNotEmpty == true ? gameData.trophy : "No Trophy"}
    
${gameData.scor ?? "Great performance!"}
    ''';

    Get.snackbar(
      'Share',
      'Share functionality would open here',
      snackPosition: SnackPosition.BOTTOM,
      messageText: Text(
        shareText,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}







