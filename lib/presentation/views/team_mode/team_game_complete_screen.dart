import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/views/team_mode/team_member_card.dart';
import 'package:get/get.dart';

import '../../../controllers/team_mode_controller/team_game_complete_controller.dart';
import '../../../controllers/team_mode_controller/team_strategic_architect_controller.dart';
import '../../../core/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/game_complete_widgets/achievement_summary.dart';
import '../../widgets/game_complete_widgets/custom_score_card.dart';
import '../../widgets/game_complete_widgets/performance_breakdown.dart';
import '../../widgets/game_complete_widgets/rewards_unlocked.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/team_mode_widgets/custom_view_widget.dart';

class TeamGameCompleteScreen extends StatelessWidget {
  const TeamGameCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final TeamGameCompleteController controller = Get.put(TeamGameCompleteController());

    // 📝 Convert RxLists -> normal lists only once
    final badgesList = controller.badges;
    final titlesList = controller.titles;
    final trophyValue = controller.trophy;
    final breakdownList = controller.breakdownItems;
    final achievementsList = controller.achievements;

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
                        onBackTap: () => Get.offNamed(AppRoutes.customAIAnalysisScreen2),
                      ),

                      SizedBox(height: height * 0.0025),

                      /// Score Card
                      Obx(() => CustomScoreCard(
                        score: controller.score.value,
                        title: "strategic_master".tr,
                        description: "ex_team_strategy".tr,
                      )),

                      SizedBox(height: height * 0.025),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomViewWidget(
                          title: "view_score".tr,
                          subtitle: "your_initiative".tr,
                          trailingIcon: Icons.play_arrow_rounded,
                          onPressed: () {

                              Get.put(TeamStrategicArchitectController()); // Initialize controller
                              Get.toNamed(AppRoutes.teamStrategicArchitectScreen2);

                          },
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      /// Team Members
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            TeamMemberCard(
                              name: "You",
                              role: "CEO Role",
                              level: 5,
                              score: 87,
                              isCurrentUser: true,
                              status: "View",
                            ),
                            TeamMemberCard(
                              name: "Johnson",
                              role: "Strategist",
                              level: 5,
                              score: 0,
                              status: "Working...",
                            ),
                            TeamMemberCard(
                              name: "Tasha",
                              role: "HR Manager",
                              level: 5,
                              score: 0,
                              status: "Working...",
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      /// Challenge Alert
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: CustomObjectiveContainer(
                          icon: Icons.add_alert,
                          title: 'challenge_alert'.tr,
                          subtitle: '',
                          description: 'adaptation_required'.tr,
                          titleColor: AppColors.primaryRed,
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      /// Performance Breakdown
                      GetBuilder<TeamGameCompleteController>(
                        builder: (_) => PerformanceBreakdown(
                          points: controller.points.value,
                          totalPoints: controller.totalPoints.value,
                          items: breakdownList
                              .map((item) => BreakdownItem(
                            item["title"],
                            item["score"],
                            item["success"],
                          ))
                              .toList(),
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      /// Rewards Unlocked
                      GetBuilder<TeamGameCompleteController>(
                        builder: (_) => RewardsUnlocked(
                          badgeImage: "assets/images/badge.png",
                          badgeName: "Strategic Thinker",
                          titleImage: "assets/images/game.png",
                          titleName: "Master Adapter",
                          trophyImage: "assets/images/trophy.png",
                          trophyName: "Silver",
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      /// Journey Map
                      CustomJourneyMap(
                        progress: 100.0,
                        steps: const [
                          "Strategy Selection",
                          "Objective Alignment",
                          "Key Results",
                          "Initiatives",
                          "Results"
                        ],
                        completedSteps: const [true, true, true, true, true],
                        onToggle: controller.toggleJourneyDetails,
                        showDetails: true,
                      ),

                      SizedBox(height: height * 0.025),

                      /// Achievement Summary
                      GetBuilder<TeamGameCompleteController>(
                        builder: (_) => AchievementSummary(
                          achievements: achievementsList.toList(),
                        ),
                      ),

                      SizedBox(height: height * 0.04),

                      /// Buttons
                      CustomButton(
                        text: "Play Another Team Game",
                        icon: Icons.play_arrow,
                        onPressed: controller.playAgain,
                      ),
                      SizedBox(height: 12.h),
                      CustomButton(
                        text: "View Team Badges",
                        icon: Icons.badge_outlined,
                        onPressed: controller.viewBadges,
                      ),
                      SizedBox(height: 12.h),
                      CustomButton(
                        text: "Share Team Score",
                        icon: Icons.share,
                        onPressed: controller.shareScore,
                      ),

                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: controller.viewJourney,
                        child: Text(
                          "View Team Journey",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                            color: AppColors.primaryBlue,
                            decoration: TextDecoration.underline,

                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.04),
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