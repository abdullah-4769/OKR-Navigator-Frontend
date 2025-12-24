import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../presentation/routes/app_routes.dart';
import '../services/shared_preference.dart';

class ChooseIndustryController extends GetxController {
  final RxInt selectedIndex = (-1).obs;
  final RxList<Map<String, dynamic>> filteredIndustries = <Map<String, dynamic>>[].obs;

  final List<Map<String, dynamic>> industries = [
    {'titleKey': 'technology', 'descriptionKey': 'technology_desc', 'icon': Icons.computer},
    {'titleKey': 'Finance Banking', 'descriptionKey': 'finance_banking_desc', 'icon': Icons.account_balance},
    {'titleKey': 'healthcare', 'descriptionKey': 'healthcare_desc', 'icon': Icons.local_hospital},
    {'titleKey': 'Energy & Utilities', 'descriptionKey': 'energy_desc', 'icon': Icons.flash_on},
    {'titleKey': 'Logistics & Transports', 'descriptionKey': 'logistics_desc', 'icon': Icons.local_shipping},
    {'titleKey': 'Public Sector & Government', 'descriptionKey': 'public_sector_desc', 'icon': Icons.account_balance_outlined},
    {'titleKey': 'Retail & Ecommerce', 'descriptionKey': 'retail_desc', 'icon': Icons.storefront},
    {'titleKey': 'Telecommunication', 'descriptionKey': 'telecom_desc', 'icon': Icons.phone_android},
    {'titleKey': 'Agriculture & Food Industry', 'descriptionKey': 'agriculture_desc', 'icon': Icons.agriculture},
  ];

  @override
  void onInit() {
    super.onInit();
    filteredIndustries.assignAll(industries);

    // ✅ Restore last selected industry if exists
    final savedIndustry = SharedPrefs.getSelectedIndustry();
    if (savedIndustry != null) {
      final index = industries.indexWhere(
            (i) => i['titleKey'] == savedIndustry['titleKey'],
      );
      if (index != -1) {
        selectedIndex.value = index;
      }
    }
  }

  void filterIndustries(String query) {
    if (query.isEmpty) {
      filteredIndustries.assignAll(industries);
    } else {
      filteredIndustries.assignAll(
        industries.where(
              (industry) => industry['titleKey']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()),
        ),
      );
    }
  }

  void selectIndustry(int index) {
    selectedIndex.value = index;

    // ✅ Save the selected industry locally
    SharedPrefs.saveSelectedIndustry(industries[index]);
  }

  // ✅ SOLO MODE: Continue to strategy selection
  void continueWithSelection(Map<String, dynamic>? selectedRole) {
    if (selectedIndex.value == -1) {
      Get.snackbar(
        'please_select_industry'.tr,
        ''.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final selectedIndustry = industries[selectedIndex.value];

    Get.toNamed(
      AppRoutes.selectStrategy,
      arguments: {
        'selectedIndustry': selectedIndustry,
        'selectedRole': selectedRole,
      },
    );
  }

  // ✅ TEAM MODE: Continue to team creation
  void continueToTeamCreation() {
    if (selectedIndex.value == -1) {
      Get.snackbar(
        'please_select_industry'.tr,
        ''.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final selectedIndustry = industries[selectedIndex.value];

    Get.toNamed(
      AppRoutes.createTeam, // Your team creation route
      arguments: {
        'selectedIndustry': selectedIndustry,
      },
    );
  }

  void openTutorial() {
    Get.snackbar(
      'tutorial'.tr,
      'open_tutorial_video'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void backToHome() {
    Get.offAllNamed(AppRoutes.home);
  }
}


// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../presentation/routes/app_routes.dart';
// import '../services/shared_preference.dart';
//
// class ChooseIndustryController extends GetxController {
//   final RxInt selectedIndex = (-1).obs;
//   final RxList<Map<String, dynamic>> filteredIndustries = <Map<String, dynamic>>[].obs;
//
//   final List<Map<String, dynamic>> industries = [
//     {'titleKey': 'technology', 'descriptionKey': 'technology_desc', 'icon': Icons.computer},
//     {'titleKey': 'finance_banking', 'descriptionKey': 'finance_banking_desc', 'icon': Icons.account_balance},
//     {'titleKey': 'healthcare', 'descriptionKey': 'healthcare_desc', 'icon': Icons.local_hospital},
//     {'titleKey': 'Energy & Utilities', 'descriptionKey': 'energy_desc', 'icon': Icons.flash_on},
//     {'titleKey': 'Logistics & Transports', 'descriptionKey': 'logistics_desc', 'icon': Icons.local_shipping},
//     {'titleKey': 'Public Sector & Government', 'descriptionKey': 'public_sector_desc', 'icon': Icons.account_balance_outlined},
//     {'titleKey': 'Retail & Ecommerce', 'descriptionKey': 'retail_desc', 'icon': Icons.storefront},
//     {'titleKey': 'Telecommunication', 'descriptionKey': 'telecom_desc', 'icon': Icons.phone_android},
//     {'titleKey': 'Agriculture & Food Industry', 'descriptionKey': 'agriculture_desc', 'icon': Icons.agriculture},
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     filteredIndustries.assignAll(industries);
//
//     // ✅ Restore last selected industry if exists
//     final savedIndustry = SharedPrefs.getSelectedIndustry();
//     if (savedIndustry != null) {
//       final index = industries.indexWhere(
//             (i) => i['titleKey'] == savedIndustry['titleKey'],
//       );
//       if (index != -1) {
//         selectedIndex.value = index;
//       }
//     }
//   }
//
//   void filterIndustries(String query) {
//     if (query.isEmpty) {
//       filteredIndustries.assignAll(industries);
//     } else {
//       filteredIndustries.assignAll(
//         industries.where(
//               (industry) => industry['titleKey']
//               .toString()
//               .toLowerCase()
//               .contains(query.toLowerCase()),
//         ),
//       );
//     }
//   }
//
//   void selectIndustry(int index) {
//     selectedIndex.value = index;
//
//     // ✅ Save the selected industry locally
//     SharedPrefs.saveSelectedIndustry(industries[index]);
//   }
//
//   void continueWithSelection(Map<String, dynamic>? selectedRole) {
//     if (selectedIndex.value == -1) {
//       Get.snackbar(
//         'please_select_industry'.tr,
//         ''.tr,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     final selectedIndustry = industries[selectedIndex.value];
//
//     Get.toNamed(
//       AppRoutes.selectStrategy,
//       arguments: {
//         'selectedIndustry': selectedIndustry,
//         'selectedRole': selectedRole,
//       },
//     );
//   }
//
//   void openTutorial() {
//     Get.snackbar(
//       'tutorial'.tr,
//       'open_tutorial_video'.tr,
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   void backToHome() {
//     Get.offAllNamed(AppRoutes.home);
//   }
// }
