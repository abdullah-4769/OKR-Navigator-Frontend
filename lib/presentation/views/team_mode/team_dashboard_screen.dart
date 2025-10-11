import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../../controllers/team_mode_controller/team_dashboard_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_circular_avatar.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/team_mode_widgets/custom_view_widget.dart';
import '../../widgets/team_mode_widgets/feedback_card.dart';
import '../../widgets/team_mode_widgets/section_card.dart';
import '../../widgets/team_mode_widgets/stat_card.dart';
import '../../widgets/team_mode_widgets/sucess_rate_bar.dart';

class TeamDashboardScreen extends StatelessWidget {
  final controller = Get.put(TeamDashboardController());

  TeamDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

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
                  child: Obx(
                        () => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [


                        /// Header
                        CustomHeader(
                          title: 'team'.tr,
                          highlightedText: 'dashboard'.tr,
                          subtitle: '',
                          onBackTap: () => Get.back(),
                        ),



                        /// Avatar + Team
                        Center(
                          child: CustomCircularAvatar(
                            imagePath: 'assets/images/role_icon.png',
                            innerColors: [
                              Colors.amber.shade100,
                              Colors.amber.shade200,
                              Colors.amber.shade300
                            ],
                            borderGradient: [AppColors.primaryRed, AppColors.primaryRed.withOpacity(0.5)],
                            size: 120,
                          ),
                        ),
                        SizedBox(height: 10.h),



                        /// Success rate bar
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SuccessRateBar(
                            successRate: controller.successRate.value,
                            progressValue: controller.progressValue(),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        /// Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StatCard(
                              value: controller.badges.value.toString(),
                              label: 'badges'.tr,
                              assetPath: 'assets/images/badge.png',
                            ),
                            StatCard(
                              value: controller.trophies.value.toString(),
                              label: 'trophies'.tr,
                              assetPath: 'assets/images/trophy.png',
                            ),
                            StatCard(
                              value: controller.games.value.toString(),
                              label: 'games'.tr,
                              assetPath: 'assets/images/game.png',
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        /// Recent Achievements
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SectionCard(
                            title: 'recent_achievements'.tr,
                            //icon: Icons.thumb_up,
                            borderColor: AppColors.primaryRed,
                            items: controller.achievements,
                            showCheck: true,
                          ),
                        ),

                        /// Feedback Section
                        SizedBox(height: 10.h),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 16.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'peer_feedback'.tr,
                              style: TextStyle(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp),
                            ),
                          ),
                        ),

                        ...controller.feedbackList
                            .map((f) => Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 12.w),
                              child: FeedbackCard(data: f),
                            ))
                            .toList(),

                        SizedBox(height: 10.h),
                        /// Bottom buttons
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CustomViewWidget(
                            title: 'schedule_team_game'.tr,
                            subtitle: ''.tr,
                            onPressed: () {},
                            trailingIcon: Icons.schedule_send_outlined,
                          ),
                        ),
                        /// Recent Games
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SectionCard(
                            title: 'recent_games'.tr,
                            icon: Icons.videogame_asset,
                            borderColor: AppColors.primaryRed,
                            items: controller.recentGames,
                            showScore: true,
                          ),
                        ),

                        SizedBox(height: 20.h),

                        /// -------- ACTION BUTTONS --------
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.d24.w),
                          child: Column(
                            children: [
                              CustomButton(
                                icon: Icons.schedule,
                                text: "schedule_TG".tr,
                                onPressed: () {

                                },
                              ),
                              SizedBox(height: AppDimensions.d12.h),
                              CustomButton(
                                icon: Icons.person,
                                text: "invite_p".tr,
                                onPressed: () => {

                                },

                                backgroundColor: AppColors.primaryBlue,
                              ),
                              SizedBox(height: AppDimensions.d12.h),
                              CustomButton(
                                icon: Icons.launch,
                                text: "launch_c".tr,
                                onPressed: () => {

                                },
                              ),
                            ],
                          ),
                        ),
                      
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