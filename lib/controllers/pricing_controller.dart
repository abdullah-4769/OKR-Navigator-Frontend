import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../presentation/routes/app_routes.dart';
import 'game_mode_controller.dart';
import '../../services/shared_preference.dart'; // Add this import

class PricingController extends GetxController {
  final RxInt currentPageIndex = 0.obs;

  /// Inject GameModeController
  final GameModeController gameModeController = Get.find<GameModeController>();

  final List<Map<String, dynamic>> pricingPlans = [
    {
      'title': 'navigator',
      'price': 'Free'.tr,
      'features': [
        {'text': 'solo_mode_level_1', 'included': true},
        {'text': 'ai_feedback_per_day', 'included': true},
        {'text': 'certified_challenge_per_day', 'included': true},
        {'text': 'limited_badges', 'included': true},
      ],
      'level': 'level_1_access',
      'users': 'single_user',
      'highlighted': false,
    },
    {
      'title': 'navigator_plus',
      'price': '3.99€/month',
      'features': [
        {'text': 'full_solo_mode', 'included': true},
        {'text': 'weekly_missions', 'included': true},
        {'text': 'ai_tips_debrief', 'included': true},
        {'text': 'xp_tracking', 'included': true},
        {'text': 'community_leaderboard', 'included': true},
        {'text': 'bonus_mode', 'included': true},
      ],
      'level': 'level_2_access',
      'users': 'single_user',
      'highlighted': true,
    },
    {
      'title': 'master_navigation',
      'price': '9.99€/month',
      'features': [
        {'text': 'all_navigator_plus_features', 'included': true},
        {'text': 'official_certificate', 'included': true},
        {'text': 'performance_reports', 'included': true},
        {'text': 'monthly_live_coaching', 'included': true},
        {'text': 'exclusive_badge_sets', 'included': true},
      ],
      'level': 'level_3_access',
      'users': 'multiple_users',
      'highlighted': false,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _verifyGameMode(); // Verify the game mode on init
  }

  /// Verify that we have a valid game mode
  void _verifyGameMode() async {
    final savedMode = await SharedPrefs.getGameMode();
    if (savedMode == null || savedMode.isEmpty) {
      // If no mode is saved, default to solo and save it
      await SharedPrefs.saveGameMode('solo');
      gameModeController.selectedMode.value = 'solo';
    } else {
      // Ensure the controller has the correct mode
      gameModeController.selectedMode.value = savedMode;
    }
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  void nextCard(PageController pageController) {
    if (currentPageIndex.value < pricingPlans.length - 1) {
      currentPageIndex.value++;
      pageController.animateToPage(
        currentPageIndex.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousCard(PageController pageController) {
    if (currentPageIndex.value > 0) {
      currentPageIndex.value--;
      pageController.animateToPage(
        currentPageIndex.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void handleContinue() {
    final mode = gameModeController.selectedMode.value;

    // Ensure mode is saved before navigation
    SharedPrefs.saveGameMode(mode);

    if (mode == 'team') {
      Get.toNamed(AppRoutes.splashScreenTeam);
      Get.delete<PricingController>();
    }
    else if (mode == 'campaign') {
      Get.toNamed(AppRoutes.roleSelection);
      Get.delete<PricingController>();
    }
    else {
      // Solo mode
      selectPlan(currentPageIndex.value);
    }
  }

  void selectPlan(int index) {
    Get.toNamed(AppRoutes.roleSelection);
    Get.delete<PricingController>();
  }
}













// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import '../presentation/routes/app_routes.dart';
// import 'game_mode_controller.dart';
//
// class PricingController extends GetxController {
//   final RxInt currentPageIndex = 0.obs;
//
//   /// Inject GameModeController
//   final GameModeController gameModeController = Get.find<GameModeController>();
//
//   final List<Map<String, dynamic>> pricingPlans = [
//     {
//       'title': 'navigator',
//       'price': 'Free',
//       'features': [
//         {'text': 'solo_mode_level_1', 'included': true},
//         {'text': 'ai_feedback_per_day', 'included': true},
//         {'text': 'certified_challenge_per_day', 'included': true},
//         {'text': 'limited_badges', 'included': true},
//       ],
//       'level': 'level_1_access',
//       'users': 'single_user',
//       'highlighted': false,
//     },
//     {
//       'title': 'navigator_plus',
//       'price': '3.99€/month',
//       'features': [
//         {'text': 'full_solo_mode', 'included': true},
//         {'text': 'weekly_missions', 'included': true},
//         {'text': 'ai_tips_debrief', 'included': true},
//         {'text': 'xp_tracking', 'included': true},
//         {'text': 'community_leaderboard', 'included': true},
//         {'text': 'bonus_mode', 'included': true},
//       ],
//       'level': 'level_2_access',
//       'users': 'single_user',
//       'highlighted': true,
//     },
//     {
//       'title': 'master_navigation',
//       'price': '9.99€/month',
//       'features': [
//         {'text': 'all_navigator_plus_features', 'included': true},
//         {'text': 'official_certificate', 'included': true},
//         {'text': 'performance_reports', 'included': true},
//         {'text': 'monthly_live_coaching', 'included': true},
//         {'text': 'exclusive_badge_sets', 'included': true},
//       ],
//       'level': 'level_3_access',
//       'users': 'multiple_users',
//       'highlighted': false,
//     },
//   ];
//
//   void onPageChanged(int index) {
//     currentPageIndex.value = index;
//   }
//
//   void nextCard(PageController pageController) {
//     if (currentPageIndex.value < pricingPlans.length - 1) {
//       currentPageIndex.value++;
//       pageController.animateToPage(
//         currentPageIndex.value,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void previousCard(PageController pageController) {
//     if (currentPageIndex.value > 0) {
//       currentPageIndex.value--;
//       pageController.animateToPage(
//         currentPageIndex.value,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//   void handleContinue() {
//     final mode = gameModeController.selectedMode.value;
//
//     if (mode == 'team') {
//       //  Navigate to splash for team
//       Get.toNamed(AppRoutes.splashScreenTeam);
//
//       // dispose pricing controller after moving away
//       Get.delete<PricingController>();
//     }
//     else if (mode == 'campaign') {
//       //  Navigate to splash for team
//       Get.toNamed(AppRoutes.campaignRoleSelectionScreen);
//
//       // dispose pricing controller after moving away
//       Get.delete<PricingController>();
//     }
//     else {
//       //  Solo or Campaign continue normal flow
//       selectPlan(currentPageIndex.value);
//     }
//   }
//
//   void selectPlan(int index) {
//     Get.toNamed(AppRoutes.roleSelection);
//     // dispose pricing controller after use
//     Get.delete<PricingController>();
//   }
//
// }
