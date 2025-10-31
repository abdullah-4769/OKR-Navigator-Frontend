// lib/view_models/feedback_evaluation_view_model.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:game_app/controllers/key_objective_controller.dart';
import 'package:game_app/controllers/language_controller.dart';
import 'package:game_app/controllers/strategy_selection_controller.dart';
import 'package:game_app/data/response/api_response.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
import 'package:game_app/services/shared_preference.dart';

import '../../data/response/status.dart';
import '../../generated/models/requests/campaign_mode/feedback_evaluation_model.dart';
import '../../generated/models/responses/key_results/key_results_response.dart' as key_result_models;
import '../../repository/campaign_mode/feedback_evaluation_repository.dart';

class FeedbackEvaluationViewModel extends GetxController {
  final FeedbackEvaluationRepository _repository = FeedbackEvaluationRepository();
  var apiResponse = Rx<ApiResponse<FeedbackEvaluationModel>>(ApiResponse.loading());
  var isLoading = false.obs;
  Future<void> evaluateSelectedKeyResults(List<key_result_models.KeyResult> selectedKeyResults) async  {
    try {
      isLoading.value = true;
      apiResponse.value = ApiResponse.loading();

      // Get all required data from controllers and SharedPreferences
      final strategyController = Get.find<StrategySelectionController>();
      final objectiveController = Get.find<KeyObjectiveController>();
      final languageController = Get.find<LanguageController>();

      final strategyTitle = strategyController.selectedStrategy.value?.title;
      final objectiveTitle = objectiveController.selectedObjective.value?.title;
      final language = languageController.selectedLanguage.value.name;
      final userRole = SharedPrefs.getUserRole();

      if (strategyTitle == null || objectiveTitle == null || userRole == null) {
        throw Exception('Required data not found');
      }

      // Get industry/organization based on game mode
      final industryOrOrganization = await _getIndustryOrOrganization();

      // Convert key results to string format for API
      final keyResultsString = _formatKeyResults(selectedKeyResults);

      print('🎯 Evaluating OKR with:');
      print('   Strategy: $strategyTitle');
      print('   Role: $userRole');
      print('   Industry/Org: $industryOrOrganization');
      print('   Objective: $objectiveTitle');
      print('   Key Results: $keyResultsString');
      print('   Language: $language');

      // API call
      final response = await _repository.evaluateOKR(
        strategy: strategyTitle,
        role: userRole,
        industry: industryOrOrganization,
        objective: objectiveTitle,
        keyResults: keyResultsString,
        language: language,
      );

      apiResponse.value = response;

      if (response.status == Status.completed && response.data != null) {
        print('✅ Evaluation successful: ${response.data!.overallScore}');
      } else {
        print('❌ Evaluation failed: ${response.message}');
        throw Exception(response.message ?? 'Evaluation failed');
      }
    } catch (e) {
      print('❌ Error in evaluation: $e');
      apiResponse.value = ApiResponse.error(e.toString());
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }


  Future<String> _getIndustryOrOrganization() async {
    try {
      final savedMode = await SharedPrefs.getGameMode();
      final isCampaignMode = savedMode == 'campaign';

      print('🎮 Game Mode: $savedMode, Is Campaign: $isCampaignMode');

      if (isCampaignMode) {
        // Campaign mode: Use organization data
        final organizationData = SharedPrefs.getSelectedIndustry();
        if (organizationData != null) {
          final orgTitle = organizationData['titleKey']?.toString() ?? 'organization_a';
          print('🎯 Campaign Mode: Using organization - $orgTitle');
          return orgTitle;
        } else {
          print('⚠️ Campaign Mode: No organization data found, using default');
          return 'organization_a';
        }
      } else {
        // Solo mode: Get industry data from SharedPreferences
        final industryData = SharedPrefs.getSelectedIndustry();
        final industryTitle = industryData?['titleKey']?.toString() ?? 'general_industry';
        print('🎯 Solo Mode: Using industry - $industryTitle');
        return industryTitle;
      }
    } catch (e) {
      print('❌ Error getting industry/organization: $e');
      return 'general_industry';
    }
  }

  String _formatKeyResults(List<KeyResult> keyResults) {
    return keyResults.map((kr) {
      final title = kr.title?.tr ?? '';
      final description = kr.description?.tr ?? '';
      return '$title - $description';
    }).join(',\n');
  }

  FeedbackEvaluationModel? get evaluationResult => apiResponse.value.data;
  bool get hasData => apiResponse.value.status == Status.completed;
  bool get isLoadingData => isLoading.value;
}