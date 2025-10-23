// Update your CampaignModeScreen with dynamic level handling
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/role_selection_controller.dart';
import '../../../core/app_colors.dart';
import '../../../services/shared_preference.dart';
import '../../routes/app_routes.dart';
import '../../widgets/campaign_mode_widgets/campaign_progress_service.dart';
import '../../widgets/campaign_mode_widgets/custom_industry_card.dart';
import '../../widgets/campaign_mode_widgets/custom_progress_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_circular_avatar.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class CampaignModeScreen extends StatelessWidget {
  const CampaignModeScreen({super.key});

  @override
  Widget build(BuildContext context) => OrientationBuilder(
    builder: (context, orientation) {
      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;
      final theme = Theme.of(context);
      final RoleSelectionController controller = Get.put(RoleSelectionController());

      // ✅ Initialize campaign progress when screen loads
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await CampaignProgressService.initializeCampaign();

        // Debug verification
        final savedMode = await SharedPrefs.getGameMode();
        final campaignStatus = await CampaignProgressService.getCampaignStatus();

        print('🎮 Campaign Mode: $savedMode');
        print('📊 Campaign Status: $campaignStatus');
      });

      return Scaffold(
        backgroundColor: AppColors.white,
        body: CustomBackground(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),
                      CustomHeader(
                        title: "campaign".tr,
                        highlightedText: "mode".tr,
                        onBackTap: () => Get.back(),
                        showDashboardIcon: false,
                      ),
                      SizedBox(height: 12.h),
                      CustomCircularAvatar(
                        imagePath: "assets/images/solo2.png",
                        size: 130,
                        innerColors: const [
                          AppColors.softRed,
                          AppColors.softRed,
                          AppColors.softRed,
                        ],
                        borderGradient: [
                          AppColors.primaryRed,
                          AppColors.primaryRed.withValues(alpha: 0.3),
                        ],
                        borderWidth: 2,
                        innermostFactor: 0.8,
                        imageScale: 50,
                        imageOffset: Offset(0, 9),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomObjectiveContainer(
                          title: "navigator_mission".tr,
                          description: "navigator_mission_desc".tr,
                          titleColor: AppColors.black,
                          icon: Icons.explore,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "campaign_progress".tr,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // ✅ Dynamic Progress Bar based on current level
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: CampaignProgressService.getCampaignStatus(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final status = snapshot.data!;
                              final currentLevel = status['currentLevel'] as int;

                              return CustomProgressBar(
                                totalSteps: 3,
                                currentStep: currentLevel,
                              );
                            }
                            return CustomProgressBar(
                              totalSteps: 3,
                              currentStep: 1,
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 2.h),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "organizations".tr,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "organizations_desc".tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // ✅ Dynamic Organization Cards
                      FutureBuilder<Map<String, dynamic>>(
                        future: CampaignProgressService.getCampaignStatus(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final status = snapshot.data!;
                            return Column(
                              children: [
                                // Organization A (Level 1)
                                _buildOrganizationCard(
                                  level: 1,
                                  orgTitle: "organization_a".tr,
                                  subTitle: "startup_phase_level1".tr,
                                  strategyText: "${'strategy_cards'.tr}",
                                  challengeText: "${'Object_Results'.tr}",
                                  bottomTitle: "growth_scale_obj".tr,
                                  isUnlocked: status['level1Unlocked'] as bool,
                                  isCompleted: status['level1Completed'] as bool,
                                  onStart: () => _startOrganization(1, controller),
                                ),

                                // Organization B (Level 2)
                                _buildOrganizationCard(
                                  level: 2,
                                  orgTitle: "organization_b".tr,
                                  subTitle: "startup_phase_level2".tr,
                                  strategyText: "${'initiatives'.tr}",
                                  challengeText: "${'contextual_chal'.tr}",
                                  bottomTitle: status['level2Unlocked'] as bool ? "ready_to_start".tr : "locked".tr,
                                  isUnlocked: status['level2Unlocked'] as bool,
                                  isCompleted: status['level2Completed'] as bool,
                                  onStart: () => _startOrganization(2, controller),
                                ),

                                // Organization C (Level 3)
                                _buildOrganizationCard(
                                  level: 3,
                                  orgTitle: "organization_c".tr,
                                  subTitle: "description3".tr,
                                  strategyText: "${'redthread'.tr}",
                                  challengeText: "",
                                  bottomTitle: status['level3Unlocked'] as bool ? "final_challenge".tr : "locked".tr,
                                  isUnlocked: status['level3Unlocked'] as bool,
                                  isCompleted: status['level3Completed'] as bool,
                                  onStart: () => _startOrganization(3, controller),
                                ),
                              ],
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      ),

                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: CustomButton(
                          text: "campaign_guide".tr,
                          backgroundColor: AppColors.primaryBlue,
                          icon: Icons.info,
                          onPressed: () {
                            print('📚 Campaign guide pressed');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: width * -0.07,
                top: height * 0.4,
                child: const CustomHomeNavBar(),
              ),
            ],
          ),
        ),
      );
    },
  );

  // ✅ Organization Card Builder
  Widget _buildOrganizationCard({
    required int level,
    required String orgTitle,
    required String subTitle,
    required String strategyText,
    required String challengeText,
    required String bottomTitle,
    required bool isUnlocked,
    required bool isCompleted,
    required VoidCallback onStart,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: CustomIndustryCard(
        orgTitle: orgTitle,
        subTitle: subTitle,
        strategyText: strategyText,
        challengeText: challengeText,
        bottomTitle: isCompleted ? "completed".tr : bottomTitle,
        onStart: isUnlocked ? onStart : () {
          if (!isUnlocked) {
            Get.snackbar(
              "Locked".tr,
              "Complete previous organization first".tr,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        imagePath: 'assets/images/role_icon.png',
        isUnlocked: isUnlocked,
        // You can add additional visual indicators for completion
        // isCompleted: isCompleted,
      ),
    );
  }

  // ✅ Start Organization Logic
  void _startOrganization(int level, RoleSelectionController controller) async {
    print('🎯 Starting Organization Level $level');

    // Verify game mode
    final savedMode = await SharedPrefs.getGameMode();
    if (savedMode != 'campaign') {
      Get.snackbar("Error".tr, "Game mode not set to campaign".tr);
      return;
    }

    // Verify role selection
    final selectedRoleIndex = SharedPrefs.getSelectedRoleIndex();
    if (selectedRoleIndex == -1) {
      Get.snackbar("Error".tr, "No role selected".tr);
      return;
    }

    final roleData = controller.roles[selectedRoleIndex];
    final language = Get.locale?.languageCode ?? "en";

    print("🚀 Starting Level $level with role: ${roleData['role']}");

    // For Level 1: Get mission description and go to mission screen
    if (level == 1) {
      final response = await controller.postRoleAndLanguage(
        roleData['role'].toString(),
        language,
      );

      if (response != null) {
        final description = response['description'] ?? response['name'] ?? 'No description available';
        await SharedPrefs.saveMissionDescription(description);
        Get.toNamed(AppRoutes.missionScreen);
      }
    }
    // For Level 2 & 3: Go directly to suggestion initiatives screen
    else if (level ==2) {
      // Save which level we're starting
      await SharedPrefs.saveString('current_campaign_level', level.toString());
      Get.toNamed(AppRoutes.suggestionInitiativeScreen);
    }
    else if ( level == 3) {
      // Save which level we're starting
      await SharedPrefs.saveString('current_campaign_level', level.toString());
      Get.toNamed(AppRoutes.navigatorStartScreen);
    }
  }
}













