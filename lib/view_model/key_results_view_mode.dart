// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../generated/models/requests/key_results_latest_model.dart';
// import '../repository/key_result_latest_repo.dart';
//
//
// class KeyResultsLatestViewModel extends GetxController {
//   final KeyResultsLatestRepository _repository = KeyResultsLatestRepository();
//
//   final RxList<KeyResultLatest> allKeyResults = <KeyResultLatest>[].obs;
//   final RxList<int> selectedIndices = <int>[].obs;
//   final RxBool loading = false.obs;
//   final RxString error = ''.obs;
//
//   // Configuration
//   final int requiredCount = 3;
//
//   // Getters
//   int get selectedCount => selectedIndices.length;
//   bool get isSelectionComplete => selectedCount >= requiredCount;
//   List<KeyResultLatest> get selectedKeyResults => selectedIndices
//       .map((index) => allKeyResults[index])
//       .toList();
//
//   // Check if index is selected
//   bool isSelected(int index) => selectedIndices.contains(index);
//
//   // Toggle selection
//   void toggleSelection(int index) {
//     if (isSelected(index)) {
//       selectedIndices.remove(index);
//     } else {
//       if (selectedCount < requiredCount) {
//         selectedIndices.add(index);
//       } else {
//         // Show message that maximum selection reached
//         Get.snackbar(
//           'Maximum Selection',
//           'You can only select $requiredCount key results',
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//         );
//       }
//     }
//     update();
//   }
//
//   // Clear all selections
//   void clearSelections() {
//     selectedIndices.clear();
//     update();
//   }
//
//   // Generate key results from API
//   Future<void> generateKeyResults({
//     required String strategy,
//     required List<String> objectives,
//     required String role,
//     required String language,
//   }) async {
//     try {
//       loading.value = true;
//       error.value = '';
//
//       final responses = await _repository.generateKeyResults(
//         strategy: strategy,
//         objectives: objectives,
//         role: role,
//         language: language,
//       );
//
//       // Extract all key results from all responses
//       final List<KeyResultLatest> allResults = [];
//       for (final response in responses) {
//         allResults.addAll(response.keyResults);
//       }
//
//       allKeyResults.assignAll(allResults);
//       selectedIndices.clear();
//
//     } catch (e) {
//       error.value = 'Failed to generate key results: $e';
//       Get.snackbar(
//         'Error',
//         error.value,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       loading.value = false;
//     }
//   }
//
//   // Generate mock key results (for testing)
//   Future<void> generateMockKeyResults({
//     required String strategy,
//     required List<String> objectives,
//     required String role,
//     required String language,
//   }) async {
//     try {
//       loading.value = true;
//       error.value = '';
//
//       final responses = await _repository.generateMockKeyResults(
//         strategy: strategy,
//         objectives: objectives,
//         role: role,
//         language: language,
//       );
//
//       // Extract all key results from all responses
//       final List<KeyResultLatest> allResults = [];
//       for (final response in responses) {
//         allResults.addAll(response.keyResults);
//       }
//
//       allKeyResults.assignAll(allResults);
//       selectedIndices.clear();
//
//     } catch (e) {
//       error.value = 'Failed to generate mock key results: $e';
//     } finally {
//       loading.value = false;
//     }
//   }
//
//   // Get selected key results as Map (for compatibility with existing code)
//   List<Map<String, dynamic>> getSelectedKeyResults() {
//     return selectedKeyResults.map((kr) => kr.toJson()).toList();
//   }
// }