// base_strategy_controller.dart
import 'package:get/get_core/src/get_main.dart';
import '../presentation/routes/app_routes.dart';
import 'package:game_app/controllers/journey_controller.dart';
import 'package:game_app/controllers/language_controller.dart';
import 'package:game_app/generated/models/responses/strategy/strategy_response.dart';
import 'package:get/get.dart';

abstract class BaseStrategyController extends GetxController {
  /// Back card asset
  final String backCardAsset = 'assets/images/backcard_img.png';

  /// List of English strategy card assets (8 cards)
  final List<String> englishCardAssets = [
    'assets/images/strategy1.png',
    'assets/images/strategy2.png',
    'assets/images/strategy3.png',
    'assets/images/strategy4.png',
    'assets/images/strategy5.png',
    'assets/images/strategy6.png',
    'assets/images/strategy7.png',
    'assets/images/strategy8.png',
  ];

  /// List of French strategy card assets (16 cards)
  final List<String> frenchCardAssets = [
    "assets/carte defis/carte defis_Page_1.png",
    "assets/carte defis/carte defis_Page_2.png",
    "assets/carte defis/carte defis_Page_3.png",
    "assets/carte defis/carte defis_Page_4.png",
    "assets/carte defis/carte defis_Page_5.png",
    "assets/carte defis/carte defis_Page_6.png",
    "assets/carte defis/carte defis_Page_7.png",
    "assets/carte defis/carte defis_Page_8.png",
    "assets/carte defis/carte defis_Page_9.png",
    "assets/carte defis/carte defis_Page_10.png",
    "assets/carte defis/carte defis_Page_11.png",
    "assets/carte defis/carte defis_Page_12.png",
    "assets/carte defis/carte defis_Page_13.png",
    "assets/carte defis/carte defis_Page_14.png",
    "assets/carte defis/carte defis_Page_15.png",
    "assets/carte defis/carte defis_Page_16.png",
  ];

  /// List of French strategy card titles (16 titles)
  final List<String> frenchCardTitles = [
    "Défi",
    "stratégie d'engagement client",
    "Défi",
    "stratégie d'engagement process",
    "Défi",
    "stratégie de Développement des talents",
    "Défi",
    "stratégie de Maximisation des Revenus",
    "Défi",
    "stratégie d'Innovation continue",
    "Défi",
    "stratégie de Renforcement Culturel",
    "Défi",
    "stratégie d'Expansion de Marché",
    "Défi",
    "stratégie de Durabilité Environnementale",
  ];

  /// List of Spanish strategy card assets (16 cards)
  final List<String> spanishCardAssets = [
    "assets/cartes objectifs/cartes objectifs_Page_1.png",
    "assets/cartes objectifs/cartes objectifs_Page_2.png",
    "assets/cartes objectifs/cartes objectifs_Page_3.png",
    "assets/cartes objectifs/cartes objectifs_Page_4.png",
    "assets/cartes objectifs/cartes objectifs_Page_5.png",
    "assets/cartes objectifs/cartes objectifs_Page_6.png",
    "assets/cartes objectifs/cartes objectifs_Page_7.png",
    "assets/cartes objectifs/cartes objectifs_Page_8.png",
    "assets/cartes objectifs/cartes objectifs_Page_9.png",
    "assets/cartes objectifs/cartes objectifs_Page_10.png",
    "assets/cartes objectifs/cartes objectifs_Page_11.png",
    "assets/cartes objectifs/cartes objectifs_Page_12.png",
    "assets/cartes objectifs/cartes objectifs_Page_13.png",
    "assets/cartes objectifs/cartes objectifs_Page_14.png",
    "assets/cartes objectifs/cartes objectifs_Page_15.png",
    "assets/cartes objectifs/cartes objectifs_Page_16.png",
  ];

