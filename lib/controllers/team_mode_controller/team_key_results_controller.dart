import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'team_strategy_selection_controller.dart'; 

class TeamKeyResultsController extends GetxController {
 final StrategyRepository repo = Get.find<StrategyRepository>();

 RxBool loading = false.obs;
 RxList<KeyResult> keyResults = <KeyResult>[].obs;
 RxList<int> selectedIndexes = <int>[].obs;
 RxInt selectedCount = 0.obs;
 RxInt requiredCount = 3.obs;
 final RxBool hasFetched = false.obs; // <--- NEW: Guard flag to prevent infinite loops

 @override
 void onInit() {
  super.onInit();
 }

 /// Fetches key results using the selected team strategy ID
 Future<void> fetchKeyResults() async {
    // [FIX 1: GUARD CLAUSE] Stop if data has already been fetched once successfully.
    if (hasFetched.value) {
      log('KR Fetch: Skipping fetch, already completed once.');
      return;
    }

  final strategyController = Get.find<TeamStrategySelectionController>();
  // Get the strategy ID from the team strategy response
  final strategyId = strategyController.teamStrategyResponse.value?.strategyId; 

  log('KR Fetch: Attempting to fetch with Strategy ID: $strategyId'); 

  if (strategyId == null) {
   log('KR Fetch: FAILED - Strategy ID is null.');
   SnackbarHelper.error('Missing Strategy ID. Cannot fetch Key Results.');
   return;
  }

  try {
   loading.value = true;
      // [FIX 2: SET FLAG] Set the flag true while the API call is in progress.
      hasFetched.value = true;
      
   log('KR Fetch: Calling API for strategyId $strategyId...');
   // ✅ API Call: GET /key-result/by-strategy
   final results = await repo.getKeyResultsByStrategy(strategyId); //

   if (results.isEmpty) {
    log('KR Fetch: API returned empty list. Using fallback.');
    SnackbarHelper.warning('No key results found for this strategy. Using fallback.');
    // Fallback data structure updated to match KeyResult object properties
    keyResults.assignAll([
     KeyResult(id: 1, title: 'achieve_revenue_new_products', description: 'generate_revenue_stream'), //
     KeyResult(id: 2, title: 'acquire_10000_customers', description: 'build_customer_base'), //
     KeyResult(id: 3, title: 'achieve_15_market_share', description: 'establish_market_presence'), //
    ]);
    
   } else {
    log('KR Fetch: Successfully received ${results.length} key results.');
    keyResults.assignAll(results);
   }
   
  } catch (e) {
   log('KR Fetch: EXCEPTION - ${e.toString()}');
   SnackbarHelper.error('Failed to fetch key results: ${e.toString()}'); //
   keyResults.clear();
      // [FIX 3: RESET FLAG ON ERROR] Reset the flag so the fetch can be attempted again later.
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