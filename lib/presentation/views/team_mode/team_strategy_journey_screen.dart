import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/team_mode_controller/team_strategy_journey_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/strategic_icons_show.dart';
import '../../widgets/game_complete_widgets/achievement_summary.dart';
import '../screens_after_complete_game/section_card.dart';

class TeamStrategyJourneyScreen extends StatelessWidget {
  const TeamStrategyJourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TeamStrategyJourneyController controller =
    TeamStrategyJourneyController.getOrPut();

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
                  padding: EdgeInsets.only(bottom: height * 0.014),
                  child: Column(
                    children: [

                      /// -------- HEADER --------
                      CustomHeader(
                        title: 'strategic'.tr,
                        highlightedText: 'journey'.tr,
                        subtitle: 'team'.tr,
                        onBackTap: () => Get.back(),
                      ),

                      SizedBox(height: height * 0.02),

                      /// -------- STRATEGIC ICON MAP (Center cluster) --------
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: StrategicIconsShow(),
                      ),

                      SizedBox(height: height * 0.02),

                      /// -------- KEY STRENGTHS --------
                      Obx(
                            () => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.d16.w),
                          child: SectionCard(
                            icon: Icons.thumb_up,
                            borderColor: AppColors.primaryRed,
                            title: "key_strengths",
                            items: controller.strengths.toList(),
                          ),
                        ),
                      ),

                      /// -------- GROWTH OPPORTUNITIES --------
                      Obx(
                            () => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.d16.w),
                          child: SectionCard(
                            icon: Icons.trending_up,
                            borderColor: const Color(0xFFF0B400),
                            title: "growth_opportunities",
                            items: controller.growthOpportunities.toList(),
                          ),
                        ),
                      ),

                      /// -------- ACHIEVEMENT SUMMARY --------
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.d12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(height: AppDimensions.d12.h),
                            AchievementSummary(
                                achievements:
                                controller.achievements.toList()),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      /// -------- ACTION BUTTONS --------
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.d24.w),
                        child: Column(
                          children: [
                            CustomButton(
                              text: "play_again".tr,
                              onPressed: () {
                                controller.resetJourney();
                              },
                            ),
                            SizedBox(height: AppDimensions.d12.h),
                            CustomButton(
                              text: "go_to_dashboard".tr,
                              onPressed: () => {
                                Get.offNamed(
                                 AppRoutes.teamDashboard),
                              },

                              backgroundColor: AppColors.primaryBlue,
                            ),
                            SizedBox(height: AppDimensions.d12.h),
                            CustomButton(
                              text: "bonus_case_study_mode".tr,
                              onPressed: () => {
                              //     Get.toNamed('/game_mode'),
                              // backgroundColor: AppColors.primaryRed,
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.06),
                    ],
                  ),
                ),
              ),

              /// -------- FLOATING HOME NAV --------
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
