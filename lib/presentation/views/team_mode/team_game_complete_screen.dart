// lib/presentation/views/team_mode/team_game_complete_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/views/team_mode/team_member_card.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'dart:io';

import '../../../controllers/team_mode_controller/team_game_complete_controller.dart';
import '../../../controllers/team_mode_controller/team_strategic_architect_controller.dart';
import '../../../core/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/game_complete_widgets/achievement_summary.dart';
import '../../widgets/game_complete_widgets/custom_score_card.dart';
import '../../widgets/game_complete_widgets/performance_breakdown.dart';
import '../../widgets/game_complete_widgets/rewards_unlocked.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/team_mode_widgets/custom_view_widget.dart';

class TeamGameCompleteScreen extends StatelessWidget {
  TeamGameCompleteScreen({super.key});

  final TeamGameCompleteController controller = Get.put(TeamGameCompleteController());
  
  // GlobalKey for screenshot capture
  final GlobalKey _screenshotKey = GlobalKey();

 @override
 Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;

  // 📝 Access RxLists directly (they are already observables)
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
       /// Scrollable content - Wrapped in RepaintBoundary for screenshot
       Positioned.fill(
        child: RepaintBoundary(
         key: _screenshotKey,
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
           /// View Individual Score Button
           Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomViewWidget(
             title: "view_score".tr,
             subtitle: "your_initiative".tr,
             trailingIcon: Icons.play_arrow_rounded,
             onPressed: () {
               Get.put(TeamStrategicArchitectController.getOrPut()); // Ensure controller is initialized
               Get.toNamed(AppRoutes.teamStrategicArchitectScreen2);
             },
            ),
           ),

           SizedBox(height: height * 0.025),

           /// Team Members - DYNAMIC LIST INTEGRATION
           Obx(() { // <--- MODIFIED LOGIC START
                if (controller.memberData.isEmpty && controller.score.value == 0) { // Only show loading if score is 0 AND members haven't loaded
                     return Center(
                         child: Padding(
                             padding: EdgeInsets.symmetric(vertical: 30.h),
                             child: Column(
                                 children: [
                                     CircularProgressIndicator(color: AppColors.primaryRed),
                                     SizedBox(height: 10.h),
                                     Text("Loading team results...".tr, style: Theme.of(context).textTheme.bodyMedium),
                                 ],
                             )
                         )
                     );
                }
               
                return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                        children: controller.memberData.map((member) => TeamMemberCard(
                            name: member['name'].toString(),
                            role: member['role'].toString(),
                            level: member['level'] as int,
                            score: member['score'] as int,
                            isCurrentUser: member['isCurrentUser'] as bool,
                            status: member['status'].toString(),
                            badge: member['badge']?.toString() ?? "",
                            trophy: member['trophy']?.toString() ?? "",
                            title: member['title']?.toString() ?? "",
                        )).toList(),
                    ),
                );
            }), // <--- MODIFIED LOGIC END

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

           /// Performance Breakdown - DYNAMIC DATA
           Obx(() => PerformanceBreakdown(
             points: controller.points.value,
             totalPoints: controller.totalPoints.value,
             items: breakdownList
               .map((item) => BreakdownItem(
              item["title"].toString().tr, // Translate title
              item["score"].toString(),
              item["success"] as bool,
             ))
               .toList(),
            ),
           ),

           SizedBox(height: height * 0.025),

           /// Rewards Unlocked - DYNAMIC DATA
           Obx(() => RewardsUnlocked(
             badgeImage: "assets/images/badge.png",
             badgeName: badgesList.isNotEmpty ? badgesList.first.tr : "Strategic Thinker".tr, 
             titleImage: "assets/images/game.png",
             titleName: titlesList.isNotEmpty ? titlesList.first.tr : "Master Adapter".tr, 
             trophyImage: "assets/images/trophy.png",
             trophyName: trophyValue.value.isNotEmpty ? trophyValue.value.tr : "Silver".tr, 
            ),
           ),

           SizedBox(height: height * 0.025),

           /// Achievement Summary
           Obx(() => AchievementSummary(
             achievements: achievementsList.toList().map((e) => e.tr).toList(),
            ),
           ),

           SizedBox(height: height * 0.04),

          /// Buttons
          CustomButton(
           text: 'play_another_team_game'.tr,
           icon: Icons.play_arrow,
           onPressed: controller.playAgain,
          ),
           SizedBox(height: 12.h),
          CustomButton(
           text: 'view_team_badges'.tr,
           icon: Icons.badge_outlined,
           onPressed: controller.viewBadges,
          ),
           SizedBox(height: 12.h),
          CustomButton(
           text: 'share_team_score'.tr,
           icon: Icons.share,
           onPressed: controller.shareScore,
          ),

           SizedBox(height: 16.h),
           GestureDetector(
            onTap: controller.viewJourney,
            child: Text(
             'view_team_journey'.tr,
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