import 'dart:math';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'journey_controller.dart';

class StrategySelectionController extends GetxController {
  /// List of available strategy card assets
  final List<String> cardAssets = [
    "assets/images/card1.png",
    "assets/images/card2.png",
    "assets/images/card3.png",
    "assets/images/card4.png",
  ];

  /// Index of the selected card (-1 = backcard)
  final RxInt selectedCardIndex = (-1).obs;

  /// Whether a card is revealed
  final RxBool isCardRevealed = false.obs;

  /// Name of the selected strategy
  final RxString selectedStrategy = ''.obs;

  /// Access JourneyController
  JourneyController get journey => Get.find<JourneyController>();

  /// Reveal a specific card
  void revealCard(int index, {String? name}) {
    selectedCardIndex.value = index;
    isCardRevealed.value = true;

    if (name != null) {
      selectedStrategy.value = name;
    }

    // ✅ Mark step 0 as completed & update journey progress
    journey.completeStep(0);
  }

  /// Hide the card → Show backcard.svg again
  void hideCard() {
    selectedCardIndex.value = -1; // backcard
    isCardRevealed.value = false;
    selectedStrategy.value = '';

    // ✅ Reset journey progress for step 0
    journey.resetStep(0);
  }

  /// Draw a new strategy → Go back to backcard.svg first
  void resetAndDrawNewCard() {
    // ✅ Show backcard.svg again
    hideCard();
    // ❌ Do NOT reveal a random card automatically
  }

  /// Reveal a random strategy card from the list
  void revealRandomCard() {
    if (cardAssets.isNotEmpty) {
      final randomIndex = Random().nextInt(cardAssets.length);
      revealCard(randomIndex);
    }
  }

  /// Begin mission and navigate to the next screen
  void beginMission() {
    Get.toNamed(AppRoutes.keyObjectiveScreen);
  }
}













// import 'package:get/get.dart';
//
// class JourneyController extends GetxController {
//   // Current step index
//   final RxInt currentStep = 0.obs;
//
//   // Steps in the journey
//   final List<String> steps = [
//     "Select Strategy",
//     "Select Objective",
//     "Select Key Results",
//     "Suggest Initiatives",
//     "Complete",
//   ];
//
//   // Track which steps are completed
//   final RxList<bool> completedSteps = <bool>[].obs;
//
//   // Progress percentage
//   final RxDouble progress = 0.0.obs;
//
//   // Show/hide details
//   final RxBool showDetails = false.obs;
//
//   JourneyController() {
//     completedSteps.value = List<bool>.filled(steps.length, false);
//   }
//
//   /// ✅ Mark a step as active/inactive
//   void setStep(int index, bool active) {
//     if (index >= 0 && index < steps.length) {
//       if (active) {
//         currentStep.value = index;
//       }
//     }
//   }
//
//   /// ✅ Mark a step as completed
//   void completeStep(int index) {
//     if (index >= 0 && index < completedSteps.length) {
//       completedSteps[index] = true;
//       updateProgress();
//     }
//   }
//
//   /// ✅ Reset everything back to start
//   void resetProgress() {
//     currentStep.value = 0;
//     completedSteps.value = List<bool>.filled(steps.length, false);
//     progress.value = 0.0;
//     showDetails.value = false;
//   }
//
//   /// ✅ Recalculate progress (percentage)
//   void updateProgress() {
//     final total = steps.length;
//     final done = completedSteps.where((e) => e).length;
//     progress.value = (done / total) * 100;
//   }
//
//   /// ✅ Toggle details view
//   void toggleJourneyDetails() {
//     showDetails.value = !showDetails.value;
//   }
// }
