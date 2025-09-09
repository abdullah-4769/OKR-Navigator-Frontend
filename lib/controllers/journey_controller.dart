import 'package:get/get.dart';

class JourneyController extends GetxController {
  /// Index of the current step (reactive)
  final RxInt currentStep = 0.obs;

  /// Journey steps
  final List<String> steps = [
    'Select Strategy'.tr,
    'Select Objective'.tr,
    'Select Key Results'.tr,
    'Suggest Initiatives'.tr,
    'Complete'.tr,
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
  void setStep(int index, completed) {
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
  void updateKeyResultsStep(enable) {
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
