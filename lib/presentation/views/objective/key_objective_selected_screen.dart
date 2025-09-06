import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../controllers/journey_controller.dart';
import '../../controllers/key_objective_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/custom_industry_container.dart'; // ✅ reuse here

class KeyObjectiveSelectedScreen extends StatelessWidget {
  KeyObjectiveSelectedScreen({super.key});

  final KeyObjectiveController controller = Get.put(KeyObjectiveController());
  final JourneyController journeyController = Get.find<JourneyController>();

  @override
  Widget build(BuildContext context) {
    // ✅ mark step
    journeyController.setStep(0, true);

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // ✅ Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
                  ),
                ),
              ),
            ),

            // ✅ Scrollable Content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.d90.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: AppDimensions.d16.h),

                      // 🔹 Header
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.d0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomCurvedArrow(
                              isLeft: true,
                              onTap: () => Get.back(),
                              width: AppDimensions.d55.w,
                              height: AppDimensions.d130.h,
                            ),
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Select ',
                                      style: TextStyle(
                                        fontFamily: 'Gotham-Bold',
                                        fontSize: AppDimensions.d40.sp,
                                        color: AppColors.primaryRed,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\nObjective',
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

                      SizedBox(height: AppDimensions.d20.h),

                      // 🔹 Objectives List (✅ reused CustomIndustryContainer)
                      Obx(() {
                        return Column(
                          children: List.generate(controller.objectives.length, (index) {
                            final obj = controller.objectives[index];
                            return CustomIndustryContainer(
                              title: obj["title"],
                              description: obj["description"],
                              icon: obj["icon"],
                              isSelected: controller.isSelected(index),
                              onTap: () {
                                controller.selectObjective(index);
                                journeyController.completeStep(0);
                                journeyController.progress.value = 40;
                              },
                              showTag1: false,
                              showTag2: false,
                              showTag3: false,
                            );
                          }),
                        );
                      }),

                      SizedBox(height: AppDimensions.d24.h),

                      // 🔹 Journey Map
                      Obx(() => CustomJourneyMap(
                        progress: journeyController.progress.value,
                        steps: journeyController.steps,
                        completedSteps: journeyController.completedSteps,
                        onToggle: journeyController.toggleJourneyDetails,
                        showDetails: journeyController.showDetails.value,
                      )),

                      SizedBox(height: AppDimensions.d24.h),

                      // 🔹 Complete Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.d40.w),
                        child: Obx(
                              () => CustomButton2(
                            text: 'Complete Your Selection',
                            onPressed: controller.isButtonEnabled
                                ? () => Get.offAllNamed(AppRoutes.keyResultsScreen)
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

            // 🔹 Floating Home Button (✅ moved inside to avoid overflow)
            Positioned(
              right: screenWidth * -0.07000001, // small margin inside
              top: MediaQuery.of(context).size.height * 0.50,
              child: CustomHomeNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}
