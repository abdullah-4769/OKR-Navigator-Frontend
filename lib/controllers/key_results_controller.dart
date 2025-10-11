






import 'package:get/get.dart';
import 'package:flutter/material.dart';

class KeyResultsController extends GetxController {
  // Loading indicator (to fix `loading` undefined error)
  RxBool loading = false.obs;

  // Selected items count
  RxInt selectedCount = 0.obs;

  // Selected item indexes
  RxList<int> selectedIndexes = <int>[].obs;

  // Required count (for now hardcoded, replace with backend later)
  RxInt requiredCount = 3.obs;

  // List of Key Results
  final List<Map<String, dynamic>> keyResults = [
    {
      'title': 'achieve_5m_revenue',
      'description': 'generate_revenue_stream',
      'icon': Icons.attach_money,
      'tag1': 'revenue',
      'tag2': 'twelve_months',
    },
    {
      'title': 'acquire_10000_customers',
      'description': 'build_customer_base',
      'icon': Icons.people,
      'tag1': 'customer_growth',
      'tag2': 'fifteen_months',
    },
    {
      'title': 'achieve_15_market_share',
      'description': 'establish_market_presence',
      'icon': Icons.pie_chart,
      'tag1': 'market_share',
      'tag2': 'eighteen_months',
    },
    {
      'title': 'achieve_45_satisfaction',
      'description': 'maintain_quality_standards',
      'icon': Icons.star,
      'tag1': 'satisfaction',
      'tag2': 'ongoing',
    },
    {
      'title': 'launch_products_faster',
      'description': 'optimize_development_cycles',
      'icon': Icons.speed,
      'tag1': 'medium_impact',
      'tag2': 'nine_months',
    },
  ];

  // Toggle selection of a key result
  void toggleSelection(Map<String, dynamic> item) {
    final index = keyResults.indexOf(item);
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      if (selectedIndexes.length < requiredCount.value) {
        selectedIndexes.add(index);
      }
    }
    selectedCount.value = selectedIndexes.length;
  }

  // Check if a key result is selected
  bool isSelected(Map<String, dynamic> item) {
    final index = keyResults.indexOf(item);
    return selectedIndexes.contains(index);
  }

  // Get list of selected key result maps
  List<Map<String, dynamic>> getSelectedKeyResults() =>
      selectedIndexes.map((index) => keyResults[index]).toList();

  // Get list of selected key result titles
  List<String> getSelectedTitles() => selectedIndexes
      .map((index) => keyResults[index]['title'] as String)
      .toList();
}








// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
//
// class KeyResultsController extends GetxController {
//   // Add this method to your KeyResultsController class
//   List<Map<String, dynamic>> getSelectedKeyResults() =>
//       selectedIndexes.map((index) => keyResults[index]).toList();
//
//   // Selected items count
//   RxInt selectedCount = 0.obs;
//
//   // Selected item indexes
//   RxList<int> selectedIndexes = <int>[].obs;
//
//   // Required count (for now hardcoded, replace with backend later)
//   RxInt requiredCount = 3.obs;
//
//   // List of Key Results - use translation KEYS instead of actual strings
//   final List<Map<String, dynamic>> keyResults = [
//     {
//       'titleKey': 'achieve_5m_revenue',
//       'descriptionKey': 'generate_revenue_stream',
//       'icon': Icons.attach_money,
//       'tag1Key': 'revenue',
//       'tag2Key': 'twelve_months',
//     },
//     {
//       'titleKey': 'acquire_10000_customers',
//       'descriptionKey': 'build_customer_base',
//       'icon': Icons.people,
//       'tag1Key': 'customer_growth',
//       'tag2Key': 'fifteen_months',
//     },
//     {
//       'titleKey': 'achieve_15_market_share',
//       'descriptionKey': 'establish_market_presence',
//       'icon': Icons.pie_chart,
//       'tag1Key': 'market_share',
//       'tag2Key': 'eighteen_months',
//     },
//     {
//       'titleKey': 'achieve_45_satisfaction',
//       'descriptionKey': 'maintain_quality_standards',
//       'icon': Icons.star,
//       'tag1Key': 'satisfaction',
//       'tag2Key': 'ongoing',
//     },
//     {
//       'titleKey': 'launch_products_faster',
//       'descriptionKey': 'optimize_development_cycles',
//       'icon': Icons.speed,
//       'tag1Key': 'medium_impact',
//       'tag2Key': 'nine_months',
//     },
//   ];
//
//   // Toggle selection of a key result
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
//   // Check if a key result is selected
//   bool isSelected(int index) => selectedIndexes.contains(index);
//
//   // Get list of selected key result titles - REMOVE .tr from here!
//   List<String> getSelectedTitles() => selectedIndexes
//       .map(
//         (index) => keyResults[index]['titleKey'] as String,
//       ) // Just return the key, no .tr
//       .toList();
// }
