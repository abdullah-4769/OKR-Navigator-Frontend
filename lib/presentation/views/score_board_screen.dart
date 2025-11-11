import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/scoreboard_controllers/score_board_controller.dart';
import '../widgets/global_widgets/custom_top_performer_widget.dart';
import '../widgets/score_board/mode_selector.dart';
import '../widgets/score_board/rank_item_widget.dart';
import '../widgets/score_board/top_performance.dart';
import '../widgets/screens_unique_parts/custom_header.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScoreboardController());

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "your".tr,
              highlightedText: "scoreboard".tr,
              subtitle: "".tr,
              onBackTap: () => Get.back(),
            ),
            Container(
        
              child: const Column(
                children: [
                  SizedBox(height: 10),
                  ModeSelectorWidget(),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                }
        
                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading scoreboard',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () => controller.fetchScoreboard(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
        
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Show Personal Achievements',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                       CustomTopPerformerWidget(
                      ),
                      const SizedBox(height: 20),
                      if (controller.userDetails.value != null)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                color: Colors.red,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'I\'m ranked #${controller.userDetails.value?.rank ?? 'N/A'} in ${controller.getModeName()} this week!',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Leaderboard',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (controller.allPlayers.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'No leaderboard data available',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.allPlayers.length,
                                itemBuilder: (context, index) {
                                  final player = controller.allPlayers[index];
                                  final isCurrentUser =
                                      controller.userDetails.value?.userId ==
                                          player.userId;
                                  return RankItemWidget(
                                    player: player,
                                    isCurrentUser: isCurrentUser,
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/scoreboard_controllers/score_board_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../../core/app_theme.dart';
import '../widgets/custom_home_navbar.dart';
import '../widgets/custom_objective_container.dart';
import '../widgets/global_widgets/custom_top_performer_widget.dart';
import '../widgets/score_board/rank_item_widget.dart';
import '../widgets/screens_unique_parts/custom_background.dart';
import '../widgets/screens_unique_parts/custom_header.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScoreboardController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: Stack(
          children: [
            Positioned.fill(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryRed,
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: AppColors.primaryRed,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading scoreboard',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () => controller.fetchScoreboard(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: size.height * 0.012),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppDimensions.d10.h),

                      /// Header
                      CustomHeader(
                        title: "your".tr,
                        highlightedText: "scoreboard".tr,
                        subtitle: "".tr,
                        onBackTap: () => Get.back(),
                      ),

                      SizedBox(height: AppDimensions.d4.h),

                      /// Show Personal Achievements Link
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "show_personal_achievements".tr,
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

                      SizedBox(height: AppDimensions.d4.h),

                      /// Top Performers
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d8.w,
                        ),
                        child: CustomTopPerformerWidget(
                         // topThree: controller.topThree,
                        ),
                      ),

                      SizedBox(height: AppDimensions.d14.h),

                      if (controller.userDetails.value != null)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomObjectiveContainer(
                              title: '',
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.d16.w,
                                  vertical: AppDimensions.d8.h,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'I\'m ranked #${controller.userDetails.value?.rank ?? 'N/A'} in ${controller.getModeName()} this week!',
                                        style: appTheme.textTheme.bodySmall?.copyWith(
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: AppDimensions.d14.h),

                      /// Leaderboard
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d16.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: AppDimensions.d16.h),

                            if (controller.allPlayers.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'No leaderboard data available',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.allPlayers.length,
                                itemBuilder: (context, index) {
                                  final player = controller.allPlayers[index];
                                  final isCurrentUser =
                                      controller.userDetails.value?.userId ==
                                          player.userId;
                                  return RankItemWidget(
                                    player: player,
                                    isCurrentUser: isCurrentUser,
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

            /// Floating NavBar
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
}*/


/*import 'package:flutter/material.dart';
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
                    SizedBox(height: AppDimensions.d10.h),
                    /// ✅ Header
                    CustomHeader(
                      title: "your".tr,
                      highlightedText: "scoreboard".tr,
                      subtitle: "".tr,
                      onBackTap: () => Get.back(),
                    ),

                    SizedBox(height: AppDimensions.d4.h),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "show_personal_achievements".tr,
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




                    SizedBox(height: AppDimensions.d4.h),
                    /// ✅ Top Performers
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.d8.w),
                        child: CustomTopPerformerWidget(),
                    ),
                    SizedBox(height: AppDimensions.d14.h),

                     Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomObjectiveContainer(
                          title: '',
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.d16.w,
                              vertical: AppDimensions.d8.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'I’m ranked #3 in Strategic Agility this week!'.tr,
                                  style: appTheme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),

                              ],
                            ),
                          ),
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
}*/
