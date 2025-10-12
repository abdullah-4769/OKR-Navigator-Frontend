import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../generated/models/responses/key_results/key_results_response.dart';

class KeyResultsController extends GetxController {
  // Loading indicator
  RxBool loading = false.obs;

  // Selected items count
  RxInt selectedCount = 0.obs;

  // Selected item indexes
  RxList<int> selectedIndexes = <int>[].obs;

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

  // Toggle selection by INDEX
  void toggleSelection(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      if (selectedIndexes.length < requiredCount.value) {
        selectedIndexes.add(index);
      }
    }
    selectedCount.value = selectedIndexes.length;
  }

  // Check if selected by INDEX
  bool isSelected(int index) {
    return selectedIndexes.contains(index);
  }

  // Convert Map to KeyResult model for API submission
  List<KeyResult> getSelectedKeyResults() {
    return selectedIndexes.map((index) {
      final item = keyResults[index];
      return KeyResult(
        id: item['id'],
        title: item['title'],
        description: item['description'],
        // Add other fields if needed by your API
      );
    }).toList();
  }

  // Get selected titles
  List<String> getSelectedTitles() {
    return selectedIndexes
        .map((index) => keyResults[index]['title'] as String)
        .toList();
  }

  // Reset selections
  void reset() {
    selectedIndexes.clear();
    selectedCount.value = 0;
  }
}