// strategy_selection_controller.dart
import 'dart:math';
import 'package:game_app/controllers/base_strategy_controller.dart';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../generated/models/responses/strategy/strategy_response.dart';




// ============================================
// UPDATED: strategy_selection_controller.dart
// ADD THIS METHOD
// ============================================

class StrategySelectionController extends BaseStrategyController {
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();

  @override
  void onInit() {
    super.onInit();
    // Initialize with back card
    resetToBackCard();
    print('🎴 Controller initialized');
  }

  // ✅ NEW METHOD: Reset to backcard state
  void resetToBackCard() {
    selectedCardIndex.value = -1;
    isCardRevealed.value = false;
    canReveal.value = true;
    selectedStrategy.value = null;
    loading.value = false;

    print('🔄 Reset to backcard - Ready for new game');
    print('   selectedCardIndex: ${selectedCardIndex.value}');
    print('   isCardRevealed: ${isCardRevealed.value}');
    print('   canReveal: ${canReveal.value}');
  }

  @override
  void revealCard(StrategyResponse strategy) {
    if (!canReveal.value) {
      SnackbarHelper.error('You can only reveal one card');
      return;
    }

    try {
      // Map API cardId (1-8) to our asset index (0-7)
      int cardIndex = (strategy.cardId ?? 1);

      // Ensure index is within bounds
      if (cardIndex < 0 || cardIndex >= strategyCardAssets.length) {
        cardIndex = 0;
      }

      // Update card index
      selectedCardIndex.value = cardIndex;
      isCardRevealed.value = true;
      selectedStrategy.value = strategy;
      canReveal.value = false;

      // Complete journey step
      journey.completeStep(0);

      print('🎴 Card revealed: ${strategyCardAssets[cardIndex]}');
      print('🎴 Card index: $cardIndex');
      print('🎴 API cardId: ${strategy.cardId}');
      print('📋 Strategy: ${strategy.title}');

    } catch (e) {
      print('❌ Error in revealCard: $e');
      // Fallback to random card
      final randomIndex = Random().nextInt(strategyCardAssets.length);
      selectedCardIndex.value = randomIndex;
      isCardRevealed.value = true;
      selectedStrategy.value = strategy;
      canReveal.value = false;
      journey.completeStep(0);
    }
  }

  @override
  void hideCard() {
    // Go back to back card
    selectedCardIndex.value = -1;
    isCardRevealed.value = false;
    selectedStrategy.value = null;
    canReveal.value = true;

    // Reset journey progress
    journey.resetStep(0);

    print('🎴 Card hidden - showing back card');
  }

  @override
  void resetAndDrawNewCard() {
    // Don't allow resetting if card is already revealed
    if (isCardRevealed.value) {
      SnackbarHelper.error('You cannot draw a new card after revealing');
      return;
    }
    hideCard();
  }

