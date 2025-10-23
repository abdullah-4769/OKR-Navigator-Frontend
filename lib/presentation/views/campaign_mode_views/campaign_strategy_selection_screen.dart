
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/core/app_theme.dart';
import 'package:get/get.dart';

import '../../../controllers/campaign_mode_controllers/campaign_strategy_selection_controller.dart';
import '../../../controllers/journey_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_cards_pagebuilder.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class CampaignStrategySelectionScreen extends StatelessWidget {
  static const String routeName = "/campaign_strategy_selection";

  CampaignStrategySelectionScreen({super.key});

  final campaignStrategySelectionController = Get.put(
    CampaignStrategySelectionController(),
  );
  final journeyController = Get.find<JourneyController>();

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String? selectedRole = args['role'];
    final String? selectedIndustry = args['industry'];

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: SafeArea(
          child: Stack(
            children: [
              /// ---------- SCROLLABLE CONTENT ----------
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.d2.h),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.02),

                        /// ---------- HEADER ----------
                        CustomHeader(
                          title: "Select".tr,
                          highlightedText: "Strategy".tr,
                          subtitle: "".tr,
                          onBackTap: () => Get.offAllNamed(AppRoutes.teamLobby),
                        ),

                        SizedBox(height: height * 0.01),

                        /// ---------- CONTENT ----------
                        Padding(
                          padding: EdgeInsets.all(20.r),
                          child: Column(
                            children: [
                              /// Welcome texts
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.041,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'welcome_team'.tr,
                                      style: appTheme.textTheme.headlineLarge
                                          ?.copyWith(
                                        color: AppColors.primaryRed,
                                        fontFamily: 'Gotham-Bold',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: height * 0.01),
                                    Text(
                                      'draw_team_strategy_subtitle'.tr,
                                      style: appTheme.textTheme.bodyLarge
                                          ?.copyWith(
                                        color: AppColors.black,
                                        fontFamily: 'Gotham-Bold',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: height * 0.025),

                              /// Cards Section
                              CustomCardPagerBuilder(
                                controller: campaignStrategySelectionController,
                                // buttonText: 'Growth Strategy',

                              ),

                              SizedBox(height: height * 0.025),

                              /// Journey Map
                              Obx(
                                    () => CustomJourneyMap(
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

                              SizedBox(height: height * 0.025),

                              /// ---------- Begin Mission Button ----------
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.12),
                                child: CustomButton2(
                                  text: 'begin_mission'.tr,

                                  onPressed: () {
                                    Get.toNamed(
                                      AppRoutes.selectStrategy, // replace later with next route
                                    );

                                    //   journeyController.setStep(0, true);
                                    //   campaignStrategySelectionController
                                    //       .beginMission(
                                    //     {'role': selectedRole},
                                    //     {'industry': selectedIndustry},
                                    //   );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// ---------- NAVBAR ----------
              Positioned(
                right: width * -0.07000001,
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






























// this is old we have new
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:game_app/core/app_theme.dart';
// import 'package:get/get.dart';
//
// import '../../../controllers/campaign_mode_controllers/campaign_strategy_selection_controller.dart';
// import '../../../controllers/journey_controller.dart';
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
// class CampaignStrategySelectionScreen extends StatelessWidget {
//   static const String routeName = "/campaign_strategy_selection";
//
//   CampaignStrategySelectionScreen({super.key});
//
//   final campaignStrategySelectionController = Get.put(
//     CampaignStrategySelectionController(),
//   );
//   final journeyController = Get.find<JourneyController>();
//
//   @override
//   Widget build(BuildContext context) {
//     final args = Get.arguments ?? {};
//     final String? selectedRole = args['role'];
//     final String? selectedIndustry = args['industry'];
//
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomBackground(
//         child: SafeArea(
//           child: Stack(
//             children: [
//               /// ---------- SCROLLABLE CONTENT ----------
//               Positioned.fill(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Padding(
//                     padding: EdgeInsets.only(bottom: AppDimensions.d2.h),
//                     child: Column(
//                       children: [
//                         SizedBox(height: height * 0.02),
//
//                         /// ---------- HEADER ----------
//                         CustomHeader(
//                           title: "Select".tr,
//                           highlightedText: "Strategy".tr,
//                           subtitle: "".tr,
//                           onBackTap: () => Get.offAllNamed(AppRoutes.teamLobby),
//                         ),
//
//                         SizedBox(height: height * 0.01),
//
//                         /// ---------- CONTENT ----------
//                         Padding(
//                           padding: EdgeInsets.all(20.r),
//                           child: Column(
//                             children: [
//                               /// Welcome texts
//                               Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: width * 0.041,
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       'welcome_team'.tr,
//                                       style: appTheme.textTheme.headlineLarge
//                                           ?.copyWith(
//                                         color: AppColors.primaryRed,
//                                         fontFamily: 'Gotham-Bold',
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     SizedBox(height: height * 0.01),
//                                     Text(
//                                       'draw_team_strategy_subtitle'.tr,
//                                       style: appTheme.textTheme.bodyLarge
//                                           ?.copyWith(
//                                         color: AppColors.black,
//                                         fontFamily: 'Gotham-Bold',
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//                               SizedBox(height: height * 0.025),
//
//                               /// Cards Section
//                               CustomCardPagerBuilder(
//                                 controller: campaignStrategySelectionController,
//                                 buttonText: 'Growth Strategy',
//                               ),
//
//                               SizedBox(height: height * 0.025),
//
//                               /// Journey Map
//                               Obx(
//                                     () => CustomJourneyMap(
//                                   progress: journeyController.progress.value,
//                                   steps: journeyController.steps,
//                                   completedSteps:
//                                   journeyController.completedSteps,
//                                   onToggle:
//                                   journeyController.toggleJourneyDetails,
//                                   showDetails:
//                                   journeyController.showDetails.value,
//                                 ),
//                               ),
//
//                               SizedBox(height: height * 0.025),
//
//                               /// ---------- Begin Mission Button ----------
//                               Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: width * 0.12),
//                                 child: CustomButton2(
//                                   text: 'begin_mission'.tr,
//
//                                   onPressed: () {
//                                     Get.toNamed(
//                                       AppRoutes.campaignChooseStrategy, // replace later with next route
//                                     );
//                                   //   journeyController.setStep(0, true);
//                                   //   campaignStrategySelectionController
//                                   //       .beginMission(
//                                   //     {'role': selectedRole},
//                                   //     {'industry': selectedIndustry},
//                                   //   );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               /// ---------- NAVBAR ----------
//               Positioned(
//                 right: width * -0.07000001,
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
//
//
//
//
//
//
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:game_app/core/app_theme.dart';
// // import 'package:get/get.dart';
// //
// // import '../../../controllers/campaign_mode_controllers/campaign_strategy_selection_controller.dart';
// // import '../../../controllers/journey_controller.dart';
// // import '../../../core/app_colors.dart';
// // import '../../../core/app_dimensions.dart';
// // import '../../routes/app_routes.dart';
// // import '../../widgets/custom_button2.dart';
// // import '../../widgets/custom_cards_pagebuilder.dart';
// // import '../../widgets/custom_home_navbar.dart';
// // import '../../widgets/custom_journey_map.dart';
// // import '../../widgets/screens_unique_parts/custom_background.dart';
// // import '../../widgets/screens_unique_parts/custom_header.dart';
// //
// // class CampaignStrategySelectionScreen extends StatelessWidget {
// //   static const String routeName = "/campaign_strategy_selection";
// //
// //   CampaignStrategySelectionScreen({super.key});
// //
// //   final campaignStrategySelectionController = Get.put(
// //     CampaignStrategySelectionController(),
// //   );
// //   final journeyController = Get.find<JourneyController>();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     final args = Get.arguments ?? {};
// //     final String? selectedRole = args['role'];
// //     final String? selectedIndustry = args['industry'];
// //
// //     final size = MediaQuery.of(context).size;
// //     final width = size.width;
// //     final height = size.height;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: CustomBackground(
// //         child: SafeArea(
// //           child: Stack(
// //             children: [
// //               /// ---------- SCROLLABLE CONTENT ----------
// //               Positioned.fill(
// //                 child: SingleChildScrollView(
// //                   physics: const BouncingScrollPhysics(),
// //                   child: Padding(
// //                     padding: EdgeInsets.only(bottom: AppDimensions.d2.h),
// //                     child: Column(
// //                       children: [
// //                         SizedBox(height: height * 0.02),
// //
// //                         /// ---------- HEADER ----------
// //                         CustomHeader(
// //                           title: "Select".tr,
// //                           highlightedText: "Strategy".tr,
// //                           subtitle: "".tr,
// //                           onBackTap: () => Get.offAllNamed(AppRoutes.teamLobby),
// //                         ),
// //
// //                         SizedBox(height: height * 0.01),
// //
// //                         /// ---------- CONTENT ----------
// //                         Padding(
// //                           padding: EdgeInsets.all(20.r),
// //                           child: Column(
// //                             children: [
// //                               /// Welcome texts
// //                               Padding(
// //                                 padding: EdgeInsets.symmetric(
// //                                   horizontal: width * 0.041,
// //                                 ),
// //                                 child: Column(
// //                                   children: [
// //                                     Text(
// //                                       'welcome_team'.tr,
// //                                       style: appTheme.textTheme.headlineLarge
// //                                           ?.copyWith(
// //                                             color: AppColors.primaryRed,
// //                                             fontFamily: 'Gotham-Bold',
// //                                           ),
// //                                       textAlign: TextAlign.center,
// //                                     ),
// //                                     SizedBox(height: height * 0.01),
// //                                     Text(
// //                                       'draw_team_strategy_subtitle'.tr,
// //                                       style: appTheme.textTheme.bodyLarge
// //                                           ?.copyWith(
// //                                             color: AppColors.black,
// //                                             fontFamily: 'Gotham-Bold',
// //                                           ),
// //                                       textAlign: TextAlign.center,
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //
// //                               SizedBox(height: height * 0.025),
// //
// //                               /// Cards Section
// //                               CustomCardPagerBuilder(
// //                                 controller: campaignStrategySelectionController,
// //                                 buttonText: 'Growth Strategy',
// //                               ),
// //
// //                               SizedBox(height: height * 0.025),
// //
// //                               /// Journey Map
// //                               Obx(
// //                                 () => CustomJourneyMap(
// //                                   progress: journeyController.progress.value,
// //                                   steps: journeyController.steps,
// //                                   completedSteps:
// //                                       journeyController.completedSteps,
// //                                   onToggle:
// //                                       journeyController.toggleJourneyDetails,
// //                                   showDetails:
// //                                       journeyController.showDetails.value,
// //                                 ),
// //                               ),
// //
// //                               SizedBox(height: height * 0.025),
// //
// //                               /// Begin Mission Button
// //
// //                               Obx(() {
// //                                 final isRevealed =
// //                                     campaignStrategySelectionController.isCardRevealed.value;
// //
// //                                 return AnimatedOpacity(
// //                                   opacity: isRevealed ? 1.0 : 0.4,
// //                                   duration: const Duration(milliseconds: 300),
// //                                   child: Padding(
// //                                     padding: EdgeInsets.symmetric(horizontal: width * 0.12),
// //                                     child: CustomButton2(
// //                                       text: 'begin_mission'.tr,
// //                                      onPressed: campaignStrategySelectionController.isCardRevealed.value
// //                                           ? () {
// //                                         journeyController.setStep(0, true);
// //                                         campaignStrategySelectionController.beginMission(
// //                                           {'role': selectedRole},
// //                                           {'industry': selectedIndustry},
// //                                         );
// //                                       }
// //                                           : null,
// //                                     ),
// //                                   ),
// //                                 );
// //                               }),
// //
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //
// //               /// ---------- NAVBAR ----------
// //               Positioned(
// //                 right: width * -0.07000001,
// //                 top: height * 0.50,
// //                 child: const CustomHomeNavBar(),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
