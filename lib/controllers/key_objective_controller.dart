import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'journey_controller.dart';

class KeyObjectiveController extends GetxController {
  // Store selected objective index
  RxInt selectedIndex = (-1).obs;

  // Objectives list - use translation KEYS, not the actual translated strings
  final List<Map<String, dynamic>> objectives = [
    {
      'titleKey': 'expand_product_line',
      'descriptionKey': 'introduce_new_products',
      'icon': Icons.add_business,
    },
    {
      'titleKey': 'improve_customer_experience',
      'descriptionKey': 'enhance_satisfaction',
      'icon': Icons.sentiment_satisfied,
    },
    {
      'titleKey': 'increase_market_share',
      'descriptionKey': 'gain_significant_presence',
      'icon': Icons.pie_chart,
    },
  ];

  // Toggle objective selection
  void selectObjective(int index) {
    if (selectedIndex.value == index) {
      // Deselect if clicked again
      selectedIndex.value = -1;
    } else {
      // Select new objective
      selectedIndex.value = index;
    }
  }

  // Check if objective is selected
  bool isSelected(int index) => selectedIndex.value == index;

  // Button enabled only when something is selected
  bool get isButtonEnabled => selectedIndex.value != -1;

  // Get selected objective title - JUST return the key, NO .tr here
  String get selectedTitleKey => selectedIndex.value != -1
      ? objectives[selectedIndex.value]['titleKey']
      : '';
}