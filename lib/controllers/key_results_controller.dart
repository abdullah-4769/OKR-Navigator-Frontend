

// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../generated/models/responses/key_results/key_results_response.dart';
//
// class KeyResultsController extends GetxController {
//   // Loading indicator
//   RxBool loading = false.obs;
//
//   // Selected items count
//   RxInt selectedCount = 0.obs;
//
//   // Selected item indexes
//   RxList<int> selectedIndexes = <int>[].obs;
//
//   // Required count
//   RxInt requiredCount = 3.obs;
//
//   // Map-based list for UI display
//   final List<Map<String, dynamic>> keyResults = [
//     {
//       'id': 1,
//       'title': 'achieve_5m_revenue',
//       'description': 'generate_revenue_stream',
//       'icon': Icons.attach_money,
//       'tag1': 'revenue',
//       'tag2': 'twelve_months',
//     },
//     {
//       'id': 2,
//       'title': 'acquire_10000_customers',
//       'description': 'build_customer_base',
//       'icon': Icons.people,
//       'tag1': 'customer_growth',
//       'tag2': 'fifteen_months',
//     },
//     {
//       'id': 3,
//       'title': 'achieve_15_market_share',
//       'description': 'establish_market_presence',
//       'icon': Icons.pie_chart,
//       'tag1': 'market_share',
//       'tag2': 'eighteen_months',
//     },
//     {
//       'id': 4,
//       'title': 'achieve_45_satisfaction',
//       'description': 'maintain_quality_standards',
//       'icon': Icons.star,
//       'tag1': 'satisfaction',
//       'tag2': 'ongoing',
//     },
//     {
//       'id': 5,
//       'title': 'launch_products_faster',
//       'description': 'optimize_development_cycles',
//       'icon': Icons.speed,
//       'tag1': 'medium_impact',
//       'tag2': 'nine_months',
//     },
//   ];
//
//   // Toggle selection by INDEX
//   void toggleSelection(int index) {
//     if (selectedIndexes.contains(index)) {
//       selectedIndexes.remove(index);
//     } else {
//       if (selectedIndexes.length < requiredCount.value) {
//         selectedIndexes.add(index);
//       }
//     }
//     selectedCount.value = selectedIndexes.length;
//   }
//
//   // Check if selected by INDEX
//   bool isSelected(int index) {
//     return selectedIndexes.contains(index);
//   }
//
//   // Convert Map to KeyResult model for API submission
//   List<KeyResult> getSelectedKeyResults() {
//     return selectedIndexes.map((index) {
//       final item = keyResults[index];
//       return KeyResult(
//         id: item['id'],
//         title: item['title'],
//         description: item['description'],
//         // Add other fields if needed by your API
//       );
//     }).toList();
//   }
//
//   // Get selected titles
//   List<String> getSelectedTitles() {
//     return selectedIndexes
//         .map((index) => keyResults[index]['title'] as String)
//         .toList();
//   }
//
//   // Reset selections
//   void reset() {
//     selectedIndexes.clear();
//     selectedCount.value = 0;
//   }
// }
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../generated/models/responses/key_results/key_results_response.dart';
import 'journey_controller.dart';

class KeyResultsController extends GetxController {
  // Loading indicator
  RxBool loading = false.obs;

  // Selected items count
  RxInt selectedCount = 0.obs;

  // Selected item indexes - Use RxSet for better performance
  RxSet<int> selectedIndexes = <int>{}.obs;

  // Required count
  RxInt requiredCount = 3.obs;

