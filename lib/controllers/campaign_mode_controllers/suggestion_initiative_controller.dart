import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:game_app/controllers/language_controller.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';

import '../../data/repositories/strategy_repository.dart';
import 'campaign_key_objective_controller.dart';
import 'campaign_object_sellection_controller.dart';

class CampaignSuggestionInitiativesController extends GetxController {
  final firstInitiativeTitle = TextEditingController();
  final firstInitiativeDesc = TextEditingController();
  final secondInitiativeTitle = TextEditingController();
  final secondInitiativeDesc = TextEditingController();

  var aiFeedback = ''.obs;
  var isSubmitting = false.obs;

  /// ✅ Submit initiatives for Campaign Mode AI analysis
  Future<void> submitInitiatives(List<KeyResult> selectedKeyResults) async {
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

      /// 🔹 Simulate API / repository call
      final response = await Get.find<StrategyRepository>().submitInitiatives(
        strategy: Get.find<CampaignStrategySelectionController>()
            .selectedStrategy
            .value?['title'] ??
            '',
        initiatives: [
          firstInitiativeTitle.text.trim(),
          firstInitiativeDesc.text.trim(),
          secondInitiativeTitle.text.trim(),
          secondInitiativeDesc.text.trim(),
        ],
        keyResults: selectedKeyResults,
        objective: Get.find<CampaignKeyObjectiveController>()
            .selectedObjective
            .value?['title'] ??
            '',
        language: Get.find<LanguageController>().selectedLanguage.value.name,
      );

      aiFeedback.value = 'initiatives_submitted'.tr;

      // ✅ Future navigation after success (optional)
      // await Get.toNamed(
      //   AppRoutes.campaignContextualChallenge,
      //   arguments: {
      //     'keyResults': selectedKeyResults,
      //     'initiatives': [
      //       {
      //         'title': firstInitiativeTitle.text,
      //         'description': firstInitiativeDesc.text,
      //       },
      //       {
      //         'title': secondInitiativeTitle.text,
      //         'description': secondInitiativeDesc.text,
      //       },
      //     ],
      //   },
      // );
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
