import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/core/app_theme.dart';
import 'package:get/get.dart';

import '../../../controllers/journey_controller.dart';
import '../../../controllers/team_mode_controller/team_game_controller.dart';
import '../../../controllers/team_mode_controller/team_strategy_selection_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_cards_pagebuilder.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class TeamStrategySelectionScreen extends StatelessWidget {
  TeamStrategySelectionScreen({super.key});
  final teamController = Get.put(TeamStrategySelectionController());
  final journeyController = Get.find<JourneyController>();
  final TeamStrategySelectionController teamStrategySelectionController =
      Get.put(TeamStrategySelectionController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: SafeArea(
          child: Stack(
            children: [
              /// ---------- SCROLLABLE CONTENT ----------
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.d2.h),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.02),

                        /// ---------- HEADER ----------
                        CustomHeader(
                          title: "Select".tr,
                          highlightedText: "Strategy".tr,
                          subtitle: "".tr,
                          onBackTap: () => Get.offAllNamed(AppRoutes.teamLobby),
                        ),

                        SizedBox(height: height * 0.01),

                        /// ---------- TIMER ----------
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
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
                                    'Time Limit'.tr,
                                    style: appTheme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  Obx(() {
                                    final timerController = Get.find<TeamGameTimerController>();
                                    final totalSeconds = timerController.remainingSeconds.value;
                                    final minutes = totalSeconds ~/ 60;
                                    final seconds = totalSeconds % 60;
                                    return Text(
                                      '$minutes:${seconds.toString().padLeft(2, '0')}',
                                      style: appTheme.textTheme.titleLarge?.copyWith(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.015),

                        /// ---------- CONTENT ----------
                        Column(
                          children: [
                            /// Welcome texts
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.041,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'welcome_team'.tr,
                                    style: appTheme.textTheme.headlineLarge
                                        ?.copyWith(
                                          color: AppColors.primaryRed,
                                          fontFamily: 'Gotham-Bold',
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Text(
                                    'draw_team_strategy_subtitle'.tr,
                                    style: appTheme.textTheme.bodyLarge
                                        ?.copyWith(
                                          color: AppColors.black,
                                          fontFamily: 'Gotham-Bold',
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: height * 0.025),

                            /// Cards Section
                            CustomCardPagerBuilder(controller: teamController),

                            SizedBox(height: height * 0.025),

                            /// Journey Map
                            Obx(
                              () => CustomJourneyMap(
                                progress: journeyController.progress.value,
                                steps: journeyController.steps,
                                completedSteps:
                                    journeyController.completedSteps,
                                onToggle:
                                    journeyController.toggleJourneyDetails,
                                showDetails:
                                    journeyController.showDetails.value,
                              ),
                            ),

                            SizedBox(height: height * 0.025),

                            /// Begin Mission Button
                            Obx(
                              () => Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.12,
                                  ),
                                  child: CustomButton2(
                                      text: 'begin_mission'.tr,
                                      onPressed: teamStrategySelectionController.isCardRevealed.value
                                          ? () {
                                              teamStrategySelectionController.beginMission(); 
                                          }
                                          : null,
                                  ),
                              ),
                          ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// ---------- NAVBAR ----------
              Positioned(
                right: width * -0.07000001,
                top: height * 0.50,
                child: const CustomHomeNavBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
