import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presentation/routes/app_routes.dart';
import '../services/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presentation/routes/app_routes.dart';
import '../services/shared_preference.dart';

class HomeController extends GetxController {
  late PageController pageController;
  final RxInt selectedCardIndex = 0.obs;


  final List<Map<String, dynamic>> cards = [
    {
      'titleTop': 'Start',
      'titleBottom': 'Game',
      'subtitle': 'Jump into action! Play solo at your own pace or team up for a collaborative strategy challenge.',
      'cta': 'Tap to Start',
      'bg': 0xFFC34028,
      'bg2': 0xFFB23322,
      'icon': 'assets/images/game.svg',
    },
    {
      'titleTop': 'Join',
      'titleBottom': 'Challenge',
      'subtitle': 'Accept an invite or launch a duel. Compete with friends or colleagues to sharpen your OKR skills.',
      'cta': 'Tap to Join',
      'bg': 0xFFBDEFE4,
      'bg2': 0xFFA3E1D4,
      'icon': 'assets/images/join.svg',
    },
    {
      'titleTop': 'Score',
      'titleBottom': 'Board',
      'subtitle': 'Track your performance, see where you rank, and celebrate milestones with badges and trophies.',
      'cta': 'Tap to Check',
      'bg': 0xFFC9CBEF,
      'bg2': 0xFFB4B7EA,
      'icon': 'assets/images/score.svg',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _clearPreviousGameData();
    _initializePageController();

  }


  Future<void> _clearPreviousGameData() async {
    try {
      await SharedPrefs.clearGameSessionData();
      print('🔄 Home screen: Cleared previous game data for fresh start');
    } catch (e) {
      print('❌ Error clearing game data: $e');
    }
  }
  void _initializePageController() {
    pageController = PageController(
      viewportFraction: 0.85,
      initialPage: selectedCardIndex.value,
    );
    pageController.addListener(_onScroll);
  }

  void _onScroll() {
    if (pageController.hasClients) {
      final page = pageController.page;
      if (page != null) {
        selectedCardIndex.value = page.round();
      }
    }
  }

  void resetPageController() {
    pageController.removeListener(_onScroll);
    pageController.dispose();
    _initializePageController();
  }

  void goNext() {
    if (pageController.hasClients && selectedCardIndex.value < cards.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goPrev() {
    if (pageController.hasClients && selectedCardIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onTapCTA() {
    switch (selectedCardIndex.value) {
      case 0:
        Get.toNamed(AppRoutes.gameMode);
        break;

      case 1:
        _saveChallengeMode();
        Get.toNamed(AppRoutes.joinChallengeScreen);
        break;

      case 2:
        Get.toNamed(AppRoutes.scoreboardScreen);
        break;
    }
  }

  // Save challenge mode when user clicks "Join Challenge"
  Future<void> _saveChallengeMode() async {
    try {
      await SharedPrefs.saveGameMode('challenge');
      print('🎯 Challenge mode saved to SharedPreferences');

      // Verify it was saved
      final savedMode = await SharedPrefs.getGameMode();
      print('✅ Verified saved game mode: $savedMode');
    } catch (e) {
      print('❌ Error saving challenge mode: $e');
    }
  }


  @override
  void onClose() {
    pageController.removeListener(_onScroll);
    pageController.dispose();
    super.onClose();
  }
}






//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../presentation/routes/app_routes.dart';
// import '../services/shared_preference.dart';
//
// class HomeController extends GetxController {
//   final PageController pageController = PageController(viewportFraction: 0.78);
//   final RxInt selectedCardIndex = 0.obs;
//
//   final List<Map<String, dynamic>> cards = [
//     {
//       'titleTop': 'Start'.tr,
//       'titleBottom': 'Game'.tr,
//       'subtitle': 'Jump into action! Play solo at your own pace or team up for a collaborative strategy challenge.'.tr,
//       'cta': 'Tap to Start'.tr,
//       'bg': 0xFFC34028,
//       'bg2': 0xFFB23322,
//       'icon': 'assets/images/game.svg',
//     },
//     {
//       'titleTop': 'Join'.tr,
//       'titleBottom': 'Challenge'.tr,
//       'subtitle': 'Accept an invite or launch a duel. Compete with friends or colleagues to sharpen your OKR skills.'.tr,
//       'cta': 'Tap to Join'.tr,
//       'bg': 0xFFBDEFE4,
//       'bg2': 0xFFA3E1D4,
//       'icon': 'assets/images/join.svg',
//     },
//     {
//       'titleTop': 'Score'.tr,
//       'titleBottom': 'Board'.tr,
//       'subtitle': 'Track your performance, see where you rank, and celebrate milestones with badges and trophies.'.tr,
//       'cta': 'Tap to Check'.tr,
//       'bg': 0xFFC9CBEF,
//       'bg2': 0xFFB4B7EA,
//       'icon': 'assets/images/score.svg',
//     },
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       pageController.addListener(_onScroll);
//     });
//   }
//
//   void _onScroll() {
//     if (!pageController.hasClients) return;
//     final page = pageController.page;
//     if (page != null) {
//       selectedCardIndex.value = page.round();
//     }
//   }
//
//   void goNext() {
//     if (selectedCardIndex.value < cards.length - 1) {
//       pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void goPrev() {
//     if (selectedCardIndex.value > 0) {
//       pageController.previousPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void onTapCTA() {
//     switch (selectedCardIndex.value) {
//       case 0:
//       // Solo/Team/Campaign mode selection
//         Get.toNamed(AppRoutes.gameMode);
//         break;
//
//       case 1:
//       // ✅ Save "challenge" mode and navigate to join challenge screen
//         _saveChallengeMode();
//         Get.toNamed(AppRoutes.joinChallengeScreen);
//         break;
//
//       case 2:
//       // Scoreboard
//         Get.toNamed(AppRoutes.scoreboardScreen);
//         break;
//     }
//   }
//
//   // ✅ Save challenge mode when user clicks "Join Challenge"
//   Future<void> _saveChallengeMode() async {
//     try {
//       await SharedPrefs.saveGameMode('challenge');
//       print('🎯 Challenge mode saved to SharedPreferences');
//
//       // Verify it was saved
//       final savedMode = await SharedPrefs.getGameMode();
//       print('✅ Verified saved game mode: $savedMode');
//     } catch (e) {
//       print('❌ Error saving challenge mode: $e');
//     }
//   }
//
//   @override
//   void onClose() {
//     pageController.dispose();
//     super.onClose();
//   }
// }
//
