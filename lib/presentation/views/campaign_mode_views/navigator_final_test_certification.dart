import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/views/campaign_mode_views/widgets/custom_timer_widget.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../services/shared_preference.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_initiative_input.dart';
import '../../widgets/global_widgets/custom_progress_path.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/team_mode_widgets/section_card.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/responsive_arrow.dart';

// ================== CONTROLLER ==================
class AchievementController extends GetxController {
  final firstInitiativeTitle = TextEditingController();
  final firstInitiativeDesc = TextEditingController();

  /// ✅ Validate & Submit initiatives
  Future<void> submitInitiatives() async {
    if (firstInitiativeTitle.text.trim().isEmpty ||
        firstInitiativeDesc.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in both initiative title and description before continuing.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Save objective to SharedPreferences
      await SharedPrefs.saveCertificateObjective(
        firstInitiativeTitle.text.trim(),
        firstInitiativeDesc.text.trim(),
      );

      // Debug: Print saved data
      SharedPrefs.printCertificateData();

      Get.snackbar(
        'Success',
        'Objective saved successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to next screen
      Get.toNamed(AppRoutes.navigatorkeyResultsScreen);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save objective: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    firstInitiativeTitle.dispose();
    firstInitiativeDesc.dispose();
    super.onClose();
  }
}
// ================== MAIN SCREEN ==================
class NavigatorFinalTestCertificationScreen extends StatefulWidget {
  const NavigatorFinalTestCertificationScreen({super.key});

  @override
  State<NavigatorFinalTestCertificationScreen> createState() =>
      _NavigatorFinalTestCertificationScreenState();
}

class _NavigatorFinalTestCertificationScreenState
    extends State<NavigatorFinalTestCertificationScreen> {
  final controller = Get.put(AchievementController());

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: CustomBackground(
        child: OrientationBuilder(
          builder: (context, orientation) => Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: height * 0.015),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomHeader(
                        title: 'Navigator',
                        highlightedText: 'Certification',
                        subtitle: '',
                        onBackTap: () => Get.back(),
                      ),
                      SizedBox(height: height * 0.01),

                      SizedBox(height: 10.h),
                      Center(child:
                      CountdownTimerWidget(
                        totalMinutes: 15,
                        size: 130,
                        onTimerComplete: () {
                          // Custom navigation or action
                          Get.offAllNamed('/campaignModeScreen');
                          // Or any other action
                        },
                      )),
                      SizedBox(height: 10.h),
                      Center(child: const ResponsiveArrow()),
                      SizedBox(height: 10.h),
                      /// Scenario
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomObjectiveContainer(
                          title: 'Business Scenario',
                          description: SharedPrefs.getCertificateScenario(),
                          icon: Icons.business_center,
                        ),
                      ),

                      /// Impact section
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.yellow.withOpacity(0.7),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Impact: ',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Expanded(
                              child: Text(
                                'Increase market share by 15% while improving cross-departmental efficiency by 25% within 12 months.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.primaryRed),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.h),

                      /// Progress Path
                      Text("Your OKR Progress Path"),
                      SizedBox(height: 5.h),
                      CustomProgressPath(
                        stepLabels: ["1", "2", "3", "4"],
                        currentStep: 1,
                        showCircles: true,
                      ),

                      SizedBox(height: 15.h),

                      /// Initiative Input Fields
                      CustomInitiativeInput(
                        numberText: 'Enter Objective',
                        titleController: controller.firstInitiativeTitle,
                        descController: controller.firstInitiativeDesc,
                      ),
                      SizedBox(height: 15.h),

                      /// Quick Tips
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SectionCard(
                          title: 'Ai Evaluation Focus',
                          icon: Icons.lightbulb,
                          borderColor: AppColors.primaryRed,
                          showScore: false,

                          items: [
                            {'title': 'Strategic Thinker',
                            'score': 85,},
                            {'title': 'Goal Master',
                              'score': 85,},

                            {'title': 'Innovation Expert',
                              'score': 85,},
                            {'title': 'Challenge Solver',
                              'score': 85,},
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// Quick Tips
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SectionCard(
                          title: 'Quick Tips',
                          icon: Icons.lightbulb,
                          borderColor: AppColors.primaryRed,
                          showScore: false,
                          items: [
                            {
                              'title': 'our initiative lacks cost competitiveness consider price benchmarking or bundling.',

                            },

                          ],
                        ),
                      ),

                      /// Continue Button
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d24,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: AppDimensions.d12),
                            CustomButton(
                              icon: Icons.launch,
                              text: "Continue",
                              onPressed: () {
                                controller.submitInitiatives();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Floating NavBar
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

//
//
//
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:game_app/presentation/views/campaign_mode_views/widgets/startegy_widgets.dart';
// import 'package:game_app/presentation/widgets/bubble_button.dart';
// import 'package:game_app/presentation/widgets/custom_objective_container.dart';
// import 'package:game_app/presentation/widgets/global_widgets/custom_progress_path.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
//
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/custom_initiative_input.dart';
// import '../../widgets/responsive_arrow.dart';
// import '../../widgets/responsive_arrow.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
// import '../../widgets/team_mode_widgets/custom_view_widget.dart';
// import '../../widgets/team_mode_widgets/section_card.dart';
// import '../../widgets/team_mode_widgets/stat_card.dart';
//
// class NavigatorFinalTestCertificationScreen extends StatefulWidget {
//
//   const NavigatorFinalTestCertificationScreen({super.key});
//
//   @override
//   State<NavigatorFinalTestCertificationScreen> createState() => _NavigatorFinalTestCertificationScreenState();
// }
//
// class _NavigatorFinalTestCertificationScreenState extends State<NavigatorFinalTestCertificationScreen> {
//   final controller = Get.put(AchievementController());
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context);
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
//     final recentAchievements = <String>[
//       "Strategic Thinker",
//       "Goal Master",
//       "Innovation Expert",
//       "Challenge Solver"
//     ].obs;
//     var badges = 12.obs;
//     var trophies = 16.obs;
//     var games = 8.obs;
//     return Scaffold(
//
//       body: CustomBackground(
//         child: OrientationBuilder(
//           builder: (context, orientation) => Stack(
//             children: [
//               /// Scrollable content
//               Positioned.fill(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: EdgeInsets.only(bottom: height * 0.015),
//                   child: Obx(
//                         () => Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//
//
//                         /// Header
//                         CustomHeader(
//                           title: 'Navigator'.tr,
//                           highlightedText: 'Certification'.tr,
//                           subtitle: '',
//                           onBackTap: () => Get.back(),
//                         ),
//
//
//                         SizedBox(height: height * 0.01),
//
//                         /// Recent Achievements
//                         Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: CustomObjectiveContainer(
//                             title: 'Scenario: TechCorp Global'.tr,
//
//                             description: 'A multinational technology company facing declining market share and internal coordination challenges across 3 departments: Sales, Product, and Operations.',
//                             icon: Icons.ac_unit_outlined,
//
//                           ),
//                         ),
//                         Center(child: const ResponsiveArrow()),
//
//
//
//                         Container(
//                           padding: EdgeInsets.all(AppDimensions.d12.w),
//                           decoration: BoxDecoration(
//                             color: AppColors.primaryRed.withOpacity(0.05),
//                             borderRadius: BorderRadius.circular(AppDimensions.d8.r),
//                             border: Border.all(
//                               color: Colors.yellow.withOpacity(0.7),
//                               width: 2,
//                             ),
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.baseline,
//                             textBaseline: TextBaseline.alphabetic,
//                             children: [
//
//                               Text(
//                                 'Impact: ',
//                                 style: Theme.of(context).textTheme.bodySmall
//                                     ?.copyWith(
//                                   color: AppColors.primaryRed,
//                                   height: 1.3,
//                                 ),
//                               ),
//                               SizedBox(width: AppDimensions.d8.w, ),
//
//                               Expanded(
//                                 child: Text(
//                                   'Increase market share by 15% while improving cross-departmental efficiency by 25% within 12 months.',
//                                   style: Theme.of(context).textTheme.bodySmall
//                                       ?.copyWith(
//                                     color: AppColors.primaryRed,
//                                     height: 1.2,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         ///
//                         Text("Your OKR Progress Path"),
//                         SizedBox(height: 5.h),
//                         CustomProgressPath(stepLabels: ["1","2","3","4"], currentStep: 2, showCircles: true),
//                         SizedBox(height: 10.h),
//
//
//                         CustomInitiativeInput(
//                           numberText: 'first_initiative'.tr,
//                           titleController: controller.firstInitiativeTitle,
//                           descController: controller.firstInitiativeDesc,
//                         ),
//                         SizedBox(height: 10.h),
//
//                         Padding(
//                           padding:  EdgeInsets.symmetric(horizontal: 16.w),
//                           child: Obx(() => _sectionCard(
//                             context,
//                             title: "Recent Achievements",
//                             items: controller.recentAchievements,
//
//                           )),
//
//                         ),
//                         SizedBox(height: 10.h),
//
//                         /// Recent Games
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: SectionCard(
//                             title: 'Quick Tips'.tr,
//                             icon: Icons.lightbulb,
//                             borderColor: AppColors.primaryRed,
//
//                             showScore: false, items: [
//                             {
//                               'title': 'Solo Campaign - Level 1',
//                               'date': 'Jan 15, 2025',
//                               'score': 85
//                             },
//                             {'title': 'Team Challenge', 'date': 'Jan 12, 2025', 'score': 92},
//
//
//                           ],
//                           ),
//                         ),
//                         SizedBox(height: 10.h),
//                         /// -------- ACTION BUTTONS --------
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: AppDimensions.d24.w),
//                           child: Column(
//                             children: [
//
//
//
//                               SizedBox(height: AppDimensions.d12.h),
//                               CustomButton(
//                                 icon: Icons.launch,
//                                 text: "Continue".tr,
//                                 onPressed: () => {
//
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//
//
//                       ],
//                     ),
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
//   Widget _sectionCard(BuildContext context, {required String title, required List<String> items}) => Container(
//     margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 18.w),
//     padding: EdgeInsets.all(12.w),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(18.r),
//       border: Border.all(color: AppColors.primaryRed),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Text(title,
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.black,
//                   )),
//             ),
//             const Icon(Icons.lightbulb, size: 18, color: Colors.grey),
//           ],
//         ),
//         SizedBox(height: 12.h),
//         ...items.map((e) => Padding(
//           padding: EdgeInsets.symmetric(vertical: 6.h),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 14.r,
//                 backgroundColor: AppColors.primaryRed,
//                 child: Icon(Icons.check, color: Colors.white, size: 16.sp),
//               ),
//               SizedBox(width: 8.w),
//               Expanded(
//                 child: Text(e,
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: AppColors.black,
//                         fontWeight: FontWeight.w600)),
//               ),
//             ],
//           ),
//         ))
//       ],
//     ),
//   );
//
//
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
//
//
//
//
//
//
//
//
//
// class AchievementController extends GetxController {
//   final firstInitiativeTitle = TextEditingController();
//   final firstInitiativeDesc = TextEditingController();
//
//   /// ✅ Submit initiatives for Campaign Mode AI analysis
//   Future<void> submitInitiatives(List<KeyResult> selectedKeyResults) async {
//     if (firstInitiativeTitle.text.isEmpty ||
//         firstInitiativeDesc.text.isEmpty ||
//         ) {
//       Get.snackbar(
//         'error'.tr,
//         'fill_initiatives'.tr,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//   }
//
//   @override
//   void onClose() {
//     firstInitiativeTitle.dispose();
//     firstInitiativeDesc.dispose();
//
//     super.onClose();
//   }
//   late final recentAchievements = <String>[
//     "Strategic Thinker",
//     "Goal Master",
//     "Innovation Expert",
//     "Challenge Solver"
//   ].obs;
//
// }
//
//
//
//
