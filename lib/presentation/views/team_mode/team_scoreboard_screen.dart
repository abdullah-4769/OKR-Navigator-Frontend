import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/controllers/team_mode_controller/team_scoreboard_controller.dart';
import 'package:get/get.dart';

import '../../../controllers/widgets_controllers/rank_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/global_widgets/custom_top_performer_widget.dart';
import '../../widgets/scoreboard_widgets/custom_rank_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';


class TeamScoreboardScreen extends StatelessWidget {
  TeamScoreboardScreen({super.key});

  final TeamScoreboardController controller = Get.put(TeamScoreboardController());
  final RankController rankController = Get.put(RankController()); // Still present but unused for main list

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: OrientationBuilder(
          builder: (context, orientation) => Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: size.height * 0.012),
                  child: Column(
                    children: [
                      SizedBox(height: AppDimensions.d10.h),
                      /// Header
                      CustomHeader(
                        title: "Your".tr,
                        highlightedText: "Scoreboard".tr,
                        subtitle: "",
                        onBackTap: () => Get.back(),
                      ),

                      SizedBox(height: AppDimensions.d4.h),
                      /// Show achievements text button
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.teamAchievementsScreen);
                          },
                          child: Text(
                            "Show Team achievements".tr,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primaryBlue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimensions.d12.h),

                      /// Top Performers/Podium
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.d8.w),
                        child: CustomTopPerformerWidget(), // Dynamic mock data via TopPerformerController
                      ),

                      SizedBox(height: AppDimensions.d20.h),

                      /// Achievement banner (Static Placeholder for now, as dynamic generation is complex)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: CustomObjectiveContainer(
                          title: '',
                          subtitle: 'I’m ranked #3 in Strategic Agility this week!',
                          description: '',
                        ),
                      ),

                      SizedBox(height: AppDimensions.d20.h),

                      /// Leaderboard List - DYNAMIC DATA
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                        child: Obx(
                              () => ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.leaderboard.length,
                            itemBuilder: (context, index) {
                              final item = controller.leaderboard[index];
                              return CustomRankContainer(
                                rank: item['rank'] as int,
                                name: item['name'].toString(),
                                level: item['level'] as int,
                                points: item['points'] as int,
                                score: item['score'] as int,
                                isHighlighted: item['highlighted'] as bool? ?? false,
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: AppDimensions.d20.h),
                    ],
                  ),
                ),
              ),

              /// Floating Navbar
              Positioned(
                right: size.width * -0.07,
                top: size.height * 0.5,
                child: const CustomHomeNavBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}