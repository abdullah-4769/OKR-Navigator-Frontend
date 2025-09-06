import 'package:get/get.dart';

class JourneyController extends GetxController {
  /// Index of the current step (reactive)
  final RxInt currentStep = 0.obs;

  /// Journey steps
  final List<String> steps = [
    "Select Strategy",
    "Select Objective",
    "Select Key Results",
    "Suggest Initiatives",
    "Complete",
  ];

  /// Track completed steps (true = completed, false = pending)
  final RxList<bool> completedSteps = <bool>[].obs;

  /// Overall progress (0% → 100%)
  final RxDouble progress = 0.0.obs;

  /// Show/hide details in the journey map
  final RxBool showDetails = false.obs;

  JourneyController() {
    // Initialize completedSteps for all steps
    completedSteps.value = List<bool>.filled(steps.length, false);
    updateProgress();
  }

  /// ✅ Mark a step as completed or uncompleted
  void setStep(int index, bool completed) {
    if (index >= 0 && index < completedSteps.length) {
      completedSteps[index] = completed;
      updateProgress();
    }
  }

  /// ✅ Mark a specific step as completed
  void completeStep(int index) {
    setStep(index, true);
  }

  /// ✅ Mark a specific step as incomplete
  void uncompleteStep(int index) {
    setStep(index, false);
  }

  /// ✅ Reset a specific step
  void resetStep(int index) {
    if (index >= 0 && index < completedSteps.length) {
      completedSteps[index] = false;
      updateProgress();
    }
  }

  /// ✅ Update journey progress dynamically
  void updateProgress() {
    final total = steps.length;
    final done = completedSteps.where((e) => e).length;
    progress.value = total == 0 ? 0 : (done / total) * 100;
  }

  /// ✅ Reset the entire journey
  void resetProgress() {
    currentStep.value = 0;
    completedSteps.value = List<bool>.filled(steps.length, false);
    progress.value = 0.0;
    showDetails.value = false;
  }

  /// ✅ Toggle journey details visibility
  void toggleJourneyDetails() {
    showDetails.value = !showDetails.value;
  }

  /// ✅ Set progress based on current screen's step
  /// For example: KeyResultsScreen → stepIndex = 1 → progress = 40%
  void setProgressByStep(int stepIndex) {
    if (stepIndex < 0 || stepIndex >= steps.length) return;

    // Mark all previous steps completed automatically
    for (int i = 0; i <= stepIndex; i++) {
      completedSteps[i] = true;
    }

    // Update current active step
    currentStep.value = stepIndex;

    // Recalculate overall progress
    updateProgress();
  }


  /// ✅ Update Key Results step progress dynamically
  void updateKeyResultsStep(bool enable) {
    if (enable) {
      // Mark Key Results step as completed (3rd step → index 2)
      completedSteps[2] = true;
    } else {
      // Mark it incomplete if deselected
      completedSteps[2] = false;
    }
    updateProgress(); // Recalculate overall journey progress
  }

}







