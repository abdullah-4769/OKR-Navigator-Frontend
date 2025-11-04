import 'package:flutter/material.dart';
import 'package:game_app/core/app_colors.dart';
import 'package:get/get.dart';

import '../presentation/routes/app_routes.dart';
import '../repository/challange_repositories/organization_suggestion_repository.dart';
import '../services/shared_preference.dart';

class RoleSelectionController extends GetxController {
  final RxInt selectedIndex = (-1).obs;
  final CampaignSuggestionRepository repository = CampaignSuggestionRepository();
  final List<Map<String, dynamic>> roles = [
    {
      'id': 0,
      'title': 'CEO'.tr,
      'role': 'CEO',
      'subtitle': 'Strategic Visionary'.tr,
      'extra': 'Lead from the top'.tr,
      'asset': 'assets/images/1.png',
      'tagColor': 0xFFFFC857,
      'accent': 0xFFCC4A2E,
      'icon': Icons.emoji_events,
      'iconBg': const Color(0xFFFFC857),
    },
    {
      'id': 1,
      'title': 'Manager'.tr,
      'role': 'Manager',
      'subtitle': 'Team Leader'.tr,
      'extra': 'Drive execution'.tr,
      'asset': 'assets/images/2.png',
      'tagColor': AppColors.reddish,
      'accent': AppColors.reddish,
      'icon': Icons.groups,
      'iconBg': AppColors.reddish,
    },
    {
      'id': 2,
      'title': 'Strategist'.tr,
      'role': 'Strategist',
      'subtitle': 'Master Planner'.tr,
      'extra': 'Shape the future'.tr,
      'asset': 'assets/images/3.png',
      'tagColor': 0xFFA8D0E6,
      'accent': 0xFF2E8FDE,
      'icon': Icons.sports_cricket,
      'iconBg': const Color(0xFF4CAF50),
    },
    {
      'id': 3,
      'title': 'HR Manager'.tr,
      'role': 'HR Manager',
      'subtitle': 'People Champion'.tr,
      'extra': 'Empower teams'.tr,
      'asset': 'assets/images/4.png',
      'tagColor': 0xFFF3C6E0,
      'accent': 0xFFB14AAE,
      'icon': Icons.favorite,
      'iconBg': const Color(0xFFFF80AB),
    },
    {
      'id': 4,
      'title': 'Practitionner'.tr,
      'role': 'Key Player',
      'subtitle': 'Execute and improve)'.tr,
      'extra': 'Empower teams'.tr,
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
        ''.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.black,
      );
      return;
    }

    final selectedRole = roles[selectedIndex.value];

    // Get the saved game mode
    final savedGameMode = await SharedPrefs.getGameMode();
    print('🎮 Game mode detected: $savedGameMode');

    // Navigate based on the game mode
    switch (savedGameMode) {
      case 'team':

        final selectedRole = roles[selectedIndex.value];
        Get.toNamed(
          AppRoutes.chooseIndustry,
          arguments: {'selectedRole': selectedRole},
        );
        break;

      case 'campaign':
      // ✅ Campaign mode: Create organization data and go to strategy selection
        print('🚀 Campaign mode: Creating organization data and going to strategy selection');

        // Create organization data for campaign mode
        final organizationData = {
          'titleKey': 'organization_a',
          'descriptionKey': 'startup_phase_level1',
          'icon': Icons.business,
        };

        // Save organization for campaign mode
        await SharedPrefs.saveSelectedIndustry(organizationData);

        // Navigate directly to strategy selection with both role and organization
        Get.toNamed(
          AppRoutes.campaignModeScreen,
          arguments: {
            'selectedRole': selectedRole,
            'selectedIndustry': organizationData,
            'isCampaignMode': true, // ✅ Flag to indicate campaign mode
          },
        );
        break;

      case 'solo':
      default:
      // ✅ Solo mode: Go to industry selection
        print('🎯 Solo mode: Navigating to industry selection');
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
      print('Error in controller posting role: $e');
      return null;
    }
  }
}









