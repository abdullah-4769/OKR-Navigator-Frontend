import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/widgets/custom_button.dart';
import 'package:get/get.dart';
import '../../../controllers/campaign_mode_controllers/mission_screen_controller.dart';
import '../../../controllers/role_selection_controller.dart';
import '../../../core/app_colors.dart';
import '../../../services/shared_preference.dart';
import '../../widgets/campaign_mode_widgets/custom_industry_card.dart';
import '../../widgets/campaign_mode_widgets/organization_path_card.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/custom_home_navbar.dart';

import '../../widgets/team_mode_widgets/section_card.dart'; // ✅ use SectionCard

class MissionScreen extends StatefulWidget {
  static const String routeName = "/mission";

  MissionScreen({super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  final MissionScreenController controller = Get.put(MissionScreenController());
  final RoleSelectionController roleController = Get.find<RoleSelectionController>();

  // ✅ ADD: State variable for loading
  bool _isStartingCampaign = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: OrientationBuilder(
          builder: (context, orientation) => Stack(
            children: [
              /// Scrollable content
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: height * 0.02),
                  child: Obx(
                        () => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Header
                        CustomHeader(
                          title: "start".tr,
                          highlightedText: "the_mission".tr,
                          subtitle: "",
                          onBackTap: () => Get.back(),
                        ),

                        SizedBox(height: 10.h),

                        /// Organization Path
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: OrganizationPathCard(
                            orgName: controller.orgName.value,
                            orgSubtitle: controller.orgSubtitle.value,
                            stars: controller.stars.value,
                            nodes: controller.nodes,
                          ),
                        ),

                        SizedBox(height: 10.h),

                        /// Industry Card
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: CustomIndustryCard(
                            orgTitle: controller.industryTitle.value,
                            subTitle: controller.industrySubtitle.value,
                            bottomTitle: controller.bottomTitle.value,
                            strategyText: "strategy_cards".tr,
                            challengeText: "Object_Results".tr,
                            imagePath: "assets/images/role_icon.png",
                            isUnlocked: true,
                            onStart: controller.onStartMission,
                            showPlayButton: false,
                          ),
                        ),

                        SizedBox(height: 10.h),

                        /// 🔹 Rewards / Trophy Section Card
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: SectionCard(
                            showTopButton: false,
                            showLeftIcons: true,
                            showRightIcons: false,
                            icon: Icons.wine_bar,
                            title: "trophy_rewards"
                                .tr, // e.g. "Trophy & Rewards Unlocked"
                            borderColor: AppColors.primaryRed,
                            showCheck: true,
                            items: [
                              {
                                'key': "badge_strategic_thinker".tr,
                                'done': true,
                                'icon': Icons.check, // ✅ Tick inside circle
                                'iconColor': Colors.white,
                              },
                              {
                                'key': "title_master_adapter".tr,
                                'done': true,
                                'icon': Icons.check,
                                'iconColor': Colors.white,
                              },
                            ],
                            outerCircleColor: AppColors.primaryRed,
                            checkIconColor: AppColors.primaryRed,
                          ),
                        ),
                        SizedBox(height: 25.h),

                        // ✅ Buttons with Circular Progress
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: _isStartingCampaign
                              ? Container(
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                              : CustomButton(
                            text: "begin_campaign".tr,
                            backgroundColor: AppColors.primaryRed,
                            icon: Icons.play_arrow,
                            onPressed: _startCampaign, // ✅ Use separate method
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: CustomButton(
                            text: "Mission Brief".tr,
                            backgroundColor: AppColors.primaryBlue,
                            icon: Icons.info,
                            onPressed: () {},
                          ),
                        ),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ),

              /// Home Navbar (floating right center)
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

  // ✅ ADD: Separate method for starting campaign
  Future<void> _startCampaign() async {
    if (_isStartingCampaign) return; // Prevent multiple clicks

    setState(() {
      _isStartingCampaign = true;
    });

    print('🎯 Org A Start button pressed');

    try {
      // ✅ First verify game mode
      final savedMode = await SharedPrefs.getGameMode();
      print('📋 Current saved game mode: $savedMode');

      if (savedMode != 'campaign') {
        print('❌ Game mode mismatch! Expected: campaign, Got: $savedMode');
        Get.snackbar(
          "Error".tr,
          "Game mode not set to campaign".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final selectedRoleIndex = SharedPrefs.getSelectedRoleIndex();
      print('👤 Selected role index: $selectedRoleIndex');

      if (selectedRoleIndex == -1) {
        Get.snackbar(
          "Error".tr,
          "No role selected".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final roleData = roleController.roles[selectedRoleIndex];
      final language = Get.locale?.languageCode ?? "en";

      print("🚀 Sending API request - role: ${roleData['role']}, language: $language");

      // ✅ Call the API and wait for response
      final response = await roleController.postRoleAndLanguage(
        roleData['role'].toString(),
        language,
      );

      if (response != null) {
        print("✅ API Response received: ${response.keys}");
        print("📝 Response data: $response");

        // ✅ Save the description in SharedPreferences
        final description = response['description'] ?? response['name'] ?? 'No description available';
        await SharedPrefs.saveMissionDescription(description);
        print('💾 Mission description saved: $description');

        // ✅ Create organization data for campaign mode
        final organizationData = {
          'titleKey': 'organization_a',
          'descriptionKey': 'startup_phase_level1',
          'icon': Icons.business,
        };

        // ✅ Save organization for campaign mode
        await SharedPrefs.saveSelectedIndustry(organizationData);

        // ✅ Navigate to Strategy Selection with both role and organization
        print('🎬 Navigating to Strategy Selection with campaign data');
        Get.toNamed(
          AppRoutes.selectStrategy,
          arguments: {
            'selectedRole': roleData,
            'selectedIndustry': organizationData,
            'isCampaignMode': true, // ✅ Flag to indicate campaign mode
          },
        );
      } else {
        print('❌ API returned null response');
        Get.snackbar(
          "Error".tr,
          "Failed to load mission details".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('❌ Error starting campaign: $e');
      Get.snackbar(
        "Error".tr,
        "Failed to start campaign: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // ✅ Reset loading state
      if (mounted) {
        setState(() {
          _isStartingCampaign = false;
        });
      }
    }
  }
}












// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:game_app/presentation/routes/app_routes.dart';
// import 'package:game_app/presentation/widgets/custom_button.dart';
// import 'package:get/get.dart';
// import '../../../controllers/campaign_mode_controllers/mission_screen_controller.dart';
// import '../../../controllers/role_selection_controller.dart';
// import '../../../core/app_colors.dart';
// import '../../../services/shared_preference.dart';
// import '../../widgets/campaign_mode_widgets/custom_industry_card.dart';
// import '../../widgets/campaign_mode_widgets/organization_path_card.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
// import '../../widgets/custom_home_navbar.dart';
//
// import '../../widgets/team_mode_widgets/section_card.dart'; // ✅ use SectionCard
//
// class MissionScreen extends StatelessWidget {
//   static const String routeName = "/mission";
//
//
//   MissionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(MissionScreenController());
//     ScreenUtil.init(context);
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomBackground(
//         child: OrientationBuilder(
//           builder: (context, orientation) => Stack(
//             children: [
//               /// Scrollable content
//               Positioned.fill(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: EdgeInsets.only(bottom: height * 0.02),
//                   child: Obx(
//                         () => Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         /// Header
//                         CustomHeader(
//                           title: "start".tr,
//                           highlightedText: "the_mission".tr,
//                           subtitle: "",
//                           onBackTap: () => Get.back(),
//                         ),
//
//                         SizedBox(height: 10.h),
//
//                         /// Organization Path
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: OrganizationPathCard(
//                             orgName: controller.orgName.value,
//                             orgSubtitle: controller.orgSubtitle.value,
//                             stars: controller.stars.value,
//                             nodes: controller.nodes,
//                           ),
//                         ),
//
//                         SizedBox(height: 10.h),
//
//                         /// Industry Card
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: CustomIndustryCard(
//                             orgTitle: controller.industryTitle.value,
//                             subTitle: controller.industrySubtitle.value,
//
//                             bottomTitle: controller.bottomTitle.value,
//                             strategyText: "strategy_cards".tr,
//                             challengeText: "Object_Results".tr,
//                             imagePath: "assets/images/role_icon.png",
//                             isUnlocked: true,
//                             onStart: controller.onStartMission,
//                             showPlayButton: false,
//                           ),
//                         ),
//
//                         SizedBox(height: 10.h),
//
//                         /// 🔹 Rewards / Trophy Section Card
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: SectionCard(
//                             showTopButton: false,
//                             showLeftIcons: true,
//                             showRightIcons: false,
//                             icon: Icons.wine_bar,
//                             title: "trophy_rewards"
//                                 .tr, // e.g. "Trophy & Rewards Unlocked"
//                             borderColor: AppColors.primaryRed,
//                             showCheck: true,
//                             items: [
//                               {
//                                 'key': "badge_strategic_thinker".tr,
//                                 'done': true,
//                                 'icon': Icons.check, // ✅ Tick inside circle
//                                 'iconColor': Colors.white,
//                               },
//                               {
//                                 'key': "title_master_adapter".tr,
//                                 'done': true,
//                                 'icon': Icons.check,
//                                 'iconColor': Colors.white,
//                               },
//                             ],
//                             outerCircleColor: AppColors.primaryRed,
//                             checkIconColor: AppColors.primaryRed,
//                           ),
//                         ),
//                         SizedBox(height: 25.h),
//
//                         // ✅ Buttons with Circular Progress
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: StatefulBuilder(
//                             builder: (context, setState) {
//                               bool _isStartingCampaign = false;
//
//                               return _isStartingCampaign
//                                   ? Container(
//                                 width: double.infinity,
//                                 height: 50.h,
//                                 decoration: BoxDecoration(
//                                   color: AppColors.primaryRed.withOpacity(0.7),
//                                   borderRadius: BorderRadius.circular(25.r),
//                                 ),
//                                 child: Center(
//                                   child: SizedBox(
//                                     width: 24.w,
//                                     height: 24.w,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 3,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                                   : CustomButton(
//                                 text: "begin_campaign".tr,
//                                 backgroundColor: AppColors.primaryRed,
//                                 icon: Icons.play_arrow,
//                                 onPressed: () async {
//                                   setState(() {
//                                     _isStartingCampaign = true;
//                                   });
//
//                                   print('🎯 Org A Start button pressed');
//
//                                   try {
//                                     // ✅ First verify game mode
//                                     final savedMode = await SharedPrefs.getGameMode();
//                                     print('📋 Current saved game mode: $savedMode');
//
//                                     if (savedMode != 'campaign') {
//                                       print('❌ Game mode mismatch! Expected: campaign, Got: $savedMode');
//                                       Get.snackbar(
//                                         "Error".tr,
//                                         "Game mode not set to campaign".tr,
//                                         snackPosition: SnackPosition.BOTTOM,
//                                       );
//                                       return;
//                                     }
//
//                                     // Get the controller instance
//                                     final controller = Get.find<RoleSelectionController>();
//
//                                     final selectedRoleIndex = SharedPrefs.getSelectedRoleIndex();
//                                     print('👤 Selected role index: $selectedRoleIndex');
//
//                                     if (selectedRoleIndex == -1) {
//                                       Get.snackbar(
//                                         "Error".tr,
//                                         "No role selected".tr,
//                                         snackPosition: SnackPosition.BOTTOM,
//                                       );
//                                       return;
//                                     }
//
//                                     final roleData = controller.roles[selectedRoleIndex];
//                                     final language = Get.locale?.languageCode ?? "en";
//
//                                     print("🚀 Sending API request - role: ${roleData['role']}, language: $language");
//
//                                     // ✅ Call the API and wait for response
//                                     final response = await controller.postRoleAndLanguage(
//                                       roleData['role'].toString(),
//                                       language,
//                                     );
//
//                                     if (response != null) {
//                                       print("✅ API Response received: ${response.keys}");
//                                       print("📝 Response data: $response");
//
//                                       // ✅ Save the description in SharedPreferences
//                                       final description = response['description'] ?? response['name'] ?? 'No description available';
//                                       await SharedPrefs.saveMissionDescription(description);
//                                       print('💾 Mission description saved: $description');
//
//                                       // ✅ Create organization data for campaign mode
//                                       final organizationData = {
//                                         'titleKey': 'organization_a',
//                                         'descriptionKey': 'startup_phase_level1',
//                                         'icon': Icons.business,
//                                       };
//
//                                       // ✅ Save organization for campaign mode
//                                       await SharedPrefs.saveSelectedIndustry(organizationData);
//
//                                       // ✅ Navigate to Strategy Selection with both role and organization
//                                       print('🎬 Navigating to Strategy Selection with campaign data');
//                                       Get.toNamed(
//                                         AppRoutes.selectStrategy,
//                                         arguments: {
//                                           'selectedRole': roleData,
//                                           'selectedIndustry': organizationData,
//                                           'isCampaignMode': true, // ✅ Flag to indicate campaign mode
//                                         },
//                                       );
//                                     } else {
//                                       print('❌ API returned null response');
//                                       Get.snackbar(
//                                         "Error".tr,
//                                         "Failed to load mission details".tr,
//                                         snackPosition: SnackPosition.BOTTOM,
//                                       );
//                                     }
//                                   } catch (e) {
//                                     print('❌ Error starting campaign: $e');
//                                     Get.snackbar(
//                                       "Error".tr,
//                                       "Failed to start campaign: ${e.toString()}",
//                                       snackPosition: SnackPosition.BOTTOM,
//                                     );
//                                   } finally {
//                                     // ✅ REMOVED the mounted check - just set the state
//                                     setState(() {
//                                       _isStartingCampaign = false;
//                                     });
//                                   }
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 12.h),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: CustomButton(
//                             text: "Mission Brief".tr,
//                             backgroundColor: AppColors.primaryBlue,
//                             icon: Icons.info,
//                             onPressed: () {},
//                           ),
//                         ),
//
//                         SizedBox(height: 30.h),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               /// Home Navbar (floating right center)
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
