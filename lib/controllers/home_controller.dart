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
      'titleTop': 'start'.tr,
      'titleBottom': 'game'.tr,
      'subtitle': 'start_game_subtitle'.tr,
      'cta': 'tap_to_start'.tr,
      'bg': 0xFFC34028,
      'bg2': 0xFFB23322,
      'icon': 'assets/images/game.svg',
    },
    {
      'titleTop': 'join'.tr,
      'titleBottom': 'challenge'.tr,
      'subtitle': 'join_challenge_subtitle'.tr,
      'cta': 'tap_to_join'.tr,
      'bg': 0xFFBDEFE4,
      'bg2': 0xFFA3E1D4,
      'icon': 'assets/images/join.svg',
    },
    {
      'titleTop': 'score'.tr,
      'titleBottom': 'board'.tr,
      'subtitle': 'scoreboard_subtitle'.tr,
      'cta': 'tap_to_check'.tr,
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
      print('home_journey_reset'.tr);
    } catch (e) {
      print('home_journey_reset_error'.trParams({'error': e.toString()}));
    }
  }

  Future<void> _clearPreviousGameData() async {
    try {
      await SharedPrefs.clearGameSessionData();
      print('home_clear_game_data'.tr);
    } catch (e) {
      print('home_clear_game_data_error'.trParams({'error': e.toString()}));
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

  Future<void> _saveChallengeMode() async {
    try {
      await SharedPrefs.saveGameMode('challenge');
      print('home_challenge_mode_saved'.tr);

      final savedMode = await SharedPrefs.getGameMode();
      print('home_challenge_mode_verified'.trParams({'mode': savedMode ?? 'null'}));
    } catch (e) {
      print('home_challenge_mode_error'.trParams({'error': e.toString()}));
    }
  }

  @override
  void onClose() {
    pageController.removeListener(_onScroll);
    pageController.dispose();
    super.onClose();
  }
}