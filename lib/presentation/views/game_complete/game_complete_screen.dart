import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/controllers/journey_controller.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/widgets/custom_journey_map.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
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

                        /// Score Card
                        CustomScoreCard(
                          score: 78,
                          title: "strategic_architect".tr,
                          description: "strategic_architect_desc".tr,
                        ),

                        SizedBox(height: height * 0.025),

                        /// Performance Breakdown
                        PerformanceBreakdown(
                          points: 9,
                          totalPoints: 10,
                          items: [
                            BreakdownItem("strategy_selection".tr, "2/2", true),
                            BreakdownItem("objective_alignment".tr, "2/2", true),
                            BreakdownItem("key_results_quality".tr, "1/2", false),
                            BreakdownItem("initiative_relevance".tr, "2/2", true),
                            BreakdownItem("challenge_adaptation".tr, "2/2", true),
                          ],
                        ),
                        SizedBox(height: height * 0.025),

                        /// Rewards Unlocked
                        RewardsUnlocked(
                          badgeImage: "assets/images/badge.png",
                          badgeName: "Strategic Thinker",
                          titleImage: "assets/images/game.png",
                          titleName: "Master Adapter",
                          trophyImage: "assets/images/trophy.png",
                          trophyName: "Silver",
                        ),


                        SizedBox(height: height * 0.025),
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
                          achievements: [
                            "completed_strategic_cycle".tr,
                            "adapted_market_challenge".tr,
                            "demonstrated_thinking_excellence".tr,
                            "earned_strategic_architect".tr,
                          ],
                        ),

                        SizedBox(height: height * 0.04),

                        /// Buttons
                        CustomButton(text: "play_again".tr,
                            icon: Icons.play_arrow,
                            onPressed: () {}),
                        SizedBox(height: 12.h),
                        CustomButton(text: "view_badges".tr,
                            icon: Icons.badge_outlined,

                            onPressed: () {Get.offAllNamed(AppRoutes.personalAchievementScreen);}),
                        SizedBox(height: 12.h),
                        CustomButton(text: "share_score".tr,
                            icon: Icons.score,
                            onPressed: () {}),

                        SizedBox(height: 16.h),
                        GestureDetector(
                          onTap: () {Get.toNamed(AppRoutes.strategyJourneyScreen);},
                          child: Text(
                            "view_your_journey".tr,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: AppDimensions.d14.sp,
                              color: AppColors.primaryBlue,
                              decoration: TextDecoration.underline,
                            ),

                          ),
                        ),

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
}

//
// 🔹 Custom Widgets (Responsive)
//