// import 'package:get/get.dart';
//
// class JourneyController extends GetxController {
//   /// Index of the current step
//   final RxInt currentStep = 0.obs;
//
//   /// Journey steps
//   final List<String> steps = [
//     "Select Strategy",
//     "Select Objective",
//     "Select Key Results",
//     "Suggest Initiatives",
//     "Complete",
//   ];
//
//   /// Track completed steps
//   final RxList<bool> completedSteps = <bool>[].obs;
//
//   /// Overall progress (0% → 100%)
//   final RxDouble progress = 0.0.obs;
//
//   /// Show/hide details in the journey map
//   final RxBool showDetails = false.obs;
//
//   JourneyController() {
//     // Initialize completedSteps list
//     completedSteps.value = List<bool>.filled(steps.length, false);
//     updateProgress();
//   }
//
//   /// ✅ Mark a step as completed or uncompleted
//   void setStep(int index, bool completed) {
//     if (index >= 0 && index < completedSteps.length) {
//       completedSteps[index] = completed;
//       updateProgress();
//     }
//   }
//
//   /// ✅ Mark a step as completed
//   void completeStep(int index) {
//     setStep(index, true);
//   }
//
//   /// ✅ Mark a step as incomplete
//   void uncompleteStep(int index) {
//     setStep(index, false);
//   }
//
//   /// ✅ Reset a specific step
//   void resetStep(int index) {
//     if (index >= 0 && index < completedSteps.length) {
//       completedSteps[index] = false;
//       updateProgress(); // 🔹 Ensure progress is recalculated immediately
//     }
//   }
//
//   /// ✅ Recalculate the journey progress
//   void updateProgress() {
//     final total = steps.length;
//     final done = completedSteps.where((e) => e).length;
//     progress.value = total == 0 ? 0 : (done / total) * 100;
//   }
//
//   /// ✅ Reset the entire journey
//   void resetProgress() {
//     currentStep.value = 0;
//     completedSteps.value = List<bool>.filled(steps.length, false);
//     progress.value = 0.0;
//     showDetails.value = false;
//   }
//
//   /// ✅ Toggle journey details visibility
//   void toggleJourneyDetails() {
//     showDetails.value = !showDetails.value;
//   }
// }
//
//
//
//
//
//
// //
// //
// //
// // // lib/presentation/controllers/journey_controller.dart
// // import 'package:get/get.dart';
// //
// // class JourneyController extends GetxController {
// //   /// index of currently focused step (optional)
// //   final RxInt currentStep = 0.obs;
// //
// //   /// steps of the global journey (default set here)
// //   final List<String> steps = [
// //     "Select Strategy",
// //     "Select Objective",
// //     "Select Key Results",
// //     "Suggest Initiatives",
// //     "Complete",
// //   ];
// //
// //   /// completed flags for each step (reactive)
// //   final RxList<bool> completedSteps = <bool>[].obs;
// //
// //   /// progress as percentage 0..100
// //   final RxDouble progress = 0.0.obs;
// //
// //   /// show/hide details in the journey widget
// //   final RxBool showDetails = false.obs;
// //
// //   JourneyController() {
// //     // initialize completedSteps to false for each step
// //     completedSteps.value = List<bool>.filled(steps.length, false);
// //     updateProgress();
// //   }
// //
// //   /// mark a step index as completed or not
// //   void setStep(int index, bool completed) {
// //     if (index >= 0 && index < completedSteps.length) {
// //       completedSteps[index] = completed;
// //       updateProgress();
// //     }
// //   }
// //
// //   /// helper to mark a step as completed
// //   void completeStep(int index) {
// //     setStep(index, true);
// //   }
// //
// //   /// helper to unmark a step
// //   void uncompleteStep(int index) {
// //     setStep(index, false);
// //   }
// //
// //   /// recalculate progress percent from completedSteps
// //   void updateProgress() {
// //     final total = steps.length;
// //     final done = completedSteps.where((e) => e).length;
// //     progress.value = total == 0 ? 0 : (done / total) * 100;
// //   }
// //
// //   // inside JourneyController
// //
// //   /// ✅ Reset a specific step
// //   void resetStep(int index) {
// //     if (index >= 0 && index < completedSteps.length) {
// //       completedSteps[index] = false;
// //       updateProgress();
// //     }
// //   }
// //   //
// //   //
// //   // /// reset everything
// //   // void resetProgress() {
// //   //   currentStep.value = 0;
// //   //   completedSteps.value = List<bool>.filled(steps.length, false);
// //   //   progress.value = 0.0;
// //   //   showDetails.value = false;
// //   // }
// //
// //   /// toggle the "show details" flag used by your JourneyMap widget
// //   void toggleJourneyDetails() {
// //     showDetails.value = !showDetails.value;
// //   }
// // }
// //
// //
// //
// // // import 'package:get/get.dart';
// // //
// // // class JourneyController extends GetxController {
// // //   // Track journey details visibility
// // //   RxBool showDetails = false.obs;
// // //
// // //   // Track current progress percentage (0 to 100)
// // //   RxDouble progress = 0.0.obs;
// // //
// // //   // Completed steps tracker → all false initially
// // //   RxList<bool> completedSteps = <bool>[].obs;
// // //
// // //   // Steps list
// // //   final List<String> steps = [
// // //     "Select Strategy",
// // //     "Complete Mission",
// // //     "Upgrade Gear",
// // //     "Unlock Skills",
// // //     "Win Battle"
// // //   ];
// // //
// // //   // Total steps
// // //   int get totalSteps => steps.length;
// // //
// // //   @override
// // //   void onInit() {
// // //     super.onInit();
// // //     // ✅ All steps disabled by default
// // //     completedSteps.value = List.generate(totalSteps, (_) => false);
// // //   }
// // //
// // //   // Toggle journey details visibility
// // //   void toggleJourneyDetails() {
// // //     showDetails.value = !showDetails.value;
// // //   }
// // //
// // //   // Update progress dynamically (+20% per completed step)
// // //   void updateProgress() {
// // //     final completed = completedSteps.where((done) => done).length;
// // //     final stepPercentage = 100 / totalSteps;
// // //     progress.value = (completed * stepPercentage).clamp(0, 100);
// // //   }
// // //
// // //   // Mark a step completed → Auto-update progress
// // //   void completeStep(int stepIndex) {
// // //     if (stepIndex < totalSteps) {
// // //       completedSteps[stepIndex] = true;
// // //       updateProgress();
// // //     }
// // //   }
// // //
// // //   // Reset journey progress
// // //   void resetProgress() {
// // //     progress.value = 0.0;
// // //     completedSteps.value = List.generate(totalSteps, (_) => false);
// // //     showDetails.value = false;
// // //   }
// // // }
