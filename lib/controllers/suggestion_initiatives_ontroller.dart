import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presentation/routes/app_routes.dart';

class SuggestionInitiativesController extends GetxController {
  final List<Map<String, dynamic>> keyResults;

  SuggestionInitiativesController({required this.keyResults});

  final firstInitiativeTitle = TextEditingController();
  final firstInitiativeDesc = TextEditingController();
  final secondInitiativeTitle = TextEditingController();
  final secondInitiativeDesc = TextEditingController();

  var aiFeedback = ''.obs;
  var isSubmitting = false.obs;

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

      // 🔹 Future: Send data to backend / AI API
      // For now, just simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      aiFeedback.value = 'initiatives_submitted'.tr;

      // ✅ Navigate to next screen after success
      await Get.toNamed(
        AppRoutes.aiAnalysisShowScreen,
        arguments: {
          'keyResults': keyResults,
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
