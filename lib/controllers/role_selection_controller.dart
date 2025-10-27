import 'package:flutter/material.dart';
import 'package:game_app/core/app_colors.dart';
import 'package:get/get.dart';

import '../presentation/routes/app_routes.dart';
import '../services/shared_preference.dart';

class RoleSelectionController extends GetxController {
  final RxInt selectedIndex = (-1).obs;

  final List<Map<String, dynamic>> roles = [
    {
      'id': 0,
      'title': 'CEO'.tr,
      'subtitle': 'Strategic Visionary'.tr,
      'extra': 'Lead from the top'.tr,
      'asset': 'assets/images/solo.svg',
      'tagColor': 0xFFFFC857,
      'accent': 0xFFCC4A2E,
      'icon': Icons.emoji_events,
      'iconBg': const Color(0xFFFFC857),
    },
    {
      'id': 1,
      'title': 'Manager'.tr,
      'subtitle': 'Team Leader'.tr,
      'extra': 'Drive execution'.tr,
      'asset': 'assets/images/solo.svg',
      'tagColor': AppColors.reddish,
      'accent': AppColors.reddish,
      'icon': Icons.groups,
      'iconBg': AppColors.reddish,
    },
    {
      'id': 2,
      'title': 'Strategist'.tr,
      'subtitle': 'Master Planner'.tr,
      'extra': 'Shape the future'.tr,
      'asset': 'assets/images/solo.svg',
      'tagColor': 0xFFA8D0E6,
      'accent': 0xFF2E8FDE,
      'icon': Icons.sports_cricket,
      'iconBg': const Color(0xFF4CAF50),
    },
    {
      'id': 3,
      'title': 'HR Manager'.tr,
      'subtitle': 'People Champion'.tr,
      'extra': 'Empower teams'.tr,
      'asset': 'assets/images/solo.svg',
      'tagColor': 0xFFF3C6E0,
      'accent': 0xFFB14AAE,
      'icon': Icons.favorite,
      'iconBg': const Color(0xFFFF80AB),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    selectedIndex.value = SharedPrefs.getSelectedRoleIndex();
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
      }
    }
  }

  /// ✅ Continue Button Action
  void continueWithSelection() {
    if (selectedIndex.value == -1) {
      Get.snackbar(
        'please_select_role'.tr,
        ''.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.black,
      );
      return;
    }

    final selectedRole = roles[selectedIndex.value];
    Get.toNamed(
      AppRoutes.chooseIndustry,
      arguments: {'selectedRole': selectedRole},
    );
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
}
