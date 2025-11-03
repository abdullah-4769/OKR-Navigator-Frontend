import 'package:get/get_core/src/get_main.dart';

import '../presentation/routes/app_routes.dart';
import 'package:game_app/controllers/journey_controller.dart';
import 'package:game_app/generated/models/responses/strategy/strategy_response.dart';
import 'package:get/get.dart';

// base_strategy_controller.dart
abstract class BaseStrategyController extends GetxController {

  /// Back card asset
  final String backCardAsset = 'assets/images/backcard_img.png';

  /// ✅ FIXED: Add cardAssets for UI compatibility
  List<String> get cardAssets => [backCardAsset] + strategyCardAssets;

  /// List of 8 strategy card assets
  final List<String> strategyCardAssets = [
    'assets/images/strategy1.png',
    'assets/images/strategy2.png',
    'assets/images/strategy3.png',
    'assets/images/strategy4.png',
    'assets/images/strategy5.png',
    'assets/images/strategy6.png',
    'assets/images/strategy7.png',
    'assets/images/strategy8.png',
  ];

  /// Reactive properties
  final RxInt selectedCardIndex = (-1).obs; // -1 = back card
  final RxBool isCardRevealed = false.obs;
  final RxBool loading = false.obs;
  final Rxn<StrategyResponse> selectedStrategy = Rxn();
  final RxBool canReveal = true.obs;

  JourneyController get journey => Get.find<JourneyController>();

  // ✅ ADDED: currentCardAsset getter for compatibility
  String get currentCardAsset {
    if (selectedCardIndex.value == -1) {
      return backCardAsset;
    }
    if (selectedCardIndex.value >= 0 && selectedCardIndex.value < cardAssets.length) {
      return cardAssets[selectedCardIndex.value];
    }
    return backCardAsset;
  }

  // ✅ ADDED: cardDisplayText getter
  String get cardDisplayText {
    if (!isCardRevealed.value) {
      return 'Tap to Reveal Strategy';
    }
    return selectedStrategy.value?.title ?? 'Strategy Card';
  }

  bool get canUserReveal => canReveal.value && !isCardRevealed.value;

  void revealCard(StrategyResponse strategy);
  void hideCard();
  void resetAndDrawNewCard();
  Future<void> revealRandomCard();

  void beginMission(
      Map<String, dynamic>? selectedRole,
      Map<String, dynamic>? selectedIndustry,
      ) {
    if (!isCardRevealed.value) {
      Get.snackbar(
        'Error',
        'Please reveal a strategy card first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.toNamed(
      AppRoutes.keyObjectiveScreen,
      arguments: {
        'selectedRole': selectedRole,
        'selectedIndustry': selectedIndustry,
        'strategy': selectedStrategy.value,
      },
    );
  }
}
// // import 'package:game_app/controllers/journey_controller.dart';
// // import 'package:game_app/generated/models/responses/strategy/strategy_response.dart';
// // import 'package:get/get.dart';
// //
// // import '../presentation/routes/app_routes.dart';
// //
// // abstract class BaseStrategyController extends GetxController {
// //   /// List of available strategy card assets
// //   final List<String> cardAssets = [
// //     'assets/images/backcard_img.png',
// //     'assets/images/card_1.png',
// //     'assets/images/card_1.png',
// //     'assets/images/card_1.png',
// //   ];
// //   final Rxn<String> selectedCardImage = Rxn<String>();
// //   final RxBool loading = false.obs;
// //
// //   /// Whether a card is revealed
// //   final RxBool isCardRevealed = false.obs;
// //
// //   /// Name of the selected strategy
// //   final Rxn<StrategyResponse> selectedStrategy = Rxn();
// //
// //   JourneyController get journey => Get.find<JourneyController>();
// //
// //   void revealCard(StrategyResponse strategy);
// //
// //   void hideCard();
// //
// //   void resetAndDrawNewCard();
// //
// //   Future<void> revealRandomCard();
// //
// //   /// Begin mission and navigate to the next screen
// //   void beginMission(
// //     Map<String, dynamic>? selectedRole,
// //     Map<String, dynamic>? selectedIndustry,
// //   ) {
// //     Get.toNamed(
// //       AppRoutes.keyObjectiveScreen,
// //       arguments: {
// //         'selectedRole': selectedRole,
// //         'selectedIndustry': selectedIndustry,
// //       },
// //     );
// //   }
// // }
// // ============================================
// // FILE 1: base_strategy_controller.dart
// // ============================================
//
// import 'package:game_app/controllers/journey_controller.dart';
// import 'package:game_app/generated/models/responses/strategy/strategy_response.dart';
// import 'package:get/get.dart';
// import '../presentation/routes/app_routes.dart';
//
// /// Base controller for all strategy-based screens.
// /// Child controllers should extend this and implement abstract methods.
// abstract class BaseStrategyController extends GetxController {
//   /// Available card images (front + back)
//   final List<String> cardAssets = [
//     'assets/images/backcard_img.png',
//     'assets/images/card_1.png',
//     'assets/images/backcard_img.png',
//     'assets/images/backcard_img.png',
//   ];
//
//   /// Reactive properties for UI updates
//   final Rxn<String> selectedCardImage = Rxn<String>();
//   final RxBool isCardRevealed = false.obs;
//   final RxBool loading = false.obs;
//   final Rxn<StrategyResponse> selectedStrategy = Rxn();
//
//   /// ✅ ADDED: Track which card index is selected (for PageView/Carousel)
//   final RxInt selectedCardIndex = 0.obs;
//
//   /// Access Journey controller for progress tracking
//   JourneyController get journey => Get.find<JourneyController>();
//
//   /// Must be implemented in subclasses
//   void revealCard(StrategyResponse strategy);
//   void hideCard();
//   void resetAndDrawNewCard();
//   Future<void> revealRandomCard();
//
//   /// Navigate to next mission screen
//   void beginMission(
//       Map<String, dynamic>? selectedRole,
//       Map<String, dynamic>? selectedIndustry,
//       ) {
//     Get.toNamed(
//       AppRoutes.keyObjectiveScreen,
//       arguments: {
//         'selectedRole': selectedRole,
//         'selectedIndustry': selectedIndustry,
//         'strategy': selectedStrategy.value,
//       },
//     );
//   }
//
//   /// ✅ HELPER: Update card index manually (for PageView controller)
//   void updateCardIndex(int index) {
//     if (index >= 0 && index < cardAssets.length) {
//       selectedCardIndex.value = index;
//     }
//   }
//
//   /// ✅ HELPER: Get current card asset path
//   String? get currentCardAsset {
//     if (selectedCardIndex.value >= 0 &&
//         selectedCardIndex.value < cardAssets.length) {
//       return cardAssets[selectedCardIndex.value];
//     }
//     return null;
//   }
// }
