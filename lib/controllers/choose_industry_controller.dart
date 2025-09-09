import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../presentation/routes/app_routes.dart';

class ChooseIndustryController extends GetxController {
  final RxInt selectedIndex = (-1).obs;

  final List<Map<String, dynamic>> industries = [
    {
      'title': 'Technology'.tr,
      'description': 'Software, SaaS, Digital Products'.tr,
      'icon': Icons.computer,
    },
    {
      'title': 'Finance & Banking'.tr,
      'description': 'Investment, Insurance, Fintech'.tr,
      'icon': Icons.account_balance,
    },
    {
      'title': 'Healthcare'.tr,
      'description': 'Medical, Pharma, Health Tech'.tr,
      'icon': Icons.local_hospital,
    },
  ];

  void selectIndustry(int index) {
    selectedIndex.value = index;
  }

  void continueWithSelection(Map<String, dynamic>? selectedRole) {
    if (selectedIndex.value == -1) {
      Get.snackbar(
        'Select Industry'.tr,
        'Please select an industry to continue'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final selectedIndustry = industries[selectedIndex.value];

    Get.snackbar(
      'Selected'.tr,
      'You selected: ${selectedIndustry['title']}'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.toNamed(
      AppRoutes.selectStrategy,
      arguments: {
        'selectedIndustry': selectedIndustry,
        'selectedRole': selectedRole,
      },
    );
  }

  void openTutorial() {
    Get.snackbar(
      'Tutorial'.tr,
      'Open tutorial video (to be handled later)'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void backToHome() {
    Get.offAllNamed(AppRoutes.home);
  }
}
