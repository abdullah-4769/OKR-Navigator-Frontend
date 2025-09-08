import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController(viewportFraction: 0.78);
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.addListener(_onScroll);
    });
  }

  void _onScroll() {
    if (!pageController.hasClients) return;
    final page = pageController.page;
    if (page != null) {
      selectedCardIndex.value = page.round();
    }
  }

  void goNext() {
    if (selectedCardIndex.value < cards.length - 1) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void goPrev() {
    if (selectedCardIndex.value > 0) {
      pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void onTapCTA() {
    switch (selectedCardIndex.value) {
      case 0:
        Get.toNamed(AppRoutes.gameMode);
        break;
      case 1:
        Get.toNamed(AppRoutes.gameMode);
        break;
      case 2:
        Get.toNamed(AppRoutes.gameMode);
        break;
    }
  }
  // void onTapCTA() {
  //   // Navigate to GameModeScreen
  //   Get.toNamed(AppRoutes.gameMode);
  // }


  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}






// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class HomeController extends GetxController {
//   final PageController pageController = PageController(viewportFraction: 0.78);
//
//   final RxInt selectedCardIndex = 0.obs;
//
//   final List<Map<String, dynamic>> cards = [
//     {
//       'titleTop': 'Start',
//       'titleBottom': 'Game',
//       'subtitle': 'Jump into action! Play solo at your own pace or team up for a collaborative strategy challenge.',
//       'cta': 'Tap to Start',
//       'bg': 0xFFC34028,
//       'bg2': 0xFFB23322,
//       'icon': 'assets/images/game.svg',
//     },
//     {
//       'titleTop': 'Join',
//       'titleBottom': 'Challenge',
//       'subtitle': 'Accept an invite or launch a duel. Compete with friends or colleagues to sharpen your OKR skills.',
//       'cta': 'Tap to Join',
//       'bg': 0xFFBDEFE4,
//       'bg2': 0xFFA3E1D4,
//       'icon': 'assets/images/join.svg',
//     },
//     {
//       'titleTop': 'Score',
//       'titleBottom': 'Board',
//       'subtitle': 'Track your performance, see where you rank, and celebrate milestones with badges and trophies.',
//       'cta': 'Tap to Check',
//       'bg': 0xFFC9CBEF,
//       'bg2': 0xFFB4B7EA,
//       'icon': 'assets/images/score.svg',
//     },
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     pageController.addListener(_onScroll);
//   }
//
//   void _onScroll() {
//     if (pageController.hasClients) {
//       selectedCardIndex.value = pageController.page?.round() ?? 0;
//     }
//   }
//
//   void goNext() {
//     if (selectedCardIndex.value < cards.length - 1) {
//       pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
//     }
//   }
//
//   void goPrev() {
//     if (selectedCardIndex.value > 0) {
//       pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
//     }
//   }
//
//   void onTapCTA() {
//     switch (selectedCardIndex.value) {
//       case 0:
//         Get.toNamed('/gameMode');
//         //Get.toNamed('/game-start');
//         break;
//       case 1:
//         Get.toNamed('/gameMode');
//         //Get.toNamed('/challenges');
//         break;
//       case 2:
//         Get.toNamed('/gameMode');
//       // Get.toNamed('/scoreboard');
//         break;
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
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
