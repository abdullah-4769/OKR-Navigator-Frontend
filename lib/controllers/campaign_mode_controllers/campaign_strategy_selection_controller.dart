import 'dart:math';
import 'package:get/get.dart';
import 'package:game_app/controllers/base_strategy_controller.dart';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/generated/models/responses/strategy/strategy_response.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import '../../presentation/routes/app_routes.dart';

class CampaignStrategySelectionController extends BaseStrategyController {
  /// 🔹 Track which card is visible (needed by CustomCardPagerBuilder)
  final RxInt selectedCardIndex = (-1).obs;

  // 🔸 Disabled for now — no card reveal logic
  @override
  void revealCard(StrategyResponse strategy) {
    // final randomIndex = Random().nextInt(cardAssets.length);
    // selectedCardIndex.value = randomIndex;
    // selectedCardImage.value = cardAssets[randomIndex];
    // isCardRevealed.value = true;
    // selectedStrategy.value = strategy;
    //
    // journey.completeStep(0);
  }

  @override
  void hideCard() {
    selectedCardIndex.value = -1;
    selectedCardImage.value = null;
    isCardRevealed.value = false;
    selectedStrategy.value = null;

    journey.resetStep(0);
  }

  @override
  void resetAndDrawNewCard() {
    hideCard();
  }

  @override
  Future<void> revealRandomCard() async {
    // 🔸 Disabled strategy fetching for now
    // try {
    //   if (cardAssets.isNotEmpty) {
    //     loading.value = true;
    //     final strategy =
    //         await Get.find<StrategyRepository>().getStrategyImage();
    //     revealCard(strategy);
    //   }
    // } catch (e) {
    //   SnackbarHelper.error(e.toString());
    // } finally {
    //   loading.value = false;
    // }
  }

  /// ✅ Simplified: just navigates to the next screen for now
  @override
  void beginMission(Map<String, dynamic>? objective, Map<String, dynamic>? initiative) {
    Get.toNamed(
      AppRoutes.campaignStrategySelection, // replace later with next route
    );
  }
}
