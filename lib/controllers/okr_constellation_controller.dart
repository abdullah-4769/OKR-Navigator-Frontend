// controllers/okr_constellation_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// class OKRConstellationController extends GetxController {
//   /// Order matters. We render 0->left-up, 1->left-down, 2->right-up
//   final RxList<IconData> selectedIcons = <IconData>[].obs;
//
//   int get requiredCount => 3;
//   bool get showPlusButton => selectedIcons.length < requiredCount;
//
//   void addIcon(IconData icon) {
//     if (selectedIcons.length < requiredCount && !selectedIcons.contains(icon)) {
//       selectedIcons.add(icon);
//     }
//   }
//
//   void removeIcon(IconData icon) {
//     selectedIcons.remove(icon);
//   }
//
//   void reset() => selectedIcons.clear();
// }
class OKRConstellationController extends GetxController {
  final RxList<IconData> selectedIcons = <IconData>[].obs;

  int get requiredCount => 3;
  bool get showPlusButton => selectedIcons.length < requiredCount;

  void addIcon(IconData icon) {
    if (selectedIcons.length < requiredCount && !selectedIcons.contains(icon)) {
      selectedIcons.add(icon);
    }
  }

  void removeIcon(IconData icon) {
    selectedIcons.remove(icon);
  }

  void reset() => selectedIcons.clear();

  // If you're trying to save/load state
  Map<String, dynamic> toJson() {
    return {
      'selectedIcons': selectedIcons.map((icon) => icon.codePoint).toList(),
    };
  }

  void fromJson(Map<String, dynamic>? json) {
    if (json != null && json['selectedIcons'] is List) {
      selectedIcons.value = (json['selectedIcons'] as List)
          .map((code) => IconData(code as int, fontFamily: 'MaterialIcons'))
          .toList();
    }
  }
}