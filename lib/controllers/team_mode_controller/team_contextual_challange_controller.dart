// lib/controllers/team_mode_controller/team_contextual_challange_controller.dart

import 'dart:developer';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/controllers/team_mode_controller/team_objective_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_strategy_selection_controller.dart';
import 'package:game_app/controllers/language_controller.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import 'team_key_results_controller.dart'; 

class TeamContextualChallengeController extends GetxController {
  
  // Dependencies
  final TeamObjectiveController _objectiveController = Get.find<TeamObjectiveController>();
  final TeamKeyResultsController _keyResultsController = Get.find<TeamKeyResultsController>();
  final TeamStrategySelectionController _strategyController = Get.find<TeamStrategySelectionController>();
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
  final LanguageController _languageController = Get.find<LanguageController>();

  /// State to hold the current Initiatives 
  final RxList<String> finalInitiatives = <String>[].obs;
  
  // NEW: Challenge state variables
  final RxString challengeTitle = 'Market Disruption Challenge'.obs; // Default English/Key
  final RxString challengeDescription = 'A major competitor has launched a similar product at 30% lower price point, affecting your market positioning.'.obs; // Default English/Key
  final RxInt previousAttempts = 1.obs;
  final RxBool isLoadingChallenge = false.obs;
  
  // Existing unused or secondary state
  var teamName = ''.obs;
  var challengeStatus = ''.obs; 

  @override
  void onInit() {
    super.onInit();
    // Fetch the challenge immediately when the screen is accessed
    Future.delayed(Duration.zero, () {
        fetchChallenge();
    });
  }

  // --- NEW: Fetch challenge from API (POST /challenge) ---
  // Future<void> fetchChallenge() async {
  //   isLoadingChallenge.value = true;
  //   try {
  //       final strategyTitle = _strategyController.teamStrategyResponse.value?.title;
  //       final objectiveTitle = _objectiveController.selectedObjective.value?.title;
  //
  //       // Use titles of selected key results joined by a delimiter
  //       final keyResultTitles = _keyResultsController.getSelectedTitles();
  //       if (keyResultTitles.isEmpty) {
  //           throw Exception("Key Results not selected yet.");
  //       }
  //       final keyResultString = keyResultTitles.join('; ');
  //
  //       final language = _languageController.currentLanguage.code;
  //
  //       if (strategyTitle == null || objectiveTitle == null) {
  //           throw Exception("Missing strategy or objective data for challenge generation.");
  //       }
  //
  //       final response = await _strategyRepository.getChallenge(
  //           strategy: strategyTitle,
  //           objective: objectiveTitle,
  //           keyResult: keyResultString,
  //           previousAttempts: previousAttempts.value,
  //           language: language,
  //       );
  //
  //       // Update observables with response data
  //       if (response.title != null && response.text != null) {
  //           challengeTitle.value = response.title!;
  //           challengeDescription.value = response.text!;
  //           SnackbarHelper.success("New challenge loaded!".tr);
  //       } else {
  //            throw Exception("Invalid challenge response format or missing fields.");
  //       }
  //
  //   } catch (e) {
  //       log('Error fetching challenge: $e');
  //       SnackbarHelper.error('Failed to load challenge: ${e.toString()}');
  //       // Fallback to static/default data on error
  //       challengeTitle.value = 'Market Disruption Challenge'.tr;
  //       challengeDescription.value = 'A major competitor has launched a similar product at 30% lower price point, affecting your market positioning.'.tr;
  //   } finally {
  //       isLoadingChallenge.value = false;
  //   }
  // }
// Replace the fetchChallenge() method in team_contextual_challange_controller.dart

  Future<void> fetchChallenge() async {
    // ✅ GUARD: Don't fetch if key results aren't ready yet
    final keyResultTitles = _keyResultsController.getSelectedTitles();
    if (keyResultTitles.isEmpty) {
      log('Skipping challenge fetch: Key Results not selected yet.');
      return; // Exit silently without throwing error
    }

    isLoadingChallenge.value = true;
    try {
      final strategyTitle = _strategyController.teamStrategyResponse.value?.title;
      final objectiveTitle = _objectiveController.selectedObjective.value?.title;

      final keyResultString = keyResultTitles.join('; ');
      final language = _languageController.currentLanguage.code;

      if (strategyTitle == null || objectiveTitle == null) {
        throw Exception('Missing strategy or objective data for challenge generation.');
      }

      final response = await _strategyRepository.getChallenge(
        strategy: strategyTitle,
        objective: objectiveTitle,
        keyResult: keyResultString,
        previousAttempts: previousAttempts.value,
        language: language,
      );

      // Update observables with response data
      if (response.title != null && response.text != null) {
        challengeTitle.value = response.title!;
        challengeDescription.value = response.text!;
        SnackbarHelper.success("New challenge loaded!".tr);
      } else {
        throw Exception("Invalid challenge response format or missing fields.");
      }

    } catch (e) {
      log('Error fetching challenge: $e');
      SnackbarHelper.error('Failed to load challenge: ${e.toString()}');
      // Fallback to static/default data on error
      challengeTitle.value = 'Market Disruption Challenge'.tr;
      challengeDescription.value = 'A major competitor has launched a similar product at 30% lower price point, affecting your market positioning.'.tr;
    } finally {
      isLoadingChallenge.value = false;
    }
  }
  /// Propose adjustments for the team's strategy
  void proposeAdjustments() {
    // Increment attempts if user revisits adjustments (useful for challenge grading)
    // NOTE: This counter is currently local and does not persist across the whole game flow if the flow restarts.
    previousAttempts.value++; 
    Get.toNamed(AppRoutes.teamContextualAdjustmentScreen);
  }
  
  // --- Dynamic Getters for UI ---
  
  String get currentObjectiveTitle => _objectiveController.selectedObjective.value?.title ?? 'expand_emerging_markets';
  String get currentObjectiveDescription => _objectiveController.selectedObjective.value?.description ?? 'objective_description';
  
  List<Map<String, String>> get displayKeyResults {
      final selectedKR = _keyResultsController.getSelectedKeyResults();
      if(selectedKR.isEmpty) return []; 
      
      return selectedKR.map((kr) => {
          // Use raw title/description directly from KR object (they might be API strings)
          'title': kr.title ?? 'achieve_revenue_new_products', 
          'description': kr.description ?? 'generate_revenue_stream',
      }).toList();
  }

  List<Map<String, String>> get displayInitiatives {
      if (finalInitiatives.isEmpty) return [];

      return finalInitiatives.map((i) {
          final parts = i.split(' - ');
          return {
              'title': parts.length > 0 ? parts[0] : 'Initiative Title',
              'description': parts.length > 1 ? parts[1] : 'Initiative description missing.',
          };
      }).toList();
  }

  /// Navigates to Objective Selection Screen (Modify Objective)
  void modifyObjective() {
      Get.toNamed(
              AppRoutes.teamObjectiveSelectionScreen,
              arguments: {'isChallengeMode': true}
          );
      }
  
  /// Navigates to Key Results Screen (Adjust Key Results)
  void adjustKeyResults() {
     Get.toNamed(
              AppRoutes.teamKeyResultScreen,
              arguments: {'isChallengeMode': true}
          );
    
  }

  /// Navigates to Initiatives Suggestion Screen (Revise Initiatives)
  Future<void> reviseInitiatives() async {
  final result = await Get.toNamed(
    AppRoutes.teamSuggestionInitiativeScreen,
    arguments: {'isChallengeMode': true, 'keyResults': _keyResultsController.keyResults},
  );

  if (result != null && result['refreshed'] == true) {
    update();
  }
}
}