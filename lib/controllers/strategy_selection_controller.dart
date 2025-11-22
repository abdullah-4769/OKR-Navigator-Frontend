import 'dart:math';
import 'package:game_app/controllers/base_strategy_controller.dart';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../generated/models/responses/strategy/strategy_response.dart';
class StrategySelectionController extends BaseStrategyController {
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();

  @override
  void onInit() {
    super.onInit();
    // Initialize with back card
    resetToBackCard();
    print('🎴 Controller initialized');

    // Listen to language changes and reset if language changes
    ever(languageController.selectedLanguage, (_) {
      print('🌍 Language changed, resetting cards...');
      if (isCardRevealed.value) {
        // If a card is already revealed, inform user
        Get.snackbar(
          'Language Changed',
          'Cards have been updated for the new language',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      resetToBackCard();
    });
  }

  /// Reset to backcard state
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
    print('   Available cards: ${strategyCardAssets.length}');
  }

  @override
  @override
  void revealCard(StrategyResponse strategy) {
    print('🎴 Revealing Card:');
    print('   Backend cardId: ${strategy.cardId}');
    print('   Backend title: ${strategy.title}');
    print('   Language: ${languageController.selectedLanguage.value}');

    // Set the selected strategy
    selectedStrategy.value = strategy;

    // Map backend cardId to local index for display
    final mappedIndex = getCardIndexFromBackendId(strategy.cardId);
    selectedCardIndex.value = mappedIndex;

    // Ensure title retrieval is language-aware
    final displayTitle = getCardTitleFromBackendId(strategy.cardId) ?? 'Strategy Card';
    print('   Display title: $displayTitle');

    // Mark card as revealed
    isCardRevealed.value = true;

    print('   Mapped local index: $mappedIndex');
    print('   Selected Card Index: ${selectedCardIndex.value}');
    print('   Current Asset: $currentCardAsset');
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
      print('   Current language: ${languageController.selectedLanguage.value.name}');
      print('   Available cards: ${strategyCardAssets.length}');

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

  /// Reset controller to initial state
  void resetController() {
    resetToBackCard();
    print('🔄 StrategySelectionController reset to initial state');
  }

  /// Check if begin mission should be enabled
  bool get canBeginMission => isCardRevealed.value && selectedStrategy.value != null;
}
// strategy_selection_controller.dart
// import 'dart:math';
// import 'package:game_app/controllers/base_strategy_controller.dart';
// import 'package:game_app/data/repositories/strategy_repository.dart';
// import 'package:game_app/utils/snackbar_helper.dart';
// import 'package:get/get.dart';
// import '../generated/models/responses/strategy/strategy_response.dart';
//
// class StrategySelectionController extends BaseStrategyController {
//   final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize with back card
//     resetToBackCard();
//     print('🎴 Controller initialized');
//
//     // Listen to language changes and reset if language changes
//     ever(languageController.selectedLanguage, (_) {
//       print('🌍 Language changed, resetting cards...');
//       if (isCardRevealed.value) {
//         // If a card is already revealed, inform user
//         Get.snackbar(
//           'Language Changed',
//           'Cards have been updated for the new language',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//       resetToBackCard();
//     });
//   }
//
//   /// Reset to backcard state
//   void resetToBackCard() {
//     selectedCardIndex.value = -1;
//     isCardRevealed.value = false;
//     canReveal.value = true;
//     selectedStrategy.value = null;
//     loading.value = false;
//
//     print('🔄 Reset to backcard - Ready for new game');
//     print('   selectedCardIndex: ${selectedCardIndex.value}');
//     print('   isCardRevealed: ${isCardRevealed.value}');
//     print('   canReveal: ${canReveal.value}');
//     print('   Available cards: ${strategyCardAssets.length}');
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
//       // Map API cardId to our asset index
//       // For English: 8 cards (cardId 1-8 maps to index 0-7)
//       // For French/Spanish: 16 cards (cardId 1-16 maps to index 0-15)
//       int cardIndex = (strategy.cardId ?? 1) - 1; // Convert to 0-based index
//
//       // Ensure index is within bounds of current language's card assets
//       if (cardIndex < 0 || cardIndex >= strategyCardAssets.length) {
//         print('⚠️ Card index out of bounds: $cardIndex, using fallback');
//         cardIndex = Random().nextInt(strategyCardAssets.length);
//       }
//
//       // Update card state
//       selectedCardIndex.value = cardIndex;
//       isCardRevealed.value = true;
//       selectedStrategy.value = strategy;
//       canReveal.value = false;
//
//       // Complete journey step
//       journey.completeStep(0);
//
//       // Get the display title (hardcoded for FR/ES, API for EN)
//       final displayTitle = getCardTitle(cardIndex) ?? strategy.title ?? 'Strategy Card';
//
//       print('🎴 Card revealed successfully:');
//       print('   Language: ${languageController.selectedLanguage.value.name}');
//       print('   Card index: $cardIndex');
//       print('   Card asset: ${strategyCardAssets[cardIndex]}');
//       print('   API cardId: ${strategy.cardId}');
//       print('   API Strategy title: ${strategy.title}');
//       print('   Display title: $displayTitle');
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
//
//       print('⚠️ Used fallback random card: index $randomIndex');
//     }
//   }
//
//   @override
//   void hideCard() {
//     // Go back to back card
//     selectedCardIndex.value = -1;
//     isCardRevealed.value = false;
//     selectedStrategy.value = null;
//     canReveal.value = true;
//
//     // Reset journey progress
//     journey.resetStep(0);
//
//     print('🎴 Card hidden - showing back card');
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
//       return;
//     }
//
//     try {
//       loading.value = true;
//       print('🔄 Fetching random strategy from API...');
//       print('   Current language: ${languageController.selectedLanguage.value.name}');
//       print('   Available cards: ${strategyCardAssets.length}');
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
//     // Don't reset here - let the screen decide when to reset
//     super.onClose();
//   }
//
//   /// Reset controller to initial state
//   void resetController() {
//     resetToBackCard();
//     print('🔄 StrategySelectionController reset to initial state');
//   }
//
//   /// Check if begin mission should be enabled
//   bool get canBeginMission => isCardRevealed.value && selectedStrategy.value != null;
// }