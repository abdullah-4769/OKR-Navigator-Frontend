import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/journey_controller.dart';
import '../../../controllers/suggestion_initiatives_ontroller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';

import '../../widgets/custom_ai_strategy_container.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_initiative_input.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_svg.dart';

class SuggestionInitiativesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> selectedKeyResults;

  SuggestionInitiativesScreen({super.key, required this.selectedKeyResults});

  final JourneyController journeyController = Get.find<JourneyController>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      SuggestionInitiativesController(keyResults: selectedKeyResults),
    );

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
                padding: EdgeInsets.only(bottom: height * 0.15),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.02),

                    /// Header: Curved Arrow + Heading + Person Dashboard
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.00),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomCurvedArrow(
                            isLeft: true,
                            onTap: () =>
                                Get.offAllNamed(AppRoutes.keyResultsScreen),
                            width: width * 0.15,
                            height: height * 0.18,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'suggestion'.tr,
                                        style: TextStyle(
                                          fontFamily: 'Gotham-Bold',
                                          fontSize: width * 0.09,
                                          color: AppColors.primaryRed,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nof_initiatives'.tr,
                                        style: TextStyle(
                                          fontFamily: 'Gotham-Bold',
                                          fontSize: width * 0.06,
                                          color: AppColors.primaryBlue,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                Text(
                                  'add_initiatives_subtitle'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: width * 0.035,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: width * 0.06,
                            backgroundColor: AppColors.white,
                            child: Padding(
                              padding: EdgeInsets.all(width * 0.01),
                              child: CustomSvg(
                                assetPath: 'assets/images/solo.svg',
                                semanticsLabel: 'profile'.tr,
                                height: width * 0.12,
                                width: width * 0.12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: height * 0.025),

                    /// Initiative Inputs
                    CustomInitiativeInput(
                      numberText: 'first_initiative'.tr,
                      titleController: controller.firstInitiativeTitle,
                      descController: controller.firstInitiativeDesc,
                    ),
                    CustomInitiativeInput(
                      numberText: 'second_initiative'.tr,
                      titleController: controller.secondInitiativeTitle,
                      descController: controller.secondInitiativeDesc,
                    ),

                    SizedBox(height: height * 0.03),

                    const CustomAIStrategyContainer(),

                    SizedBox(height: height * 0.03),

                    /// Journey Map
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
                    // Complete Button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.d40.w,
                      ),
                      child: Obx(
                            () => CustomButton2(
                          text: controller.isSubmitting.value
                              ? 'submitting'.tr
                              : 'submit_analysis'.tr,
                          onPressed: controller.isSubmitting.value
                              ? null
                              : () => controller.submitInitiatives(),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ),

            /// Home Navbar (Always at top right)
            Positioned(
              right: width * -0.05,
              top: height * 0.5,
              child: const CustomHomeNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}
