

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'journey_controller.dart';

class KeyObjectiveController extends GetxController {
  // Store selected objective index
  RxInt selectedIndex = (-1).obs;



  // Objectives list
  final List<Map<String, dynamic>> objectives = [
    {
      "title": "Expand Product Line",
      "description": "Introduce new products in emerging markets",
      "icon": Icons.add_business,
    },
    {
      "title": "Improve Customer Experience",
      "description": "Enhance satisfaction across all touchpoints",
      "icon": Icons.sentiment_satisfied,
    },
    {
      "title": "Increase Market Share",
      "description": "Gain significant presence in target regions",
      "icon": Icons.pie_chart,
    },
  ];

  // Reference to Journey Controller
  final JourneyController journeyController = Get.find<JourneyController>();

  // Toggle objective selection
  void selectObjective(int index) {
    if (selectedIndex.value == index) {
      // Deselect if clicked again
      selectedIndex.value = -1;
      journeyController.progress.value = 20; // Reset progress
      journeyController.completedSteps[0] = false;
    } else {
      // Select new objective
      selectedIndex.value = index;
      journeyController.progress.value = 40; // Update progress
      journeyController.completedSteps[0] = true;
    }
  }

  // Check if objective is selected
  bool isSelected(int index) => selectedIndex.value == index;

  // Button enabled only when something is selected
  bool get isButtonEnabled => selectedIndex.value != -1;

  // Get selected objective title
  String get selectedTitle =>
      selectedIndex.value != -1 ? objectives[selectedIndex.value]["title"] : "";
}

