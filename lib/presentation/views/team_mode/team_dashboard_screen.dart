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
                          title: controller.teamName.value, // DYNAMIC
                          highlightedText: 'dashboard'.tr,
                          subtitle: '',
                          onBackTap: () => Get.back(),
                        ),



                        /// Avatar + Team
                        Center(
                          child: CustomCircularAvatar(
                            imagePath: 'assets/images/role_icon.png', // STATIC for now
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



                        /// Success rate bar - DYNAMIC
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SuccessRateBar(
                            successRate: controller.successRate.value,
                            progressValue: controller.progressValue(),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        /// Stats Row - DYNAMIC
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

                        /// Recent Achievements - DYNAMIC
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SectionCard(
                            title: 'recent_achievements'.tr,
                            borderColor: AppColors.primaryRed,
                            items: controller.achievements.toList(), // DYNAMIC list
                            showCheck: true,
                          ),
                        ),

                        SizedBox(height: 10.h),
                        /// Bottom buttons (ViewWidget is mostly static wrapper)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CustomViewWidget(
                            title: 'schedule_team_game'.tr,
                            subtitle: 'plan_new_session'.tr, // Assuming plan_new_session is a valid key
                            onPressed: () {},
                            trailingIcon: Icons.schedule_send_outlined,
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
                                  // Action logic here
                                },
                              ),
                              SizedBox(height: AppDimensions.d12.h),
                              CustomButton(
                                icon: Icons.person,
                                text: "invite_p".tr,
                                onPressed: () {
                                  // Action logic here
                                },
                                backgroundColor: AppColors.primaryBlue,
                              ),
                              SizedBox(height: AppDimensions.d12.h),
                              CustomButton(
                                icon: Icons.launch,
                                text: "launch_c".tr,
                                onPressed: () {
                                  // Action logic here
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