// import 'package:flutter/material.dart';
// import 'package:game_app/core/app_colors.dart';
// import 'package:get/get.dart';
//
// import '../presentation/routes/app_routes.dart';
// import '../repository/challange_repositories/organization_suggestion_repository.dart';
// import '../services/shared_preference.dart';
//
// class RoleSelectionController extends GetxController {
//   final RxInt selectedIndex = (-1).obs;
//   final CampaignSuggestionRepository repository = CampaignSuggestionRepository();
//   final List<Map<String, dynamic>> roles = [
//     {
//       'id': 0,
//       'title': 'CEO'.tr,
//       'role': 'CEO', // ✅ Add this field for API calls
//       'subtitle': 'Strategic Visionary'.tr,
//       'extra': 'Lead from the top'.tr,
//       'asset': 'assets/images/solo.svg',
//       'tagColor': 0xFFFFC857,
//       'accent': 0xFFCC4A2E,
//       'icon': Icons.emoji_events,
//       'iconBg': const Color(0xFFFFC857),
//     },
//     {
//       'id': 1,
//       'title': 'Manager'.tr,
//       'role': 'Manager', // ✅ Add this field for API calls
//       'subtitle': 'Team Leader'.tr,
//       'extra': 'Drive execution'.tr,
//       'asset': 'assets/images/solo.svg',
//       'tagColor': AppColors.reddish,
//       'accent': AppColors.reddish,
//       'icon': Icons.groups,
//       'iconBg': AppColors.reddish,
//     },
//     {
//       'id': 2,
//       'title': 'Strategist'.tr,
//       'role': 'Strategist', // ✅ Add this field for API calls
//       'subtitle': 'Master Planner'.tr,
//       'extra': 'Shape the future'.tr,
//       'asset': 'assets/images/solo.svg',
//       'tagColor': 0xFFA8D0E6,
//       'accent': 0xFF2E8FDE,
//       'icon': Icons.sports_cricket,
//       'iconBg': const Color(0xFF4CAF50),
//     },
//     {
//       'id': 3,
//       'title': 'HR Manager'.tr,
//       'role': 'HR Manager', // ✅ Add this field for API calls
//       'subtitle': 'People Champion'.tr,
//       'extra': 'Empower teams'.tr,
//       'asset': 'assets/images/solo.svg',
//       'tagColor': 0xFFF3C6E0,
//       'accent': 0xFFB14AAE,
//       'icon': Icons.favorite,
//       'iconBg': const Color(0xFFFF80AB),
//     },
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     selectedIndex.value = SharedPrefs.getSelectedRoleIndex();
//   }
//
//   /// ✅ Select or Deselect a Role
//   void selectRole(int index) {
//     if (index >= 0 && index < roles.length) {
//       if (selectedIndex.value == index) {
//         selectedIndex.value = -1;
//         SharedPrefs.saveSelectedRoleIndex(-1);
//       } else {
//         selectedIndex.value = index;
//         SharedPrefs.saveSelectedRoleIndex(index);
//         final selectedRole = roles[index]['title'] ?? '';
//         SharedPrefs.saveUserRole(selectedRole);
//       }
//     }
//   }
//
//   /// ✅ Continue Button Action - Navigates based on saved game mode
//   void continueWithSelection() async {
//     if (selectedIndex.value == -1) {
//       Get.snackbar(
//         'please_select_role'.tr,
//         ''.tr,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent.withOpacity(0.1),
//         colorText: Colors.black,
//       );
//       return;
//     }
//
//     final selectedRole = roles[selectedIndex.value];
//
//     // Get the saved game mode
//     final savedGameMode = await SharedPrefs.getGameMode();
//     print('🎮 Game mode detected: $savedGameMode');
//
//     // Navigate based on the game mode
//     switch (savedGameMode) {
//       case 'team':
//       // Team mode flow
//         Get.toNamed(
//           AppRoutes.assignRoleScreen,
//           arguments: {'selectedRole': selectedRole},
//         );
//         break;
//
//       case 'campaign':
//       // ✅ Campaign mode: Skip industry, go directly to campaign screen
//         print('🚀 Campaign mode: Navigating to campaign screen');
//         Get.toNamed(
//           AppRoutes.campaignModeScreen,
//           arguments: {'selectedRole': selectedRole},
//         );
//         break;
//
//       case 'solo':
//       default:
//       // ✅ Solo mode: Go to industry selection
//         print('🎯 Solo mode: Navigating to industry selection');
//         Get.toNamed(
//           AppRoutes.chooseIndustry,
//           arguments: {'selectedRole': selectedRole},
//         );
//         break;
//     }
//   }
//
//   /// ✅ Tutorial
//   void openTutorial() {
//     Get.snackbar(
//       'tutorial'.tr,
//       'opening_tutorial'.tr,
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   /// ✅ Back to Home
//   void backToHome() {
//     Get.offAllNamed(AppRoutes.home);
//   }
//
//   /// ✅ API Call - Fixed version
//   Future<Map<String, dynamic>?> postRoleAndLanguage(String role, String language) async {
//     try {
//       return await repository.postRoleAndLanguage(role, language);
//     } catch (e) {
//       print('Error in controller posting role: $e');
//       return null;
//     }
//   }
// }
//
//
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:game_app/core/app_colors.dart';
// // import 'package:get/get.dart';
// //
// // import '../presentation/routes/app_routes.dart';
// // import '../services/shared_preference.dart';
// //
// // class RoleSelectionController extends GetxController {
// //   final RxInt selectedIndex = (-1).obs;
// //
// //   final List<Map<String, dynamic>> roles = [
// //     {
// //       'id': 0,
// //       'title': 'CEO'.tr,
// //       'role': 'CEO', // Add this for API calls
// //       'subtitle': 'Strategic Visionary'.tr,
// //       'extra': 'Lead from the top'.tr,
// //       'asset': 'assets/images/solo.svg',
// //       'tagColor': 0xFFFFC857,
// //       'accent': 0xFFCC4A2E,
// //       'icon': Icons.emoji_events,
// //       'iconBg': const Color(0xFFFFC857),
// //     },
// //     {
// //       'id': 1,
// //       'title': 'Manager'.tr,
// //       'role': 'Manager', // Add this for API calls
// //       'subtitle': 'Team Leader'.tr,
// //       'extra': 'Drive execution'.tr,
// //       'asset': 'assets/images/solo.svg',
// //       'tagColor': AppColors.reddish,
// //       'accent': AppColors.reddish,
// //       'icon': Icons.groups,
// //       'iconBg': AppColors.reddish,
// //     },
// //     {
// //       'id': 2,
// //       'title': 'Strategist'.tr,
// //       'role': 'Strategist', // Add this for API calls
// //       'subtitle': 'Master Planner'.tr,
// //       'extra': 'Shape the future'.tr,
// //       'asset': 'assets/images/solo.svg',
// //       'tagColor': 0xFFA8D0E6,
// //       'accent': 0xFF2E8FDE,
// //       'icon': Icons.sports_cricket,
// //       'iconBg': const Color(0xFF4CAF50),
// //     },
// //     {
// //       'id': 3,
// //       'title': 'HR Manager'.tr,
// //       'role': 'HR Manager', // Add this for API calls
// //       'subtitle': 'People Champion'.tr,
// //       'extra': 'Empower teams'.tr,
// //       'asset': 'assets/images/solo.svg',
// //       'tagColor': 0xFFF3C6E0,
// //       'accent': 0xFFB14AAE,
// //       'icon': Icons.favorite,
// //       'iconBg': const Color(0xFFFF80AB),
// //     },
// //   ];
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     selectedIndex.value = SharedPrefs.getSelectedRoleIndex();
// //   }
// //
// //   /// ✅ Select or Deselect a Role
// //   void selectRole(int index) {
// //     if (index >= 0 && index < roles.length) {
// //       if (selectedIndex.value == index) {
// //         selectedIndex.value = -1;
// //         SharedPrefs.saveSelectedRoleIndex(-1);
// //       } else {
// //         selectedIndex.value = index;
// //         SharedPrefs.saveSelectedRoleIndex(index);
// //         final selectedRole = roles[index]['title'] ?? '';
// //         SharedPrefs.saveUserRole(selectedRole);
// //       }
// //     }
// //   }
// //
// //   /// ✅ Continue Button Action - Navigates based on saved game mode
// //   void continueWithSelection() async {
// //     if (selectedIndex.value == -1) {
// //       Get.snackbar(
// //         'please_select_role'.tr,
// //         ''.tr,
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: Colors.redAccent.withOpacity(0.1),
// //         colorText: Colors.black,
// //       );
// //       return;
// //     }
// //
// //     final selectedRole = roles[selectedIndex.value];
// //
// //     // Get the saved game mode
// //     final savedGameMode = await SharedPrefs.getGameMode();
// //     print('🎮 RoleSelection - Current game mode: $savedGameMode');
// //
// //     // Navigate based on the game mode
// //     switch (savedGameMode) {
// //       case 'team':
// //       // Team mode flow
// //         Get.toNamed(
// //           AppRoutes.assignRoleScreen,
// //           arguments: {'selectedRole': selectedRole},
// //         );
// //         break;
// //
// //       case 'campaign':
// //       // Campaign mode flow: Role → Campaign Screen
// //         print('🎯 Campaign mode selected, navigating to campaign screen');
// //         Get.toNamed(
// //           AppRoutes.campaignModeScreen,
// //           arguments: {'selectedRole': selectedRole},
// //         );
// //         break;
// //
// //       case 'solo':
// //       default:
// //       // Solo mode flow: Role → Industry Selection
// //         print('🎯 Solo mode selected, navigating to industry selection');
// //         Get.toNamed(
// //           AppRoutes.chooseIndustry,
// //           arguments: {'selectedRole': selectedRole},
// //         );
// //         break;
// //     }
// //   }
// //
// //   /// ✅ Tutorial
// //   void openTutorial() {
// //     Get.snackbar(
// //       'tutorial'.tr,
// //       'opening_tutorial'.tr,
// //       snackPosition: SnackPosition.BOTTOM,
// //     );
// //   }
// //
// //   /// ✅ Back to Home
// //   void backToHome() {
// //     Get.offAllNamed(AppRoutes.home);
// //   }
// // }
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// // //
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:game_app/core/app_colors.dart';
// // // import 'package:get/get.dart';
// // //
// // // import '../presentation/routes/app_routes.dart';
// // // import '../services/shared_preference.dart';
// // //
// // // class RoleSelectionController extends GetxController {
// // //   final RxInt selectedIndex = (-1).obs;
// // //
// // //   final List<Map<String, dynamic>> roles = [
// // //     {
// // //       'id': 0,
// // //       'title': 'CEO'.tr,
// // //       'subtitle': 'Strategic Visionary'.tr,
// // //       'extra': 'Lead from the top'.tr,
// // //       'asset': 'assets/images/solo.svg',
// // //       'tagColor': 0xFFFFC857,
// // //       'accent': 0xFFCC4A2E,
// // //       'icon': Icons.emoji_events,
// // //       'iconBg': const Color(0xFFFFC857),
// // //     },
// // //     {
// // //       'id': 1,
// // //       'title': 'Manager'.tr,
// // //       'subtitle': 'Team Leader'.tr,
// // //       'extra': 'Drive execution'.tr,
// // //       'asset': 'assets/images/solo.svg',
// // //       'tagColor': AppColors.reddish,
// // //       'accent': AppColors.reddish,
// // //       'icon': Icons.groups,
// // //       'iconBg': AppColors.reddish,
// // //     },
// // //     {
// // //       'id': 2,
// // //       'title': 'Strategist'.tr,
// // //       'subtitle': 'Master Planner'.tr,
// // //       'extra': 'Shape the future'.tr,
// // //       'asset': 'assets/images/solo.svg',
// // //       'tagColor': 0xFFA8D0E6,
// // //       'accent': 0xFF2E8FDE,
// // //       'icon': Icons.sports_cricket,
// // //       'iconBg': const Color(0xFF4CAF50),
// // //     },
// // //     {
// // //       'id': 3,
// // //       'title': 'HR Manager'.tr,
// // //       'subtitle': 'People Champion'.tr,
// // //       'extra': 'Empower teams'.tr,
// // //       'asset': 'assets/images/solo.svg',
// // //       'tagColor': 0xFFF3C6E0,
// // //       'accent': 0xFFB14AAE,
// // //       'icon': Icons.favorite,
// // //       'iconBg': const Color(0xFFFF80AB),
// // //     },
// // //   ];
// // //
// // //   @override
// // //   void onInit() {
// // //     super.onInit();
// // //     selectedIndex.value = SharedPrefs.getSelectedRoleIndex();
// // //   }
// // //
// // //   /// ✅ Select or Deselect a Role
// // //   void selectRole(int index) {
// // //     if (index >= 0 && index < roles.length) {
// // //       if (selectedIndex.value == index) {
// // //         selectedIndex.value = -1;
// // //         SharedPrefs.saveSelectedRoleIndex(-1);
// // //       } else {
// // //         selectedIndex.value = index;
// // //         SharedPrefs.saveSelectedRoleIndex(index);
// // //         final selectedRole = roles[index]['title'] ?? '';
// // //         SharedPrefs.saveUserRole(selectedRole);
// // //       }
// // //     }
// // //   }
// // //
// // //   /// ✅ Continue Button Action - Navigates based on saved game mode
// // //   void continueWithSelection() async {
// // //     if (selectedIndex.value == -1) {
// // //       Get.snackbar(
// // //         'please_select_role'.tr,
// // //         ''.tr,
// // //         snackPosition: SnackPosition.BOTTOM,
// // //         backgroundColor: Colors.redAccent.withOpacity(0.1),
// // //         colorText: Colors.black,
// // //       );
// // //       return;
// // //     }
// // //
// // //     final selectedRole = roles[selectedIndex.value];
// // //
// // //     // Get the saved game mode
// // //     final savedGameMode = await SharedPrefs.getGameMode();
// // //
// // //     // Navigate based on the game mode
// // //     switch (savedGameMode) {
// // //       case 'team':
// // //       //  we will chnage when comes from remote developer
// // //         Get.toNamed(
// // //           AppRoutes.assignRoleScreen, // Make sure this route exists
// // //           arguments: {'selectedRole': selectedRole},
// // //         );
// // //         break;
// // //
// // //       case 'campaign':
// // //       // Navigate to campaign mode screen
// // //         Get.toNamed(
// // //           AppRoutes.campaignModeScreen,
// // //           arguments: {'selectedRole': selectedRole},
// // //         );
// // //         break;
// // //
// // //       case 'solo':
// // //       default:
// // //       // Navigate to solo mode screen (choose industry)
// // //         Get.toNamed(
// // //           AppRoutes.chooseIndustry,
// // //           arguments: {'selectedRole': selectedRole},
// // //         );
// // //         break;
// // //     }
// // //   }
// // //
// // //   /// ✅ Tutorial
// // //   void openTutorial() {
// // //     Get.snackbar(
// // //       'tutorial'.tr,
// // //       'opening_tutorial'.tr,
// // //       snackPosition: SnackPosition.BOTTOM,
// // //     );
// // //   }
// // //
// // //   /// ✅ Back to Home
// // //   void backToHome() {
// // //     Get.offAllNamed(AppRoutes.home);
// // //   }
// // // }
// // //