// lib/view_models/feedback_evaluation_view_model.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game_app/controllers/role_selection_controller.dart';
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
  // Future<void> evaluateSelectedKeyResults(List<key_result_models.KeyResult> selectedKeyResults) async  {
  //   try {
  //     isLoading.value = true;
  //     apiResponse.value = ApiResponse.loading();
  //
  //     // Get all required data from controllers and SharedPreferences
  //     final strategyController = Get.find<StrategySelectionController>();
  //     final objectiveController = Get.find<KeyObjectiveController>();
  //     final languageController = Get.find<LanguageController>();
  //
  //     final strategyTitle = strategyController.selectedStrategy.value?.title;
  //     final objectiveTitle = objectiveController.selectedObjective.value?.title;
  //     final language = languageController.selectedLanguage.value.name;
  //     final userRole = SharedPrefs.getUserRole();
  //
  //     if (strategyTitle == null || objectiveTitle == null || userRole == null) {
  //       throw Exception('Required data not found');
  //     }
  //
  //     // Get industry/organization based on game mode
  //     final industryOrOrganization = await _getIndustryOrOrganization();
  //
  //     // Convert key results to string format for API
  //     final keyResultsString = _formatKeyResults(selectedKeyResults);
  //
  //     print('🎯 Evaluating OKR with:');
  //     print('   Strategy: $strategyTitle');
  //     print('   Role: $userRole');
  //     print('   Industry/Org: $industryOrOrganization');
  //     print('   Objective: $objectiveTitle');
  //     print('   Key Results: $keyResultsString');
  //     print('   Language: $language');
  //
  //     // API call
  //     final response = await _repository.evaluateOKR(
  //       strategy: strategyTitle,
  //       role: userRole,
  //       industry: industryOrOrganization,
  //       objective: objectiveTitle,
  //       keyResults: keyResultsString,
  //       language: language,
  //     );
  //
  //     apiResponse.value = response;
  //
  //     if (response.status == Status.completed && response.data != null) {
  //       print('✅ Evaluation successful: ${response.data!.overallScore}');
  //     } else {
  //       print('❌ Evaluation failed: ${response.message}');
  //       throw Exception(response.message ?? 'Evaluation failed');
  //     }
  //   } catch (e) {
  //     print('❌ Error in evaluation: $e');
  //     apiResponse.value = ApiResponse.error(e.toString());
  //     rethrow;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
// In FeedbackEvaluationViewModel - update the evaluateSelectedKeyResults method
  Future<void> evaluateSelectedKeyResults(List<key_result_models.KeyResult> selectedKeyResults) async {
    try {
      isLoading.value = true;
      apiResponse.value = ApiResponse.loading();

      print('🎯 Starting evaluation with ${selectedKeyResults.length} key results');

      // Get all required data from multiple sources
      final strategyTitle = await _getStrategyTitle();
      final objectiveTitle = await _getObjectiveTitle();
      final language = await _getLanguage();
      final userRole = await _getUserRole();

      if (strategyTitle.isEmpty || objectiveTitle.isEmpty || userRole.isEmpty) {
        print('❌ Missing required data:');
        print('   - Strategy: $strategyTitle');
        print('   - Objective: $objectiveTitle');
        print('   - Role: $userRole');
        throw Exception('Required data not found. Please complete previous steps.');
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
      print('   Key Results Count: ${selectedKeyResults.length}');
      print('   Language: $language');

      // ✅ SAVE KEY RESULTS FOR LATER USE
      await _saveSelectedKeyResults(selectedKeyResults);

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

// ✅ ADD THESE HELPER METHODS
  Future<String> _getStrategyTitle() async {
    try {
      // Try controller first
      final strategyController = Get.find<StrategySelectionController>();
      final strategy = strategyController.selectedStrategy.value;
      if (strategy?.title != null && strategy!.title!.isNotEmpty) {
        return strategy.title!;
      }

      // Try SharedPreferences
      final strategyData = await SharedPrefs.getSelectedStrategy();
      if (strategyData != null && strategyData['title'] != null) {
        return strategyData['title'].toString();
      }

      // Try certificate data
      final certificateStrategy = SharedPrefs.getCertificateSelectedAIStrategy();
      if (certificateStrategy.isNotEmpty && certificateStrategy['title'] != null) {
        return certificateStrategy['title'].toString();
      }

      return 'Default Strategy';
    } catch (e) {
      print('❌ Error getting strategy: $e');
      return 'Default Strategy';
    }
  }

  Future<String> _getObjectiveTitle() async {
    try {
      // Try controller first
      final objectiveController = Get.find<KeyObjectiveController>();
      final objective = objectiveController.selectedObjective.value;
      if (objective?.title != null && objective!.title!.isNotEmpty) {
        return objective.title!;
      }

      // Try SharedPreferences
      final objectiveData = await SharedPrefs.getSelectedObjective();
      if (objectiveData != null && objectiveData['title'] != null) {
        return objectiveData['title'].toString();
      }

      // Try certificate data
      final certificateObjective = SharedPrefs.getCertificateObjective();
      if (certificateObjective['title']?.isNotEmpty == true) {
        return certificateObjective['title']!;
      }

      return 'Default Objective';
    } catch (e) {
      print('❌ Error getting objective: $e');
      return 'Default Objective';
    }
  }

  Future<String> _getUserRole() async {
    try {
      // Try SharedPreferences first
      final roleData = await SharedPrefs.getSelectedRole();
      if (roleData != null && roleData['titleKey'] != null) {
        return roleData['titleKey'].toString();
      }

      // Try user role
      final userRole = SharedPrefs.getUserRole();
      if (userRole != null) {
        return userRole;
      }

      // Try selected role index
      final selectedRoleIndex = SharedPrefs.getSelectedRoleIndex();
      if (selectedRoleIndex != -1) {
        final roleController = Get.find<RoleSelectionController>();
        if (selectedRoleIndex < roleController.roles.length) {
          final roleData = roleController.roles[selectedRoleIndex];
          return roleData['titleKey']?.toString() ?? 'Manager';
        }
      }

      return 'Manager';
    } catch (e) {
      print('❌ Error getting user role: $e');
      return 'Manager';
    }
  }

  Future<String> _getLanguage() async {
    try {
      final languageController = Get.find<LanguageController>();
      return languageController.selectedLanguage.value.name;
    } catch (e) {
      print('❌ Error getting language: $e');
      return 'English';
    }
  }

// ✅ SAVE KEY RESULTS FOR LATER USE
  Future<void> _saveSelectedKeyResults(List<key_result_models.KeyResult> selectedKeyResults) async {
    try {
      final keyResultsJson = jsonEncode(selectedKeyResults.map((kr) => {
        'id': kr.id,
        'title': kr.title,
        'description': kr.description,
        // 'tag1': kr.tag1,
        // 'tag2': kr.tag2,
      }).toList());

      await SharedPrefs.saveString('selected_key_results', keyResultsJson);
      print('💾 Saved ${selectedKeyResults.length} key results to SharedPreferences');
    } catch (e) {
      print('❌ Error saving key results: $e');
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