import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/journey_controller.dart';
import '../../../controllers/key_results_controller.dart';
import '../../../controllers/okr_constellation_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_industry_container.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/custom_selected_key_result_container.dart';
import '../../widgets/custom_okr_constellation.dart';

class KeyResultsScreen extends StatelessWidget {
  KeyResultsScreen({super.key});

  final KeyResultsController keyResultsController = Get.put(
    KeyResultsController(),
  );
  final OKRConstellationController constellationController = Get.put(
    OKRConstellationController(),
  );
  final JourneyController journeyController = Get.find<JourneyController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      journeyController.completeStep(0);
      journeyController.setStep(1, true);
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
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
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: AppDimensions.d90.h),
                      child: Column(
                        children: [
                          SizedBox(height: AppDimensions.d16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.d1.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomCurvedArrow(
                                  isLeft: true,
                                  onTap: () => Get.offAllNamed(
                                    AppRoutes.keyObjectiveScreen,
                                  ),
                                  width: AppDimensions.d55.w,
                                  height: AppDimensions.d130.h,
                                ),
                                Expanded(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'select'.tr + ' ',
                                          style: TextStyle(
                                            fontFamily: 'Gotham-Bold',
                                            fontSize: AppDimensions.d40.sp,
                                            color: AppColors.primaryRed,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n${'key_results'.tr}',
                                          style: TextStyle(
                                            fontFamily: 'Gotham-Bold',
                                            fontSize: AppDimensions.d26.sp,
                                            color: AppColors.primaryBlue,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: AppDimensions.d22.r,
                                  backgroundColor: AppColors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(2.r),
                                    child: CustomSvg(
                                      assetPath: 'assets/images/solo.svg',
                                      semanticsLabel: 'profile',
                                      height: AppDimensions.d60.h,
                                      width: AppDimensions.d60.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppDimensions.d10.h),
                           CustomObjectiveContainer(
                            title: 'selected_objective'.tr,
                            subtitle: 'launch_2_products'.tr,
                            description: 'objective_description'.tr,
                          ),
                          SizedBox(height: AppDimensions.d20.h),
                          const CustomSelectedKeyResultsContainer(),
                          SizedBox(height: AppDimensions.d20.h),
                          Text(
                            'select_key_results'.tr,
                            style: TextStyle(
                              fontSize: AppDimensions.d20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryRed,
                              fontFamily: 'Gotham-Bold',
                            ),
                          ),
                          Text(
                            'choose_3_outcomes'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppDimensions.d15.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: AppDimensions.d20.h),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: keyResultsController.keyResults.length,
                              itemBuilder: (context, index) {
                                final item =
                                keyResultsController.keyResults[index];
                                return Obx(
                                      () => CustomIndustryContainer(
                                    title: item['title']?.tr,
                                    description: item['description']?.tr,
                                    icon: Icons.rocket,
                                    isSelected: keyResultsController.isSelected(
                                      index,
                                    ),
                                    onTap: () {
                                      keyResultsController.toggleSelection(
                                        index,
                                      );

                                      final icon = item['icon'];
                                      if (keyResultsController.isSelected(
                                        index,
                                      )) {
                                        constellationController.addIcon(icon);
                                      } else {
                                        constellationController.removeIcon(
                                          icon,
                                        );
                                      }
                                    },
                                    showTag1: true,
                                    tag1Icon: Icons.trending_up,
                                    tag1Text: item['tag1']?.tr,
                                    showTag2: true,
                                    tag2Icon: Icons.access_time,
                                    tag2Text: item['tag2']?.tr,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: AppDimensions.d24.h),
                          const CustomOKRConstellation(),
                          SizedBox(height: AppDimensions.d24.h),
                          Obx(
                                () => CustomJourneyMap(
                              progress: journeyController.progress.value,
                              steps: journeyController.steps,
                              completedSteps: journeyController.completedSteps,
                              onToggle: journeyController.toggleJourneyDetails,
                              showDetails: journeyController.showDetails.value,
                            ),
                          ),
                          SizedBox(height: AppDimensions.d24.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.d40.w,
                            ),
                            child: Obx(
                                  () => CustomButton2(
                                text: 'complete_selection'.tr,
                                onPressed:
                                keyResultsController.selectedCount.value ==
                                    keyResultsController.requiredCount.value
                                    ? () {
                                  journeyController.completeStep(2);
                                  Get.offAllNamed(
                                    AppRoutes
                                        .suggestionInitiativeScreen,
                                  );
                                }
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(height: AppDimensions.d20.h),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: screenWidth * -0.07000001,
                  top: screenHeight * 0.50,
                  child: const CustomHomeNavBar(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
