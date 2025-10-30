import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignKeyResultsController extends GetxController {
  /// 🔹 Loading indicator
  final loading = false.obs;

  /// 🔹 Selected items count
  final selectedCount = 0.obs;

  /// 🔹 Selected item indexes
  final selectedIndexes = <int>[].obs;

  /// 🔹 Required selection count
  final requiredCount = 3.obs;

  /// 🔹 Campaign Key Results data
  final List<Map<String, dynamic>> keyResults = [
    {
      'titleKey': 'increase_campaign_visibility',
      'descriptionKey': 'boost_brand_presence_through_ads',
      'icon': Icons.campaign,
      'tag1Key': 'brand_awareness',
      'tag2Key': 'six_months',
    },
    {
      'titleKey': 'generate_5000_campaign_leads',
      'descriptionKey': 'expand_customer_outreach',
      'icon': Icons.people_alt,
      'tag1Key': 'lead_generation',
      'tag2Key': 'nine_months',
    },
    {
      'titleKey': 'achieve_30_conversion_rate',
      'descriptionKey': 'optimize_conversion_strategies',
      'icon': Icons.trending_up,
      'tag1Key': 'conversion',
      'tag2Key': 'twelve_months',
    },
    {
      'titleKey': 'reduce_campaign_costs_15',
      'descriptionKey': 'enhance_cost_efficiency',
      'icon': Icons.monetization_on_outlined,
      'tag1Key': 'cost_saving',
      'tag2Key': 'six_months',
    },
    {
      'titleKey': 'launch_3_successful_campaigns',
      'descriptionKey': 'execute_targeted_marketing_initiatives',
      'icon': Icons.rocket_launch,
      'tag1Key': 'execution',
      'tag2Key': 'eighteen_months',
    },
  ];

  /// 🔹 Toggle selection (max = requiredCount)
  void toggleSelection(Map<String, dynamic> item) {
    final index = keyResults.indexOf(item);

    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      if (selectedIndexes.length < requiredCount.value) {
        selectedIndexes.add(index);
      } else {
        Get.snackbar(
          'limit_reached'.tr,
          'you_can_only_select_3'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }

    selectedCount.value = selectedIndexes.length;
  }

  /// 🔹 Check if item is selected
  bool isSelected(Map<String, dynamic> item) {
    final index = keyResults.indexOf(item);
    return selectedIndexes.contains(index);
  }

  /// 🔹 Return selected items as a map list
  List<Map<String, dynamic>> getSelectedKeyResults() =>
      selectedIndexes.map((index) => keyResults[index]).toList();

  /// 🔹 Return selected titles only (for debugging or backend payloads)
  List<String> getSelectedTitles() =>
      selectedIndexes.map((i) => keyResults[i]['titleKey'] as String).toList();
}
