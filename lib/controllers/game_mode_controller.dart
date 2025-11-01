import 'package:flutter/material.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';
import '../../services/shared_preference.dart';

class GameModeController extends GetxController {
  final PageController pageController = PageController(viewportFraction: 0.8);
  final RxInt selectedIndex = 0.obs;
  final RxString selectedMode = 'solo'.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    isLoading.value = true;

    // Load saved mode first
    await _loadSavedGameMode();

    // Then setup page controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        pageController.jumpToPage(selectedIndex.value);
      }
    });

    pageController.addListener(_handlePageChange);
    isLoading.value = false;
  }

  void resetGameMode() {
    selectedIndex.value = 0;
    selectedMode.value = 'solo';
    SharedPrefs.clearGameMode();
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    print('🎮 Game mode reset to: solo');
  }

  final List<Map<String, dynamic>> gameModes = [
    {
      'title': 'solo'.tr,
      'subtitle': 'Play alone at your own pace'.tr,
      'icon': 'assets/images/solop.png',
      'color': const Color(0xFF4ECDC4),
      'description': 'Challenge yourself and improve your skills individually'.tr,
      'mode': 'solo',
    },
    {
      'title': 'Team'.tr,
      'subtitle': 'Collaborate with others'.tr,
      'icon': 'assets/images/teamteam.png',
      'color': const Color(0xFFFF6B6B),
      'description': 'Work together with your team to achieve common goals'.tr,
      'mode': 'team',
    },

    {
      'title': 'campaign'.tr,
      'subtitle': 'Complete missions and progress'.tr,
      'icon': 'assets/images/campaign_image.png',
      'color': const Color(0xFF45B7D1),
      'description': 'Engage in structured missions with progressive difficulty'.tr,
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
        selectedMode.value = gameModes[newIndex]['mode'] as String;
        print('🔄 Page changed to: ${selectedMode.value}');
      }
    }
  }

  /// Load saved game mode from SharedPreferences
  Future<void> _loadSavedGameMode() async {
    try {
      final savedMode = await SharedPrefs.getGameMode();
      print('📥 Loading saved game mode: $savedMode');

      if (savedMode != null && savedMode.isNotEmpty) {
        selectedMode.value = savedMode;
        // Find the index of the saved mode
        final index = gameModes.indexWhere((mode) => mode['mode'] == savedMode);
        if (index != -1) {
          selectedIndex.value = index;
          print('✅ Loaded saved mode: $savedMode at index: $index');
        } else {
          print('⚠️ Saved mode not found in gameModes, using default');
        }
      } else {
        print('ℹ️ No saved game mode found, using default: solo');
      }
    } catch (e) {
      print('❌ Error loading saved game mode: $e');
    }
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
    selectedMode.value = gameModes[index]['mode'] as String;
    print('🎯 Page manually changed to: ${selectedMode.value}');
  }

  void nextCard() {
    if (selectedIndex.value < gameModes.length - 1) {
      selectedIndex.value++;
      selectedMode.value = gameModes[selectedIndex.value]['mode'] as String;
      pageController.animateToPage(
        selectedIndex.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      print('➡️ Next card: ${selectedMode.value}');
    }
  }

  void previousCard() {
    if (selectedIndex.value > 0) {
      selectedIndex.value--;
      selectedMode.value = gameModes[selectedIndex.value]['mode'] as String;
      pageController.animateToPage(
        selectedIndex.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      print('⬅️ Previous card: ${selectedMode.value}');
    }
  }

  /// Navigate to Pricing screen and store selected mode
  void navigateToPricingScreen() {
    final selectedGameMode = gameModes[selectedIndex.value]['mode'] as String;
    selectedMode.value = selectedGameMode;

    print('💾 Saving game mode: $selectedGameMode');
    SharedPrefs.saveGameMode(selectedGameMode);

    print('🚀 Navigating to PricingScreen with mode: $selectedGameMode');
    Get.toNamed(AppRoutes.pricingScreen);
  }

  /// Get current game mode for external use
  String get currentGameMode => selectedMode.value;

  /// Check if a specific mode is selected
  bool isModeSelected(String mode) => selectedMode.value == mode;

  String get modeSvg {
    switch (selectedMode.value) {
      case 'team':
        return 'assets/images/team.svg';
      case 'campaign':
        return 'assets/images/campaign.svg';
      case 'solo':
      default:
        return 'assets/images/solo.svg';
    }
  }
  // In your Campaign controller
  Future<void> verifyGameMode() async {
    final savedMode = await SharedPrefs.getGameMode();
    print('🎮 Current saved game mode: $savedMode');

    if (savedMode != 'campaign') {
      print('⚠️ Warning: Campaign screen loaded but saved mode is: $savedMode');
      // You might want to handle this case - redirect or show error
    } else {
      print('✅ Campaign mode verified successfully');
    }
  }

  // In GameModeController - add this method
  String getCurrentGameMode() {
    return selectedMode.value;
  }

  bool isCampaignMode() {
    return selectedMode.value == 'campaign';
  }

  bool isSoloMode() {
    return selectedMode.value == 'solo';
  }

}

//kjsscoiugasdluvc
//
//
// import 'package:flutter/material.dart';
// import 'package:game_app/presentation/routes/app_routes.dart';
// import 'package:get/get.dart';
//
// class GameModeController extends GetxController {
//   final PageController pageController = PageController(viewportFraction: 0.8);
//   final RxInt selectedIndex = 0.obs;
//   @override
//   void onInit() {
//     super.onInit();
//     // Instead of jumpToPage here, wait for the first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (pageController.hasClients) {
//         pageController.jumpToPage(0); // or whatever index you want
//       }
//     });
//
//     pageController.addListener(_handlePageChange);
//   }
//
//   void resetGameMode() {
//     selectedIndex.value = 0;
//     selectedMode.value = 'solo';
//     if (pageController.hasClients) {
//       pageController.jumpToPage(0);
//     }
//   }
//
//   /// Selected mode for PricingScreen (solo, team, campaign)
//   final RxString selectedMode = 'solo'.obs;
//
//   /// Game modes list with proper asset paths and additional data
//   final List<Map<String, dynamic>> gameModes = [
//     {
//       'title': 'Solo'.tr,
//       'subtitle': 'Play alone at your own pace'.tr,
//       'icon': 'assets/images/solo.svg',
//       'color': const Color(0xFF4ECDC4),
//       'description':
//       'Challenge yourself and improve your skills individually'.tr,
//       'mode': 'solo',
//     },
//     {
//       'title': 'Team'.tr,
//       'subtitle': 'Collaborate with others'.tr,
//       'icon': 'assets/images/team.svg',
//       'color': const Color(0xFFFF6B6B),
//       'description': 'Work together with your team to achieve common goals'.tr,
//       'mode': 'team',
//     },
//     {
//       'title': 'Campaign'.tr,
//       'subtitle': 'Complete missions and progress'.tr,
//       'icon': 'assets/images/campaign.svg',
//       'color': const Color(0xFF45B7D1),
//       'description':
//       'Engage in structured missions with progressive difficulty'.tr,
//       'mode': 'campaign',
//     },
//   ];
//
//
//
//   @override
//   void onClose() {
//     pageController.removeListener(_handlePageChange);
//     pageController.dispose();
//     super.onClose();
//   }
//
//   void _handlePageChange() {
//     if (pageController.page != null) {
//       final newIndex = pageController.page!.round();
//       if (newIndex != selectedIndex.value) {
//         selectedIndex.value = newIndex;
//       }
//     }
//   }
//
//   void onPageChanged(int index) {
//     selectedIndex.value = index;
//   }
//
//   void nextCard() {
//     if (selectedIndex.value < gameModes.length - 1) {
//       selectedIndex.value++;
//       pageController.animateToPage(
//         selectedIndex.value,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void previousCard() {
//     if (selectedIndex.value > 0) {
//       selectedIndex.value--;
//       pageController.animateToPage(
//         selectedIndex.value,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   /// Navigate to Pricing screen and store selected mode
//   void navigateToPricingScreen() {
//     final selectedGameMode = gameModes[selectedIndex.value]['mode'] as String;
//     selectedMode.value = selectedGameMode;
//     Get.toNamed(AppRoutes.pricingScreen);
//   }
//
//   /// Get relevant SVG asset for PricingScreen
//   String get modeSvg {
//     switch (selectedMode.value) {
//       case 'team':
//         return 'assets/images/team.svg';
//       case 'campaign':
//         return 'assets/images/campaign.svg'; // ✅ fixed spelling
//       case 'solo':
//       default:
//         return 'assets/images/solo.svg';
//     }
//   }
// }
//



