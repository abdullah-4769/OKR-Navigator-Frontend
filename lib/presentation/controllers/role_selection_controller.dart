import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:game_app/core/app_colors.dart';
import '../routes/app_routes.dart';

class RoleSelectionController extends GetxController {
  final RxInt selectedIndex = (-1).obs;

  // List of roles
  final List<Map<String, dynamic>> roles = [
    {
      'id': 0,
      'title': 'CEO',
      'subtitle': 'Strategic Visionary',
      'extra': 'Lead from the top',
      'asset': 'assets/images/solo.svg',
      'tagColor': 0xFFFFC857,
      'accent': 0xFFCC4A2E,
      'icon': Icons.emoji_events,
      'iconBg': Color(0xFFFFC857),
    },
    {
      'id': 1,
      'title': 'Manager',
      'subtitle': 'Team Leader',
      'extra': 'Drive execution',
      'asset': 'assets/images/solo.svg',
      'tagColor': AppColors.reddish,
      'accent': AppColors.reddish,
      'icon': Icons.groups,
      'iconBg': AppColors.reddish,
    },
    {
      'id': 2,
      'title': 'Strategist',
      'subtitle': 'Master Planner',
      'extra': 'Shape the future',
      'asset': 'assets/images/solo.svg',
      'tagColor': 0xFFA8D0E6,
      'accent': 0xFF2E8FDE,
      'icon': Icons.sports_cricket,
      'iconBg': Color(0xFF4CAF50),
    },
    {
      'id': 3,
      'title': 'HR Manager',
      'subtitle': 'People Champion',
      'extra': 'Empower teams',
      'asset': 'assets/images/solo.svg',
      'tagColor': 0xFFF3C6E0,
      'accent': 0xFFB14AAE,
      'icon': Icons.favorite,
      'iconBg': Color(0xFFFF80AB),
    },
  ];

  /// ✅ Select or Deselect a Role
  void selectRole(int index) {
    if (index >= 0 && index < roles.length) {
      if (selectedIndex.value == index) {
        selectedIndex.value = -1; // Deselect if already selected
      } else {
        selectedIndex.value = index; // Select role
      }
    }
  }

  /// ✅ Continue Button Action
  void continueWithSelection() {
    if (selectedIndex.value == -1) {
      Get.snackbar(
        'Select Role',
        'Please select a role to continue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.black,
      );
      return;
    }

    final selectedRole = roles[selectedIndex.value];

    // Pass the selected role to the next screen
    Get.toNamed(
      AppRoutes.chooseIndustry,
      arguments: {
        'selectedRole': selectedRole,
      },
    );
  }

  /// ✅ Open Tutorial Video
  void openTutorial() {
    Get.snackbar(
      'Tutorial',
      'Opening tutorial video...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// ✅ Back to Home
  void backToHome() {
    Get.offAllNamed(AppRoutes.home);
  }
}