  /// List of Spanish strategy card titles (16 titles)
  final List<String> spanishCardTitles = [
    "Objectif",
    "Engagement client",
    "Objectif",
    "Optimisation des processus",
    "Objectif",
    "Développement des Talents",
    "Objectif",
    "stratégie de maximisation des revenus",
    "Objectif",
    "Innovation continue",
    "Objectif",
    "Renforcement culturel",
    "Objectif",
    "Expansion de marché",
    "Objectif",
    "Durabilité environnementale",
  ];

  /// Reactive properties
  final RxInt selectedCardIndex = (-1).obs; // -1 = back card
  final RxBool isCardRevealed = false.obs;
  final RxBool loading = false.obs;
  final Rxn<StrategyResponse> selectedStrategy = Rxn();
  final RxBool canReveal = true.obs;

  /// Get controllers
  JourneyController get journey => Get.find<JourneyController>();
  LanguageController get languageController => Get.find<LanguageController>();

  /// Helper method to check if language is French
  bool get isFrench {
    final lang = languageController.selectedLanguage.value;
    final langStr = lang.toString().toLowerCase();
    return langStr.contains('french') || langStr.contains('.fr') || langStr.endsWith('fr');
  }

  /// Helper method to check if language is Spanish
  bool get isSpanish {
    final lang = languageController.selectedLanguage.value;
    final langStr = lang.toString().toLowerCase();
    return langStr.contains('spanish') || langStr.contains('.es') || langStr.endsWith('es');
  }

  /// Get strategy card assets based on selected language
  List<String> get strategyCardAssets {
    if (isFrench) {
      print('🇫🇷 Using French cards (${frenchCardAssets.length} cards)');
      return frenchCardAssets;
    } else if (isSpanish) {
      print('🇪🇸 Using Spanish cards (${spanishCardAssets.length} cards)');
      return spanishCardAssets;
    } else {
      print('🇬🇧 Using English cards (${englishCardAssets.length} cards)');
      return englishCardAssets;
    }
  }

  /// Get strategy card titles based on selected language
  List<String> get strategyCardTitles {
    if (isFrench) {
      return frenchCardTitles;
    } else if (isSpanish) {
      return spanishCardTitles;
    } else {
      return []; // English titles come from API
    }
  }

  /// Get title for a specific card index
  String? getCardTitle(int cardIndex) {
    final titles = strategyCardTitles;
    if (titles.isEmpty) {
      // For English, use API title
      return selectedStrategy.value?.title;
    }

    // For French/Spanish, use hardcoded titles
    if (cardIndex >= 0 && cardIndex < titles.length) {
      return titles[cardIndex];
    }
    return null;
  }

  /// Get all card assets including back card
  List<String> get cardAssets => [backCardAsset] + strategyCardAssets;

  /// Get current card asset based on selected index
  String get currentCardAsset {
    if (selectedCardIndex.value == -1) {
      return backCardAsset;
    }
    if (selectedCardIndex.value >= 0 && selectedCardIndex.value < strategyCardAssets.length) {
      return strategyCardAssets[selectedCardIndex.value];
    }
    return backCardAsset;
  }

  /// Get card display text with proper title handling
  String get cardDisplayText {
    if (!isCardRevealed.value) {
      return 'Tap to Reveal Strategy';
    }

    // Try to get hardcoded title first (for French/Spanish)
    final hardcodedTitle = getCardTitle(selectedCardIndex.value);
    if (hardcodedTitle != null && hardcodedTitle.isNotEmpty) {
      return hardcodedTitle;
    }

    // Fall back to API title (for English)
    return selectedStrategy.value?.title ?? 'Strategy Card';
  }

  /// Check if user can reveal card
  bool get canUserReveal => canReveal.value && !isCardRevealed.value;

  /// Abstract methods to be implemented by child controllers
  void revealCard(StrategyResponse strategy);
  void hideCard();
  void resetAndDrawNewCard();
  Future<void> revealRandomCard();

