// lib/view_models/suggestion_initiatives_view_model.dart

import 'package:flutter/material.dart';
import 'package:game_app/controllers/key_objective_controller.dart';
import 'package:game_app/controllers/language_controller.dart';
import 'package:game_app/controllers/strategy_selection_controller.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
import 'package:game_app/generated/models/responses/evaluate_initiative/evaluate_initiative_model.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/evaluate_initiative_repo.dart';
import '../../../../data/response/api_response.dart';
import '../../../../data/response/status.dart';
import '../../../../presentation/routes/app_routes.dart';

class SuggestionInitiativesViewModel extends GetxController {
  final firstInitiativeTitle = TextEditingController();
  final firstInitiativeDesc = TextEditingController();
  final secondInitiativeTitle = TextEditingController();
  final secondInitiativeDesc = TextEditingController();

  final EvaluateInitiativeRepository _repository = EvaluateInitiativeRepository();
  var isSubmitting = false.obs;
  var apiResponse = Rx<ApiResponse<EvaluateInitiativeModel>>(ApiResponse.loading());

  Future<void> submitInitiatives(List<KeyResult> selectedKeyResults) async {
    print('Submitting initiatives...');
    print('Selected Key Results: $selectedKeyResults');

    // Input validation
    if (firstInitiativeTitle.text.trim().isEmpty ||
        firstInitiativeDesc.text.trim().isEmpty ||
        secondInitiativeTitle.text.trim().isEmpty ||
        secondInitiativeDesc.text.trim().isEmpty) {
      print('Validation failed: One or more input fields are empty');
      Get.snackbar(
        'error'.tr,
        'fill_initiatives'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      isSubmitting.value = true;
      apiResponse.value = ApiResponse.loading();

      // Fetch controller data
      final strategyController = Get.find<StrategySelectionController>();
      final objectiveController = Get.find<KeyObjectiveController>();
      final languageController = Get.find<LanguageController>();

      final strategyTitle = strategyController.selectedStrategy.value?.title;
      final objectiveTitle = objectiveController.selectedObjective.value?.title;
      final language = languageController.selectedLanguage.value.name;

      print('Strategy Title: $strategyTitle');
      print('Objective Title: $objectiveTitle');
      print('Language: $language');

      if (strategyTitle == null || objectiveTitle == null) {
        print('Validation failed: Strategy or Objective is null');
        apiResponse.value = ApiResponse.error('Required data not found');
        Get.snackbar(
          'error'.tr,
          'Required data not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      final initiatives = [
        '${firstInitiativeTitle.text.trim()} - ${firstInitiativeDesc.text.trim()}',
        '${secondInitiativeTitle.text.trim()} - ${secondInitiativeDesc.text.trim()}',
      ];

      print('Initiatives: $initiatives');

      // API call
      final response = await _repository.evaluateInitiatives(
        strategy: strategyTitle,
        objective: objectiveTitle,
        initiatives: initiatives,
        keyResults: selectedKeyResults,
        language: language,
      );

      print('API Response Status: ${response.status}');
      print('API Response Data: ${response.data?.toJson()}');
      print('API Response Message: ${response.message}');
      print('Is Status.COMPLETED: ${response.status == Status.COMPLETED}');
      print('Is Data Not Null: ${response.data != null}');

      apiResponse.value = response;

      if (response.status == Status.COMPLETED && response.data != null) {
        print('Success: Navigating to AIAnalysisShowScreen with data: ${response.data?.toJson()}');
        Get.snackbar(
          'success'.tr,
          'Initiatives evaluated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(
          AppRoutes.aiAnalysisShowScreen,
          arguments: response.data,
        );
      } else {
        print('Error: API response validation failed');
        print('Status: ${response.status}, Data: ${response.data}, Message: ${response.message}');
        Get.snackbar(
          'error'.tr,
          response.message ?? 'Failed to process API response',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Exception caught: $e');
      apiResponse.value = ApiResponse.error(e.toString());
      Get.snackbar(
        'error'.tr,
        'Error: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isSubmitting.value = false;
      print('isSubmitting reset to: ${isSubmitting.value}');
    }
  }

  EvaluateInitiativeModel? get evaluationResult => apiResponse.value.data;
  bool get hasData => apiResponse.value.status == Status.COMPLETED;

  @override
  void onClose() {
    firstInitiativeTitle.dispose();
    firstInitiativeDesc.dispose();
    secondInitiativeTitle.dispose();
    secondInitiativeDesc.dispose();
    super.onClose();
  }
}