  @override
  Future<void> revealRandomCard() async {
    if (!canReveal.value) {
      SnackbarHelper.error('You have already revealed a card');
      return;
    }

    if (loading.value) {
      return;
    }

    try {
      loading.value = true;
      print('🔄 Fetching random strategy from API...');

      // Get strategy from API
      final strategy = await _strategyRepository.getStrategyImage();

      // Reveal the card with the strategy
      revealCard(strategy);

      loading.value = false;
      print('✅ Random card revealed successfully');

    } catch (e, s) {
      loading.value = false;
      print('❌ Error revealing random card: $e');
      print('Stack trace: $s');
      SnackbarHelper.error('Failed to reveal card: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    // Don't reset here - let the screen decide when to reset
    super.onClose();
  }

  void resetController() {
    resetToBackCard();
    print('🔄 StrategySelectionController reset to initial state');
  }

  // Check if begin mission should be enabled
  bool get canBeginMission => isCardRevealed.value && selectedStrategy.value != null;
}



//
// class StrategySelectionController extends BaseStrategyController {
//   final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize with back card
//     selectedCardIndex.value = -1;
//     isCardRevealed.value = false;
//     canReveal.value = true;
//     print('🎴 Controller initialized - canReveal: ${canReveal.value}');
//   }
//
//   @override
//   void revealCard(StrategyResponse strategy) {
//     if (!canReveal.value) {
//       SnackbarHelper.error('You can only reveal one card');
//       return;
//     }
//
//     try {
//       // ✅ FIXED: Map API cardId (1-8) to our asset index (0-7)
//       int cardIndex = (strategy.cardId ?? 1) ;
//
//       // Ensure index is within bounds
//       if (cardIndex < 0 || cardIndex >= strategyCardAssets.length) {
//         cardIndex = 0; // fallback to first card
//       }
//
//       // Update card index (this will show the corresponding strategy card)
//       selectedCardIndex.value = cardIndex;
//       isCardRevealed.value = true;
//       selectedStrategy.value = strategy;
//
//       // Prevent further reveals
//       canReveal.value = false;
//
//       // Complete journey step
//       journey.completeStep(0);
//
//       print('🎴 Card revealed: ${strategyCardAssets[cardIndex]}');
//       print('🎴 Card index: $cardIndex');
//       print('🎴 API cardId: ${strategy.cardId}');
//       print('📋 Strategy: ${strategy.title}');
//       print('🔒 canReveal set to: ${canReveal.value}');
//
//     } catch (e) {
//       print('❌ Error in revealCard: $e');
//       // Fallback to random card
//       final randomIndex = Random().nextInt(strategyCardAssets.length);
//       selectedCardIndex.value = randomIndex;
//       isCardRevealed.value = true;
//       selectedStrategy.value = strategy;
//       canReveal.value = false;
//       journey.completeStep(0);
//     }
//   }
//
//   @override
//   void hideCard() {
//     // Go back to back card
//     selectedCardIndex.value = -1;
//     isCardRevealed.value = false;
//     selectedStrategy.value = null;
//
//     // Allow revealing again when card is hidden
//     canReveal.value = true;
//
//     // Reset journey progress
//     journey.resetStep(0);
//
//     print('🎴 Card hidden - showing back card');
//     print('🔓 canReveal set to: ${canReveal.value}');
//   }
//
//   @override
//   void resetAndDrawNewCard() {
//     // Don't allow resetting if card is already revealed
//     if (isCardRevealed.value) {
//       SnackbarHelper.error('You cannot draw a new card after revealing');
//       return;
//     }
//     hideCard();
//   }
//
//   @override
//   Future<void> revealRandomCard() async {
//     if (!canReveal.value) {
//       SnackbarHelper.error('You have already revealed a card');
//       return;
//     }
//
//     if (loading.value) {
//       // Already loading, prevent multiple taps
//       return;
//     }
//
//     try {
//       loading.value = true;
//       print('🔄 Fetching random strategy from API...');
//
//       // Get strategy from API
//       final strategy = await _strategyRepository.getStrategyImage();
//
//       // Reveal the card with the strategy
//       revealCard(strategy);
//
//       loading.value = false;
//       print('✅ Random card revealed successfully');
//
//     } catch (e, s) {
//       loading.value = false;
//       print('❌ Error revealing random card: $e');
//       print('Stack trace: $s');
//       SnackbarHelper.error('Failed to reveal card: ${e.toString()}');
//     }
//   }
//
//   @override
//   void onClose() {
//     // Reset controller state when controller is closed
//     resetController();
//     super.onClose();
//   }
//
//   void resetController() {
//     selectedCardIndex.value = -1;
//     isCardRevealed.value = false;
//     canReveal.value = true;
//     selectedStrategy.value = null;
//     loading.value = false;
//
//     print('🔄 StrategySelectionController reset to initial state');
//   }
//
//   // Add a method to check if begin mission should be enabled
//   bool get canBeginMission => isCardRevealed.value && selectedStrategy.value != null;
// }



