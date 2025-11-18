import 'package:flutter/material.dart';
import 'package:game_app/core/app_colors.dart';
import 'package:get/get.dart';

import '../presentation/routes/app_routes.dart';
import '../repository/challange_repositories/organization_suggestion_repository.dart';
import '../services/shared_preference.dart';

class RoleSelectionController extends GetxController {
  final RxInt selectedIndex = (-1).obs;
  final CampaignSuggestionRepository repository = CampaignSuggestionRepository();
  bool cameFromBonus = false;

  @override

  final List<Map<String, dynamic>> roles = [
    {
      'id': 0,
      'title': 'ceo_title'.tr,
      'role': 'CEO',
      'subtitle': 'strategic_visionary'.tr,
      'extra': 'lead_from_top'.tr,
      'asset': 'assets/images/1.png',
      'tagColor': 0xFFFFC857,
      'accent': 0xFFCC4A2E,
      'icon': Icons.emoji_events,
      'iconBg': const Color(0xFFFFC857),
    },
    {
      'id': 1,
      'title': 'manager_title'.tr,
      'role': 'Manager',
      'subtitle': 'team_leader'.tr,
      'extra': 'drive_execution'.tr,
      'asset': 'assets/images/2.png',
      'tagColor': AppColors.reddish,
      'accent': AppColors.reddish,
      'icon': Icons.groups,
      'iconBg': AppColors.reddish,
    },
    {
      'id': 2,
      'title': 'strategist_title'.tr,
      'role': 'Strategist',
      'subtitle': 'master_planner'.tr,
      'extra': 'shape_future'.tr,
      'asset': 'assets/images/3.png',
      'tagColor': 0xFFA8D0E6,
      'accent': 0xFF2E8FDE,
      'icon': Icons.sports_cricket,
      'iconBg': const Color(0xFF4CAF50),
    },
    {
      'id': 3,
      'title': 'hr_manager_title'.tr,
      'role': 'HR Manager',
      'subtitle': 'people_champion'.tr,
      'extra': 'empower_teams'.tr,
      'asset': 'assets/images/4.png',
      'tagColor': 0xFFF3C6E0,
      'accent': 0xFFB14AAE,
      'icon': Icons.favorite,
      'iconBg': const Color(0xFFFF80AB),
    },
    {
      'id': 4,
      'title': 'practitioner_title'.tr,
      'role': 'Key Player',
      'subtitle': 'execute_and_improve'.tr,
      'extra': 'empower_teams_practitioner'.tr,
      'asset': 'assets/images/solo.svg',
      'tagColor': 0xFFF3C6E0,
      'accent': 0xFFB14AAE,
      'icon': Icons.ac_unit_outlined,
      'iconBg': const Color(0xFFFF80AB),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    selectedIndex.value = SharedPrefs.getSelectedRoleIndex();

    cameFromBonus = (Get.arguments?['fromBonus'] == true);

    if (cameFromBonus) {
      print("🟢 RoleSelection loaded AGAIN from Bonus Mode");
    }
  }

  /// ✅ Select or Deselect a Role
  void selectRole(int index) {
    if (index >= 0 && index < roles.length) {
      if (selectedIndex.value == index) {
        selectedIndex.value = -1;
        SharedPrefs.saveSelectedRoleIndex(-1);
      } else {
        selectedIndex.value = index;
        SharedPrefs.saveSelectedRoleIndex(index);
        final selectedRole = roles[index]['title'] ?? '';
        SharedPrefs.saveUserRole(selectedRole);
      }
    }
  }

  /// ✅ Continue Button Action - Navigates based on saved game mode
  void continueWithSelection() async {
    if (selectedIndex.value == -1) {
      Get.snackbar(
        'please_select_role'.tr,
        'select_role_required'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.black,
      );
      return;
    }

    final selectedRole = roles[selectedIndex.value];
    final savedGameMode = await SharedPrefs.getGameMode();
    print('role_selection_game_mode'.trParams({'mode': savedGameMode ?? 'default'}));

    switch (savedGameMode) {
      case 'team':
      case 'solo':
        Get.toNamed(
          AppRoutes.chooseIndustry,
          arguments: {'selectedRole': selectedRole},
        );
        break;

      case 'campaign':
        final organizationData = {
          'titleKey': 'organization_a',
          'descriptionKey': 'startup_phase_level1',
          'icon': Icons.business,
        };
        await SharedPrefs.saveSelectedIndustry(organizationData);
        Get.toNamed(
          AppRoutes.campaignModeScreen,
          arguments: {
            'selectedRole': selectedRole,
            'selectedIndustry': organizationData,
            'isCampaignMode': true,
          },
        );
        break;

      case 'bonus':
      // Navigate forward for bonus mode
        Get.toNamed(
          AppRoutes.chooseIndustry,  // or bonus-specific screen
          arguments: {'selectedRole': selectedRole, 'fromBonusMode': true},
        );
        break;

      default:
        Get.toNamed(
          AppRoutes.chooseIndustry,
          arguments: {'selectedRole': selectedRole},
        );
        break;
    }
  }

  /// ✅ Tutorial
  void openTutorial() {
    Get.snackbar(
      'tutorial'.tr,
      'opening_tutorial'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// ✅ Back to Home
  void backToHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  /// ✅ API Call - Fixed version
  Future<Map<String, dynamic>?> postRoleAndLanguage(String role, String language) async {
    try {
      return await repository.postRoleAndLanguage(role, language);
    } catch (e) {
      print('role_api_error'.trParams({'error': e.toString()}));
      return null;
    }
  }
}







