import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/team_mode_controller/team_strategic_architect_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/game_complete_widgets/achievement_summary.dart';
import '../../widgets/game_complete_widgets/custom_score_card.dart';
import '../../widgets/game_complete_widgets/performance_breakdown.dart';
import '../../widgets/game_complete_widgets/rewards_unlocked.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class TeamStrategicArchitectScreen2 extends StatelessWidget {
  const TeamStrategicArchitectScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamStrategicArchitectController>();
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

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


                      /// Header
                      CustomHeader(
                        title: 'Game',
                        highlightedText: 'Complete!',
                        subtitle: '',
                        onBackTap: () => Get.back(),
                      ),

                      SizedBox(height: height * 0.025),

                      /// Score Card
                      Obx(() => CustomScoreCard(
                        score: controller.score.value,
                        title: "Strategic Architect",
                        description:
                        "Excellent strategic thinking and adaptation skills!",
                      )),

                      SizedBox(height: height * 0.025),

                      /// Performance Breakdown
                      Obx(() => PerformanceBreakdown(
                        points: controller.points.value,
                        totalPoints: controller.totalPoints.value,
                        items: controller.breakdownItems
                            .map((item) => BreakdownItem(
                            item["title"], item["score"], item["success"]))
                            .toList(),
                      )),

                      SizedBox(height: height * 0.025),

                      /// Rewards Unlocked
                      Obx(() => RewardsUnlocked(
                        badgeImage: "assets/images/badge.png",
                        badgeName: controller.badges.isNotEmpty ? controller.badges[0] : "Strategic Thinker",
                        titleImage: "assets/images/game.png",
                        titleName: controller.titles.isNotEmpty ? controller.titles[0] : "Master Adapter",
                        trophyImage: "assets/images/trophy.png",
                        trophyName: controller.trophy.value,
                      )),

                      SizedBox(height: height * 0.025),

                      /// Journey Map
                      Obx(() => CustomJourneyMap(
                        progress: 100.0,
                        steps: const [
                          "Strategy Selection",
                          "Objective Selection",
                          "Key Result Selection",
                          "Initiatives Suggestion",
                          "Result Performance"
                        ],
                        completedSteps: const [true, true, true, true, true],
                        onToggle: controller.toggleJourneyDetails,
                        showDetails: controller.showJourneyDetails.value,
                      )),

                      SizedBox(height: height * 0.025),

                      /// Achievement Summary
                      Obx(() => AchievementSummary(
                        achievements: controller.achievements.toList(),
                      )),

                      SizedBox(height: height * 0.04),

                      /// Buttons
                      CustomButton(
                        text: "Play Again",
                        icon: Icons.play_arrow,
                        onPressed: controller.playAgain,
                      ),
                      SizedBox(height: 12.h),
                      CustomButton(
                        text: "View Badges",
                        icon: Icons.badge_outlined,
                        onPressed: controller.viewBadges,
                      ),
                      SizedBox(height: 12.h),
                      CustomButton(
                        text: "Share Score",
                        icon: Icons.share,
                        onPressed: controller.shareScore,
                      ),

                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: controller.viewJourney,
                        child: Text(
                          "View Your Journey",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
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