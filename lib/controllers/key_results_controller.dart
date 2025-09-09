import 'package:get/get.dart';
import 'package:flutter/material.dart';

class KeyResultsController extends GetxController {
  // Add this method to your KeyResultsController class
  List<Map<String, dynamic>> getSelectedKeyResults() =>
      selectedIndexes.map((index) => keyResults[index]).toList();

  // Selected items count
  RxInt selectedCount = 0.obs;

  // Selected item indexes
  RxList<int> selectedIndexes = <int>[].obs;

  // Required count (for now hardcoded, replace with backend later)
  RxInt requiredCount = 3.obs;

  // List of Key Results (can later come from backend)
  final List<Map<String, dynamic>> keyResults = [
    {
      'title': 'Achieve \$5M Revenue from New Products',
      'description':
      'Generate significant revenue stream within first 12 months of launch',
      'icon': Icons.attach_money,
      'tag1': 'Revenue',
      'tag2': '12 months',
    },
    {
      'title': 'Acquire 10,000 New Customers',
      'description':
      'Build customer base in target emerging markets through product adoption',
      'icon': Icons.people,
      'tag1': 'Customer Growth',
      'tag2': '15 months',
    },
    {
      'title': 'Achieve 15% Market Share in Target Regions',
      'description':
      'Establish significant market presence through new product penetration',
      'icon': Icons.pie_chart,
      'tag1': 'Market Share',
      'tag2': '18 months',
    },
    {
      'title': 'Achieve 4.5+ Customer Satisfaction Score',
      'description':
      'Maintain high quality standards and customer experience across new products',
      'icon': Icons.star,
      'tag1': 'Satisfaction',
      'tag2': 'Ongoing',
    },
    {
      'title': 'Launch Products 20% Faster Than Industry Average',
      'description':
      'Optimize development cycles to gain competitive advantage in time-to-market',
      'icon': Icons.speed,
      'tag1': 'Medium Impact',
      'tag2': '9 months',
    },
  ];

  // Toggle selection of a key result
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

  // Check if a key result is selected
  bool isSelected(int index) => selectedIndexes.contains(index);

  // Get list of selected key result titles
  List<String> getSelectedTitles() => selectedIndexes
      .map((index) => keyResults[index]['title'] as String)
      .toList();
}
