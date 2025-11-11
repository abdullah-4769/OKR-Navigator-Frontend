import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/journey_controller.dart';
import '../../../controllers/team_mode_controller/team_game_controller.dart';
import '../../../controllers/team_mode_controller/team_objective_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/custom_industry_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
// ... existing imports ...

class TeamObjectiveScreen extends StatelessWidget {
  TeamObjectiveScreen({super.key}) {
    // 💡 Add explicit call to fetch objectives after controller initialization
    _fetchObjectivesOnLoad();
  }

  // Use Get.put and Get.find correctly
  final TeamObjectiveController controller = Get.put(TeamObjectiveController());
  final JourneyController journeyController = Get.find<JourneyController>();
  final isChallengeMode = (Get.arguments as Map<String, dynamic>?)?['isChallengeMode'] ?? false;
  void _fetchObjectivesOnLoad() {
    // Only call fetch logic once if objectives are not loaded yet
    if (controller.objectives.isEmpty && !controller.loading.value) {
      final args = Get.arguments as Map<String, dynamic>?;
      // You must ensure these keys match what's passed from the previous screen (e.g., AssignRolesScreen's navigation)
      final Map<String, dynamic>? role = args?['selectedRole'] as Map<String, dynamic>?;
      final Map<String, dynamic>? industry = args?['selectedIndustry'] as Map<String, dynamic>?;

      // Use hardcoded placeholder values if missing, or throw error to debug navigation chain
      if (role == null || industry == null) {
          // Fallback values for testing if navigation arguments are missing
          final defaultRole = {'title': 'CEO'};
          final defaultIndustry = {'titleKey': 'Technology'};
          controller.getTeamObjectives(role: defaultRole, industry: defaultIndustry);
          
          Get.snackbar('Warning', 'Missing Role/Industry. Using default values for now.', snackPosition: SnackPosition.BOTTOM);
      } else {
        // If arguments are present, trigger the API call
        controller.getTeamObjectives(role: role, industry: industry);
      }
    }
  }

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
      journeyController.setStep(0, true);
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
                      padding: EdgeInsets.only(bottom: AppDimensions.d18.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [


                          /// -------- HEADER ----------
                          CustomHeader(
                            title: _safeTranslate('choose'),
                            highlightedText: _safeTranslate('objective'),
                            subtitle: _safeTranslate(''),
                            onBackTap:
                            ()=>Get.back(),
                          ),

                          SizedBox(height: AppDimensions.d10.h),

                          /// ---------- TIMER ----------
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

                          /// ---------- SELECTED STRATEGY CARD -----------
                          SizedBox(height: AppDimensions.d10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: CustomObjectiveContainer(
                              title: _safeTranslate('selected_strategy'),
                              subtitle:
                              _safeTranslate('development_new_markets'),
                              description:
                              _safeTranslate('objective_description'),
                              icon: Icons.emoji_objects,
                            ),
                          ),

                          SizedBox(height: AppDimensions.d20.h),

                          /// --------- TITLE ----------
                          Text(
                            _safeTranslate('choose_your_objective'),
                            style: TextStyle(
                              fontSize: AppDimensions.d22.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryRed,
                              fontFamily: 'Gotham-Bold',
                            ),
                          ),
                          SizedBox(height: AppDimensions.d6.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              _safeTranslate('select_one_objective'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppDimensions.d15.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),

                          SizedBox(height: AppDimensions.d16.h),

                          /// --------- OBJECTIVES LIST ----------
                          Obx(
  () => Column(
    children: List.generate(
      controller.objectives.length,
      (index) {
        final obj = controller.objectives[index]; // obj is Objective

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          child: CustomIndustryContainer(
            title: _safeTranslate(obj.title ?? 'Unknown'),
            description: _safeTranslate(obj.description ?? 'No description'),
            icon: Icons.star, // Default icon since API doesn’t provide one
            isSelected: controller.isSelected(obj),
            onTap: () {
              controller.selectObjective(obj);

              if (controller.isSelected(obj)) {
                journeyController.progress.value = 40;
                journeyController.completeStep(0);
              } else {
                journeyController.progress.value = 20;
                journeyController.completedSteps[0] = false;
              }
            },

            // Hide tags (Objective model doesn’t have them)
            showTag1: false,
            tag1Icon: null,
            tag1Text: null,
            showTag2: false,
            tag2Icon: null,
            tag2Text: null,
            showTag3: false,
            tag3Icon: null,
            tag3Text: null,
          ),
        );
      },
    ),
  ),
),


                          SizedBox(height: AppDimensions.d14.h),

                          /// ---------- JOURNEY MAP ----------
                          Obx(
                                () => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: CustomJourneyMap(
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
                          ),

                          SizedBox(height: AppDimensions.d24.h),

                          /// ---------- BUTTON ----------
                         Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.d40.w),
                            child: Obx(
                                  () => CustomButton2(
                                text:
                                _safeTranslate('define_key_results'),
                                onPressed: controller.isButtonEnabled
                                    ? () {
                                        // Update journey status
                                        journeyController.completeStep(0);
                                        
                                        final List<String> objectiveTitles = controller.getAllObjectiveTitles();
                                        
                                        if (isChallengeMode) {
                                            // ✅ CHALLENGE FLOW FIX: Go directly back to the screen that opened this (Contextual Challenge)
                                            Get.back(); 
                                        } else {
                                            // 1. NORMAL FLOW: Proceed to Key Results screen
                                            Get.toNamed(
                                              AppRoutes.teamKeyResultScreen,
                                              arguments: {
                                                  'objectiveTitles': objectiveTitles,
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

                /// ----------- Floating Home Nav -------------
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