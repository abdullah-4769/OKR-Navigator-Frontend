import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamObjectiveController extends GetxController {
  // Store selected objective index
  RxInt selectedIndex = (-1).obs;

  // Objectives list - with translation keys, icons and bottom tags
  final List<Map<String, dynamic>> objectives = [
    {
      'titleKey': 'expand_to_new_markets',
      'descriptionKey': 'expand_to_new_markets_desc',
      'icon': Icons.public,
      'tags': [
        {'icon': Icons.public, 'textKey': 'market_expansion'},
        {'icon': Icons.star, 'textKey': 'high_impact'},
        {'icon': Icons.access_time, 'textKey': '12m'},
      ],
    },
    {
      'titleKey': 'capture_market_share',
      'descriptionKey': 'capture_market_share_desc',
      'icon': Icons.pie_chart,
      'tags': [
        {'icon': Icons.trending_up, 'textKey': 'growth_focus'},
        {'icon': Icons.star_half, 'textKey': 'medium_impact'},
        {'icon': Icons.access_time, 'textKey': '9m'},
      ],
    },
    {
      'titleKey': 'launch_new_products',
      'descriptionKey': 'launch_new_products_desc',
      'icon': Icons.lightbulb_outline,
      'tags': [
        {'icon': Icons.build, 'textKey': 'innovation'},
        {'icon': Icons.star_border, 'textKey': 'low_impact'},
        {'icon': Icons.access_time, 'textKey': '6m'},
      ],
    },
  ];

  void selectObjective(int index) {
    if (selectedIndex.value == index) {
      selectedIndex.value = -1;
    } else {
      selectedIndex.value = index;
    }
  }

  bool isSelected(int index) => selectedIndex.value == index;

  bool get isButtonEnabled => selectedIndex.value != -1;

  String get selectedTitleKey => selectedIndex.value != -1
      ? objectives[selectedIndex.value]['titleKey']
      : '';
}
