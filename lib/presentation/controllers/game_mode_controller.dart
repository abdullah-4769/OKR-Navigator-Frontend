import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameModeController extends GetxController {
  final PageController pageController = PageController(viewportFraction: 0.8);
  final RxInt selectedIndex = 0.obs;

  // Game modes list with proper asset paths and additional data
  final List<Map<String, dynamic>> gameModes = [
    {
      "title": "Solo",
      "subtitle": "Play alone at your own pace",
      "icon": "assets/images/solo.svg",
      "color": Color(0xFF4ECDC4),
      "description": "Challenge yourself and improve your skills individually"
    },
    {
      "title": "Team",
      "subtitle": "Collaborate with others",
      "icon": "assets/images/team.svg",
      "color": Color(0xFFFF6B6B),
      "description": "Work together with your team to achieve common goals"
    },
    {
      "title": "Campaign",
      "subtitle": "Complete missions and progress",
      "icon": "assets/images/compaign.svg",
      "color": Color(0xFF45B7D1),
      "description": "Engage in structured missions with progressive difficulty"
    },
  ];

  @override
  void onInit() {
    super.onInit();
    // Add listener to sync selectedIndex with page changes
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

  // DIRECT NAVIGATION TO PRICING SCREEN
  void navigateToPricingScreen() {
    Get.toNamed('/pricing'); // Direct navigation to pricing screen
  }

/*
  // COMMENTED OUT UNUSED FUNCTIONS FOR FUTURE USE:

  void selectCard(int index) {
    if (index >= 0 && index < gameModes.length) {
      selectedIndex.value = index;
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  // Get current selected game mode
  Map<String, dynamic> get selectedGameMode {
    return gameModes[selectedIndex.value];
  }

  // Check if specific game mode is selected
  bool isSelected(int index) {
    return selectedIndex.value == index;
  }

  // Get total number of game modes
  int get totalModes {
    return gameModes.length;
  }

  // Reset selection to first card
  void resetSelection() {
    selectedIndex.value = 0;
    pageController.jumpToPage(0);
  }

  // Simulate loading for async operations
  Future<void> simulateLoading() async {
    // isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    // isLoading.value = false;
  }
  */
}