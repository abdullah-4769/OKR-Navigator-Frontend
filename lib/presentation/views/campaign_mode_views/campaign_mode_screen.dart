// Update your CampaignModeScreen with dynamic level handling
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart' hide Text;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/views/campaign_mode_views/widgets/custom_progress_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/key_results_controller.dart';
import '../../../controllers/role_selection_controller.dart';
import '../../../core/app_colors.dart';
import '../../../generated/models/responses/key_results/key_results_response.dart' hide Text;
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

class CampaignModeScreen extends StatefulWidget {
  const CampaignModeScreen({super.key});

  @override
  State<CampaignModeScreen> createState() => _CampaignModeScreenState();
}

class _CampaignModeScreenState extends State<CampaignModeScreen> with WidgetsBindingObserver {
  final RoleSelectionController controller = Get.put(RoleSelectionController());
  Map<String, dynamic> _campaignStatus = {
    'currentLevel': 1,
    'level1Unlocked': true,
    'level1Completed': false,
    'level2Unlocked': false,
    'level2Completed': false,
    'level3Unlocked': false,
    'level3Completed': false,
  };
  bool _isLoading = true;
  bool _isStartingLevel = false;
  int? _currentStartingLevel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCampaignStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ✅ AUTOMATICALLY RELOAD WHEN SCREEN BECOMES VISIBLE
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('🔄 Screen resumed - reloading campaign status');
      _loadCampaignStatus();
    }
  }

  // ✅ RELOAD WHEN SCREEN IS FOCUSED (GetX navigation)
  @override
  void didPopNext() {
    print('🔄 Screen focused - reloading campaign status');
    _loadCampaignStatus();
  }

  /// ✅ Load campaign status with refresh capability
  Future<void> _loadCampaignStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await CampaignProgressService.initializeCampaign();
      final status = await CampaignProgressService.getCampaignStatus();

      setState(() {
        _campaignStatus = status;
        _isLoading = false;
      });

      // Debug verification
      final savedMode = await SharedPrefs.getGameMode();
      print('🎮 Campaign Mode: $savedMode');
      print('📊 Campaign Status: $status');

      // ✅ SHOW UNLOCK MESSAGES
      _showUnlockMessages(status);
    } catch (e) {
      print('❌ Error loading campaign status: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ✅ SHOW UNLOCK MESSAGES WHEN LEVELS ARE UNLOCKED
  void _showUnlockMessages(Map<String, dynamic> status) {
    if (status['level2Unlocked'] as bool && !(status['level2Completed'] as bool)) {
      Future.delayed(Duration(milliseconds: 500), () {
        // Get.snackbar(
        //   "🎉 Level 2 Unlocked!".tr,
        //   "You can now start Organization B".tr,
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: AppColors.primaryGreen,
        //   colorText: Colors.white,
        // );
      });
    }

    if (status['level3Unlocked'] as bool && !(status['level3Completed'] as bool)) {
      Future.delayed(Duration(milliseconds: 800), () {
        // Get.snackbar(
        //   "🎉 Level 3 Unlocked!".tr,
        //   "You can now start Organization C".tr,
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: AppColors.primaryBlue,
        //   colorText: Colors.white,
        // );
      });
    }
  }

  /// ✅ Pull to refresh functionality
  Future<void> _onRefresh() async {
    await _loadCampaignStatus();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomBackground(
        child: Stack(
          children: [
            Positioned.fill(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),
                      CustomHeader(
                        title: "camp".tr,
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
                        child: _isLoading
                            ? _buildProgressBarLoader()
                            : CustomProgressBar(
                          totalSteps: 3,
                          currentStep: _campaignStatus['currentLevel'] as int,
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

                      // ✅ Dynamic Organization Cards with Loaders
                      _isLoading
                          ? _buildOrganizationCardsLoader()
                          : Column(
                        children: [
                          // Organization A (Level 1)
                          _buildOrganizationCard(
                            level: 1,
                            orgTitle: "organization_a".tr,
                            subTitle: "startup_phase_level1".tr,
                            strategyText: "${'strategy_cards'.tr}",
                            challengeText: "${'Object_Results'.tr}",
                            bottomTitle: "growth_scale_obj".tr,
                            isUnlocked: _campaignStatus['level1Unlocked'] as bool,
                            isCompleted: _campaignStatus['level1Completed'] as bool,
                            isLoading: _isStartingLevel && _currentStartingLevel == 1,
                          ),

                          // Organization B (Level 2)
                          _buildOrganizationCard(
                            level: 2,
                            orgTitle: "organization_b".tr,
                            subTitle: "startup_phase_level2".tr,
                            strategyText: "${'initiatives'.tr}",
                            challengeText: "${'contextual_chal'.tr}",
                            bottomTitle: _campaignStatus['level2Unlocked'] as bool
                                ? "ready_to_start".tr
                                : "locked".tr,
                            isUnlocked: _campaignStatus['level2Unlocked'] as bool,
                            isCompleted: _campaignStatus['level2Completed'] as bool,
                            isLoading: _isStartingLevel && _currentStartingLevel == 2,
                          ),

                          // Organization C (Level 3)
                          _buildOrganizationCard(
                            level: 3,
                            orgTitle: "organization_c".tr,
                            subTitle: "description3".tr,
                            strategyText: "${'redthread'.tr}",
                            challengeText: "",
                            bottomTitle: _campaignStatus['level3Unlocked'] as bool
                                ? "final_challenge".tr
                                : "locked".tr,
                            isUnlocked: _campaignStatus['level3Unlocked'] as bool,
                            isCompleted: _campaignStatus['level3Completed'] as bool,
                            isLoading: _isStartingLevel && _currentStartingLevel == 3,
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: CustomButton(
                          text: "Start Certification".tr,
                          backgroundColor: AppColors.primaryBlue,
                          icon: Icons.info,
                          onPressed: () {
                            Get.toNamed(AppRoutes.navigatorStartScreen);
                          },
                        ),
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
                      SizedBox(height: 20.h),
                      // ✅ Refresh button for manual reload - FIXED
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: CustomButton(
                          text: "refresh_status".tr,
                          backgroundColor: AppColors.primaryGreen,
                          icon: Icons.refresh,
                          onPressed: _isLoading ? () {} : () => _loadCampaignStatus(),
                        ),
                      ),
                    ],
                  ),
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

  }
  // ✅ ADD THIS METHOD TO MARK LEVEL COMPLETE
  void _markLevelComplete() async {
    try {
      // Check if we're in campaign mode
      final savedMode = await SharedPrefs.getGameMode();
      if (savedMode == 'campaign') {
        // Get current level from storage or default to 1
        final currentLevelStr = await SharedPrefs.getString('current_campaign_level') ?? '1';
        final currentLevel = int.tryParse(currentLevelStr) ?? 1;

        // Mark level as completed using the FIXED CampaignProgressService
        await CampaignProgressService.completeLevel(currentLevel);

        print('✅ Campaign Level $currentLevel marked as completed!');

        // Show completion message
        Get.snackbar(
          "Level Completed!".tr,
          "Organization ${currentLevel == 1 ? 'A' : currentLevel == 2 ? 'B' : 'C'} completed!".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Error marking level complete: $e');
    }
  }
// ✅ ADD THIS METHOD TO YOUR CampaignModeScreen STATE CLASS
  Future<void> _navigateCampaignMode(String source) async {
    print('🏆 Campaign Mode Navigation - Source: $source');

    if (source == 'contextual_challenge' || source == 'challenge_adjustment') {
      print('➡️ Campaign Mode: Completing current level and navigating...');

      // Get current campaign level
      final currentLevel = await _getCurrentCampaignLevel();
      print('🎯 Current campaign level: $currentLevel');

      // Complete the current level using the FIXED method
      if (currentLevel > 0 && currentLevel <= 3) {
        await CampaignProgressService.completeLevel(currentLevel);
        print('✅ Level $currentLevel marked as completed');
      }

      // Navigate back to campaign screen
      print('➡️ Returning to Campaign Mode Screen');
      Get.offAllNamed(AppRoutes.campaignModeScreen);
    } else {
      print('➡️ Campaign Mode: Default navigation to Campaign Mode Screen');
      Get.offAllNamed(AppRoutes.campaignModeScreen);
    }
  }

// ✅ ADD THIS HELPER METHOD TO GET CURRENT CAMPAIGN LEVEL
  Future<int> _getCurrentCampaignLevel() async {
    try {
      final levelStr = await SharedPrefs.getString('current_campaign_level');
      return int.tryParse(levelStr ?? '1') ?? 1;
    } catch (e) {
      print('❌ Error getting current campaign level: $e');
      return 1;
    }
  }
// ✅ FIXED: Convert dynamic list to KeyResult objects
  Future<List<KeyResult>> _getKeyResultsFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keyResultsJson = prefs.getString('selected_key_results');

      if (keyResultsJson != null) {
        final List<dynamic> jsonList = json.decode(keyResultsJson);

        // Convert dynamic list to KeyResult objects
        final List<KeyResult> keyResults = jsonList.map((item) {
          return KeyResult(
            id: item['id'] ?? 0,
            title: item['title']?.toString(),
            description: item['description']?.toString(),
            // tag1: item['tag1']?.toString(),
            // tag2: item['tag2']?.toString(),
          );
        }).toList();

        print('📦 Retrieved ${keyResults.length} key results from SharedPreferences');
        return keyResults;
      }
    } catch (e) {
      print('❌ Error reading key results from SharedPreferences: $e');
    }
    return [];
  }

  // ✅ Organization Card Builder with Loader - FIXED
  Widget _buildOrganizationCard({
    required int level,
    required String orgTitle,
    required String subTitle,
    required String strategyText,
    required String challengeText,
    required String bottomTitle,
    required bool isUnlocked,
    required bool isCompleted,
    required bool isLoading,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Stack(
        children: [
          CustomIndustryCard(
            orgTitle: orgTitle,
            subTitle: subTitle,
            strategyText: strategyText,
            challengeText: challengeText,
            bottomTitle: isCompleted
                ? "✅ ${"completed".tr}"
                : isLoading
                ? "⏳ ${"loading".tr}"
                : bottomTitle,
            onStart: (isUnlocked && !isLoading) ? () => _startOrganization(level) : () {
              if (!isUnlocked && !isLoading) {
                Get.snackbar(
                  "Locked".tr,
                  "Complete previous organization first".tr,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            imagePath: 'assets/images/role_icon.png',
            isUnlocked: isUnlocked,
          ),

          // ✅ Add loading overlay if the card is loading
          if (isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
// ✅ Start Organization Logic with Loader - UPDATED
  void _startOrganization(int level) async {
    if (_isStartingLevel) return; // Prevent multiple clicks

    setState(() {
      _isStartingLevel = true;
      _currentStartingLevel = level;
    });

    print('🎯 Starting Organization Level $level');

    try {
      // Verify game mode
      final savedMode = await SharedPrefs.getGameMode();
      if (savedMode != 'campaign') {
        Get.snackbar("Error".tr, "Game mode not set to campaign".tr);
        return;
      }

      // Verify the level is unlocked
      final status = await CampaignProgressService.getCampaignStatus();
      final isLevelUnlocked = status['level${level}Unlocked'] as bool;

      if (!isLevelUnlocked) {
        Get.snackbar(
            "Locked".tr,
            "Complete Level ${level - 1} first to unlock Level $level".tr
        );
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

      // ✅ SAVE CURRENT LEVEL before navigation
      await SharedPrefs.saveString('current_campaign_level', level.toString());
      print('💾 Saved current campaign level: $level');

      // Navigate based on level
      switch (level) {
        case 1:
          final response = await controller.postRoleAndLanguage(
            roleData['role'].toString(),
            language,
          );

          if (response != null) {
            final description = response['description'] ?? response['name'] ?? 'No description available';
            await SharedPrefs.saveMissionDescription(description);
            Get.toNamed(AppRoutes.missionScreen);
          }
          break;
        case 2:
        // Try to get key results from SharedPreferences
          final savedKeyResults = await _getKeyResultsFromSharedPreferences();

          if (savedKeyResults.isNotEmpty) {
            print('🎯 Navigating to SuggestionInitiativesScreen with ${savedKeyResults.length} saved key results');
            Get.toNamed(
              AppRoutes.suggestionInitiativeScreen,
              arguments: {
                'selectedKeyResults': savedKeyResults, // ✅ Now it's List<KeyResult>
                'isCampaignMode': true,
              },
            );
          } else {
            // If no key results found, navigate without them
            print('⚠️ No saved key results found, navigating without key results');
            Get.toNamed(
              AppRoutes.suggestionInitiativeScreen,
              arguments: {
                'isCampaignMode': true,
              },
            );
          }

          break;
        case 3:
          Get.toNamed(AppRoutes.navigatorStartScreen);
          break;

        default:
          Get.snackbar("Error".tr, "Invalid level: $level".tr);
          break;
      }
    } catch (e) {
      print('❌ Error starting level $level: $e');
      Get.snackbar("Error".tr, "Failed to start level: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isStartingLevel = false;
          _currentStartingLevel = null;
        });
      }
    }
  }
  // // ✅ Start Organization Logic with Loader
  // void _startOrganization(int level) async {
  //   if (_isStartingLevel) return; // Prevent multiple clicks
  //
  //   setState(() {
  //     _isStartingLevel = true;
  //     _currentStartingLevel = level;
  //   });
  //
  //   print('🎯 Starting Organization Level $level');
  //
  //   try {
  //     // Verify game mode
  //     final savedMode = await SharedPrefs.getGameMode();
  //     if (savedMode != 'campaign') {
  //       Get.snackbar("Error".tr, "Game mode not set to campaign".tr);
  //       return;
  //     }
  //
  //     // Verify the level is unlocked
  //     final status = await CampaignProgressService.getCampaignStatus();
  //     final isLevelUnlocked = status['level${level}Unlocked'] as bool;
  //
  //     if (!isLevelUnlocked) {
  //       Get.snackbar(
  //           "Locked".tr,
  //           "Complete Level ${level - 1} first to unlock Level $level".tr
  //       );
  //       return;
  //     }
  //
  //     // Verify role selection
  //     final selectedRoleIndex = SharedPrefs.getSelectedRoleIndex();
  //     if (selectedRoleIndex == -1) {
  //       Get.snackbar("Error".tr, "No role selected".tr);
  //       return;
  //     }
  //
  //     final roleData = controller.roles[selectedRoleIndex];
  //     final language = Get.locale?.languageCode ?? "en";
  //
  //     print("🚀 Starting Level $level with role: ${roleData['role']}");
  //
  //     // ✅ SAVE CURRENT LEVEL before navigation
  //     await SharedPrefs.saveString('current_campaign_level', level.toString());
  //     print('💾 Saved current campaign level: $level');
  //
  //     // Navigate based on level
  //     switch (level) {
  //       case 1:
  //         final response = await controller.postRoleAndLanguage(
  //           roleData['role'].toString(),
  //           language,
  //         );
  //
  //         if (response != null) {
  //           final description = response['description'] ?? response['name'] ?? 'No description available';
  //           await SharedPrefs.saveMissionDescription(description);
  //           Get.toNamed(AppRoutes.missionScreen);
  //         }
  //         break;
  //       case 2:
  //       // Try to get key results from SharedPreferences
  //         final savedKeyResults = await _getKeyResultsFromSharedPreferences();
  //
  //         if (savedKeyResults.isNotEmpty) {
  //           Get.toNamed(
  //             AppRoutes.suggestionInitiativeScreen,
  //             arguments: {
  //               'selectedKeyResults': savedKeyResults,
  //               'isCampaignMode': true,
  //             },
  //           );
  //         } else {
  //           // If no key results found, navigate without them
  //           Get.toNamed(
  //             AppRoutes.suggestionInitiativeScreen,
  //             arguments: {
  //               'isCampaignMode': true,
  //             },
  //           );
  //         }
  //         break;
  //       case 3:
  //         Get.toNamed(AppRoutes.navigatorStartScreen);
  //         break;
  //
  //       default:
  //         Get.snackbar("Error".tr, "Invalid level: $level".tr);
  //         break;
  //     }
  //   } catch (e) {
  //     print('❌ Error starting level $level: $e');
  //     Get.snackbar("Error".tr, "Failed to start level: ${e.toString()}");
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isStartingLevel = false;
  //         _currentStartingLevel = null;
  //       });
  //     }
  //   }
  // }

  // ✅ Loading indicator for progress bar
  Widget _buildProgressBarLoader() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Center(
        child: SizedBox(
          width: 20.w,
          height: 20.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryRed,
          ),
        ),
      ),
    );
  }

  // ✅ Loading indicator for organization cards
  Widget _buildOrganizationCardsLoader() {
    return Column(
      children: [
        _buildOrganizationCardLoader(level: 1),
        _buildOrganizationCardLoader(level: 2),
        _buildOrganizationCardLoader(level: 3),
      ],
    );
  }

  Widget _buildOrganizationCardLoader({required int level}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120.w,
                    height: 16.h,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 80.w,
                    height: 12.h,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// // Update your CampaignModeScreen with dynamic level handling
// import 'dart:convert';
// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:game_app/presentation/views/campaign_mode_views/widgets/custom_progress_bar.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../controllers/key_results_controller.dart';
// import '../../../controllers/role_selection_controller.dart';
// import '../../../core/app_colors.dart';
// import '../../../services/shared_preference.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/campaign_mode_widgets/campaign_progress_service.dart';
// import '../../widgets/campaign_mode_widgets/custom_industry_card.dart';
// import '../../widgets/campaign_mode_widgets/custom_progress_bar.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_circular_avatar.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/custom_objective_container.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
//
// class CampaignModeScreen extends StatefulWidget {
//   const CampaignModeScreen({super.key});
//
//   @override
//   State<CampaignModeScreen> createState() => _CampaignModeScreenState();
// }
//
// class _CampaignModeScreenState extends State<CampaignModeScreen> {
//   final RoleSelectionController controller = Get.put(RoleSelectionController());
//   Map<String, dynamic> _campaignStatus = {
//     'currentLevel': 1,
//     'level1Unlocked': true,
//     'level1Completed': false,
//     'level2Unlocked': false,
//     'level2Completed': false,
//     'level3Unlocked': false,
//     'level3Completed': false,
//   };
//   bool _isLoading = true;
//   bool _isStartingLevel = false;
//   int? _currentStartingLevel;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCampaignStatus();
//   }
//
//   /// ✅ Load campaign status with refresh capability
//   Future<void> _loadCampaignStatus() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       await CampaignProgressService.initializeCampaign();
//       final status = await CampaignProgressService.getCampaignStatus();
//
//       setState(() {
//         _campaignStatus = status;
//         _isLoading = false;
//       });
//
//       // Debug verification
//       final savedMode = await SharedPrefs.getGameMode();
//       print('🎮 Campaign Mode: $savedMode');
//       print('📊 Campaign Status: $status');
//     } catch (e) {
//       print('❌ Error loading campaign status: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   /// ✅ Pull to refresh functionality
//   Future<void> _onRefresh() async {
//     await _loadCampaignStatus();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: CustomBackground(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: RefreshIndicator(
//                 onRefresh: _onRefresh,
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: EdgeInsets.only(bottom: 15.h),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(height: 10.h),
//                       CustomHeader(
//                         title: "camp".tr,
//                         highlightedText: "mode".tr,
//                         onBackTap: () => Get.back(),
//                         showDashboardIcon: false,
//                       ),
//                       SizedBox(height: 12.h),
//                       CustomCircularAvatar(
//                         imagePath: "assets/images/solo2.png",
//                         size: 130,
//                         innerColors: const [
//                           AppColors.softRed,
//                           AppColors.softRed,
//                           AppColors.softRed,
//                         ],
//                         borderGradient: [
//                           AppColors.primaryRed,
//                           AppColors.primaryRed.withValues(alpha: 0.3),
//                         ],
//                         borderWidth: 2,
//                         innermostFactor: 0.8,
//                         imageScale: 50,
//                         imageOffset: Offset(0, 9),
//                       ),
//                       SizedBox(height: 8.h),
//                       Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: CustomObjectiveContainer(
//                           title: "navigator_mission".tr,
//                           description: "navigator_mission_desc".tr,
//                           titleColor: AppColors.black,
//                           icon: Icons.explore,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Center(
//                           child: Text(
//                             "campaign_progress".tr,
//                             style: theme.textTheme.headlineLarge?.copyWith(
//                               color: AppColors.primaryRed,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // ✅ Dynamic Progress Bar based on current level
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: _isLoading
//                             ? _buildProgressBarLoader()
//                             : CustomProgressBar(
//                           totalSteps: 3,
//                           currentStep: _campaignStatus['currentLevel'] as int,
//                         ),
//                       ),
//
//                       SizedBox(height: 2.h),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Center(
//                           child: Text(
//                             "organizations".tr,
//                             style: theme.textTheme.headlineLarge?.copyWith(
//                               color: AppColors.primaryRed,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Center(
//                           child: Text(
//                             "organizations_desc".tr,
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               color: AppColors.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 8.h),
//
//                       // ✅ Dynamic Organization Cards with Loaders
//                       _isLoading
//                           ? _buildOrganizationCardsLoader()
//                           : Column(
//                         children: [
//                           // Organization A (Level 1)
//                           _buildOrganizationCard(
//                             level: 1,
//                             orgTitle: "organization_a".tr,
//                             subTitle: "startup_phase_level1".tr,
//                             strategyText: "${'strategy_cards'.tr}",
//                             challengeText: "${'Object_Results'.tr}",
//                             bottomTitle: "growth_scale_obj".tr,
//                             isUnlocked: _campaignStatus['level1Unlocked'] as bool,
//                             isCompleted: _campaignStatus['level1Completed'] as bool,
//                             isLoading: _isStartingLevel && _currentStartingLevel == 1,
//                           ),
//
//                           // Organization B (Level 2)
//                           _buildOrganizationCard(
//                             level: 2,
//                             orgTitle: "organization_b".tr,
//                             subTitle: "startup_phase_level2".tr,
//                             strategyText: "${'initiatives'.tr}",
//                             challengeText: "${'contextual_chal'.tr}",
//                             bottomTitle: _campaignStatus['level2Unlocked'] as bool
//                                 ? "ready_to_start".tr
//                                 : "locked".tr,
//                             isUnlocked: _campaignStatus['level2Unlocked'] as bool,
//                             isCompleted: _campaignStatus['level2Completed'] as bool,
//                             isLoading: _isStartingLevel && _currentStartingLevel == 2,
//                           ),
//
//                           // Organization C (Level 3)
//                           _buildOrganizationCard(
//                             level: 3,
//                             orgTitle: "organization_c".tr,
//                             subTitle: "description3".tr,
//                             strategyText: "${'redthread'.tr}",
//                             challengeText: "",
//                             bottomTitle: _campaignStatus['level3Unlocked'] as bool
//                                 ? "final_challenge".tr
//                                 : "locked".tr,
//                             isUnlocked: _campaignStatus['level3Unlocked'] as bool,
//                             isCompleted: _campaignStatus['level3Completed'] as bool,
//                             isLoading: _isStartingLevel && _currentStartingLevel == 3,
//                           ),
//                         ],
//                       ),
//
//                       SizedBox(height: 20.h),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.w),
//                         child: CustomButton(
//                           text: "Start Certification".tr,
//                           backgroundColor: AppColors.primaryBlue,
//                           icon: Icons.info,
//                           onPressed: () {
//                             Get.toNamed(AppRoutes.navigatorStartScreen);
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.w),
//                         child: CustomButton(
//                           text: "campaign_guide".tr,
//                           backgroundColor: AppColors.primaryBlue,
//                           icon: Icons.info,
//                           onPressed: () {
//                             print('📚 Campaign guide pressed');
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                       // ✅ Refresh button for manual reload - FIXED
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.w),
//                         child: CustomButton(
//                           text: "refresh_status".tr,
//                           backgroundColor: AppColors.primaryGreen,
//                           icon: Icons.refresh,
//                           onPressed: _isLoading ? () {} : () => _loadCampaignStatus(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               right: width * -0.07,
//               top: height * 0.4,
//               child: const CustomHomeNavBar(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// // Add this method to your _CampaignModeScreenState class
//   Future<List<dynamic>> _getKeyResultsFromSharedPreferences() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final keyResultsJson = prefs.getString('selected_key_results');
//
//       if (keyResultsJson != null) {
//         final List<dynamic> jsonList = json.decode(keyResultsJson);
//         return jsonList;
//       }
//     } catch (e) {
//       print('❌ Error reading key results from SharedPreferences: $e');
//     }
//     return [];
//   }
//   // ✅ Organization Card Builder with Loader - FIXED
//   Widget _buildOrganizationCard({
//     required int level,
//     required String orgTitle,
//     required String subTitle,
//     required String strategyText,
//     required String challengeText,
//     required String bottomTitle,
//     required bool isUnlocked,
//     required bool isCompleted,
//     required bool isLoading,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//       child: Stack(
//         children: [
//           CustomIndustryCard(
//             orgTitle: orgTitle,
//             subTitle: subTitle,
//             strategyText: strategyText,
//             challengeText: challengeText,
//             bottomTitle: isCompleted
//                 ? "✅ ${"completed".tr}"
//                 : isLoading
//                 ? "⏳ ${"loading".tr}"
//                 : bottomTitle,
//             onStart: (isUnlocked && !isLoading) ? () => _startOrganization(level) : () {
//               if (!isUnlocked && !isLoading) {
//                 Get.snackbar(
//                   "Locked".tr,
//                   "Complete previous organization first".tr,
//                   snackPosition: SnackPosition.BOTTOM,
//                 );
//               }
//             },
//             imagePath: 'assets/images/role_icon.png',
//             isUnlocked: isUnlocked,
//           ),
//
//           // ✅ Add loading overlay if the card is loading
//           if (isLoading)
//             Positioned.fill(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: Center(
//                   child: Container(
//                     padding: EdgeInsets.all(16.w),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                     ),
//                     child: SizedBox(
//                       width: 20.w,
//                       height: 20.w,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: AppColors.primaryRed,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   // ✅ Start Organization Logic with Loader
//   void _startOrganization(int level) async {
//     if (_isStartingLevel) return; // Prevent multiple clicks
//
//     setState(() {
//       _isStartingLevel = true;
//       _currentStartingLevel = level;
//     });
//
//     print('🎯 Starting Organization Level $level');
//
//     try {
//       // Verify game mode
//       final savedMode = await SharedPrefs.getGameMode();
//       if (savedMode != 'campaign') {
//         Get.snackbar("Error".tr, "Game mode not set to campaign".tr);
//         return;
//       }
//
//       // Verify the level is unlocked
//       final status = await CampaignProgressService.getCampaignStatus();
//       final isLevelUnlocked = status['level${level}Unlocked'] as bool;
//
//       if (!isLevelUnlocked) {
//         Get.snackbar(
//             "Locked".tr,
//             "Complete Level ${level - 1} first to unlock Level $level".tr
//         );
//         return;
//       }
//
//       // Verify role selection
//       final selectedRoleIndex = SharedPrefs.getSelectedRoleIndex();
//       if (selectedRoleIndex == -1) {
//         Get.snackbar("Error".tr, "No role selected".tr);
//         return;
//       }
//
//       final roleData = controller.roles[selectedRoleIndex];
//       final language = Get.locale?.languageCode ?? "en";
//
//       print("🚀 Starting Level $level with role: ${roleData['role']}");
//
//       // ✅ SAVE CURRENT LEVEL before navigation
//       await SharedPrefs.saveString('current_campaign_level', level.toString());
//       print('💾 Saved current campaign level: $level');
//
//       // Navigate based on level
//       switch (level) {
//         case 1:
//           final response = await controller.postRoleAndLanguage(
//             roleData['role'].toString(),
//             language,
//           );
//
//           if (response != null) {
//             final description = response['description'] ?? response['name'] ?? 'No description available';
//             await SharedPrefs.saveMissionDescription(description);
//             Get.toNamed(AppRoutes.missionScreen);
//           }
//           break;
// // In CampaignModeScreen - update the Level 2 navigation
//         case 2:
//         // Try to get key results from SharedPreferences
//           final savedKeyResults = await _getKeyResultsFromSharedPreferences();
//
//           if (savedKeyResults.isNotEmpty) {
//             Get.toNamed(
//               AppRoutes.suggestionInitiativeScreen,
//               arguments: {
//                 'selectedKeyResults': savedKeyResults,
//                 'isCampaignMode': true,
//               },
//             );
//           } else {
//             // If no key results found, navigate without them
//             Get.toNamed(
//               AppRoutes.suggestionInitiativeScreen,
//               arguments: {
//                 'isCampaignMode': true,
//               },
//             );
//           }
//           break;
//         case 3:
//           Get.toNamed(AppRoutes.navigatorStartScreen);
//           break;
//
//         default:
//           Get.snackbar("Error".tr, "Invalid level: $level".tr);
//           break;
//       }
//     } catch (e) {
//       print('❌ Error starting level $level: $e');
//       Get.snackbar("Error".tr, "Failed to start level: ${e.toString()}");
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isStartingLevel = false;
//           _currentStartingLevel = null;
//         });
//       }
//     }
//   }
//
//   // ✅ Loading indicator for progress bar
//   Widget _buildProgressBarLoader() {
//     return Container(
//       height: 60.h,
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(30.r),
//       ),
//       child: Center(
//         child: SizedBox(
//           width: 20.w,
//           height: 20.w,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             color: AppColors.primaryRed,
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ✅ Loading indicator for organization cards
//   Widget _buildOrganizationCardsLoader() {
//     return Column(
//       children: [
//         _buildOrganizationCardLoader(level: 1),
//         _buildOrganizationCardLoader(level: 2),
//         _buildOrganizationCardLoader(level: 3),
//       ],
//     );
//   }
//
//   Widget _buildOrganizationCardLoader({required int level}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//       child: Container(
//         padding: EdgeInsets.all(16.w),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 40.w,
//               height: 40.w,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//               child: Center(
//                 child: SizedBox(
//                   width: 16.w,
//                   height: 16.w,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: AppColors.primaryRed,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 12.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 120.w,
//                     height: 16.h,
//                     color: Colors.grey[300],
//                   ),
//                   SizedBox(height: 8.h),
//                   Container(
//                     width: 80.w,
//                     height: 12.h,
//                     color: Colors.grey[300],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // ✅ Update your CustomIndustryCard to support loading state
// // Add this to your CustomIndustryCard widget:
// /*
// class CustomIndustryCard extends StatelessWidget {
//   final bool isLoading;
//
//   const CustomIndustryCard({
//     super.key,
//     required this.orgTitle,
//     required this.subTitle,
//     required this.strategyText,
//     required this.challengeText,
//     required this.bottomTitle,
//     required this.onStart,
//     required this.imagePath,
//     required this.isUnlocked,
//     this.isLoading = false,
//   });
//
//   // In your build method, update the button:
//   Widget _buildStartButton() {
//     if (isLoading) {
//       return Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//         decoration: BoxDecoration(
//           color: Colors.grey[400],
//           borderRadius: BorderRadius.circular(20.r),
//         ),
//         child: SizedBox(
//           width: 16.w,
//           height: 16.w,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             color: Colors.white,
//           ),
//         ),
//       );
//     }
//
//     // Your existing button code...
//   }
// }
// */
//
//
