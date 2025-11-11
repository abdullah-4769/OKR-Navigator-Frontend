import 'package:get/get.dart';

class CampaignKeyObjectiveController extends GetxController {
  /// List of objectives shown to the player
  var objectives = <Map<String, dynamic>>[
    {
      'title': 'Increase Market Share',
      'description': 'Focus on expanding into new markets to gain share.',
    },
    {
      'title': 'Enhance Customer Retention',
      'description': 'Improve satisfaction and loyalty programs.',
    },
    {
      'title': 'Boost Product Innovation',
      'description': 'Develop new products to capture growth opportunities.',
    },
  ].obs;

  /// Currently selected objective
  Rxn<Map<String, dynamic>> selectedObjective = Rxn<Map<String, dynamic>>();

  /// Select an objective by index
  void selectObjective(int index) {
    if (index >= 0 && index < objectives.length) {
      selectedObjective.value = objectives[index];
    }
  }

  /// Check if an objective is selected
  bool isSelected(int index) {
    return selectedObjective.value == objectives[index];
  }

  /// Deselect objective
  void clearSelection() {
    selectedObjective.value = null;
  }
}
