// import 'dart:math';
// import 'package:get/get.dart';
// import 'package:game_app/controllers/base_strategy_controller.dart';
// import 'package:game_app/data/repositories/strategy_repository.dart';
// import 'package:game_app/generated/models/responses/strategy/strategy_response.dart';
// import 'package:game_app/utils/snackbar_helper.dart';
// import '../../presentation/routes/app_routes.dart';
// import '../../services/shared_preference.dart';
//
// class CampaignStrategySelectionController extends BaseStrategyController {
//   /// 🔹 Track which card is visible (needed by CustomCardPagerBuilder)
//   final RxInt selectedCardIndex = (-1).obs;
//
//   // 🔸 Disabled for now — no card reveal logic
//   @override
//   void revealCard(StrategyResponse strategy) {
//     // final randomIndex = Random().nextInt(cardAssets.length);
//     // selectedCardIndex.value = randomIndex;
//     // selectedCardImage.value = cardAssets[randomIndex];
//     // isCardRevealed.value = true;
//     // selectedStrategy.value = strategy;
//     //
//     // journey.completeStep(0);
//   }
//
//   @override
//   void hideCard() {
//     selectedCardIndex.value = -1;
//     selectedCardImage.value = null;
//     isCardRevealed.value = false;
//     selectedStrategy.value = null;
//
//     journey.resetStep(0);
//   }
//
//   @override
//   void resetAndDrawNewCard() {
//     hideCard();
//   }
//
//   @override
//   Future<void> revealRandomCard() async {
//     // 🔸 Disabled strategy fetching for now
//     // try {
//     //   if (cardAssets.isNotEmpty) {
//     //     loading.value = true;
//     //     final strategy =
//     //         await Get.find<StrategyRepository>().getStrategyImage();
//     //     revealCard(strategy);
//     //   }
//     // } catch (e) {
//     //   SnackbarHelper.error(e.toString());
//     // } finally {
//     //   loading.value = false;
//     // }
//   }
//
//   /// ✅ Simplified: just navigates to the next screen for now
//   // In your BaseStrategyController or StrategySelectionController
//   void beginMission(Map<String, dynamic>? selectedRole, Map<String, dynamic>? contextData) async {
//     try {
//       print('🚀 Starting mission...');
//
//       // ✅ Get game mode
//       final gameMode = await SharedPrefs.getGameMode();
//       print('🎮 Game mode in beginMission: $gameMode');
//
//       if (gameMode == 'campaign') {
//         print('🏢 Campaign mode - Using organization context');
//         // Use organization data for campaign mode
//         final organizationName = SharedPrefs.getCampaignSuggestionName();
//         final organizationDesc = SharedPrefs.getCampaignSuggestionDescription();
//
//         print('🏢 Organization: $organizationName');
//         print('📝 Description: $organizationDesc');
//
//         // Navigate to next screen with organization data
//         Get.toNamed(
//           AppRoutes.keyObjectiveScreen,
//           arguments: {
//             'selectedRole': selectedRole,
//             'selectedOrganization': contextData, // Pass organization data
//             'gameMode': 'campaign',
//           },
//         );
//       } else {
//         print('🎯 Solo mode - Using industry context');
//         // Use industry data for solo mode
//         print('🏭 Industry: ${contextData?['titleKey']}');
//
//         // Navigate to next screen with industry data
//         Get.toNamed(
//           AppRoutes.keyObjectiveScreen,
//           arguments: {
//             'selectedRole': selectedRole,
//             'selectedIndustry': contextData, // Pass industry data
//             'gameMode': 'solo',
//           },
//         );
//       }
//     } catch (e) {
//       print('❌ Error in beginMission: $e');
//       Get.snackbar(
//         'Error'.tr,
//         'Failed to start mission: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
// }
