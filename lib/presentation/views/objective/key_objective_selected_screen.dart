import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/journey_controller.dart';
import '../../../controllers/key_objective_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/custom_industry_container.dart';

class KeyObjectiveSelectedScreen extends StatelessWidget {
  KeyObjectiveSelectedScreen({super.key});

  final KeyObjectiveController controller = Get.put(KeyObjectiveController());
  final JourneyController journeyController = Get.find<JourneyController>();

  @override
  Widget build(BuildContext context) {
    journeyController.setStep(0, true);

    final screenWidth = MediaQuery.of(context).size.width;

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
                          horizontal: AppDimensions.d0.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomCurvedArrow(
                              isLeft: true,
                              onTap: () =>
                                  Get.offAllNamed(AppRoutes.selectStrategy),
                              width: AppDimensions.d55.w,
                              height: AppDimensions.d130.h,
                            ),
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'choose'.tr + ' ',
                                      style: TextStyle(
                                        fontFamily: 'Gotham-Bold',
                                        fontSize: AppDimensions.d40.sp,
                                        color: AppColors.primaryRed,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\n${'objective'.tr}',
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
                       CustomObjectiveContainer(
                        title: 'selected_strategy'.tr,
                        subtitle: 'development_new_markets'.tr,
                        description: 'objective_description'.tr,
                        icon: Icons.emoji_objects,
                      ),
                      SizedBox(height: AppDimensions.d20.h),
                      Text(
                        'choose_your_objective'.tr,
                        style: TextStyle(
                          fontSize: AppDimensions.d20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryRed,
                          fontFamily: 'Gotham-Bold',
                        ),
                      ),
                      Text(
                        'select_one_objective'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppDimensions.d15.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppDimensions.d10.h),
                      Obx(
                            () => Column(
                          children: List.generate(
                            controller.objectives.length,
                                (index) {
                              final obj = controller.objectives[index];
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CustomIndustryContainer(
                                  title: obj['title']?.tr,
                                  description: obj['description']?.tr,
                                  icon: obj['icon'],
                                  isSelected: controller.isSelected(index),
                                  onTap: () {
                                    controller.selectObjective(index);
                                    journeyController.completeStep(0);
                                    journeyController.progress.value = 40;
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
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
                            onPressed: controller.isButtonEnabled
                                ? () => Get.offAllNamed(
                              AppRoutes.keyResultsScreen,
                            )
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
              top: MediaQuery.of(context).size.height * 0.50,
              child: const CustomHomeNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}
