import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestionInitiativesController extends GetxController {
  final List<Map<String, dynamic>> keyResults;

  SuggestionInitiativesController({required this.keyResults});

  final firstInitiativeTitle = TextEditingController();
  final firstInitiativeDesc = TextEditingController();
  final secondInitiativeTitle = TextEditingController();
  final secondInitiativeDesc = TextEditingController();

  var aiFeedback = "".obs;

  void submitForAIAnalysis() {
    if (firstInitiativeTitle.text.isEmpty ||
        firstInitiativeDesc.text.isEmpty ||
        secondInitiativeTitle.text.isEmpty ||
        secondInitiativeDesc.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill both initiatives before submitting.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    aiFeedback.value =
    "✅ AI analysis submitted successfully. Redirecting to results...";
  }
}









// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class SuggestionInitiativesController extends GetxController {
//   final List<Map<String, dynamic>> keyResults;
//
//   SuggestionInitiativesController({required this.keyResults});
//
//   /// Randomly selected key result
//   RxMap<String, dynamic> randomKeyResult = <String, dynamic>{}.obs;
//
//   /// Initiative Inputs
//   final firstInitiativeTitle = TextEditingController();
//   final firstInitiativeDesc = TextEditingController();
//   final secondInitiativeTitle = TextEditingController();
//   final secondInitiativeDesc = TextEditingController();
//
//   /// AI Feedback text
//   var aiFeedback = "".obs;
//
//   /// Journey progress value
//   RxDouble progress = 40.0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // Pick a random key result if available
//     if (keyResults.isNotEmpty) {
//       randomKeyResult.value =
//       keyResults[Random().nextInt(keyResults.length)];
//     }
//
//     // Listen to changes for progress updates
//     firstInitiativeTitle.addListener(updateProgress);
//     firstInitiativeDesc.addListener(updateProgress);
//     secondInitiativeTitle.addListener(updateProgress);
//     secondInitiativeDesc.addListener(updateProgress);
//   }
//
//   /// Update journey map progress based on filled initiatives
//   void updateProgress() {
//     final firstFilled = firstInitiativeTitle.text.trim().isNotEmpty &&
//         firstInitiativeDesc.text.trim().isNotEmpty;
//     final secondFilled = secondInitiativeTitle.text.trim().isNotEmpty &&
//         secondInitiativeDesc.text.trim().isNotEmpty;
//
//     // If both initiatives are filled → 60%, else → 40%
//     progress.value = (firstFilled && secondFilled) ? 60.0 : 40.0;
//   }
//
//   /// Submit Initiatives for AI Analysis
//   void submitForAIAnalysis() {
//     if (firstInitiativeTitle.text.trim().isEmpty ||
//         firstInitiativeDesc.text.trim().isEmpty ||
//         secondInitiativeTitle.text.trim().isEmpty ||
//         secondInitiativeDesc.text.trim().isEmpty) {
//       Get.snackbar(
//         "Error",
//         "Please fill both initiatives before submitting.",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     // Simulate AI analysis response
//     aiFeedback.value =
//     "✅ AI successfully analyzed your initiatives and provided strategic feedback.";
//   }
// }
//
//
//
//
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// //
// // class SuggestionInitiativesController extends GetxController {
// //   final List<Map<String, dynamic>> objectives;
// //   final List<Map<String, dynamic>> keyResults;
// //
// //   SuggestionInitiativesController({
// //     required this.objectives,
// //     required this.keyResults,
// //   });
// //
// //   /// Selected objective & key result
// //   var selectedObjective = <String, dynamic>{}.obs;
// //   var selectedKeyResult = <String, dynamic>{}.obs;
// //
// //   /// Initiative inputs
// //   final firstInitiativeTitle = TextEditingController();
// //   final firstInitiativeDesc = TextEditingController();
// //   final secondInitiativeTitle = TextEditingController();
// //   final secondInitiativeDesc = TextEditingController();
// //
// //   /// AI feedback
// //   var aiFeedback = "".obs;
// //
// //   /// Journey Map state
// //   var showDetails = false.obs;
// //   var progress = 0.0.obs;
// //   var completedSteps = <bool>[].obs;
// //
// //   final List<String> steps = [
// //     "Write Initiative",
// //     "Assign Owner",
// //     "Set Timeline",
// //     "Allocate Budget",
// //     "Review & Approve",
// //   ];
// //
// //   int get totalSteps => steps.length;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     completedSteps.value = List.generate(totalSteps, (_) => false);
// //
// //     // defaults
// //     if (objectives.isNotEmpty) selectedObjective.value = objectives[0];
// //     if (keyResults.isNotEmpty) selectedKeyResult.value = keyResults[0];
// //   }
// //
// //   void toggleJourneyDetails() {
// //     showDetails.value = !showDetails.value;
// //   }
// //
// //   void updateProgress() {
// //     final completed = completedSteps.where((done) => done).length;
// //     final stepPercentage = 100 / totalSteps;
// //     progress.value = (completed * stepPercentage).clamp(0, 100);
// //   }
// //
// //   void completeStep(int stepIndex) {
// //     if (stepIndex < totalSteps) {
// //       completedSteps[stepIndex] = true;
// //       updateProgress();
// //     }
// //   }
// //
// //   void resetProgress() {
// //     progress.value = 0.0;
// //     completedSteps.value = List.generate(totalSteps, (_) => false);
// //     showDetails.value = false;
// //   }
// //
// //   void submitForAIAnalysis() {
// //     aiFeedback.value =
// //     "✅ AI suggests refining Initiative 1 for better alignment with your Key Result.";
// //   }
// // }
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// // // // controllers/suggestion_initiatives_controller.dart
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // //
// // // class SuggestionInitiativesController extends GetxController {
// // //   final List<Map<String, dynamic>> objectives;
// // //   final List<Map<String, dynamic>> keyResults;
// // //
// // //   SuggestionInitiativesController({
// // //     required this.objectives,
// // //     required this.keyResults,
// // //   });
// // //
// // //   /// Selected objective and key result
// // //   var selectedObjective = <String, dynamic>{}.obs;
// // //   var selectedKeyResult = <String, dynamic>{}.obs;
// // //
// // //   /// Initiative inputs
// // //   final firstInitiativeTitle = TextEditingController();
// // //   final firstInitiativeDesc = TextEditingController();
// // //   final secondInitiativeTitle = TextEditingController();
// // //   final secondInitiativeDesc = TextEditingController();
// // //
// // //   /// AI feedback (reactive)
// // //   var aiFeedback = "".obs;
// // //
// // //   /// 🚀 Journey map state (this fixes your errors)
// // //   var showJourney = false.obs;   // controls expand/collapse
// // //   var progress = 0.5.obs;        // example: 50% complete
// // //   var currentStep = 2.obs;       // example: step 2 of N
// // //
// // //   @override
// // //   void onInit() {
// // //     super.onInit();
// // //
// // //     // Default to first objective & key result
// // //     if (objectives.isNotEmpty) {
// // //       selectedObjective.value = objectives[0];
// // //     }
// // //     if (keyResults.isNotEmpty) {
// // //       selectedKeyResult.value = keyResults[0];
// // //     }
// // //   }
// // //
// // //   /// Toggle journey map visibility
// // //   void toggleJourney() {
// // //     showJourney.value = !showJourney.value;
// // //   }
// // //
// // //   /// Example AI analysis function
// // //   void submitForAIAnalysis() {
// // //     aiFeedback.value =
// // //     "✅ AI suggests refining Initiative 1 for better alignment with your Key Result.";
// // //   }
// // // }
// // //
// // //
// // //
// // //
// // //
// // // // // controllers/suggestion_initiatives_controller.dart
// // // // import 'package:flutter/material.dart';
// // // // import 'package:get/get.dart';
// // // //
// // // // class SuggestionInitiativesController extends GetxController {
// // // //   /// Objectives & Key Results (passed from screen)
// // // //   final List<Map<String, dynamic>> objectives;
// // // //   final List<Map<String, dynamic>> keyResults;
// // // //
// // // //   SuggestionInitiativesController({
// // // //     required this.objectives,
// // // //     required this.keyResults,
// // // //   });
// // // //
// // // //   /// Reactive selections
// // // //   var selectedObjective = <String, dynamic>{}.obs;
// // // //   var selectedKeyResult = <String, dynamic>{}.obs;
// // // //
// // // //   /// Initiative inputs
// // // //   final firstInitiativeTitle = TextEditingController();
// // // //   final firstInitiativeDesc = TextEditingController();
// // // //   final secondInitiativeTitle = TextEditingController();
// // // //   final secondInitiativeDesc = TextEditingController();
// // // //
// // // //   /// AI feedback
// // // //   var aiFeedback = "".obs;
// // // //
// // // //   /// Journey Map state
// // // //   var showJourney = false.obs;
// // // //   var progress = 0.5.obs; // dummy value, you can update dynamically
// // // //   var currentStep = 2.obs; // dummy value, change as needed
// // // //
// // // //   @override
// // // //   void onInit() {
// // // //     super.onInit();
// // // //     // Default selections
// // // //     if (objectives.isNotEmpty) {
// // // //       selectedObjective.value = objectives[0];
// // // //     }
// // // //     if (keyResults.isNotEmpty) {
// // // //       selectedKeyResult.value = keyResults[0];
// // // //     }
// // // //   }
// // // //
// // // //   /// Toggle journey map visibility
// // // //   void toggleJourney() {
// // // //     showJourney.value = !showJourney.value;
// // // //   }
// // // //
// // // //   /// AI analysis submission
// // // //   void submitForAIAnalysis() {
// // // //     aiFeedback.value =
// // // //     "AI suggests refining Initiative 1 for better alignment with Key Result.";
// // // //   }
// // // // }
