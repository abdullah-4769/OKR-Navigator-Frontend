// lib/presentation/views/strategy/strategy_journey_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/views/screens_after_complete_game/section_card.dart';
import 'package:get/get.dart';

import '../../../controllers/journey_controller.dart';
import '../../../controllers/strategy_journey_controller.dart';
import '../../../controllers/okr_constellation_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_okr_constellation.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/game_complete_widgets/achievement_summary.dart';
import '../../widgets/strategic_icons_show.dart';

class StrategyJourneyScreen extends StatelessWidget {
  const StrategyJourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ensure controllers exist
    final StrategyJourneyController controller =
    StrategyJourneyController.getOrPut();


    //final okrController = Get.put(OKRConstellationController(), permanent: false);

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


                      // header
                      CustomHeader(
                        title: 'strategic'.tr,
                        highlightedText: 'journey'.tr,
                        subtitle: '',
                        onBackTap: () => Get.back(),
                      ),

                      SizedBox(height: height * 0.02),

                      // OKR Constellation (visual map at top)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: StrategicIconsShow(),
                      ),


                      SizedBox(height: height * 0.02),

                      // Key Strengths (red)
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

                      // Growth Opportunities (yellow)
                      Obx(
                            () => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.d16.w),
                          child: SectionCard(
                            icon: Icons.trending_up,
                            borderColor: const Color(0xFFF0B400), // yellow-ish
                            title: "growth_opportunities",
                            items: controller.growthOpportunities.toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Center(
                        child: AchievementSummary(
                            achievements:
                            controller.achievements.toList()),
                      ),
                      SizedBox(height: height * 0.02),

                      // Journey Map (expandable)
                      Obx(
                            () => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.d2.w),
                          child: CustomJourneyMap(
                            progress: controller.progress.value,
                            steps: controller.steps,
                            completedSteps: controller.completedSteps,
                            onToggle: controller.toggleJourneyDetails,
                            showDetails: controller.showDetails.value,
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      // Action Buttons at bottom
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
                              onPressed: () => Get.offNamed(AppRoutes.personalDashboardScreen),
                              backgroundColor: AppColors.primaryBlue,
                            ),
                            SizedBox(height: AppDimensions.d12.h),
                            CustomButton(
                              text: "bonus_case_study_mode".tr,
                              onPressed: () => Get.toNamed('/game_mode'),
                              backgroundColor: AppColors.primaryRed,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.06),
                    ],
                  ),
                ),
              ),

              // Home Navbar
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
