import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../presentation/routes/app_routes.dart';

class HomeController extends GetxController {
  // HORIZONTAL SCROLL: viewportFraction adjusted to show partial next/prev card
  final PageController pageController = PageController(viewportFraction: 0.85); 
  final RxInt selectedCardIndex = 0.obs;

  final List<Map<String, dynamic>> cards = [
    {
      'titleTop': 'Start'.tr,
      'titleBottom': 'Game'.tr,
      'subtitle': 'Jump into action! Play solo at your own pace or team up for a collaborative strategy challenge.'.tr,
      'cta': 'Tap to Start'.tr,
      'bg': 0xFFC34028,
      'bg2': 0xFFB23322,
      'icon': 'assets/images/game.svg',
    },
    {
      'titleTop': 'Join'.tr,
      'titleBottom': 'Challenge'.tr,
      'subtitle': 'Accept an invite or launch a duel. Compete with friends or colleagues to sharpen your OKR skills.'.tr,
      'cta': 'Tap to Join'.tr,
      'bg': 0xFF4ECDC4, // Color for Join Challenge (Green/Blue)
      'bg2': 0xFF36B37E,
      'icon': 'assets/images/join.svg',
    },
    {
      'titleTop': 'Check'.tr,
      'titleBottom': 'Scoreboard'.tr,
      'subtitle': 'Track your performance, see where you rank, and celebrate milestones with badges and trophies.'.tr,
      'cta': 'Tap to Check'.tr,
      'bg': 0xFF2D3E50, // Color for Scoreboard (Blue/Purple)
      'bg2': 0xFF172B4D,
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
      // Use round to snap selection to the nearest integer page index
      selectedCardIndex.value = page.round();
    }
  }
  
  // ✅ FIX: The missing getter 'onPageChanged'
  void onPageChanged(int index) {
    selectedCardIndex.value = index;
  }

  void goNext() {
    if (selectedCardIndex.value < cards.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goPrev() {
    if (selectedCardIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onTapCTA() {
    switch (selectedCardIndex.value) {
      case 0:
        // Start Game (Red Card)
        Get.toNamed(AppRoutes.gameMode);
        break;
      case 1:
        // Join Challenge (Green/Blue Card)
        Get.toNamed(AppRoutes.contextualChallenge);
        break;
      case 2:
        // Scoreboard (Blue Card)
        Get.toNamed(AppRoutes.scoreboardScreen);
        break;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}