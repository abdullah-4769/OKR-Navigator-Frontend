// lib/presentation/views/team_mode/team_suggestion_initiatives_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/journey_controller.dart';
import '../../../controllers/team_mode_controller/team_game_controller.dart';
import '../../../controllers/team_mode_controller/team_suggestion_initiative_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../../generated/models/responses/key_results/key_results_response.dart' hide Text;

import '../../widgets/custom_ai_strategy_container.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_initiative_input.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/responsive_arrow.dart';
import '../../widgets/custom_industry_container.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class TeamSuggestionInitiativesScreen extends StatelessWidget {

  TeamSuggestionInitiativesScreen({
    super.key, required List selectedKeyResults,
  }) {
    // 1. Retrieve arguments immediately when the screen widget is instantiated
    final args = Get.arguments as Map<String, dynamic>?;
    final List<KeyResult> selectedKeyResults = (args?['selectedKeyResults'] as List<KeyResult>?) ?? [];

    // 2. Initialize controller with retrieved arguments using Get.put
    Get.put(TeamSuggestionInitiativesController(keyResults: selectedKeyResults));
  }


  final JourneyController journeyController = Get.find<JourneyController>();

  // Get controller instance once it's been initialized in the constructor
  TeamSuggestionInitiativesController get controller => Get.find<TeamSuggestionInitiativesController>();

  // ✅ FIX: Helper function to safely handle translation keys and raw strings
  String _safeTranslate(String? text, {String fallback = ''}) {
    if (text == null || text.isEmpty) return fallback;
    try {
      // If the string contains spaces, assume it's a raw string from the API and return it directly.
      if (text.contains(' ')) return text;
      return text.tr;
    } catch (e) {
      return text; // Fallback to raw string if translation fails
    }
  }


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Defensive check for Key Results data
    if (controller.keyResults.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Error", "Key Results data is missing. Navigating back.");
        Get.offNamed(AppRoutes.teamKeyResultScreen);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Defensive access to the first KR for the header container title
    final firstKeyResult = controller.keyResults.first;
    final firstKRTitle = _safeTranslate(firstKeyResult.title, fallback: 'Focus on Key Result');
    final firstKRDescription = _safeTranslate(firstKeyResult.description, fallback: 'Detail not available');


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

                      /// ✅ TIMER
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
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
                                  style: appTheme.textTheme.bodyMedium?.copyWith(
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
                                    style: appTheme.textTheme.titleLarge?.copyWith(
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
                                      // ✅ FIXED: Using safe translated title
                                      firstKRTitle,
                                      style: appTheme.textTheme.bodyLarge?.copyWith(
                                        color: AppColors.primaryRed,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      // ✅ FIXED: Using safe translated description
                                      firstKRDescription,
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

                      /// ✅ Key Results List (Used as Industries/Context)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Obx(() {
                          // Display all selected Key Results as context containers
                          if (controller.industries.isEmpty) return const SizedBox.shrink();

                          return Column(
                            children: controller.keyResults.map((kr) => Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: CustomIndustryContainer(
                                showSelectionCircle: false,
                                // ✅ FIXED: Using safe translate for KR titles and descriptions
                                title: _safeTranslate(kr.title),
                                description: _safeTranslate(kr.description),
                                icon: Icons.key,
                                isSelected: false,
                                onTap: () {},
                                showTag1: true,
                                tag1Icon: Icons.trending_up,
                                tag1Text: 'Goal'.tr,
                                showTag2: true,
                                tag2Icon: Icons.access_time,
                                tag2Text: 'Timeframe'.tr,
                              ),
                            )).toList(),
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
                            onPressed: controller.isButtonEnabled
                                ? () => controller.submitInitiatives()
                                : null,
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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../controllers/journey_controller.dart';
// import '../../../controllers/team_mode_controller/team_game_controller.dart';
// import '../../../controllers/team_mode_controller/team_suggestion_initiative_controller.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
// import '../../../core/app_theme.dart';
// import '../../routes/app_routes.dart';
// import '../../../generated/models/responses/key_results/key_results_response.dart' hide Text;
//
// import '../../widgets/custom_ai_strategy_container.dart';
// import '../../widgets/custom_button2.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/custom_initiative_input.dart';
// import '../../widgets/custom_journey_map.dart';
// import '../../widgets/responsive_arrow.dart';
// import '../../widgets/custom_industry_container.dart';
// import '../../widgets/custom_objective_container.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
//
// class TeamSuggestionInitiativesScreen extends StatelessWidget {
//
//   TeamSuggestionInitiativesScreen({
//     super.key, required List selectedKeyResults,
//   }) {
//     // 1. Retrieve arguments immediately when the screen widget is instantiated
//     final args = Get.arguments as Map<String, dynamic>?;
//     final List<KeyResult> selectedKeyResults = (args?['selectedKeyResults'] as List<KeyResult>?) ?? [];
//
//     // 2. Initialize controller with retrieved arguments using Get.put
//     Get.put(TeamSuggestionInitiativesController(keyResults: selectedKeyResults));
//   }
//
//
//   final JourneyController journeyController = Get.find<JourneyController>();
//
//   // Get controller instance once it's been initialized in the constructor
//   TeamSuggestionInitiativesController get controller => Get.find<TeamSuggestionInitiativesController>();
//
//   // ✅ FIX: Helper function to safely handle translation keys and raw strings
//   String _safeTranslate(String? text, {String fallback = ''}) {
//     if (text == null || text.isEmpty) return fallback;
//     try {
//       // If the text contains spaces, assume it's a raw string from the API and return it directly.
//       if (text.contains(' ')) return text;
//       return text.tr;
//     } catch (e) {
//       return text; // Fallback to raw string if translation fails
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
//
//     // Defensive check for Key Results data
//     if (controller.keyResults.isEmpty) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//             Get.snackbar("Error", "Key Results data is missing. Navigating back.");
//             Get.offNamed(AppRoutes.teamKeyResultScreen);
//         });
//         return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//
//     // Defensive access to the first KR for the header container title
//     final firstKeyResult = controller.keyResults.first;
//     final firstKRTitle = _safeTranslate(firstKeyResult.title, fallback: 'Focus on Key Result');
//     final firstKRDescription = _safeTranslate(firstKeyResult.description, fallback: 'Detail not available');
//
//
//     return Scaffold(
//       body: CustomBackground(
//         child: SafeArea(
//           child: Stack(
//             children: [
//               /// Scrollable Content
//               Positioned.fill(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: EdgeInsets.only(bottom: height * 0.01),
//                   child: Column(
//                     children: [
//
//
//                       /// ✅ Custom Header
//                       CustomHeader(
//                         title: 'suggestion'.tr,
//                         highlightedText: 'of_initiatives'.tr,
//                         showDashboardIcon: true,
//                         onBackTap: () =>
//                             Get.toNamed(AppRoutes.teamKeyResultScreen),
//                       ),
//
//                       SizedBox(height: height * 0.02),
//
//                       /// ✅ TIMER
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: width * 0.06),
//                         child: CustomObjectiveContainer(
//                           title: '',
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: AppDimensions.d16.w,
//                               vertical: AppDimensions.d8.h,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Time Limit'.tr,
//                                   style: appTheme.textTheme.bodyMedium?.copyWith(
//                                     color: AppColors.grey,
//                                   ),
//                                 ),
//                                 Obx(() {
//                                   final timerController = Get.find<TeamGameTimerController>();
//                                   final totalSeconds = timerController.remainingSeconds.value;
//                                   final minutes = totalSeconds ~/ 60;
//                                   final seconds = totalSeconds % 60;
//                                   return Text(
//                                     '$minutes:${seconds.toString().padLeft(2, '0')}',
//                                     style: appTheme.textTheme.titleLarge?.copyWith(
//                                       color: AppColors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   );
//                                 }),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(height: height * 0.02),
//
//                       /// ✅ Your Objective Container
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: width * 0.06),
//                         child: CustomObjectiveContainer(
//                           title: '',
//                           child: Row(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.all(AppDimensions.d8.w),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.primaryRed,
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withValues(alpha: 0.15),
//                                       blurRadius: 6,
//                                       offset: const Offset(0, 3),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Icon(
//                                   Icons.rocket,
//                                   color: Colors.white,
//                                   size: AppDimensions.d20.sp,
//                                 ),
//                               ),
//                               SizedBox(width: AppDimensions.d10.w),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       // ✅ FIXED: Using safe translated title
//                                       firstKRTitle,
//                                       style: appTheme.textTheme.bodyLarge?.copyWith(
//                                         color: AppColors.primaryRed,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4.h),
//                                     Text(
//                                       // ✅ FIXED: Using safe translated description
//                                       firstKRDescription,
//                                       style: appTheme.textTheme.bodySmall?.copyWith(
//                                         color: AppColors.black.withValues(alpha: 0.7),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(height: height * 0.015),
//                       const ResponsiveArrow(),
//                       SizedBox(height: height * 0.02),
//
//                       /// ✅ Key Results List (Used as Industries/Context)
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.w),
//                         child: Obx(() {
//                           // Display all selected Key Results as context containers
//                           if (controller.industries.isEmpty) return const SizedBox.shrink();
//
//                           return Column(
//                             children: controller.keyResults.map((kr) => Padding(
//                               padding: EdgeInsets.only(bottom: 8.h),
//                               child: CustomIndustryContainer(
//                                 showSelectionCircle: false,
//                                 // ✅ FIXED: Using safe translate for KR titles and descriptions
//                                 title: _safeTranslate(kr.title),
//                                 description: _safeTranslate(kr.description),
//                                 icon: Icons.key,
//                                 isSelected: false,
//                                 onTap: () {},
//                                 showTag1: true,
//                                 tag1Icon: Icons.trending_up,
//                                 tag1Text: 'Goal'.tr,
//                                 showTag2: true,
//                                 tag2Icon: Icons.access_time,
//                                 tag2Text: 'Timeframe'.tr,
//                               ),
//                             )).toList(),
//                           );
//                         }),
//                       ),
//
//                       SizedBox(height: height * 0.02),
//
//                       /// -------- Title ---------
//                       Center(
//                         child: Text(
//                           'select_key_results'.tr,
//                           style: appTheme.textTheme.headlineMedium?.copyWith(
//                             color: AppColors.primaryRed,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: AppDimensions.d6.h),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 8.w),
//                         child: Center(
//                           child: Text(
//                             'choose_3_outcomes'.tr,
//                             textAlign: TextAlign.center,
//                             style: appTheme.textTheme.titleSmall?.copyWith(
//                               color: AppColors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       /// Initiative Inputs
//                       CustomInitiativeInput(
//                         numberText: 'first_initiative'.tr,
//                         titleController: controller.firstInitiativeTitle,
//                         descController: controller.firstInitiativeDesc,
//                       ),
//                       CustomInitiativeInput(
//                         numberText: 'second_initiative'.tr,
//                         titleController: controller.secondInitiativeTitle,
//                         descController: controller.secondInitiativeDesc,
//                       ),
//
//                       SizedBox(height: height * 0.01),
//                       const CustomAIStrategyContainer(),
//                       SizedBox(height: height * 0.03),
//
//                       /// Journey Map
//                       Obx(
//                             () => CustomJourneyMap(
//                           progress: journeyController.progress.value,
//                           steps: journeyController.steps,
//                           completedSteps: journeyController.completedSteps,
//                           onToggle: journeyController.toggleJourneyDetails,
//                           showDetails: journeyController.showDetails.value,
//                         ),
//                       ),
//
//                       SizedBox(height: height * 0.03),
//
//                       /// Complete Button
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: AppDimensions.d40.w,
//                         ),
//                         child: Obx(
//                               () => CustomButton2(
//                             text: controller.isSubmitting.value
//                                 ? 'submitting'.tr
//                                 : 'submit_analysis'.tr,
//                            onPressed: controller.isButtonEnabled
//                             ? () => controller.submitInitiatives()
//                             : null,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: height * 0.03),
//                     ],
//                   ),
//                 ),
//               ),
//
//               /// Home Navbar
//               Positioned(
//                 right: width * -0.05,
//                 top: height * 0.5,
//                 child: const CustomHomeNavBar(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }