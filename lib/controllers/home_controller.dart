import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presentation/routes/app_routes.dart';
import '../services/shared_preference.dart';
import 'journey_controller.dart';

class HomeController extends GetxController {
  late PageController pageController;
  final RxInt selectedCardIndex = 0.obs;

  final List<Map<String, dynamic>> cards = [
    {
      'titleTop': 'start',
      'titleBottom': 'game',
      'subtitle': 'start_game_subtitle',
      'cta': 'tap_to_start',
      'bg': 0xFFC34028,
      'bg2': 0xFFB23322,
      'icon': 'assets/images/game.svg',
    },
    {
      'titleTop': 'join',
      'titleBottom': 'challenge',
      'subtitle': 'join_challenge_subtitle',
      'cta': 'tap_to_join',
      'bg': 0xFFBDEFE4,
      'bg2': 0xFFA3E1D4,
      'icon': 'assets/images/join.svg',
    },
    {
      'titleTop': 'score',
      'titleBottom': 'board',
      'subtitle': 'scoreboard_subtitle',
      'cta': 'tap_to_check',
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
    _resetJourneyProgress();
  }

  void _resetJourneyProgress() {
    try {
      final journeyController = Get.find<JourneyController>();
      journeyController.resetProgress();
      print('✅ Journey progress reset');
    } catch (e) {
      print('❌ Error resetting journey: $e');
    }
  }

  Future<void> _clearPreviousGameData() async {
    try {
      await SharedPrefs.clearGameSessionData();
      print('✅ Previous game data cleared');
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
    if (pageController.hasClients &&
        selectedCardIndex.value < cards.length - 1) {
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
        // Start Game - Navigate to GameMode selection
        print('🎮 Navigating to Game Mode Selection');
        Get.toNamed(AppRoutes.gameMode);
        break;

      case 1:
        // Join Challenge
        print('🏆 Joining Challenge Mode');
        _saveChallengeMode();
        Get.toNamed(AppRoutes.joinChallengeScreen);
        break;

      case 2:
        // Scoreboard
        print('📊 Navigating to Scoreboard');
        Get.toNamed(AppRoutes.scoreboardScreen);
        break;
    }
  }

  Future<void> _saveChallengeMode() async {
    try {
      await SharedPrefs.saveGameMode('challenge');
      print('✅ Challenge mode saved');

      final savedMode = await SharedPrefs.getGameMode();
      print('✅ Challenge mode verified: $savedMode');
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
