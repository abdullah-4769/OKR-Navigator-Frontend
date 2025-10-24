import 'dart:math';

import 'package:game_app/controllers/base_strategy_controller.dart';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';

import '../generated/models/responses/strategy/strategy_response.dart';

class StrategySelectionController extends BaseStrategyController {
  @override
  void revealCard(StrategyResponse strategy) {
    // Use the same logic as your working team controller
    final randomIndex = Random().nextInt(cardAssets.length);

    // Set the selected card index instead of selectedCardImage
    selectedCardIndex.value = randomIndex;
    isCardRevealed.value = true;

    selectedStrategy.value = strategy;

    journey.completeStep(0);
  }

  @override
  void hideCard() {
    // Reset to back card state (-1 index)
    selectedCardIndex.value = -1;
    isCardRevealed.value = false;
    selectedStrategy.value = null;

    // ✅ Reset journey progress for step 0
    journey.resetStep(0);
  }

  /// Draw a new strategy → Go back to backcard.svg first
  @override
  void resetAndDrawNewCard() {
    // ✅ Show backcard.svg again
    hideCard();
    // ❌ Do NOT reveal a random card automatically
  }

  /// Reveal a random strategy card from the list
  @override
  Future<void> revealRandomCard() async {
    try {
      if (cardAssets.isNotEmpty) {
        loading.value = true;
        final strategy = await Get.find<StrategyRepository>()
            .getStrategyImage();
        revealCard(strategy);
        loading.value = false;
      }
    } catch (e, s) {
      loading.value = false;
      SnackbarHelper.error(e.toString());
    }
  }
}

//
// import 'dart:math';
//
// import 'package:game_app/controllers/base_strategy_controller.dart';
// import 'package:game_app/data/repositories/strategy_repository.dart';
// import 'package:game_app/utils/snackbar_helper.dart';
// import 'package:get/get.dart';
//
// import '../generated/models/responses/strategy/strategy_response.dart';
//
// class StrategySelectionController extends BaseStrategyController {
//   @override
//   void revealCard(StrategyResponse strategy) {
//     final randomIndex = Random().nextInt(cardAssets.length);
//     selectedCardImage.value = cardAssets[randomIndex];
//     isCardRevealed.value = true;
//
//     selectedStrategy.value = strategy;
//
//     journey.completeStep(0);
//   }
//
//   @override
//   void hideCard() {
//     selectedCardImage.value = null; // backcard
//     isCardRevealed.value = false;
//     selectedStrategy.value = null;
//
//     // ✅ Reset journey progress for step 0
//     journey.resetStep(0);
//   }
//
//   /// Draw a new strategy → Go back to backcard.svg first
//   @override
//   void resetAndDrawNewCard() {
//     // ✅ Show backcard.svg again
//     hideCard();
//     // ❌ Do NOT reveal a random card automatically
//   }
//
//   /// Reveal a random strategy card from the list
//   @override
//   Future<void> revealRandomCard() async {
//     try {
//       if (cardAssets.isNotEmpty) {
//         loading.value = true;
//         final strategy = await Get.find<StrategyRepository>()
//             .getStrategyImage();
//         revealCard(strategy);
//         loading.value = false;
//       }
//     } catch (e, s) {
//       loading.value = false;
//       SnackbarHelper.error(e.toString());
//     }
//   }
// }
//
//
//





// import 'dart:math';
// import 'package:get/get.dart';
// import '../presentation/routes/app_routes.dart';
// import 'journey_controller.dart';
//
// class StrategySelectionController extends GetxController {
//   /// List of available strategy card assets
//   final List<String> cardAssets = [
//     'assets/images/backcard_img.png', // Index 0 - back card
//     'assets/images/card_1.png',       // Index 1 - card 1
//     'assets/images/card_1.png',       // Index 2 - card 1 (duplicate for randomness)
//     'assets/images/card_1.png',       // Index 3 - card 1 (duplicate for randomness)
//   ];
//
//   /// Index of the selected card (-1 = backcard)
//   final RxInt selectedCardIndex = (-1).obs;
//
//   /// Whether a card is revealed
//   final RxBool isCardRevealed = false.obs;
//
//   /// Selected strategy name
//   final RxString selectedStrategy = ''.obs;
//
//   /// Loading state
//   final RxBool loading = false.obs;
//
//   /// Access JourneyController
//   JourneyController get journey => Get.find<JourneyController>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize with back card
//     selectedCardIndex.value = -1;
//     isCardRevealed.value = false;
//   }
//
//   /// Reveal a specific card
//   void revealCard(int index, {String? strategyName}) {
//     print('🎴 Revealing card at index: $index');
//
//     selectedCardIndex.value = index;
//     isCardRevealed.value = true;
//
//     if (strategyName != null) {
//       selectedStrategy.value = strategyName;
//     }
//
//     // ✅ Mark step 0 as completed & update journey progress
//     journey.completeStep(0);
//
//     print('✅ Card revealed: ${cardAssets[index]}');
//     print('✅ Strategy selected: $selectedStrategy');
//   }
//
//   /// Hide the card → Show backcard again
//   void hideCard() {
//     print('🎴 Hiding card, showing back card');
//
//     selectedCardIndex.value = -1; // backcard
//     isCardRevealed.value = false;
//     selectedStrategy.value = '';
//
//     // ✅ Reset journey progress for step 0
//     journey.resetStep(0);
//   }
//
//   /// Draw a new strategy → Go back to backcard first
//   void resetAndDrawNewCard() {
//     print('🔄 Resetting and drawing new card');
//     hideCard();
//   }
//
//   /// Reveal a random strategy card from the list
//   void revealRandomCard() {
//     print('🎲 Revealing random card');
//
//     if (cardAssets.isEmpty) {
//       print('❌ No card assets available');
//       return;
//     }
//
//     try {
//       loading.value = true;
//
//       // Generate random index (1, 2, or 3 - excluding back card at index 0)
//       final randomIndex = Random().nextInt(cardAssets.length - 1) + 1;
//       print('🎯 Random index generated: $randomIndex');
//
//       // Simulate API call delay
//       Future.delayed(Duration(milliseconds: 500), () {
//         revealCard(randomIndex, strategyName: 'Strategy ${randomIndex}');
//         loading.value = false;
//
//         print('🎉 Random card revealed successfully!');
//         print('📊 Current state - isCardRevealed: ${isCardRevealed.value}');
//         print('📊 Current state - selectedCardIndex: ${selectedCardIndex.value}');
//       });
//
//     } catch (e) {
//       loading.value = false;
//       print('❌ Error revealing random card: $e');
//     }
//   }
//
//   /// Begin mission and navigate to the next screen
//   void beginMission(
//       Map<String, dynamic>? selectedRole,
//       Map<String, dynamic>? selectedIndustry,
//       ) {
//     if (!isCardRevealed.value || selectedCardIndex.value == -1) {
//       print('❌ Cannot begin mission: No card revealed');
//       Get.snackbar(
//         'Error',
//         'Please reveal a strategy card first',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     print('🚀 Beginning mission with:');
//     print('   Role: $selectedRole');
//     print('   Industry: $selectedIndustry');
//     print('   Strategy: $selectedStrategy');
//
//     Get.toNamed(
//       AppRoutes.keyObjectiveScreen,
//       arguments: {
//         'selectedRole': selectedRole,
//         'selectedIndustry': selectedIndustry,
//         'strategy': selectedStrategy.value,
//       },
//     );
//   }
// }
//
//
//
//


