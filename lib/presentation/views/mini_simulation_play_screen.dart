import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../controllers/Other_screens_controllers/mini_simulation_play_controller.dart';
import '../../controllers/key_results_controller.dart';
import '../../controllers/okr_constellation_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../../core/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_home_navbar.dart';
import '../widgets/custom_industry_container.dart';
import '../widgets/custom_objective_container.dart';
import '../widgets/custom_selected_key_result_container.dart';
import '../widgets/global_widgets/custom_progress_path.dart';
import '../widgets/key_challange_card.dart';
import '../widgets/responsive_arrow.dart';
import '../widgets/scoreboard_widgets/custom_circular_timer.dart';
import '../widgets/screens_unique_parts/custom_background.dart';
import '../widgets/screens_unique_parts/custom_header.dart';

class MiniSimulationPlayScreen extends StatelessWidget {
  MiniSimulationPlayScreen({super.key});

  final MiniSimulationPlayController controller = Get.put(
    MiniSimulationPlayController(),
  );

  final OKRConstellationController constellationController = Get.put(
    OKRConstellationController(),
  );

  String _safeTranslate(String? key, {String fallback = ''}) {
    if (key == null) return fallback;
    try {
      return key.tr;
    } catch (e) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: CustomBackground(
      child: OrientationBuilder(
        builder: (context, orientation) {
          final size = MediaQuery.of(context).size;
          final isPortrait = orientation == Orientation.portrait;
          final keyResultsController = Get.find<KeyResultsController>();

          return Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: isPortrait
                        ? size.height * 0.019
                        : size.height * 0.01,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      CustomHeader(
                        title: 'OKR'.tr,
                        highlightedText: 'mini_simulation'.tr,
                        subtitle: 'solve_okr_scenario'.tr,
                        onBackTap: () => Get.back(),
                      ),

                      SizedBox(height: 16.h),

                      /// TIMER
                      Obx(
                            () => Center(
                          child: CustomCircularTimer(
                            remainingSeconds: controller.remainingSeconds.value,
                            totalSeconds: 300,
                            label: 'remaining_time',
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimensions.d8.h),
                      Center(child: const ResponsiveArrow()),
                      SizedBox(height: AppDimensions.d8.h),

                      /// OBJECTIVE
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d16.w,
                        ),
                        child: CustomObjectiveContainer(
                          icon: Icons.deblur_outlined,
                          title: 'scenario_techcorp_global'.tr,
                          //subtitle: 'key_challenge'.tr,
                          description: 'challenge_description'.tr,
                          titleColor: AppColors.black,
                        ),
                      ),
                      SizedBox(height: AppDimensions.d14.h),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: KeyChallengeCard(
                            title: "Key Challenge:",
                            description:
                            "Increase market share by 15% while improving cross-departmental efficiency by 25% within 12 months.",
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimensions.d14.h),

                      /// PROGRESS
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d16.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'your_okr_path_progress'.tr,
                              style: appTheme.textTheme.headlineLarge?.copyWith(
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: AppDimensions.d12.h),
                            Obx(
                                  () => CustomProgressPath(
                                currentStep: controller.currentStep.value,
                                stepLabels: [
                                  'strategy_selection',
                                  'objective_definition',
                                  'key_results_ca',
                                  'initiatives',
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppDimensions.d24.h),

                      /// SELECTED KEY RESULTS COUNTER
                      //  const CustomSelectedKeyResultsContainer(),
                      SizedBox(height: AppDimensions.d16.h),

                      /// KEY RESULTS GRID
// Replace this section in your MiniSimulationPlayScreen

                      /// KEY RESULTS GRID (Fixed version)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d16.w,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = 1;
                            if (constraints.maxWidth > 1200) {
                              crossAxisCount = 3;
                            } else if (constraints.maxWidth > 800) {
                              crossAxisCount = 2;
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: keyResultsController.keyResults.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: AppDimensions.d12.w,
                                mainAxisSpacing: AppDimensions.d12.h,
                                childAspectRatio: isPortrait ? 1.2 : 1.8,
                              ),
                              itemBuilder: (context, index) {
                                final item = keyResultsController.keyResults[index];

                                return Obx(
                                      () => CustomIndustryContainer(
                                    title: _safeTranslate(
                                      item['title'],
                                      fallback: 'Title',
                                    ),
                                    description: _safeTranslate(
                                      item['description'],
                                      fallback: 'Start the next to get rewarded',
                                    ),
                                    icon: item['icon'] ?? Icons.rocket,
                                    isSelected: keyResultsController.isSelected(index), // ✅ Use index
                                    onTap: () => keyResultsController.toggleSelection(index), // ✅ Use index
                                    showTag1: true,
                                    tag1Icon: Icons.trending_up,
                                    tag1Text: _safeTranslate(
                                      item['tag1'] ?? 'No tag1',
                                      fallback: '',
                                    ),
                                    showTag2: true,
                                    tag2Icon: Icons.access_time,
                                    tag2Text: _safeTranslate(
                                      item['tag2'] ?? 'No tag2',
                                      fallback: '',
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: AppDimensions.d24.h),

                      /// NAVIGATION BUTTONS
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d24.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .stretch, // makes buttons full width
                          children: [
                            CustomButton(
                              text: "back".tr,
                              onPressed: () {
                                Get.offAllNamed(AppRoutes.miniSimulationScreen);
                              },
                            ),
                            SizedBox(
                              height: AppDimensions.d16.h,
                            ), // space between buttons
                            CustomButton(
                              text: "next".tr,
                              onPressed: () {
                                Get.offAllNamed(AppRoutes.miniSimulationScreen);
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppDimensions.d8.h),
                    ],
                  ),
                ),
              ),

              /// NAVBAR
              Positioned(
                right: size.width * -0.07,
                top: size.height * 0.5,
                child: const CustomHomeNavBar(),
              ),
            ],
          );
        },
      ),
    ),
  );
}