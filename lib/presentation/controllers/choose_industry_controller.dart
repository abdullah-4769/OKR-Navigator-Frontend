import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class ChooseIndustryController extends GetxController {
  final RxInt selectedIndex = (-1).obs;

  final List<Map<String, dynamic>> industries = [
    {'title': 'Technology', 'description': 'Software, SaaS, Digital Products', 'icon': Icons.computer},
    {'title': 'Finance & Banking', 'description': 'Investment, Insurance, Fintech', 'icon': Icons.account_balance},
    {'title': 'Healthcare', 'description': 'Medical, Pharma, Health Tech', 'icon': Icons.local_hospital},
  ];

  void selectIndustry(int index) {
    selectedIndex.value = index;
  }

  void continueWithSelection(Map<String, dynamic>? selectedRole) {
    if (selectedIndex.value == -1) {
      Get.snackbar('Select Industry', 'Please select an industry to continue', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final selectedIndustry = industries[selectedIndex.value];

    Get.snackbar('Selected', 'You selected: ${selectedIndustry['title']}', snackPosition: SnackPosition.BOTTOM);

    Get.toNamed(AppRoutes.selectStrategy, arguments: {
      'selectedIndustry': selectedIndustry,
      'selectedRole': selectedRole,
    });
  }

  void openTutorial() {
    Get.snackbar('Tutorial', 'Open tutorial video (to be handled later)', snackPosition: SnackPosition.BOTTOM);
  }

  void backToHome() {
    Get.offAllNamed(AppRoutes.home);
  }
}


// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
//
// import '../routes/app_routes.dart';
//
// class ChooseIndustryController extends GetxController {
//   final RxInt selectedIndex = (-1).obs;
//
//   final List<Map<String, dynamic>> industries = [
//     {
//       'title': 'Technology',
//       'description': 'Software, SaaS, Digital Products',
//       'icon': Icons.computer,
//     },
//     {
//       'title': 'Finance & Banking',
//       'description': 'Investment, Insurance, Fintech',
//       'icon': Icons.account_balance,
//     },
//     {
//       'title': 'Healthcare',
//       'description': 'Medical, Pharma, Health Tech',
//       'icon': Icons.local_hospital,
//     },
//   ];
//
//   void selectIndustry(int index) {
//     selectedIndex.value = index;
//   }
//
//   void continueWithSelection(Map<String, dynamic>? selectedRole) {
//     if (selectedIndex.value == -1) {
//       Get.snackbar(
//         'Select Industry',
//         'Please select an industry to continue',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     final selectedIndustry = industries[selectedIndex.value];
//
//     Get.snackbar(
//       'Selected',
//       'You selected: ${selectedIndustry['title']}',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//
//     // ✅ Navigate to strategy screen with both role & industry
//     Get.toNamed(AppRoutes.selectStrategy, arguments: {
//       'selectedIndustry': selectedIndustry,
//       'selectedRole': selectedRole,
//     });
//   }
//
//   void openTutorial() {
//     Get.snackbar(
//       'Tutorial',
//       'Open tutorial video (to be handled later)',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   void backToHome() {
//     Get.offAllNamed(AppRoutes.home);
//   }
// }
