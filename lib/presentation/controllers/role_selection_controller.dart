
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:game_app/core/app_colors.dart';

import '../routes/app_routes.dart';

class RoleSelectionController extends GetxController {
  final RxInt selectedIndex = (-1).obs;

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

  void selectRole(int index) {
    if (index >= 0 && index < roles.length) {
      selectedIndex.value = index;
    }
  }

  void continueWithSelection() {
    if (selectedIndex.value == -1) {
      Get.snackbar(
        'Select role',
        'Please select a role to continue',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final selectedRole = roles[selectedIndex.value];

    // Pass the role as arguments to chooseIndustry; AppRoutes now builds the page
    Get.toNamed(AppRoutes.chooseIndustry, arguments: {
      'selectedRole': selectedRole,
    });
  }

  void openTutorial() {
    Get.snackbar('Tutorial', 'Open tutorial video (handle later)',
        snackPosition: SnackPosition.BOTTOM);
  }

  void backToHome() {
    Get.offAllNamed(AppRoutes.home);
  }
}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:game_app/core/app_colors.dart';
// import '../routes/app_routes.dart';
//
// class RoleSelectionController extends GetxController {
//   final RxInt selectedIndex = (-1).obs;
//
//   final List<Map<String, dynamic>> roles = [
//     {
//       'id': 0,
//       'title': 'CEO',
//       'subtitle': 'Strategic Visionary',
//       'extra': 'Lead from the top',
//       'asset': 'assets/images/solo.svg',
//       'tagColor': 0xFFFFC857,
//       'accent': 0xFFCC4A2E,
//       'icon': Icons.emoji_events,
//       'iconBg': Color(0xFFFFC857),
//     },
//     {
//       'id': 1,
//       'title': 'Manager',
//       'subtitle': 'Team Leader',
//       'extra': 'Drive execution',
//       'asset': 'assets/images/solo.svg',
//       'tagColor': AppColors.reddish,
//       'accent': AppColors.reddish,
//       'icon': Icons.groups,
//       'iconBg': AppColors.reddish,
//     },
//     {
//       'id': 2,
//       'title': 'Strategist',
//       'subtitle': 'Master Planner',
//       'extra': 'Shape the future',
//       'asset': 'assets/images/solo.svg',
//       'tagColor': 0xFFA8D0E6,
//       'accent': 0xFF2E8FDE,
//       'icon': Icons.sports_cricket,
//       'iconBg': Color(0xFF4CAF50),
//     },
//     {
//       'id': 3,
//       'title': 'HR Manager',
//       'subtitle': 'People Champion',
//       'extra': 'Empower teams',
//       'asset': 'assets/images/solo.svg',
//       'tagColor': 0xFFF3C6E0,
//       'accent': 0xFFB14AAE,
//       'icon': Icons.favorite,
//       'iconBg': Color(0xFFFF80AB),
//     },
//   ];
//
//   void selectRole(int index) {
//     if (index >= 0 && index < roles.length) {
//       selectedIndex.value = index;
//     }
//   }
//
//   void continueWithSelection() {
//     if (selectedIndex.value == -1) {
//       Get.snackbar(
//         'Select role',
//         'Please select a role to continue',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     final selectedRole = roles[selectedIndex.value];
//
//     // ✅ Pass role safely as arguments
//     Get.toNamed(AppRoutes.chooseIndustry, arguments: {
//       'selectedRole': selectedRole,
//     });
//   }
//
//   void openTutorial() {
//     Get.snackbar('Tutorial', 'Open tutorial video (handle later)',
//         snackPosition: SnackPosition.BOTTOM);
//   }
//
//   void backToHome() {
//     Get.offAllNamed(AppRoutes.home);
//   }
// }
