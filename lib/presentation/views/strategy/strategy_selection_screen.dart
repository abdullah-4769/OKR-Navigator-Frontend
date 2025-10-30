import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/journey_controller.dart';
import '../../../controllers/strategy_selection_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../services/shared_preference.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_cards_pagebuilder.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class StrategySelectionScreen extends StatelessWidget {
  StrategySelectionScreen({super.key});

  final journeyController = Get.find<JourneyController>();
  final controller = Get.find<StrategySelectionController>();

  @override
  Widget build(BuildContext context) {
    // ✅ Get arguments from GetX instead of constructor
    final args = Get.arguments as Map<String, dynamic>?;
    final selectedRole = args?['selectedRole'] as Map<String, dynamic>?;
    final selectedIndustry = args?['selectedIndustry'] as Map<String, dynamic>?;

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
                  child: Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.d20.h),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.03),

                        // 🔹 Custom Header
                        CustomHeader(
                          title: 'this'.tr,
                          highlightedText: 'given'.tr,
                          onBackTap: () {
                            // ✅ Navigate back based on game mode
                            final gameMode = SharedPrefs.getGameMode();
                            if (gameMode == 'campaign') {
                              Get.offAllNamed(AppRoutes.missionScreen);
                            } else {
                              Get.offAllNamed(AppRoutes.chooseIndustry);
                            }
                          },
                        ),

                        SizedBox(height: height * 0.01),

                        // Welcome Text
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.06,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'draw_strategy'.tr,
                                style: TextStyle(
                                  fontFamily: 'GothamBold',
                                  fontSize: (width * 0.055).sp,
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                'draw_strategy_subtitle'.tr,
                                style: TextStyle(
                                  fontSize: (width * 0.037).sp,
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Gotham',
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.03),

                        // Cards Section
                        CustomCardPagerBuilder(controller: controller),

                        SizedBox(height: height * 0.03),

                        // Journey Map
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

                        // Begin Mission Button
                        Obx(
                              () => Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.12,
                            ),
                            child: CustomButton2(
                              text: 'begin_mission'.tr,
                              onPressed: controller.isCardRevealed.value
                                  ? () {
                                journeyController.setStep(0, true);

                                // ✅ Get game mode and pass appropriate data
                                final gameMode = SharedPrefs.getGameMode();
                                print('🎮 Current game mode: $gameMode');

                                if (gameMode == 'campaign') {
                                  // For campaign mode, use organization data
                                  final organizationName = SharedPrefs.getCampaignSuggestionName();
                                  final organizationDesc = SharedPrefs.getCampaignSuggestionDescription();

                                  final organizationData = {
                                    'name': organizationName ?? 'Organization',
                                    'description': organizationDesc ?? '',
                                    'type': 'organization'
                                  };

                                  print('🏢 Campaign mode - Using organization: $organizationName');
                                  controller.beginMission(
                                    selectedRole,
                                    organizationData, // Pass organization instead of industry
                                  );
                                } else {
                                  // For solo mode, use industry data as before
                                  print('🎯 Solo mode - Using industry');
                                  controller.beginMission(
                                    selectedRole,
                                    selectedIndustry,
                                  );
                                }
                              }
                                  : null,
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.03),
                      ],
                    ),
                  ),
                ),
              ),

              // 🔹 Floating Navbar
              Positioned(
                right: width * -0.14,
                top: height * 0.50,
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
// import '../../../controllers/strategy_selection_controller.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/custom_button2.dart';
// import '../../widgets/custom_cards_pagebuilder.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/custom_journey_map.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
//
// class StrategySelectionScreen extends StatelessWidget {
//   StrategySelectionScreen({super.key});
//
//   final journeyController = Get.find<JourneyController>();
//   final controller = Get.find<StrategySelectionController>();
//
//   @override
//   Widget build(BuildContext context) {
//     // ✅ Get arguments from GetX instead of constructor
//     final args = Get.arguments as Map<String, dynamic>?;
//     final selectedRole = args?['selectedRole'] as Map<String, dynamic>?;
//     final selectedIndustry = args?['selectedIndustry'] as Map<String, dynamic>?;
//
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
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
//                   child: Padding(
//                     padding: EdgeInsets.only(bottom: AppDimensions.d20.h),
//                     child: Column(
//                       children: [
//                         SizedBox(height: height * 0.03),
//
//                         // 🔹 Custom Header
//                         CustomHeader(
//                           title: 'select'.tr,
//                           highlightedText: 'strategy'.tr,
//                           onBackTap: () =>
//                               Get.offAllNamed(AppRoutes.chooseIndustry),
//                         ),
//
//                         SizedBox(height: height * 0.01),
//
//                         // Welcome Text
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: width * 0.06,
//                           ),
//                           child: Column(
//                             children: [
//                               Text(
//                                 'draw_strategy'.tr,
//                                 style: TextStyle(
//                                   fontFamily: 'GothamBold',
//                                   fontSize: (width * 0.055).sp,
//                                   color: AppColors.primaryRed,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(height: height * 0.01),
//                               Text(
//                                 'draw_strategy_subtitle'.tr,
//                                 style: TextStyle(
//                                   fontSize: (width * 0.037).sp,
//                                   color: AppColors.textSecondary,
//                                   fontFamily: 'Gotham',
//                                   height: 1.4,
//
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         SizedBox(height: height * 0.03),
//
//                         // Cards Section
//                         CustomCardPagerBuilder(controller: controller),
//
//                         SizedBox(height: height * 0.03),
//
//                         // Journey Map
//                         Obx(
//                               () => CustomJourneyMap(
//                             progress: journeyController.progress.value,
//                             steps: journeyController.steps,
//                             completedSteps: journeyController.completedSteps,
//                             onToggle: journeyController.toggleJourneyDetails,
//                             showDetails: journeyController.showDetails.value,
//                           ),
//                         ),
//
//                         SizedBox(height: height * 0.03),
//
//                         // Begin Mission Button
//                         Obx(
//                               () => Padding(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: width * 0.12,
//                             ),
//                             child: CustomButton2(
//                               text: 'begin_mission'.tr,
//                               onPressed: controller.isCardRevealed.value
//                                   ? () {
//                                 journeyController.setStep(0, true);
//                                 controller.beginMission(
//                                   selectedRole,
//                                   selectedIndustry,
//                                 );
//                               }
//                                   : null,
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(height: height * 0.03),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // 🔹 Floating Navbar
//               Positioned(
//                 right: width * -0.07,
//                 top: height * 0.50,
//                 child: const CustomHomeNavBar(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }