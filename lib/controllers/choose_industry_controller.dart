import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../presentation/routes/app_routes.dart';

class ChooseIndustryController extends GetxController {
  final RxInt selectedIndex = (-1).obs;
  final List<Map<String, dynamic>> industries = [
    {
      'titleKey': 'technology',
      'descriptionKey': 'technology_desc',
      'icon': Icons.computer,
    },
    {
      'titleKey': 'finance_banking',
      'descriptionKey': 'finance_banking_desc',
      'icon': Icons.account_balance,
    },
    {
      'titleKey': 'healthcare',
      'descriptionKey': 'healthcare_desc',
      'icon': Icons.local_hospital,
    },
    {
      'titleKey': 'Energy & Utilities',
      'descriptionKey': 'healthcare_desc',
      'icon': Icons.local_hospital,
    },
    {
      'titleKey': 'Logistics & Transports',
      'descriptionKey': 'healthcare_desc',
      'icon': Icons.local_hospital,
    },
    {
      'titleKey': 'Public Sector & Government',
      'descriptionKey': 'healthcare_desc',
      'icon': Icons.local_hospital,
    },

    {
      'titleKey': 'Retail & Ecommerce',
      'descriptionKey': 'healthcare_desc',
      'icon': Icons.local_hospital,
    },

    {
      'titleKey': 'Telecommunication',
      'descriptionKey': 'healthcare_desc',
      'icon': Icons.local_hospital,
    },

    {
      'titleKey': 'Agriculture & Food Industry',
      'descriptionKey': 'healthcare_desc',
      'icon': Icons.local_hospital,
    },
  ];

  void selectIndustry(int index) {
    selectedIndex.value = index;
  }

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