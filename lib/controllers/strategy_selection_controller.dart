import 'dart:math';

import 'package:game_app/controllers/base_strategy_controller.dart';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';

import '../generated/models/responses/strategy/strategy_response.dart';

class StrategySelectionController extends BaseStrategyController {
  @override
  void revealCard(StrategyResponse strategy) {
    final randomIndex = Random().nextInt(cardAssets.length);
    selectedCardImage.value = cardAssets[randomIndex];
    isCardRevealed.value = true;

    selectedStrategy.value = strategy;

    // ✅ Mark step 0 as completed & update journey progress
    journey.completeStep(0);
  }

  @override
  void hideCard() {
    selectedCardImage.value = null; // backcard
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
// import 'dart:math' hide log;
// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:game_app/controllers/base_strategy_controller.dart';
// import 'package:game_app/data/repositories/strategy_repository.dart';
// import 'package:game_app/generated/models/responses/strategy/strategy_response.dart';
// import 'package:game_app/utils/snackbar_helper.dart';
// import '../presentation/routes/app_routes.dart';
//
// /// Controller for Strategy Selection Screen
// class StrategySelectionController extends BaseStrategyController {
//   /// Randomly reveal one of the available cards with a fetched strategy
//   @override
//   Future<void> revealRandomCard() async {
//     try {
//       loading.value = true;
//
//       // Fetch strategy from repository (API or local)
//       final strategy = await Get.find<StrategyRepository>().getStrategyImage();
//
//       // Pick random card (excluding the back)
//       final randomIndex = Random().nextInt(cardAssets.length - 1) + 1;
//       selectedCardImage.value = cardAssets[randomIndex];
//
//       revealCard(strategy);
//     } catch (e, s) {
//       log('Error revealing card: $e', stackTrace: s);
//       SnackbarHelper.error('Failed to reveal card');
//     } finally {
//       loading.value = false;
//     }
//   }
//
//   /// Called when a specific card is revealed
//   @override
//   void revealCard(StrategyResponse strategy) {
//     isCardRevealed.value = true;
//     selectedStrategy.value = strategy;
//     journey.completeStep(0);
//   }
//
//   /// Hides the current card and resets selection
//   @override
//   void hideCard() {
//     selectedCardImage.value = null;
//     isCardRevealed.value = false;
//     selectedStrategy.value = null;
//     journey.resetStep(0);
//   }
//
//   /// Reset the card and allow new draw
//   @override
//   void resetAndDrawNewCard() {
//     hideCard();
//   }
//
//   /// Begin Mission - Navigate to next screen with selected data
//   @override
//   void beginMission(
//       Map<String, dynamic>? selectedRole,
//       Map<String, dynamic>? selectedIndustry,
//       ) {
//     // Validation check
//     if (selectedStrategy.value == null) {
//       SnackbarHelper.error('Please reveal a strategy card first');
//       log('❌ Cannot begin mission: No strategy selected');
//       return;
//     }
//
//     // Debug logs
//     log('════════════════════════════════════════');
//     log('🚀 BEGIN MISSION CALLED');
//     log('Role: $selectedRole');
//     log('Industry: $selectedIndustry');
//     log('Strategy ID: ${selectedStrategy.value?.id}');
//     log('Strategy Name: ${selectedStrategy.value?.strategyId}');
//     log('Target Route: ${AppRoutes.keyObjectiveScreen}');
//     log('Current Route BEFORE: ${Get.currentRoute}');
//     log('════════════════════════════════════════');
//
//     try {
//       // Prevent multiple taps
//       if (loading.value) {
//         log('⚠️ Already navigating, ignoring tap');
//         return;
//       }
//
//       loading.value = true;
//
//       // Use Get.toNamed directly
//       Get.toNamed(
//         AppRoutes.keyObjectiveScreen,
//         arguments: {
//           'selectedRole': selectedRole,
//           'selectedIndustry': selectedIndustry,
//           'strategy': selectedStrategy.value,
//         },
//         preventDuplicates: true, // ✅ Prevent duplicate navigation
//       )?.then((_) {
//         log('✅ Navigation completed');
//         loading.value = false;
//
//         // Check route after navigation
//         Future.delayed(const Duration(milliseconds: 500), () {
//           log('📍 Current Route AFTER: ${Get.currentRoute}');
//           if (Get.currentRoute == AppRoutes.selectStrategy) {
//             log('⚠️⚠️⚠️ STILL ON STRATEGY SCREEN - SOMETHING IS WRONG!');
//           }
//         });
//       }).catchError((e) {
//         log('❌ Navigation error: $e');
//         loading.value = false;
//       });
//
//     } catch (e, s) {
//       log('❌ Navigation failed: $e');
//       log('Stack trace: $s');
//       SnackbarHelper.error('Navigation failed: $e');
//       loading.value = false;
//     }
//   }
// }
