// Update your ContextualCAdjustmentScreen
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../services/shared_preference.dart';

import '../../../view_model/challange_view_models/adaptation_ai_analysis-viewmodel.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/custom_ai_strategy_container.dart';

class ContextualCAdjustmentScreen extends StatelessWidget {
  const ContextualCAdjustmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Initialize the view model
    final adaptationViewModel = Get.put(AdaptationAIAnalysisViewModel());

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: OrientationBuilder(
          builder: (context, orientation) => Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: height * 0.015),
                  child: Column(
                    children: [
                      CustomHeader(
                        title: 'contextual'.tr,
                        highlightedText: 'adjustment'.tr,
                        subtitle: '',
                        onBackTap: () => Get.toNamed(AppRoutes.aiAnalysisShowScreen),
                      ),

                      SizedBox(height: height * 0.0025),

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "refine_strategy_address_challenge".tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.025),

                      // Your existing adjustment container...
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppDimensions.d16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.grey.withOpacity(0.4),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "revised_key_result".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "adjust_revenue_target_question".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "additional_strategic_actions".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "new_initiatives_question".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.004),
                      const CustomAIStrategyContainer(),
                      SizedBox(height: height * 0.004),

                      // Updated Submit Button with Real API Call
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: width * 0.05.w,
                            horizontal: height * 0.05.h,
                          ),
                          child: Obx(() => CustomButton(
                            text: adaptationViewModel.isSubmitting.value
                                ? 'submitting'.tr
                                : 'submit_adaptations'.tr,
                            onPressed: adaptationViewModel.isSubmitting.value
                                ? () {}
                                : () async {
                              // Save sample adaptation data (replace with real user input)
                              await SharedPrefs.saveAdaptationData(
                                revisedKeyResult: "Adjust Q4 revenue target from \$2M to \$1.8M due to market volatility",
                                strategicActions: "Implement cost optimization measures and explore new market segments",
                                adaptationNotes: "Market analysis indicates 10% lower growth projections for Q4",
                              );

                              // Submit to API
                              await adaptationViewModel.submitAdaptationAnalysis();

                              // Navigate to results screen
                              if (adaptationViewModel.hasData) {
                                Get.toNamed(
                                  AppRoutes.aiAnalysisShowScreen,
                                  arguments: {
                                    'source': 'challenge_adjustment',
                                    'analysisData': adaptationViewModel.evaluationData.value,
                                  },
                                );
                              }
                            },
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: width * -0.07,
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
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
// import '../../../services/shared_preference.dart'; // Import SharedPrefs
// import '../../routes/app_routes.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
// import '../../widgets/custom_ai_strategy_container.dart';
//
// class ContextualCAdjustmentScreen extends StatelessWidget {
//   const ContextualCAdjustmentScreen({super.key});
//
//   // 🔹 GET ADAPTATION DATA FROM SHAREDPREFERENCES
//   Map<String, dynamic> _getAdaptationData() {
//     final adaptationData = SharedPrefs.getAdaptationData();
//
//     return {
//       'revisedKeyResult': adaptationData['revisedKeyResult'] ?? 'Revised revenue target based on market conditions',
//       'strategicActions': adaptationData['strategicActions'] ?? 'Additional strategic initiatives to address challenges',
//       'adaptationNotes': adaptationData['adaptationNotes'] ?? 'Adapted strategy to overcome contextual challenges',
//       'timestamp': DateTime.now().toIso8601String(),
//       'source': 'contextual_adjustment',
//     };
//   }
//
//   // 🔹 SAVE SAMPLE ADAPTATION DATA (You can replace this with real user input)
//   void _saveSampleAdaptationData() {
//     SharedPrefs.saveAdaptationData(
//       revisedKeyResult: "Adjust Q4 revenue target from \$2M to \$1.8M due to market volatility",
//       strategicActions: "Implement cost optimization measures and explore new market segments",
//       adaptationNotes: "Market analysis indicates 10% lower growth projections for Q4",
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
//
//     // Save sample data when screen loads (replace with actual user input)
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _saveSampleAdaptationData();
//     });
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomBackground(
//         child: OrientationBuilder(
//           builder: (context, orientation) => Stack(
//             children: [
//               /// Scrollable Content
//               Positioned.fill(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: EdgeInsets.only(bottom: height * 0.015),
//                   child: Column(
//                     children: [
//                       /// Header
//                       CustomHeader(
//                         title: 'contextual'.tr,
//                         highlightedText: 'adjustment'.tr,
//                         subtitle: '',
//                         onBackTap: () => Get.toNamed(AppRoutes.aiAnalysisShowScreen),
//                       ),
//
//                       SizedBox(height: height * 0.0025),
//
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             "refine_strategy_address_challenge".tr,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyLarge
//                                 ?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.black,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: height * 0.025),
//
//                       /// Single Main Adjustment Container
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: width * 0.05),
//                         child: Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.all(AppDimensions.d16.w),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12.r),
//                             border: Border.all(
//                               color: AppColors.grey.withOpacity(0.4),
//                             ),
//                             color: Colors.white,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               /// Revised Key Result
//                               Text(
//                                 "revised_key_result".tr,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyLarge
//                                     ?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.primaryRed,
//                                 ),
//                               ),
//                               SizedBox(height: 4.h),
//                               Text(
//                                 "adjust_revenue_target_question".tr,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium
//                                     ?.copyWith(
//                                   color: AppColors.textSecondary,
//                                 ),
//                               ),
//
//                               SizedBox(height: 8.h),
//
//                               /// Additional Strategic Actions
//                               Text(
//                                 "additional_strategic_actions".tr,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyLarge
//                                     ?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.primaryRed,
//                                 ),
//                               ),
//                               SizedBox(height: 4.h),
//                               Text(
//                                 "new_initiatives_question".tr,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium
//                                     ?.copyWith(
//                                   color: AppColors.textSecondary,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(height: height * 0.004),
//
//                       /// AI Strategy Analysis Box
//                       const CustomAIStrategyContainer(),
//
//                       SizedBox(height: height * 0.004),
//
//                       /// Propose Adjustment Button
//                       Center(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: width * 0.05.w,
//                             horizontal: height * 0.05.h,
//                           ),
//                           child: CustomButton(
//                             text: 'submit_adaptations'.tr,
//                             onPressed: () {
//                               // Get adaptation data and navigate
//                               final adaptationData = _getAdaptationData();
//                               print('📊 Adaptation Data: $adaptationData');
//
//                               Get.toNamed(
//                                 AppRoutes.aiAnalysisShowScreen,
//                                 arguments: {
//                                   'source': 'challenge_adjustment',
//                                   'adaptationData': adaptationData,
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               /// Home Navbar
//               Positioned(
//                 right: width * -0.07,
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