import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/journey_controller.dart';
import '../../../controllers/strategy_selection_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_cards_pagebuilder.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_svg.dart';

class StrategySelectionScreen extends StatelessWidget {
  StrategySelectionScreen({super.key});

  final journeyController = Get.find<JourneyController>();
  final controller = Get.find<StrategySelectionController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.backgroundTop,
                      AppColors.backgroundBottom,
                    ],
                  ),
                ),
              ),
            ),

            // Scrollable Content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.d90.h),
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.02),

                      // Main Heading
                      Padding(
                        padding: EdgeInsets.only(bottom: height * 0.10),
                        child: Column(
                          children: [
                            // Header
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.00,
                                vertical: height * 0.015,
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: CustomCurvedArrow(
                                      isLeft: true,
                                      onTap: () => Get.offAllNamed(
                                        AppRoutes.chooseIndustry,
                                      ),
                                      width: width * 0.15,
                                      height: height * 0.18,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        SizedBox(height: height * 0.005),
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'select'.tr,
                                                style: TextStyle(
                                                  fontFamily: 'Gotham-Bold',
                                                  fontSize: (width * 0.09).sp,
                                                  color: AppColors.primaryRed,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '\nstrategy'.tr,
                                                style: TextStyle(
                                                  fontFamily: 'Gotham-Bold',
                                                  fontSize: (width * 0.06).sp,
                                                  color: AppColors.primaryBlue,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: CircleAvatar(
                                      radius: width * 0.06,
                                      backgroundColor: AppColors.white,
                                      child: Padding(
                                        padding: EdgeInsets.all(width * 0.01),
                                        child: CustomSvg(
                                          assetPath: 'assets/images/solo.svg',
                                          semanticsLabel: 'profile'.tr,
                                          height: height * 0.06,
                                          width: width * 0.06,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.02),

                            // Welcome Text
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.08,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'draw_strategy'.tr,
                                    style: TextStyle(
                                      fontFamily: 'Gotham-Bold',
                                      fontSize: (width * 0.055).sp,
                                      color: AppColors.primaryRed,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Text(
                                    'draw_strategy_subtitle'.tr,
                                    style: TextStyle(
                                      fontSize: (width * 0.035).sp,
                                      color: AppColors.textSecondary,
                                      fontFamily: 'Gotham',
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: height * 0.03),

                            // Cards Section
                            CustomCardPagerBuilder(),

                            SizedBox(height: height * 0.03),

                            // Journey Map
                            Obx(
                                  () => CustomJourneyMap(
                                progress: journeyController.progress.value,
                                steps: journeyController.steps,
                                completedSteps: journeyController.completedSteps,
                                onToggle: journeyController.toggleJourneyDetails,
                                showDetails: journeyController.showDetails.value,
                              ),
                            ),

                            SizedBox(height: height * 0.03),

                            // Begin Mission Button
                            Obx(
                                  () => Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.12,
                                ),
                                child: CustomButton2(
                                  text: 'begin_mission'.tr,
                                  onPressed: controller.isCardRevealed.value
                                      ? () {
                                    journeyController.setStep(0, true);
                                    controller.beginMission();
                                  }
                                      : null,
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.03),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              right: width * -0.07000001,
              top: height * 0.50,
              child: const CustomHomeNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}