  // Map-based list for UI display
  final List<Map<String, dynamic>> keyResults = [
    {
      'id': 1,
      'title': 'achieve_5m_revenue',
      'description': 'generate_revenue_stream',
      'icon': Icons.attach_money,
      'tag1': 'revenue',
      'tag2': 'twelve_months',
    },
    {
      'id': 2,
      'title': 'acquire_10000_customers',
      'description': 'build_customer_base',
      'icon': Icons.people,
      'tag1': 'customer_growth',
      'tag2': 'fifteen_months',
    },
    {
      'id': 3,
      'title': 'achieve_15_market_share',
      'description': 'establish_market_presence',
      'icon': Icons.pie_chart,
      'tag1': 'market_share',
      'tag2': 'eighteen_months',
    },
    {
      'id': 4,
      'title': 'achieve_45_satisfaction',
      'description': 'maintain_quality_standards',
      'icon': Icons.star,
      'tag1': 'satisfaction',
      'tag2': 'ongoing',
    },
    {
      'id': 5,
      'title': 'launch_products_faster',
      'description': 'optimize_development_cycles',
      'icon': Icons.speed,
      'tag1': 'medium_impact',
      'tag2': 'nine_months',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    // Load any persisted selection
    _loadPersistedSelection();
  }

  // ✅ Load persisted selection
  void _loadPersistedSelection() {
    // You can use GetStorage, SharedPreferences, or your repository
    // For now, we'll assume empty state
    print('🔍 KeyResultsController: Loading selection state');
    updateSelectedCount();
  }

  // Toggle selection by INDEX
  void toggleSelection(int index) {
    print('🔄 Toggling selection for index: $index');
    print('📊 Current selection count: ${selectedIndexes.length}/${requiredCount.value}');

    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
      print('❌ Removed index $index');
    } else {
      if (selectedIndexes.length < requiredCount.value) {
        selectedIndexes.add(index);
        print('✅ Added index $index');
      } else {
        print('⚠️ Maximum selections reached: ${requiredCount.value}');
        Get.snackbar('Limit Reached', 'Maximum ${requiredCount.value} selections allowed',
            backgroundColor: Colors.orange);
        return;
      }
    }

    selectedCount.value = selectedIndexes.length;
    print('📊 Updated selection count: ${selectedCount.value}');

    // Persist selection
    _persistSelection();
  }

  // Check if selected by INDEX
  bool isSelected(int index) {
    return selectedIndexes.contains(index);
  }

  // ✅ Check if selection is complete
  bool isSelectionComplete() {
    final isComplete = selectedCount.value >= requiredCount.value;
    print('✅ Selection complete check: ${selectedCount.value} >= ${requiredCount.value} = $isComplete');
    return isComplete;
  }// Alternative approach in KeyResultsController
  List<KeyResult> getSelectedKeyResults() {
    print('🔄 Getting ${selectedIndexes.length} selected key results');

    final results = <KeyResult>[];

    for (final index in selectedIndexes) {
      if (index >= 0 && index < keyResults.length) {
        final item = keyResults[index];
        print('📦 Processing item at index $index: ${item['title']}');

        // Create KeyResult using fromJson if available, or direct assignment
        try {
          // Method 1: If you have fromJson constructor
          final keyResult = KeyResult.fromJson({
            'id': item['id'],
            'title': item['title'],
            'description': item['description'],
          });
          results.add(keyResult);



          print('✅ Added KeyResult: ${item['title']}');
        } catch (e) {
          print('❌ Error creating KeyResult for ${item['title']}: $e');
        }
      }
    }

    print('🎯 Final selected key results: ${results.length}');
    return results;
  }
  // Update count
  void updateSelectedCount() {
    selectedCount.value = selectedIndexes.length;
  }

  // Reset selections
  void reset() {
    print('🔄 Resetting all selections');
    selectedIndexes.clear();
    selectedCount.value = 0;
    _persistSelection();
  }

  // Clear current selection (for edit mode)
  void clearSelection() {
    print('🗑️ Clearing current selection');
    selectedIndexes.clear();
    selectedCount.value = 0;
    _persistSelection();
  }

  // ✅ Persist selection (implement with your storage solution)
  void _persistSelection() {
    print('💾 Persisting selection: ${selectedIndexes.toList()}');
    // TODO: Save to GetStorage, SharedPreferences, or your repository
    // Example with GetStorage:
    // GetStorage().write('key_results_selection', selectedIndexes.toList());
  }

  // ✅ Complete selection and mark journey step
  void completeSelection() {
    if (isSelectionComplete()) {
      print('🎉 Selection completed successfully!');
      // Mark journey step as complete
      final journeyController = Get.find<JourneyController>();
      journeyController.completeStep(2); // Key Results step
      _persistSelection();
    } else {
      print('❌ Selection not complete. Required: ${requiredCount.value}, Selected: ${selectedCount.value}');
    }
  }

  // Add this method to KeyResultsController for debugging
  void debugSelection() {
    print('🔍 DEBUG SELECTION:');
    print('   Selected indexes: ${selectedIndexes.toList()}');
    print('   Selected count: ${selectedCount.value}');
    print('   Required count: ${requiredCount.value}');

    selectedIndexes.forEach((index) {
      if (index >= 0 && index < keyResults.length) {
        final item = keyResults[index];
        print('   Index $index: ${item['title']}');
      } else {
        print('   ❌ Invalid index: $index');
      }
    });

    final convertedResults = getSelectedKeyResults();
    print('   Converted results count: ${convertedResults.length}');
  }
}