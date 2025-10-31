import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../generated/models/requests/key_results_latest_model.dart';
import '../repository/key_result_latest_repo.dart';

// Import your existing KeyResult model
import '../../../generated/models/responses/key_results/key_results_response.dart';

class KeyResultsLatestViewModel extends GetxController {
  final KeyResultsLatestRepository _repository = KeyResultsLatestRepository();

  final RxList<KeyResultLatest> allKeyResults = <KeyResultLatest>[].obs;
  final RxList<int> selectedIndices = <int>[].obs;
  final RxBool loading = false.obs;
  final RxString error = ''.obs;

  // Configuration
  final int requiredCount = 3;

  // Getters
  int get selectedCount => selectedIndices.length;
  bool get isSelectionComplete => selectedCount >= requiredCount;
  List<KeyResultLatest> get selectedKeyResults => selectedIndices
      .map((index) => allKeyResults[index])
      .toList();

  // Check if index is selected
  bool isSelected(int index) => selectedIndices.contains(index);

  // Toggle selection
  void toggleSelection(int index) {
    if (isSelected(index)) {
      selectedIndices.remove(index);
    } else {
      if (selectedCount < requiredCount) {
        selectedIndices.add(index);
      } else {
        // Show message that maximum selection reached
        Get.snackbar(
          'Maximum Selection',
          'You can only select $requiredCount key results',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
    update();
  }

  // Clear all selections
  void clearSelections() {
    selectedIndices.clear();
    update();
  }// Add this method to your ViewModel class
  void shuffleKeyResults() {
    final shuffled = List<KeyResultLatest>.from(allKeyResults)..shuffle();
    allKeyResults.assignAll(shuffled);
    print('🔄 Shuffled ${allKeyResults.length} key results for random display');
  }

// Call this after loading key results in generateKeyResults method:
  Future<void> generateKeyResults({
    required String strategy,
    required List<String> objectives,
    required String role,
    required String language,
  }) async {
    try {
      print('🚀 Starting key results generation...');

      loading.value = true;
      error.value = '';

      final responses = await _repository.generateKeyResultsBatch(
        strategy: strategy,
        objectives: objectives,
        role: role,
        language: language,
      );

      print('✅ API Response received with ${responses.length} objectives');

      // Extract ALL key results from ALL responses
      final List<KeyResultLatest> allResults = [];
      for (final response in responses) {
        print('📦 Objective: ${response.objective} - ${response.keyResults.length} key results');
        allResults.addAll(response.keyResults);
      }

      print('🎉 Total key results generated: ${allResults.length}');

      // ✅ SHUFFLE the results for random display
      allResults.shuffle();
      print('🔄 Shuffled key results for random display');

      allKeyResults.assignAll(allResults);
      selectedIndices.clear();

    } catch (e) {
      print('❌ Error generating key results: $e');
      error.value = 'Failed to generate key results: $e';
      Get.snackbar(
        'Error',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
      print('🏁 Key results generation completed');
    }
  }
  // Add this method to convert KeyResultLatest to KeyResult
  List<KeyResult> getSelectedKeyResultsAsKeyResult() {
    return selectedKeyResults.map((kr) => KeyResult(
      id: kr.id,
      title: kr.title,
      description: kr.description,
      // Add other properties as needed by your KeyResult model
      // Make sure these match your KeyResult class properties
    )).toList();
  }

  // Get selected key results as Map (for compatibility with existing code)
  List<Map<String, dynamic>> getSelectedKeyResults() {
    return selectedKeyResults.map((kr) => kr.toCompatibleMap()).toList();
  }

  // Get selected key results as KeyResultLatest list
  List<KeyResultLatest> getSelectedKeyResultsLatest() {
    return selectedKeyResults;

  }


}