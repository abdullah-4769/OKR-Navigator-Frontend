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
  final RankController rankController = Get.put(RankController());

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


                      /// Header
                      CustomHeader(
                        title: "Your",
                        highlightedText: "Scoreboard",
                        subtitle: "",
                        onBackTap: () => Get.back(),
                      ),



                      /// Show achievements text button
                      Center(
                        child: TextButton(
                          onPressed: () {

                            Get.toNamed(AppRoutes.teamAchievementsScreen);
                          },
                          child: Text(
                            "Show Team achievements",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primaryBlue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimensions.d12.h),



                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.d8.w),
                        child: CustomTopPerformerWidget(),
                      ),

                      SizedBox(height: AppDimensions.d20.h),

                      /// Achievement banner
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: CustomObjectiveContainer(
                          title: '',
                          subtitle: 'I’m ranked #3 in Strategic Agility this week!',
                          description: '',
                        ),
                      ),

                      SizedBox(height: AppDimensions.d20.h),

                      /// Leaderboard List
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
                                rank: item['rank'],
                                name: item['name'],
                                level: item['level'],
                                points: item['points'],
                                score: item['score'],
                                isHighlighted: item['highlighted'] ?? false,
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

  /// Top 3 Podium layout
  Widget _buildTopPodium() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _podiumMember("Master", 925, 2),
          _podiumMember("Kings", 1000, 1),
          _podiumMember("Spark", 890, 3),
        ],
      ),
    );
  }

  Widget _podiumMember(String name, int score, int rank) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: AppDimensions.d70.w,
              height: AppDimensions.d70.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: rank == 1 ? AppColors.primaryRed : AppColors.primaryBlue,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: AppDimensions.d28.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Positioned(
              bottom: -AppDimensions.d12.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: rank == 1 ? Colors.amber : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  "$score",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.d14.sp,
                      color: rank == 1 ? AppColors.primaryRed : AppColors.textPrimary),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.d28.h),
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppDimensions.d14.sp,
            color: AppColors.textPrimary,
          ),
        )
      ],
    );
  }
}
