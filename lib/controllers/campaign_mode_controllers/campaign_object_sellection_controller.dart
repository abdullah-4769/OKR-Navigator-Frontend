import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CampaignStrategySelectionController extends GetxController {
  RxBool isCardRevealed = false.obs;
  RxInt selectedStrategyIndex = (-1).obs;

  Rxn<Map<String, dynamic>> selectedStrategy = Rxn<Map<String, dynamic>>();

  final List<Map<String, dynamic>> strategies = [
    {
      'title': 'growth_strategy',
      'description': 'focus_on_market_expansion',
      'icon': Icons.trending_up,
    },
    {
      'title': 'innovation_strategy',
      'description': 'drive_product_innovation',
      'icon': Icons.lightbulb_outline,
    },
    {
      'title': 'cost_leadership_strategy',
      'description': 'reduce_operational_expenses',
      'icon': Icons.monetization_on_outlined,
    },
  ];

  void selectStrategy(int index) {
    selectedStrategyIndex.value = index;
    selectedStrategy.value = strategies[index];
    isCardRevealed.value = true;
  }




  bool isSelected(int index) => selectedStrategyIndex.value == index;
}
