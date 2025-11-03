import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/journey_controller.dart';
import '../../../controllers/okr_constellation_controller.dart';
import '../../../controllers/team_mode_controller/team_game_controller.dart';
import '../../../controllers/team_mode_controller/team_key_results_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_industry_container.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_okr_constellation.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/team_mode_widgets/selected_custom_keyresults-Container.dart';

class TeamKeyResultsScreen extends StatelessWidget {
  TeamKeyResultsScreen({super.key});

  final TeamKeyResultsController controller = Get.put(TeamKeyResultsController());
  final OKRConstellationController constellationController = Get.put(OKRConstellationController());
  final JourneyController journeyController = Get.isRegistered<JourneyController>()
      ? Get.find<JourneyController>()
      : Get.put(JourneyController());
final isChallengeMode = (Get.arguments as Map<String, dynamic>?)?['isChallengeMode'] ?? false;
  String _safeTranslate(String? key, {String fallback = ''}) {
    if (key == null) return fallback;
    try {
      return key.tr;
    } catch (e) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      journeyController.completeStep(1);
      journeyController.setStep(2, true);
      controller.fetchKeyResults(); 
    });

    final screenWidth = MediaQuery.of(context).size.width;

    return OrientationBuilder(
      builder: (context, orientation) => Scaffold(
        body: CustomBackground(
          child: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: AppDimensions.d20.h),
                      child: Column(
                        children: [

                          /// -------- HEADER ----------
                             CustomHeader(
                              title: _safeTranslate('select'),
                              highlightedText: _safeTranslate('key_results'),
                              subtitle: '',
                              onBackTap: () => Get.offAllNamed(
                                AppRoutes.teamObjectiveSelectionScreen,
                              ),
                            ),

                          SizedBox(height: AppDimensions.d10.h),

                          /// -------- TIMER ---------
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

                          SizedBox(height: AppDimensions.d10.h),

                          /// -------- Selected Objective ---------
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: CustomObjectiveContainer(
                              icon: Icons.rocket,
                              title: _safeTranslate('selected_objective'),
                              subtitle: _safeTranslate('launch_2_products'),
                              description: _safeTranslate('objective_description'),
                            ),
                          ),

                          SizedBox(height: AppDimensions.d16.h),

                          /// -------- Selected Count ---------
                          const CustomSelectedTeamKeyResultsContainer(),

                          SizedBox(height: AppDimensions.d14.h),

                          /// -------- Title ---------
                          Center(
                            child: Text(
                              _safeTranslate('select_key_results'),
                              style: TextStyle(
                                fontSize: AppDimensions.d22.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryRed,
                                fontFamily: 'Gotham-Bold',
                              ),
                            ),
                          ),
                          SizedBox(height: AppDimensions.d6.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Center(
                              child: Text(
                                _safeTranslate('choose_3_outcomes'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: AppDimensions.d15.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: AppDimensions.d16.h),

                          /// -------- KEY RESULTS LIST ---------
                        Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Obx(
                          () => Column(
                            children: List.generate(
                              controller.keyResults.length,
                              (index) {
                                final item = controller.keyResults[index];

                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: CustomIndustryContainer(
                                    title: item.title ?? 'Title',
                                    description: item.description ?? 'We will have to take that challenge carefully',
                                    icon: Icons.key, // replace with proper icon if needed
                                    isSelected: controller.isSelected(index),
                                    onTap: () {
                                      controller.toggleSelection(index);
                                      final icon = Icons.key; // replace with real icon if you have one
                                      if (controller.isSelected(index)) {
                                        constellationController.addIcon(icon);
                                      } else {
                                        constellationController.removeIcon(icon);
                                      }
                                    },
                                    showTag1: false, // if you have tag data, handle separately
                                    tag1Icon: null,
                                    tag1Text: null,
                                    showTag2: false,
                                    tag2Icon: null,
                                    tag2Text: null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                          SizedBox(height: AppDimensions.d20.h),

                          /// -------- CONSTELLATION ---------
                          const CustomOKRConstellation(),

                          SizedBox(height: AppDimensions.d20.h),

                          /// -------- JOURNEY MAP ---------
                          Obx(
                                () => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: CustomJourneyMap(
                                progress: journeyController.progress.value,
                                steps: journeyController.steps,
                                completedSteps: journeyController.completedSteps,
                                onToggle: journeyController.toggleJourneyDetails,
                                showDetails: journeyController.showDetails.value,
                              ),
                            ),
                          ),

                          SizedBox(height: AppDimensions.d24.h),

                          /// -------- BUTTON ---------
                       Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: Obx(
                                  () => CustomButton2(
                                text: _safeTranslate('complete_selection'),
                                onPressed: controller.selectedCount.value ==
                                    controller.requiredCount.value
                                    ? () {
                                  journeyController.completeStep(3); // Update progress status
                                  
                                  final selectedResults = controller.getSelectedKeyResults();
                                  
                                  if (isChallengeMode) {
                                      // ✅ CHALLENGE FLOW FIX: Go directly back to Contextual Challenge screen
                                      Get.back();
                                  } else {
                                      // NORMAL FLOW: Proceed to Initiatives screen
                                      Get.toNamed(
                                        AppRoutes.teamSuggestionInitiativeScreen,
                                        arguments: {
                                            'selectedKeyResults': selectedResults,
                                        }
                                      );
                                  }
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

                /// -------- Floating Nav --------
                Positioned(
                  right: screenWidth * -0.07000001,
                  top: MediaQuery.of(context).size.height * 0.50,
                  child: const CustomHomeNavBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
