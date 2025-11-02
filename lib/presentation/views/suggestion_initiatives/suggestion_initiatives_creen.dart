import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/journey_controller.dart';
import '../../../controllers/key_results_controller.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_colors.dart';
import '../../../generated/models/responses/ai_analysis_model/suggetive_initiative_viewmodel.dart';
import '../../../generated/models/responses/key_results/key_results_response.dart' hide Text;
import '../../routes/app_routes.dart';
import '../../widgets/custom_ai_strategy_container.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_initiative_input.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class SuggestionInitiativesScreen extends StatelessWidget {
  final List<KeyResult> selectedKeyResults;

  SuggestionInitiativesScreen({super.key, required this.selectedKeyResults});

  final JourneyController journeyController = Get.find<JourneyController>();
  final viewModel = Get.put(SuggestionInitiativesViewModel());

  // ✅ Track source
  final bool _isModifyFromContextual = Get.parameters['source'] == 'contextual_challenge';
  final bool _isNormalFlow = !Get.parameters.containsKey('source');

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Get a random key result from the selected ones
    final randomKeyResult = _getRandomKeyResult();

    print('🎯 Initiatives Screen Source:');
    print('   - Modify from Contextual: $_isModifyFromContextual');
    print('   - Normal Flow: $_isNormalFlow');

    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: AppDimensions.d18.h),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.03),

                      // ✅ DYNAMIC HEADER BASED ON SOURCE
                      CustomHeader(
                        title: _getHeaderTitle(),
                        highlightedText: _getHeaderHighlight(),
                        onBackTap: () {
                          if (_isModifyFromContextual) {
                            // Return to contextual challenge screen
                            Get.back();
                          } else {
                            // Normal navigation back
                            Get.back();
                          }
                        },
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // /// ✅ UPDATED: Show ALL Selected Key Results (not just one)
                      // if (_isNormalFlow) ...[
                      //   _buildAllKeyResultsSection(screenWidth),
                      //   SizedBox(height: screenHeight * 0.02),
                      // ],

                      /// ✅ UPDATED: Only show random key result for normal flow
                      if (_isNormalFlow) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getHorizontalPadding(screenWidth),
                          ),
                          child: CustomObjectiveContainer(
                            icon: Icons.flag,
                            title: 'selected_key_result'.tr,
                            subtitle: randomKeyResult?.title?.tr ?? 'Add Suggestions to Continue',
                            description: randomKeyResult?.description?.tr ?? '',
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ],

                      /// ✅ UPDATED: Show different initiative inputs based on source
                      if (_isModifyFromContextual) ...[
                        // For contextual challenge - show user's existing initiatives
                        _buildContextualInitiativeInputs(),
                      ] else ...[
                        // For normal flow - show normal initiative inputs
                        CustomInitiativeInput(
                          numberText: 'first_initiative'.tr,
                          titleController: viewModel.firstInitiativeTitle,
                          descController: viewModel.firstInitiativeDesc,
                        ),
                        CustomInitiativeInput(
                          numberText: 'second_initiative'.tr,
                          titleController: viewModel.secondInitiativeTitle,
                          descController: viewModel.secondInitiativeDesc,
                        ),

                        // ✅ ADDED: Hint for 3rd initiative in adaptation screen
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding(screenWidth)),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 20.w),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    'hint_third_initiative_adaptation'.tr,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.primaryBlue,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppDimensions.d12.h),
                      ],

                      SizedBox(height: AppDimensions.d12.h),
                      const CustomAIStrategyContainer(),

                      SizedBox(height: AppDimensions.d28.h),

                      // ✅ HIDE JOURNEY MAP FOR MODIFICATION FLOW
                      if (!_isModifyFromContextual) ...[
                        Obx(
                              () => CustomJourneyMap(
                            progress: journeyController.progress.value,
                            steps: journeyController.steps,
                            completedSteps: journeyController.completedSteps,
                            onToggle: journeyController.toggleJourneyDetails,
                            showDetails: journeyController.showDetails.value,
                          ),
                        ),
                        SizedBox(height: AppDimensions.d28.h),
                      ],

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.d40.w),
                        child: Obx(
                              () => CustomButton2(
                            text: _getButtonText(viewModel.isSubmitting.value),
                            onPressed: viewModel.isSubmitting.value
                                ? () {}
                                : () => _handleSubmit(viewModel),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimensions.d28.h),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: screenWidth * -0.07,
                top: screenHeight * 0.50,
                child: const CustomHomeNavBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ NEW: Build section to show ALL selected key results
  Widget _buildAllKeyResultsSection(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding(screenWidth)),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag, color: AppColors.primaryRed, size: 20.w),
                SizedBox(width: 8.w),
                Text(
                  'selected_key_results'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${selectedKeyResults.length}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Show all selected key results
            ...selectedKeyResults.take(3).map((keyResult) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 12.w),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          keyResult.title?.tr ?? 'No Title',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (keyResult.description != null) ...[
                          SizedBox(height: 4.h),
                          Text(
                            keyResult.description!.tr,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            )).toList(),

            // Show message if there are more than 3
            if (selectedKeyResults.length > 3) ...[
              SizedBox(height: 8.h),
              Text(
                '+ ${selectedKeyResults.length - 3} more key results selected',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// ✅ NEW: Build initiative inputs for contextual challenge flow
  Widget _buildContextualInitiativeInputs() {
    return Column(
      children: [
        // Show message that user is viewing existing initiatives
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding(MediaQuery.of(Get.context!).size.width)),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.visibility, color: AppColors.primaryBlue, size: 20.w),
                    SizedBox(width: 12.w),
                    Text(
                      'viewing_existing_initiatives'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'hint_third_initiative_adaptation'.tr,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Show user's existing initiatives (read-only or editable based on your needs)
        CustomInitiativeInput(
          numberText: 'first_initiative'.tr,
          titleController: viewModel.firstInitiativeTitle,
          descController: viewModel.firstInitiativeDesc,
          isEnabled: false, // Make read-only for viewing
        ),
        CustomInitiativeInput(
          numberText: 'second_initiative'.tr,
          titleController: viewModel.secondInitiativeTitle,
          descController: viewModel.secondInitiativeDesc,
          isEnabled: false, // Make read-only for viewing
        ),
      ],
    );
  }

  // ✅ DYNAMIC HEADER & MESSAGES BASED ON SOURCE
  String _getHeaderTitle() {
    if (_isModifyFromContextual) {
      return 'review'.tr; // Changed from 'revise' to 'review'
    }
    return 'suggestion'.tr;
  }

  String _getHeaderHighlight() {
    if (_isModifyFromContextual) {
      return 'initiatives'.tr;
    }
    return 'of_initiatives'.tr;
  }

  // ✅ Get appropriate button text
  String _getButtonText(bool isSubmitting) {
    if (isSubmitting) {
      return 'submitting'.tr;
    }
    if (_isModifyFromContextual) {
      return 'continue_to_adaptation'.tr; // Changed text
    }
    return 'submit_analysis'.tr;
  }

  // ✅ Handle submission based on source
  void _handleSubmit(SuggestionInitiativesViewModel viewModel) {
    if (_isModifyFromContextual) {
      // For contextual challenge - just navigate to adaptation screen
      Get.toNamed(AppRoutes.contextualChallenge); // Replace with your adaptation screen route
    } else {
      // Normal submission flow
      viewModel.submitInitiatives(selectedKeyResults);
    }
  }

  /// Get a random key result from the selected ones
  KeyResult? _getRandomKeyResult() {
    if (selectedKeyResults.isEmpty) return null;

    // Shuffle the list and take the first one
    final shuffled = List<KeyResult>.from(selectedKeyResults)..shuffle();
    final randomKeyResult = shuffled.first;

    print('🎲 Random key result selected: ${randomKeyResult.title}');
    return randomKeyResult;
  }

  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth > 1200) return screenWidth * 0.06;
    if (screenWidth > 900) return screenWidth * 0.04;
    if (screenWidth > 600) return screenWidth * 0.03;
    return screenWidth * 0.02;
  }
}






// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../../controllers/journey_controller.dart';
// import '../../../controllers/key_results_controller.dart';
// import '../../../core/app_dimensions.dart';
// import '../../../core/app_colors.dart';
// import '../../../generated/models/responses/ai_analysis_model/suggetive_initiative_viewmodel.dart';
// import '../../../generated/models/responses/key_results/key_results_response.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/custom_ai_strategy_container.dart';
// import '../../widgets/custom_button2.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/custom_initiative_input.dart';
// import '../../widgets/custom_journey_map.dart';
// import '../../widgets/custom_objective_container.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
//
// class SuggestionInitiativesScreen extends StatelessWidget {
//   final List<KeyResult> selectedKeyResults;
//
//   SuggestionInitiativesScreen({super.key, required this.selectedKeyResults});
//
//   final JourneyController journeyController = Get.find<JourneyController>();
//   final viewModel = Get.put(SuggestionInitiativesViewModel());
//
//   // ✅ Track source
//   final bool _isModifyFromContextual = Get.parameters['source'] == 'contextual_challenge';
//   final bool _isNormalFlow = !Get.parameters.containsKey('source');
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final screenWidth = mediaQuery.size.width;
//     final screenHeight = mediaQuery.size.height;
//
//     // Get a random key result from the selected ones
//     final randomKeyResult = _getRandomKeyResult();
//
//     print('🎯 Initiatives Screen Source:');
//     print('   - Modify from Contextual: $_isModifyFromContextual');
//     print('   - Normal Flow: $_isNormalFlow');
//
//     return Scaffold(
//       body: CustomBackground(
//         child: SafeArea(
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: EdgeInsets.only(bottom: AppDimensions.d18.h),
//                   child: Column(
//                     children: [
//                       SizedBox(height: screenHeight * 0.03),
//
//                       // ✅ DYNAMIC HEADER BASED ON SOURCE
//                       CustomHeader(
//                         title: _getHeaderTitle(),
//                         highlightedText: _getHeaderHighlight(),
//                         //subtitle: _getSubtitleText(),
//                         onBackTap: () {
//                           if (_isModifyFromContextual) {
//                             // Return to contextual challenge screen
//                             Get.back();
//                           } else {
//                             // Normal navigation back
//                             Get.back();
//                           }
//                         },
//                       ),
//
//                       SizedBox(height: screenHeight * 0.02),
//
//                       /// Random Selected Key Result Container
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: _getHorizontalPadding(screenWidth),
//                         ),
//                         child: CustomObjectiveContainer(
//                           icon: Icons.flag,
//                           title: 'selected_key_result'.tr,
//                           subtitle: randomKeyResult?.title?.tr ?? 'No key result selected',
//                           description: randomKeyResult?.description?.tr ?? '',
//                         ),
//                       ),
//
//                       SizedBox(height: screenHeight * 0.02),
//
//                       CustomInitiativeInput(
//                         numberText: 'first_initiative'.tr,
//                         titleController: viewModel.firstInitiativeTitle,
//                         descController: viewModel.firstInitiativeDesc,
//                       ),
//                       CustomInitiativeInput(
//                         numberText: 'second_initiative'.tr,
//                         titleController: viewModel.secondInitiativeTitle,
//                         descController: viewModel.secondInitiativeDesc,
//                       ),
//
//                       SizedBox(height: AppDimensions.d12.h),
//                       const CustomAIStrategyContainer(),
//
//                       SizedBox(height: AppDimensions.d28.h),
//
//                       // ✅ HIDE JOURNEY MAP FOR MODIFICATION FLOW
//                       if (!_isModifyFromContextual) ...[
//                         Obx(
//                               () => CustomJourneyMap(
//                             progress: journeyController.progress.value,
//                             steps: journeyController.steps,
//                             completedSteps: journeyController.completedSteps,
//                             onToggle: journeyController.toggleJourneyDetails,
//                             showDetails: journeyController.showDetails.value,
//                           ),
//                         ),
//                         SizedBox(height: AppDimensions.d28.h),
//                       ],
//
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: AppDimensions.d40.w),
//                         child: Obx(
//                               () => CustomButton2(
//                             text: _getButtonText(viewModel.isSubmitting.value),
//                             onPressed: viewModel.isSubmitting.value
//                                 ? () {}
//                                 : () => _handleSubmit(viewModel),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: AppDimensions.d28.h),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 right: screenWidth * -0.07,
//                 top: screenHeight * 0.50,
//                 child: const CustomHomeNavBar(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ✅ DYNAMIC HEADER & MESSAGES BASED ON SOURCE
//   String _getHeaderTitle() {
//     if (_isModifyFromContextual) {
//       return 'revise'.tr;
//     }
//     return 'suggestion'.tr;
//   }
//
//   String _getHeaderHighlight() {
//     if (_isModifyFromContextual) {
//       return 'initiatives'.tr;
//     }
//     return 'of_initiatives'.tr;
//   }
//
//   String _getSubtitleText() {
//     if (_isModifyFromContextual) {
//       return 'revise_initiatives_subtitle'.tr;
//     }
//     return 'add_initiatives_subtitle'.tr;
//   }
//
//   // ✅ Get appropriate button text
//   String _getButtonText(bool isSubmitting) {
//     if (isSubmitting) {
//       return 'submitting'.tr;
//     }
//     if (_isModifyFromContextual) {
//       return 'save_revisions'.tr;
//     }
//     return 'submit_analysis'.tr;
//   }
//
//   // ✅ Handle submission based on source
//   void _handleSubmit(SuggestionInitiativesViewModel viewModel) {
//     if (_isModifyFromContextual) {
//       // Submit and return to contextual challenge
//       viewModel.submitInitiatives(selectedKeyResults).then((_) {
//         // After successful submission, return to contextual challenge
//         Get.back();
//         Get.snackbar(
//           'Success',
//           'Initiatives revised successfully',
//           backgroundColor: AppColors.primaryGreen,
//           colorText: Colors.white,
//         );
//       });
//     } else {
//       // Normal submission flow
//       viewModel.submitInitiatives(selectedKeyResults);
//     }
//   }
//
//   /// Get a random key result from the selected ones
//   KeyResult? _getRandomKeyResult() {
//     if (selectedKeyResults.isEmpty) return null;
//
//     // Shuffle the list and take the first one
//     final shuffled = List<KeyResult>.from(selectedKeyResults)..shuffle();
//     final randomKeyResult = shuffled.first;
//
//     print('🎲 Random key result selected: ${randomKeyResult.title}');
//     return randomKeyResult;
//   }
//
//   double _getHorizontalPadding(double screenWidth) {
//     if (screenWidth > 1200) return screenWidth * 0.06;
//     if (screenWidth > 900) return screenWidth * 0.04;
//     if (screenWidth > 600) return screenWidth * 0.03;
//     return screenWidth * 0.02;
//   }
// }