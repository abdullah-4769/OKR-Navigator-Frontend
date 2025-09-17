import 'package:flutter/material.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';

class GameModeController extends GetxController {
  final PageController pageController = PageController(viewportFraction: 0.8);
  final RxInt selectedIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    // Instead of jumpToPage here, wait for the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        pageController.jumpToPage(0); // or whatever index you want
      }
    });

    pageController.addListener(_handlePageChange);
  }

  void resetGameMode() {
    selectedIndex.value = 0;
    selectedMode.value = 'solo';
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
  }

  /// Selected mode for PricingScreen (solo, team, campaign)
  final RxString selectedMode = 'solo'.obs;

  /// Game modes list with proper asset paths and additional data
  final List<Map<String, dynamic>> gameModes = [
    {
      'title': 'Solo'.tr,
      'subtitle': 'Play alone at your own pace'.tr,
      'icon': 'assets/images/solo.svg',
      'color': const Color(0xFF4ECDC4),
      'description':
      'Challenge yourself and improve your skills individually'.tr,
      'mode': 'solo',
    },
    {
      'title': 'Team'.tr,
      'subtitle': 'Collaborate with others'.tr,
      'icon': 'assets/images/team.svg',
      'color': const Color(0xFFFF6B6B),
      'description': 'Work together with your team to achieve common goals'.tr,
      'mode': 'team',
    },
    {
      'title': 'Campaign'.tr,
      'subtitle': 'Complete missions and progress'.tr,
      'icon': 'assets/images/campaign.svg',
      'color': const Color(0xFF45B7D1),
      'description':
      'Engage in structured missions with progressive difficulty'.tr,
      'mode': 'campaign',
    },
  ];



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

  /// Navigate to Pricing screen and store selected mode
  void navigateToPricingScreen() {
    final selectedGameMode = gameModes[selectedIndex.value]['mode'] as String;
    selectedMode.value = selectedGameMode;
    Get.toNamed(AppRoutes.pricingScreen);
  }

  /// Get relevant SVG asset for PricingScreen
  String get modeSvg {
    switch (selectedMode.value) {
      case 'team':
        return 'assets/images/team.svg';
      case 'campaign':
        return 'assets/images/campaign.svg'; // ✅ fixed spelling
      case 'solo':
      default:
        return 'assets/images/solo.svg';
    }
  }
}
