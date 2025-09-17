import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/widgets/custom_selected_key_result_container.dart';
import 'package:game_app/presentation/widgets/global_widgets/custom_top_performer_widget.dart';
import 'package:get/get.dart';
import '../../controllers/scoreboard_controllers/score_board_controller.dart';
import '../../controllers/widgets_controllers/rank_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../../core/app_theme.dart';

import '../routes/app_routes.dart';
import '../widgets/custom_home_navbar.dart';
import '../widgets/custom_objective_container.dart';
import '../widgets/scoreboard_widgets/custom_achievement_banner.dart';
import '../widgets/scoreboard_widgets/custom_rank_container.dart';
import '../widgets/screens_unique_parts/custom_background.dart';
import '../widgets/screens_unique_parts/custom_header.dart';

class ScoreboardScreen extends StatelessWidget {
  ScoreboardScreen({super.key});

  // ✅ Different variable names
  final ScoreboardController scoreboardController = Get.put(ScoreboardController());
  final RankController rankController = Get.put(RankController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: size.height * 0.012),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// ✅ Header
                    CustomHeader(
                      title: "your".tr,
                      highlightedText: "scoreboard".tr,
                      subtitle: "show_personal_achievements".tr,
                      onBackTap: () => Get.back(),
                    ),

                    SizedBox(height: AppDimensions.d14.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {Get.offAllNamed(AppRoutes.strategyJourneyScreen);},
                        child: Text(
                          "view_your_journey".tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: AppColors.primaryBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                    ),
                    SizedBox(height: AppDimensions.d14.h),
                    /// ✅ Top Performers
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.d8.w),
                        child: CustomTopPerformerWidget(),
                    ),
                    SizedBox(height: AppDimensions.d14.h),

                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomObjectiveContainer(
                          title: '',
                          subtitle: '',
                          description: 'I’m ranked #3 in Strategic Agility this week!',
                        ),
                      ),
                    ),

                    SizedBox(height: AppDimensions.d14.h),

                    /// ✅ Leaderboard
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppDimensions.d16.h),
                          Obx(
                                () => ListView.builder(
                              shrinkWrap: true, // ✅ fix
                              physics: const NeverScrollableScrollPhysics(), // ✅ fix
                              itemCount: rankController.ranks.length,
                              itemBuilder: (context, index) {
                                final item = rankController.ranks[index];
                                return CustomRankContainer(
                                  rank: item.rank,
                                  name: item.name,
                                  level: item.level,
                                  points: item.points,
                                  score: item.score,
                                  isHighlighted: item.isHighlighted,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
            ),

            /// ✅ Floating NavBar
            Positioned(
              right: size.width * -0.07,
              top: size.height * 0.5,
              child: const CustomHomeNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Helper for top performer avatars
  Widget _buildTopPerformer(int score, String name, int rank) => Column(
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
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  name[0],
                  style: TextStyle(
                    fontSize: AppDimensions.d20.sp,
                    fontWeight: FontWeight.bold,
                    color: rank == 1 ? AppColors.primaryRed : AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
            if (rank == 1)
              Positioned(
                top: 0,
                child: Icon(
                  Icons.star,
                  color: AppColors.primaryRed,
                  size: AppDimensions.d24.sp,
                ),
              ),
          ],
        ),
        SizedBox(height: AppDimensions.d8.h),
        Text(
          "$score",
          style: TextStyle(
            fontSize: AppDimensions.d16.sp,
            fontWeight: FontWeight.bold,
            color: rank == 1 ? AppColors.primaryRed : AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: AppDimensions.d4.h),
        Text(
          name,
          style: TextStyle(
            fontSize: AppDimensions.d14.sp,
            color: AppColors.textSecondary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
}
