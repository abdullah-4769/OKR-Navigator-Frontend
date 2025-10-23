// import 'package:game_app/controllers/journey_controller.dart';
// import 'package:game_app/generated/models/responses/strategy/strategy_response.dart';
// import 'package:get/get.dart';
//
// import '../presentation/routes/app_routes.dart';
//
// abstract class BaseStrategyController extends GetxController {
//   /// List of available strategy card assets
//   final List<String> cardAssets = [
//     'assets/images/backcard_img.png',
//     'assets/images/card_1.png',
//     'assets/images/card_1.png',
//     'assets/images/card_1.png',
//   ];
//   final Rxn<String> selectedCardImage = Rxn<String>();
//   final RxBool loading = false.obs;
//
//   /// Whether a card is revealed
//   final RxBool isCardRevealed = false.obs;
//
//   /// Name of the selected strategy
//   final Rxn<StrategyResponse> selectedStrategy = Rxn();
//
//   JourneyController get journey => Get.find<JourneyController>();
//
//   void revealCard(StrategyResponse strategy);
//
//   void hideCard();
//
//   void resetAndDrawNewCard();
//
//   Future<void> revealRandomCard();
//
//   /// Begin mission and navigate to the next screen
//   void beginMission(
//     Map<String, dynamic>? selectedRole,
//     Map<String, dynamic>? selectedIndustry,
//   ) {
//     Get.toNamed(
//       AppRoutes.keyObjectiveScreen,
//       arguments: {
//         'selectedRole': selectedRole,
//         'selectedIndustry': selectedIndustry,
//       },
//     );
//   }
// }
// ============================================
// FILE 1: base_strategy_controller.dart
// ============================================

import 'package:game_app/controllers/journey_controller.dart';
import 'package:game_app/generated/models/responses/strategy/strategy_response.dart';
import 'package:get/get.dart';
import '../presentation/routes/app_routes.dart';

/// Base controller for all strategy-based screens.
/// Child controllers should extend this and implement abstract methods.
abstract class BaseStrategyController extends GetxController {
  /// Available card images (front + back)
  final List<String> cardAssets = [
    'assets/images/backcard_img.png',
    'assets/images/card_1.png',
    'assets/images/card_2.png',
    'assets/images/card_3.png',
  ];

  /// Reactive properties for UI updates
  final Rxn<String> selectedCardImage = Rxn<String>();
  final RxBool isCardRevealed = false.obs;
  final RxBool loading = false.obs;
  final Rxn<StrategyResponse> selectedStrategy = Rxn();

  /// ✅ ADDED: Track which card index is selected (for PageView/Carousel)
  final RxInt selectedCardIndex = 0.obs;

  /// Access Journey controller for progress tracking
  JourneyController get journey => Get.find<JourneyController>();

  /// Must be implemented in subclasses
  void revealCard(StrategyResponse strategy);
  void hideCard();
  void resetAndDrawNewCard();
  Future<void> revealRandomCard();

  /// Navigate to next mission screen
  void beginMission(
      Map<String, dynamic>? selectedRole,
      Map<String, dynamic>? selectedIndustry,
      ) {
    Get.toNamed(
      AppRoutes.keyObjectiveScreen,
      arguments: {
        'selectedRole': selectedRole,
        'selectedIndustry': selectedIndustry,
        'strategy': selectedStrategy.value,
      },
    );
  }

  /// ✅ HELPER: Update card index manually (for PageView controller)
  void updateCardIndex(int index) {
    if (index >= 0 && index < cardAssets.length) {
      selectedCardIndex.value = index;
    }
  }

  /// ✅ HELPER: Get current card asset path
  String? get currentCardAsset {
    if (selectedCardIndex.value >= 0 &&
        selectedCardIndex.value < cardAssets.length) {
      return cardAssets[selectedCardIndex.value];
    }
    return null;
  }
}
