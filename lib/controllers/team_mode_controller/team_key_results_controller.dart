import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'team_strategy_selection_controller.dart'; 
import '../language_controller.dart'; 

class TeamKeyResultsController extends GetxController {
 final StrategyRepository repo = Get.find<StrategyRepository>();

 RxBool loading = false.obs;
 RxList<KeyResult> keyResults = <KeyResult>[].obs;
 RxList<int> selectedIndexes = <int>[].obs;
 RxInt selectedCount = 0.obs;
 RxInt requiredCount = 3.obs;
 final RxBool hasFetched = false.obs; // Guard flag to prevent redundant fetching

 @override
 void onInit() {
  super.onInit();
 }

 /// Fetches key results by generating them first, influenced by all objectives.
 Future<void> fetchKeyResults() async {
    // 1. GUARD CLAUSE: Stop if data has already been fetched once successfully.
    if (hasFetched.value) {
      log('KR Fetch: Skipping fetch, already completed once.');
      return;
    }
    
    // 2. Retrieve arguments passed from the previous screen
    final args = Get.arguments as Map<String, dynamic>?;
    // Capture all objective titles passed from TeamObjectiveScreen
    final List<String> objectiveTitles = (args?['objectiveTitles'] as List<String>?) ?? []; 
    
    // 3. Get necessary controllers and data
    final strategyController = Get.find<TeamStrategySelectionController>();
    final strategyTitle = strategyController.teamStrategyResponse.value?.title;
    final strategyId = strategyController.teamStrategyResponse.value?.strategyId; 
    
    // Use a default role and language
    const String role = 'HOST'; 
    final String language = Get.find<LanguageController>().selectedLanguage.value.code;

    log('KR Fetch: Attempting to fetch with Strategy ID: $strategyId, Objectives Count: ${objectiveTitles.length}'); 

     if (strategyId == null || strategyTitle == null || objectiveTitles.isEmpty) {
      log('KR Fetch: FAILED - Missing critical data.');
      SnackbarHelper.error('missing_strategy_objectives'.tr);
     
     // Fallback to minimal KRs if data is missing
     keyResults.assignAll([
      KeyResult(id: 1, title: 'achieve_revenue_new_products', description: 'generate_revenue_stream'),
      KeyResult(id: 2, title: 'acquire_10000_customers', description: 'build_customer_base'),
      KeyResult(id: 3, title: 'achieve_15_market_share', description: 'establish_market_presence'),
     ]);
     hasFetched.value = true;
     return;
    }

    try {
      loading.value = true;
      hasFetched.value = true; // Set flag true as fetch starts
      
      log('KR Fetch: Calling API to create/generate key results using all objectives...');
      
      // 4. Call the generation method using ALL objective titles
      final generatedKeyResults = await repo.createBatchKeyResults(
          strategy: strategyTitle,
          objectives: objectiveTitles,
          role: role, 
          language: language,
      );
      
      // 5. Check results
      if (generatedKeyResults.isEmpty) {
      log('KR Fetch: API returned empty list after generation. Using list.');
      SnackbarHelper.warning('no_key_results_generated'.tr);

        // Fallback data structure 
        keyResults.assignAll([
          KeyResult(id: 1, title: 'achieve_revenue_new_products', description: 'generate_revenue_stream'),
          KeyResult(id: 2, title: 'acquire_10000_customers', description: 'build_customer_base'),
          KeyResult(id: 3, title: 'achieve_15_market_share', description: 'establish_market_presence'),
        ]);
        
      } else {
        log('KR Fetch: Successfully received ${generatedKeyResults.length} key results.');
        // Assign the generated list
        keyResults.assignAll(generatedKeyResults);
      }
      
     } catch (e) {
     log('KR Fetch: EXCEPTION - ${e.toString()}');
     // Show a clean, translated error without low‑level Dio details
     SnackbarHelper.error('failed_generate_key_results'.tr);
     keyResults.clear();
     // Reset flag on error so a retry can be attempted (e.g., via refresh)
     hasFetched.value = false;
    } finally {
     loading.value = false;
    }
  }

  /// Toggle selection for a key result
  void toggleSelection(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      if (selectedIndexes.length < requiredCount.value) {
        selectedIndexes.add(index);
      } else {
        SnackbarHelper.info('You can select up to ${requiredCount.value} key results.');
      }
    }
    selectedCount.value = selectedIndexes.length;
  }

  bool isSelected(int index) => selectedIndexes.contains(index);

  /// Returns selected KeyResult objects
  List<KeyResult> getSelectedKeyResults() =>
      selectedIndexes.map((i) => keyResults[i]).toList();

  /// Returns only titles of selected KeyResults
  List<String> getSelectedTitles() =>
      selectedIndexes.map((i) => keyResults[i].title ?? '').toList();
}