import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/journey_controller.dart';
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

class TeamObjectiveScreen extends StatelessWidget {
  TeamObjectiveScreen({super.key});

  final TeamObjectiveController controller = Get.put(TeamObjectiveController());
  final JourneyController journeyController = Get.find<JourneyController>();

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
                                  final obj = controller.objectives[index];
                                  final titleKey = obj['titleKey'] as String?;
                                  final descriptionKey =
                                  obj['descriptionKey'] as String?;

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 12.w),
                                    child: CustomIndustryContainer(
                                      title: _safeTranslate(titleKey,
                                          fallback: 'Unknown'),
                                      description: _safeTranslate(
                                          descriptionKey,
                                          fallback: 'No description'),
                                      icon: obj['icon'] as IconData,
                                      isSelected:
                                      controller.isSelected(index),
                                      onTap: () {
                                        controller.selectObjective(index);
                                        if (controller.isSelected(index)) {
                                          journeyController.progress.value =
                                          40;
                                          journeyController.completeStep(0);
                                        } else {
                                          journeyController.progress.value =
                                          20;
                                          journeyController
                                              .completedSteps[0] = false;
                                        }
                                      },

                                      /// ✅ Pass tags from controller
                                      showTag1: obj['tags'] != null &&
                                          obj['tags'].length > 0,
                                      tag1Icon: obj['tags'] != null &&
                                          obj['tags'].length > 0
                                          ? obj['tags'][0]['icon'] as IconData?
                                          : null,
                                      tag1Text: obj['tags'] != null &&
                                          obj['tags'].length > 0
                                          ? _safeTranslate(
                                          obj['tags'][0]['textKey']
                                          as String?)
                                          : null,

                                      showTag2: obj['tags'] != null &&
                                          obj['tags'].length > 1,
                                      tag2Icon: obj['tags'] != null &&
                                          obj['tags'].length > 1
                                          ? obj['tags'][1]['icon'] as IconData?
                                          : null,
                                      tag2Text: obj['tags'] != null &&
                                          obj['tags'].length > 1
                                          ? _safeTranslate(
                                          obj['tags'][1]['textKey']
                                          as String?)
                                          : null,

                                      showTag3: obj['tags'] != null &&
                                          obj['tags'].length > 2,
                                      tag3Icon: obj['tags'] != null &&
                                          obj['tags'].length > 2
                                          ? obj['tags'][2]['icon'] as IconData?
                                          : null,
                                      tag3Text: obj['tags'] != null &&
                                          obj['tags'].length > 2
                                          ? _safeTranslate(
                                          obj['tags'][2]['textKey']
                                          as String?)
                                          : null,
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
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
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
                                    ? () => Get.toNamed(
                                  AppRoutes.teamKeyResultScreen,
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
