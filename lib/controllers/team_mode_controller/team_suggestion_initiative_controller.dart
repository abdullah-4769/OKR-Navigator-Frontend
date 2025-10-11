import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/routes/app_routes.dart';

class TeamSuggestionInitiativesController extends GetxController {
  final List<Map<String, dynamic>> keyResults;

  TeamSuggestionInitiativesController({required this.keyResults});

  final firstInitiativeTitle = TextEditingController();
  final firstInitiativeDesc = TextEditingController();
  final secondInitiativeTitle = TextEditingController();
  final secondInitiativeDesc = TextEditingController();

  var aiFeedback = ''.obs;
  var isSubmitting = false.obs;

  /// ✅ Properly typed Industry model
  final RxList<Map<String, dynamic>> industries = <Map<String, dynamic>>[
    {
      'title': 'Technology',
      'description': 'Innovate with cutting-edge solutions',
      'icon': Icons.memory,
      'tag1': 'High ROI',
      'tag2': 'Fast Growth',
    },

  ].obs;

  /// Track selected industry index
  var selectedIndustry = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    // ✅ Always select first industry by default
    selectedIndustry.value = 0;
  }

  /// ✅ Submit initiatives for AI analysis
  Future<void> submitInitiatives() async {
    if (firstInitiativeTitle.text.isEmpty ||
        firstInitiativeDesc.text.isEmpty ||
        secondInitiativeTitle.text.isEmpty ||
        secondInitiativeDesc.text.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'fill_initiatives'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      await Future.delayed(const Duration(seconds: 2));

      aiFeedback.value = 'initiatives_submitted'.tr;

      await Get.toNamed(
        AppRoutes.teamaiAnalysisScreen,
        arguments: {
          'keyResults': keyResults,
          'industry': selectedIndustry.value,
          'initiatives': [
            {
              'title': firstInitiativeTitle.text,
              'description': firstInitiativeDesc.text,
            },
            {
              'title': secondInitiativeTitle.text,
              'description': secondInitiativeDesc.text,
            },
          ],
        },
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    firstInitiativeTitle.dispose();
    firstInitiativeDesc.dispose();
    secondInitiativeTitle.dispose();
    secondInitiativeDesc.dispose();
    super.onClose();
  }
}
