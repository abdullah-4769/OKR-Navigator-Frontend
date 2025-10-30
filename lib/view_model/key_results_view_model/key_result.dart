// // lib/controllers/key_results_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../data/repositories/key_results_repo.dart';
// import '../../generated/models/key_results/key_results.dart';
//
//
// class KeyResultsController extends GetxController {
//   final KeyResultRepository _repository = Get.find<KeyResultRepository>();
//
//   // 🔹 Store KeyResults model objects
//   final RxList<KeyResults> keyResults = <KeyResults>[].obs;
//
//   // 🔹 Track selection by index
//   final RxMap<int, bool> selectedKeyResults = <int, bool>{}.obs;
//
//   final RxBool loading = false.obs;
//   final RxString error = ''.obs;
//
//   // 🔹 CRITICAL: Returns int, not RxInt
//   int get selectedCount {
//     return selectedKeyResults.values.where((isSelected) => isSelected).length;
//   }
//
//   final int requiredCount = 3;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchKeyResults();
//   }
//
//   Future<void> fetchKeyResults() async {
//     try {
//       loading.value = true;
//       error.value = '';
//
//       print('🔄 Controller: Fetching key results...');
//
//       final results = await _repository.fetchKeyResults();
//
//       print('📦 Controller: Received ${results.length} KeyResults');
//
//       keyResults.assignAll(results);
//
//       // Initialize selection state
//       selectedKeyResults.clear();
//       for (int i = 0; i < results.length; i++) {
//         selectedKeyResults[i] = false;
//       }
//
//       print('✅ Controller: Loaded ${keyResults.length} key results');
//       print('🔢 Selection map size: ${selectedKeyResults.length}');
//
//     } catch (e, stackTrace) {
//       error.value = 'Failed to load key results: $e';
//       print('❌ Controller Error: $e');
//       print('Stack: $stackTrace');
//
//       Get.snackbar(
//         'Error',
//         error.value,
//         snackPosition: SnackPosition.BOTTOM,
//         duration: Duration(seconds: 5),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       loading.value = false;
//       print('🏁 Loading complete. Count: ${keyResults.length}');
//     }
//   }
//
//   void toggleSelection(int index) {
//     print('🔄 Toggling index: $index');
//
//     if (index < 0 || index >= keyResults.length) {
//       print('⚠️ Invalid index: $index (max: ${keyResults.length - 1})');
//       return;
//     }
//
//     final isCurrentlySelected = selectedKeyResults[index] ?? false;
//     print('   Current state: ${isCurrentlySelected ? "selected" : "not selected"}');
//
//     // Check selection limit
//     if (!isCurrentlySelected && selectedCount >= requiredCount) {
//       print('⛔ Selection limit reached (${selectedCount}/${requiredCount})');
//       Get.snackbar(
//         'Selection Limit',
//         'You can only select $requiredCount key results',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     // Toggle selection
//     selectedKeyResults[index] = !isCurrentlySelected;
//     selectedKeyResults.refresh(); // 🔹 Force UI update
//
//     print('✅ Toggled to: ${selectedKeyResults[index]}');
//     print('📊 Selected count: $selectedCount/$requiredCount');
//     print('📋 Selected indices: ${_getSelectedIndices()}');
//   }
//
//   bool isSelected(int index) {
//     if (index >= 0 && index < keyResults.length) {
//       return selectedKeyResults[index] ?? false;
//     }
//     return false;
//   }
//
//   List<KeyResults> getSelectedKeyResults() {
//     List<KeyResults> selected = [];
//
//     selectedKeyResults.forEach((index, isSelected) {
//       if (isSelected && index >= 0 && index < keyResults.length) {
//         selected.add(keyResults[index]);
//       }
//     });
//
//     print('📦 getSelectedKeyResults: ${selected.length} items');
//     return selected;
//   }
//
//   List<int> _getSelectedIndices() {
//     return selectedKeyResults.entries
//         .where((entry) => entry.value == true)
//         .map((entry) => entry.key)
//         .toList();
//   }
//
//   void debugSelection() {
//     final selected = getSelectedKeyResults();
//     print('🎯 Debug Selection:');
//     print('   Count: ${selected.length}/${requiredCount}');
//
//     for (int i = 0; i < selected.length; i++) {
//       print('   ${i + 1}. ${selected[i].title}');
//       print('      ID: ${selected[i].id}');
//       print('      Desc: ${selected[i].description}');
//     }
//   }
//
//   void clearSelection() {
//     selectedKeyResults.clear();
//     for (int i = 0; i < keyResults.length; i++) {
//       selectedKeyResults[i] = false;
//     }
//     selectedKeyResults.refresh();
//     print('🧹 Selection cleared');
//   }
//
//   @override
//   void onClose() {
//     keyResults.clear();
//     selectedKeyResults.clear();
//     super.onClose();
//   }
// }
// view_model/key_results_view_model.dart
// lib/view_model/key_results_view_model/key_result.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/key_results_repo.dart';
import '../../generated/models/key_results/key_results.dart';

