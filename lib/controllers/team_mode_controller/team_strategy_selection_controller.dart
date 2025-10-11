import 'dart:math';
import 'package:get/get.dart';

import '../../presentation/routes/app_routes.dart';
import '../journey_controller.dart';

class TeamStrategySelectionController extends GetxController {
  /// List of available team strategy card assets
  final List<String> cardAssets = [
    'assets/images/card_1.png',
    'assets/images/card_1.png',
    'assets/images/card_1.png',
    'assets/images/card_1.png',
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

  /// Reset and allow drawing again
  void resetAndDrawNewCard() {
    hideCard();
  }

  /// Reveal a random strategy card
  void revealRandomCard() {
    if (cardAssets.isNotEmpty) {
      final randomIndex = Random().nextInt(cardAssets.length);
      revealCard(randomIndex);
    }
  }

  /// Begin team mission → navigate to next screen
  void beginMission({bool isCampaignMode = false}) {
    isCampaignMode
        ? Get.toNamed(AppRoutes.campaignChooseStrategy)
        : Get.toNamed(AppRoutes.assignRoleScreen);
  }
}