  /// Begin mission with selected strategy
  void beginMission(
      Map<String, dynamic>? selectedRole,
      Map<String, dynamic>? selectedIndustry,
      ) {
    if (!isCardRevealed.value) {
      Get.snackbar(
        'Error',
        'Please reveal a strategy card first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Get the correct display title based on language and card index
    final displayTitle = getCardTitle(selectedCardIndex.value) ??
        selectedStrategy.value?.title ??
        'Strategy Card';

    print('🚀 Begin Mission - Title Info:');
    print('   Selected card index: ${selectedCardIndex.value}');
    print('   Language: ${languageController.selectedLanguage.value}');
    print('   Is French: $isFrench');
    print('   Is Spanish: $isSpanish');
    print('   Display title: $displayTitle');
    print('   API title: ${selectedStrategy.value?.title}');

    Get.toNamed(
      AppRoutes.keyObjectiveScreen,
      arguments: {
        'selectedRole': selectedRole,
        'selectedIndustry': selectedIndustry,
        'strategy': selectedStrategy.value,
        'strategyDisplayTitle': displayTitle, // Pass display title separately
        'strategyCardIndex': selectedCardIndex.value, // Pass card index
      },
    );
  }
}
// // base_strategy_controller.dart
// import 'package:get/get_core/src/get_main.dart';
// import '../presentation/routes/app_routes.dart';
// import 'package:game_app/controllers/journey_controller.dart';
// import 'package:game_app/controllers/language_controller.dart';
// import 'package:game_app/generated/models/responses/strategy/strategy_response.dart';
// import 'package:game_app/generated/models/enums/language_enum.dart';
// import 'package:get/get.dart';
//
// abstract class BaseStrategyController extends GetxController {
//   /// Back card asset
//   final String backCardAsset = 'assets/images/backcard_img.png';
//
//   /// List of English strategy card assets (8 cards)
//   final List<String> englishCardAssets = [
//     'assets/images/strategy1.png',
//     'assets/images/strategy2.png',
//     'assets/images/strategy3.png',
//     'assets/images/strategy4.png',
//     'assets/images/strategy5.png',
//     'assets/images/strategy6.png',
//     'assets/images/strategy7.png',
//     'assets/images/strategy8.png',
//   ];
//
//   /// List of French strategy card assets (16 cards)
//   final List<String> frenchCardAssets = [
//     "assets/carte defis/carte defis_Page_1.png","title":"Défi",
//     "assets/carte defis/carte defis_Page_2.png","title":"stratégie ďengagement client",
//     "assets/carte defis/carte defis_Page_3.png","title":"Défi",
//     "assets/carte defis/carte defis_Page_4.png","title":"stratégie ďengagement process",
//     "assets/carte defis/carte defis_Page_5.png","title":"Défi",
//     "assets/carte defis/carte defis_Page_6.png","title":"stratégie de Dévelopment des talent",
//     "assets/carte defis/carte defis_Page_7.png","title":"Défi",
//     "assets/carte defis/carte defis_Page_8.png","title":"stratégie de Maximization des Revenus",
//     "assets/carte defis/carte defis_Page_9.png","title":"Défi",
//     "assets/carte defis/carte defis_Page_10.png","title":"stratégie ďInnovation continue",
//     "assets/carte defis/carte defis_Page_11.png","title":"Défi",
//     "assets/carte defis/carte defis_Page_12.png","title":"stratégie Reinforcement Culturel"
//     "assets/carte defis/carte defis_Page_13.png","title":"Défi",
//     "assets/carte defis/carte defis_Page_14.png","title":"stratégie ďExpansion de Marché"
//     "assets/carte defis/carte defis_Page_15.png","title":"Défi",
//     "assets/carte defis/carte defis_Page_16.png","title":"stratégie de Durabilité Environnementale",
//   ];
//
//   /// List of Spanish strategy card assets (16 cards)
//   final List<String> spanishCardAssets = [
//     "assets/cartes objectifs/cartes objectifs_Page_1.png","title":"Objectif",
//     "assets/cartes objectifs/cartes objectifs_Page_2.png","title":"Engagent client",
//     "assets/cartes objectifs/cartes objectifs_Page_3.png","title":"Objectif",
//     "assets/cartes objectifs/cartes objectifs_Page_4.png","title":"Optimization desprocessus",
//     "assets/cartes objectifs/cartes objectifs_Page_5.png","title":"Objectif",
//     "assets/cartes objectifs/cartes objectifs_Page_6.png","title":"Dévelopment des Talent",
//     "assets/cartes objectifs/cartes objectifs_Page_7.png","title":"Objectif",
//     "assets/cartes objectifs/cartes objectifs_Page_8.png","title":"stratégie de maximization des revenus",
//     "assets/cartes objectifs/cartes objectifs_Page_9.png","title":"Objectif",
//     "assets/cartes objectifs/cartes objectifs_Page_10.png","title":"Innovation continue",
//     "assets/cartes objectifs/cartes objectifs_Page_11.png","title":"Objectif",
//     "assets/cartes objectifs/cartes objectifs_Page_12.png","title":"Reinforcement culturel",
//     "assets/cartes objectifs/cartes objectifs_Page_13.png","title":"Objectif",
//     "assets/cartes objectifs/cartes objectifs_Page_14.png","title":"Expansion de marché",
//     "assets/cartes objectifs/cartes objectifs_Page_15.png","title":"Objectif",
//     "assets/cartes objectifs/cartes objectifs_Page_16.png","title":"Durabilitè environnementale",
//   ];
//
//   /// Reactive properties
//   final RxInt selectedCardIndex = (-1).obs; // -1 = back card
//   final RxBool isCardRevealed = false.obs;
//   final RxBool loading = false.obs;
//   final Rxn<StrategyResponse> selectedStrategy = Rxn();
//   final RxBool canReveal = true.obs;
//
//   /// Get controllers
//   JourneyController get journey => Get.find<JourneyController>();
//   LanguageController get languageController => Get.find<LanguageController>();
//
//   /// Get strategy card assets based on selected language
//   List<String> get strategyCardAssets {
//     switch (languageController.selectedLanguage.value) {
//       case SupportedLanguage.fr:
//         print('🇫🇷 Using French cards (${frenchCardAssets.length} cards)');
//         return frenchCardAssets;
//       case SupportedLanguage.es:
//         print('🇪🇸 Using Spanish cards (${spanishCardAssets.length} cards)');
//         return spanishCardAssets;
//       case SupportedLanguage.en:
//       default:
//         print('🇬🇧 Using English cards (${englishCardAssets.length} cards)');
//         return englishCardAssets;
//     }
//   }
//
//   /// Get all card assets including back card
//   List<String> get cardAssets => [backCardAsset] + strategyCardAssets;
//
//   /// Get current card asset based on selected index
//   String get currentCardAsset {
//     if (selectedCardIndex.value == -1) {
//       return backCardAsset;
//     }
//     if (selectedCardIndex.value >= 0 && selectedCardIndex.value < strategyCardAssets.length) {
//       return strategyCardAssets[selectedCardIndex.value];
//     }
//     return backCardAsset;
//   }
//
//   /// Get card display text
//   String get cardDisplayText {
//     if (!isCardRevealed.value) {
//       return 'Tap to Reveal Strategy';
//     }
//     return selectedStrategy.value?.title ?? 'Strategy Card';
//   }
//
//   /// Check if user can reveal card
//   bool get canUserReveal => canReveal.value && !isCardRevealed.value;
//
//   /// Abstract methods to be implemented by child controllers
//   void revealCard(StrategyResponse strategy);
//   void hideCard();
//   void resetAndDrawNewCard();
//   Future<void> revealRandomCard();
//
//   /// Begin mission with selected strategy
//   void beginMission(
//     Map<String, dynamic>? selectedRole,
//     Map<String, dynamic>? selectedIndustry,
//   ) {
//     if (!isCardRevealed.value) {
//       Get.snackbar(
//         'Error',
//         'Please reveal a strategy card first',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     Get.toNamed(
//       AppRoutes.keyObjectiveScreen,
//       arguments: {
//         'selectedRole': selectedRole,
//         'selectedIndustry': selectedIndustry,
//         'strategy': selectedStrategy.value,
//       },
//     );
//   }
// }