class KeyResultsViewModel extends GetxController {
  final KeyResultRepository _repository = Get.find<KeyResultRepository>();

  // API Data - Store as KeyResults objects
  final RxList<KeyResults> apiKeyResults = <KeyResults>[].obs;

  final RxBool loading = false.obs;
  final RxString error = ''.obs;

  // Selection
  final RxMap<int, bool> selectedKeyResults = <int, bool>{}.obs;
  final RxInt selectedCount = 0.obs;
  final int requiredCount = 3;

  @override
  void onInit() {
    super.onInit();
    fetchKeyResults();
    ever(selectedKeyResults, (_) => _updateSelectedCount());
  }

  Future<void> fetchKeyResults() async {
    try {
      loading.value = true;
      error.value = '';

      final results = await _repository.fetchKeyResults();
      apiKeyResults.assignAll(results);

      _initializeSelection();
      print('Loaded ${apiKeyResults.length} KeyResults');
    } catch (e, stackTrace) {
      error.value = 'Failed: $e';
      print('Error: $e\n$stackTrace');
    } finally {
      loading.value = false;
    }
  }

  void _initializeSelection() {
    selectedKeyResults.clear();
    for (int i = 0; i < apiKeyResults.length; i++) {
      selectedKeyResults[i] = false;
    }
    _updateSelectedCount();
  }

  void _updateSelectedCount() {
    selectedCount.value = selectedKeyResults.values.where((v) => v).length;
  }

  // Return List<KeyResults> directly
  List<KeyResults> getDisplayKeyResults() => apiKeyResults;

  IconData _getIconForIndex(int index) {
    final icons = [
      Icons.attach_money, Icons.people, Icons.pie_chart, Icons.star,
      Icons.speed, Icons.trending_up, Icons.analytics, Icons.bar_chart,
    ];
    return icons[index % icons.length];
  }

  void toggleSelection(int index) {
    if (index < 0 || index >= apiKeyResults.length) return;

    final isSelected = selectedKeyResults[index] ?? false;
    if (!isSelected && selectedCount.value >= requiredCount) {
      Get.snackbar('Limit', 'Max $requiredCount selections');
      return;
    }

    selectedKeyResults[index] = !isSelected;
    selectedKeyResults.refresh();
  }

  bool isSelected(int index) {
    return index >= 0 && index < apiKeyResults.length && (selectedKeyResults[index] ?? false);
  }

  List<KeyResults> getSelectedKeyResults() {
    return selectedKeyResults.entries
        .where((e) => e.value)
        .map((e) => apiKeyResults[e.key])
        .toList();
  }

  void debugSelection() {
    print('Selected: ${getSelectedKeyResults().map((e) => e.title).toList()}');
  }
}