import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameModeController extends GetxController {
  final PageController pageController = PageController(viewportFraction: 0.8);
  final RxInt selectedIndex = 0.obs;

  // Game modes list with proper asset paths and additional data
  final List<Map<String, dynamic>> gameModes = [
    {
      'title': 'Solo'.tr,
      'subtitle': 'Play alone at your own pace'.tr,
      'icon': 'assets/images/solo.svg',
      'color': const Color(0xFF4ECDC4),
      'description': 'Challenge yourself and improve your skills individually'.tr,
    },
    {
      'title': 'Team'.tr,
      'subtitle': 'Collaborate with others'.tr,
      'icon': 'assets/images/team.svg',
      'color': const Color(0xFFFF6B6B),
      'description': 'Work together with your team to achieve common goals'.tr,
    },
    {
      'title': 'Campaign'.tr,
      'subtitle': 'Complete missions and progress'.tr,
      'icon': 'assets/images/compaign.svg',
      'color': const Color(0xFF45B7D1),
      'description': 'Engage in structured missions with progressive difficulty'.tr,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(_handlePageChange);
  }

  @override
  void onClose() {
    pageController.removeListener(_handlePageChange);
    pageController.dispose();
    super.onClose();
  }

  void _handlePageChange() {
    if (pageController.page != null) {
      final newIndex = pageController.page!.round();
      if (newIndex != selectedIndex.value) {
        selectedIndex.value = newIndex;
      }
    }
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
  }

  void nextCard() {
    if (selectedIndex.value < gameModes.length - 1) {
      selectedIndex.value++;
      pageController.animateToPage(
        selectedIndex.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousCard() {
    if (selectedIndex.value > 0) {
      selectedIndex.value--;
      pageController.animateToPage(
        selectedIndex.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void navigateToPricingScreen() {
    Get.toNamed('/pricing');
  }
}
