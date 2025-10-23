import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/journey_controller.dart';
import '../../../controllers/team_mode_controller/team_suggestion_initiative_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_theme.dart';
import '../../routes/app_routes.dart';

import '../../widgets/custom_ai_strategy_container.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_initiative_input.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/responsive_arrow.dart';
import '../../widgets/custom_industry_container.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class TeamSuggestionInitiativesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> selectedKeyResults;

  TeamSuggestionInitiativesScreen({
    super.key,
    required this.selectedKeyResults,
  });

  final JourneyController journeyController = Get.find<JourneyController>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      TeamSuggestionInitiativesController(keyResults: selectedKeyResults),
    );

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: Stack(
            children: [
              /// Scrollable Content
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: height * 0.01),
                  child: Column(
                    children: [


                      /// ✅ Custom Header
                      CustomHeader(
                        title: 'suggestion'.tr,
                        highlightedText: 'of_initiatives'.tr,
                        showDashboardIcon: true,
                        onBackTap: () =>
                            Get.toNamed(AppRoutes.teamKeyResultScreen),
                      ),

                      SizedBox(height: height * 0.02),

                      /// ✅ Your Objective Container
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: CustomObjectiveContainer(
                          title: '',
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(AppDimensions.d8.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.rocket,
                                  color: Colors.white,
                                  size: AppDimensions.d20.sp,
                                ),
                              ),
                              SizedBox(width: AppDimensions.d10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Randomly Selected Key Result'.tr,
                                      style: appTheme.textTheme.bodyLarge?.copyWith(
                                        color: AppColors.primaryRed,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Focus your initiatives on this outcome'.tr,
                                      style: appTheme.textTheme.bodySmall?.copyWith(
                                        color: AppColors.black.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.015),
                      const ResponsiveArrow(),
                      SizedBox(height: height * 0.02),

                      /// ✅ Only One Industry Container
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Obx(() {
                          final item = controller.industries.first;
                          return CustomIndustryContainer(
                            showSelectionCircle: false,
                            title: item['title'] ?? '',
                            description: item['description'] ?? '',
                            icon: item['icon'],
                            isSelected: controller.selectedIndustry.value == 0,
                            onTap: () {
                              controller.selectedIndustry.value = 0;
                            },
                            showTag1: true,
                            tag1Icon: Icons.trending_up,
                            tag1Text: item['tag1'] ?? '',
                            showTag2: true,
                            tag2Icon: Icons.access_time,
                            tag2Text: item['tag2'] ?? '',
                          );
                        }),
                      ),

                      SizedBox(height: height * 0.02),

                      /// -------- Title ---------
                      Center(
                        child: Text(
                          'select_key_results'.tr,
                          style: appTheme.textTheme.headlineMedium?.copyWith(
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimensions.d6.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Center(
                          child: Text(
                            'choose_3_outcomes'.tr,
                            textAlign: TextAlign.center,
                            style: appTheme.textTheme.titleSmall?.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                      ),

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

                      SizedBox(height: height * 0.01),
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

                      /// Complete Button
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

              /// Home Navbar
              Positioned(
                right: width * -0.05,
                top: height * 0.5,
                child: const CustomHomeNavBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
