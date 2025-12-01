// lib/controllers/team_mode_controller/team_strategy_selection_controller.dart

import 'package:game_app/controllers/language_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_game_controller.dart';
import 'package:game_app/generated/models/responses/team_mode/strategy_response.dart';
import 'package:game_app/presentation/views/team_mode/game_time_controller.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../../data/repositories/strategy_repository.dart';
import '../../data/repositories/storage_repository.dart';
import '../../services/notification_service.dart';
import '../../presentation/routes/app_routes.dart';
import '../journey_controller.dart';
import 'create_team_controller.dart'; // Import for teamId lookup

class TeamStrategySelectionController extends GetxController {
  /// Repository instance
  final StrategyRepository _strategyRepository = StrategyRepository();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();

  /// Language controller to mirror single-mode rendering logic
  final LanguageController _languageController = Get.find<LanguageController>();

  /// English strategy card assets (mirrors single-player assets)
  static const List<String> _englishCardAssets = [
    'assets/images/strategy1.png',
    'assets/images/strategy2.png',
    'assets/images/strategy3.png',
    'assets/images/strategy4.png',
    'assets/images/strategy5.png',
    'assets/images/strategy6.png',
    'assets/images/strategy7.png',
    'assets/images/strategy8.png',
  ];

  /// English strategy titles for card lookup
  static const List<String> _englishCardTitles = [
    "Improved Environmental Sustainability",
    "Improve Operational Efficiency",
    "Optimize Human Resources Management",
    "Increase Profitability",
    "Innovation in Product/Service Offerings",
    "Reinforcement of Corporate Culture",
    "Development of New Markets",
    "Increase Customer Satisfaction",
  ];

  /// French assets/titles (indexes align with English order)
  static const List<String> _frenchCardAssets = [
    "assets/frencardsstrategy/1.jpeg",
    "assets/frencardsstrategy/2.jpeg",
    "assets/frencardsstrategy/3.jpeg",
    "assets/frencardsstrategy/4.jpeg",
    "assets/frencardsstrategy/5.jpeg",
    "assets/frencardsstrategy/6.jpeg",
    "assets/frencardsstrategy/7.jpeg",
    "assets/frencardsstrategy/8.jpeg",
  ];

  static const List<String> _frenchCardTitles = [
    "Amélioration de la Durabilité Environnementale",
    "Amélioration de l'Efficience opérationnelle",
    "Optimisation de la Gestion des Ressources Humaines",
    "Accroissement de la Rentabilité",
    "Innovation dans les Offres de Produits/Services",
    "Renforcement de la Culture d'Entreprise",
    "Développement de Nouveaux Marchés",
    "Augmentation de la satisfaction client",
  ];

  /// Spanish assets/titles (Spanish deck has an extra card)
  static const List<String> _spanishCardAssets = [
    "assets/cartes objectifs/cartes objectifs_Page_1.png",
    "assets/cartes objectifs/cartes objectifs_Page_2.png",
    "assets/cartes objectifs/cartes objectifs_Page_4.png",
    "assets/cartes objectifs/cartes objectifs_Page_6.png",
    "assets/cartes objectifs/cartes objectifs_Page_8.png",
    "assets/cartes objectifs/cartes objectifs_Page_10.png",
    "assets/cartes objectifs/cartes objectifs_Page_12.png",
    "assets/cartes objectifs/cartes objectifs_Page_14.png",
    "assets/cartes objectifs/cartes objectifs_Page_16.png",
  ];

  static const List<String> _spanishCardTitles = [
    "Mejora de la Sostenibilidad Ambiental",
    "Estrategia de Compromiso del Cliente",
    "Estrategia de Optimización de Procesos",
    "Estrategia de Desarrollo de Talento",
    "Estrategia de Maximización de Ingresos",
    "Estrategia de Innovación Continua",
    "Estrategia de Refuerzo Cultural",
    "Estrategia de Expansión de Mercado",
    "Estrategia de Eficiencia Operativa",
  ];

  /// Strategy assets exposed to the pager builder
  List<String> get strategyCardAssets {
    final langCode = _languageController.selectedLanguage.value.code;
    if (langCode == 'fr') return _frenchCardAssets;
    if (langCode == 'es') return _spanishCardAssets;
    return _englishCardAssets;
  }

  /// Strategy titles exposed for the active language
  List<String> get strategyCardTitles {
    final langCode = _languageController.selectedLanguage.value.code;
    if (langCode == 'fr') return _frenchCardTitles;
    if (langCode == 'es') return _spanishCardTitles;
    return _englishCardTitles;
  }

  /// Selected card index
  final RxInt selectedCardIndex = (-1).obs;

  /// Card revealed state
  final RxBool isCardRevealed = false.obs;

  /// Selected strategy name
  final RxString selectedStrategy = ''.obs;

  /// API response
  final Rxn<TeamStrategyResponse> teamStrategyResponse = Rxn<TeamStrategyResponse>();

  /// Loading state
  final RxBool isLoading = false.obs;
  RxBool get loading => isLoading;

  /// Access JourneyController
  JourneyController get journey => Get.find<JourneyController>();

  final TeamGameTimerController _timerController = Get.find<TeamGameTimerController>();

  /// Fetches team strategy from API and reveals a random card asset with the fetched name
  Future<void> fetchAndRevealStrategy() async {
    print('-------------------');
    print('Starting fetchAndRevealStrategy()');

    // Prevent multiple calls while loading or if a card is already shown
    if (isCardRevealed.value || isLoading.value) {
      print('Exiting: isRevealed=${isCardRevealed.value}, isLoading=${isLoading.value}');
      return;
    }

    try {
      isLoading.value = true;

      // 1. Retrieve required data
      if (!Get.isRegistered<CreateTeamController>()) {
        Get.snackbar('Error', 'Team creation flow not initialized.');
        print('Exiting: CreateTeamController not found.');
        return;
      }

      final teamId = Get.find<CreateTeamController>().createdTeamId.value;
      const String role = 'HOST';

      print('Team ID Check: $teamId');

      if (teamId == null) {
        Get.snackbar('Error', 'Team ID missing. Please ensure a team is created and selected.');
        print('Exiting: Team ID is null.');
        return;
      }

      print('Calling API for Team ID: $teamId');

      // 2. Call API via repository
      final response = await _strategyRepository.getTeamStrategy(teamId: teamId, role: role);
      teamStrategyResponse.value = response;
      print('API Response Status Code: ${response.statusCode}');
      print('API Response Title: ${response.title}');

      if (response.title != null) {
        // 3. Map API success to UI update
        final mappedIndex = _resolveCardIndex(response);
        if (mappedIndex == null) {
          SnackbarHelper.error('Unable to map the fetched strategy to a card.');
          print('Error: Could not find matching card for title ${response.title} or id ${response.strategyId}');
          return;
        }

        revealCard(mappedIndex, name: response.title);
        print('Success: Strategy revealed: ${response.title}');

        // 4. Initialize timer with real game time from API response
        if (response.remainingTime != null) {
          _timerController.initializeTimer(
            minutes: response.remainingTime!.minutes,
            seconds: response.remainingTime!.seconds,
          );
          print('Timer initialized with ${response.remainingTime!.minutes}:${response.remainingTime!.seconds}');
        }

      } else {
        // Handle API success but null/empty data
        Get.snackbar('Error', response.message ?? 'No strategy found for your team.');
        print('Error: API returned no title.');
      }
    } catch (e) {
      // Catch exceptions thrown by repository (e.g., API errors, network issues)
      Get.snackbar('Error', 'Failed to fetch team strategy: $e');
      print('Catch Block Error: $e');
    } finally {
      isLoading.value = false;
      print('Function finished. isLoading=false');
      print('-------------------');
    }
  }

  /// Override the method called by CustomCardPagerBuilder (UI)
  void revealRandomCard({String? name}) {
    fetchAndRevealStrategy();
  }

  /// Reveal a specific card asset and set the name
  void revealCard(int index, {String? name}) {
    if (strategyCardAssets.isEmpty) {
      SnackbarHelper.error('Strategy cards are not configured.');
      return;
    }

    final maxIndex = strategyCardAssets.length - 1;
    final clampedIndex = index.clamp(0, maxIndex).toInt();
    selectedCardIndex.value = clampedIndex;
    isCardRevealed.value = true;

    final resolvedName = name?.trim().isNotEmpty == true
        ? name!.trim()
        : (teamStrategyResponse.value?.title ??
        _getTitleForIndex(clampedIndex) ??
        '');

    selectedStrategy.value = resolvedName;

    // ✅ Mark step 0 as completed & update journey progress
    journey.completeStep(0);
  }

  /// Hide the card → Show backcard again
  void hideCard() {
    selectedCardIndex.value = -1;
    isCardRevealed.value = false;
    selectedStrategy.value = '';

    // ✅ Reset journey progress for step 0
    journey.resetStep(0);
  }

  /// Reset and allow drawing again
  void resetAndDrawNewCard() {
    hideCard();
  }

  /// Begin team mission → navigate to next screen
  void beginMission({bool isCampaignMode = false}) {
    if (!isCardRevealed.value) {
      SnackbarHelper.warning("Please reveal the strategy card first!");
      return;
    }

    // Get the arguments that were passed to THIS screen (Strategy Selection)
    final args = Get.arguments as Map<String, dynamic>?;
    final selectedRole = args?['selectedRole'];
    final selectedIndustry = args?['selectedIndustry'];

    // Update journey progress
    journey.completeStep(0);

    // ✅ FIX: Navigate to Objective Selection with arguments
    Get.toNamed(
        AppRoutes.teamObjectiveSelectionScreen,
        arguments: {
          'selectedRole': selectedRole,      // Forwarding the Role
          'selectedIndustry': selectedIndustry, // Forwarding the Industry
        }
    );
  }

  /// Readable strategy title mirroring the revealed card name
  String get strategyDisplayTitle {
    final resolvedName = selectedStrategy.value.trim();
    if (resolvedName.isNotEmpty) {
      return resolvedName;
    }

    final index = selectedCardIndex.value;
    if (index >= 0) {
      final fallback = _getTitleForIndex(index);
      if (fallback != null && fallback.trim().isNotEmpty) {
        return fallback.trim();
      }
    }

    return teamStrategyResponse.value?.title?.trim() ?? '';
  }

  /// Map backend response to a local card index
  int? _resolveCardIndex(TeamStrategyResponse response) {
    final indexFromId = _mapStrategyIdToIndex(response.strategyId);
    if (indexFromId != null) {
      return indexFromId;
    }

    final indexFromTitle = _mapTitleToIndex(response.title);
    if (indexFromTitle != null) {
      return indexFromTitle;
    }

    return null;
  }

  /// Convert backend strategyId (1-based) to 0-based index
  int? _mapStrategyIdToIndex(int? strategyId) {
    if (strategyId == null) return null;
    final adjusted = strategyId - 1;
    if (adjusted < 0) return null;

    const maxCardCount = 9; // Spanish deck contains the most cards
    if (adjusted >= maxCardCount) return null;

    return adjusted;
  }

  /// Try to match title text (any supported language) to a card index
  int? _mapTitleToIndex(String? title) {
    if (title == null || title.trim().isEmpty) return null;
    final normalized = title.toLowerCase().trim();

    final englishIndex =
    _indexOfNormalizedTitle(_englishCardTitles, normalized);
    if (englishIndex != -1) return englishIndex;

    final frenchIndex = _indexOfNormalizedTitle(_frenchCardTitles, normalized);
    if (frenchIndex != -1) return frenchIndex;

    final spanishIndex =
    _indexOfNormalizedTitle(_spanishCardTitles, normalized);
    if (spanishIndex != -1) return spanishIndex;

    return null;
  }

  int _indexOfNormalizedTitle(List<String> titles, String normalized) {
    return titles.indexWhere(
          (title) => title.toLowerCase().trim() == normalized,
    );
  }

  String? _getTitleForIndex(int index) {
    final titles = strategyCardTitles;
    if (index >= 0 && index < titles.length) {
      return titles[index];
    }
    return null;
  }
}
// import 'dart:math';
// import 'package:game_app/controllers/team_mode_controller/team_game_controller.dart';
// import 'package:game_app/generated/models/responses/team_mode/strategy_response.dart';
// import 'package:game_app/presentation/views/team_mode/game_time_controller.dart';
// import 'package:game_app/utils/snackbar_helper.dart';
// import 'package:get/get.dart';
// import '../../data/repositories/strategy_repository.dart';
// import '../../data/repositories/storage_repository.dart';
// import '../../services/notification_service.dart';
// import '../../presentation/routes/app_routes.dart';
// import '../journey_controller.dart';
// import 'create_team_controller.dart'; // Import for teamId lookup
//
// class TeamStrategySelectionController extends GetxController {
//   /// Repository instance
//   final StrategyRepository _strategyRepository = StrategyRepository();
//   final StorageRepository _storageRepository = Get.find<StorageRepository>();
//   final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();
//
//   /// List of card assets
//   final List<String> cardAssets = [
//     'assets/images/card_1.png',
//     'assets/images/card_1.png',
//     'assets/images/card_1.png',
//     'assets/images/card_1.png',
//   ];
//
//   /// Selected card index
//   final RxInt selectedCardIndex = (-1).obs;
//
//   /// Card revealed state
//   final RxBool isCardRevealed = false.obs;
//
//   /// Selected strategy name
//   final RxString selectedStrategy = ''.obs;
//
//   /// API response
//   final Rxn<TeamStrategyResponse> teamStrategyResponse = Rxn<TeamStrategyResponse>();
//
//   /// Loading state
//   final RxBool isLoading = false.obs;
//   RxBool get loading => isLoading;
//   /// Access JourneyController
//   JourneyController get journey => Get.find<JourneyController>();
// final TeamGameTimerController _timerController = Get.find<TeamGameTimerController>(); // <--- NEW FIND
// // -----------------------------------------------------------
// // ✅ INTEGRATED API CALL AND REVEAL LOGIC
// // -----------------------------------------------------------
//
//   /// Fetches team strategy from API and reveals a random card asset with the fetched name
// // lib/controllers/team_mode_controller/team_strategy_selection_controller.dart
//
// // ... existing code ...
// /// Fetches team strategy from API and reveals a random card asset with the fetched name
//  Future<void> fetchAndRevealStrategy() async {
//     // 📝 New: Always print when the function starts
//     print('-------------------');
//     print('Starting fetchAndRevealStrategy()');
//
// // Prevent multiple calls while loading or if a card is already shown
//  if (isCardRevealed.value || isLoading.value) {
//         print('Exiting: isRevealed=${isCardRevealed.value}, isLoading=${isLoading.value}');
//         return;
//     }
//  try {
//  isLoading.value = true;
// // 1. Retrieve required data
//       // Defensive Find: Ensure CreateTeamController is available
//       if (!Get.isRegistered<CreateTeamController>()) {
//         Get.snackbar('Error', 'Team creation flow not initialized.');
//         print('Exiting: CreateTeamController not found.');
//         return;
//       }
//
//
//  final teamId = Get.find<CreateTeamController>().createdTeamId.value;
//  const String role = 'HOST';
//
//       print('Team ID Check: $teamId');
//
// if (teamId == null) {
//  Get.snackbar('Error', 'Team ID missing. Please ensure a team is created and selected.');
//         print('Exiting: Team ID is null.');
//  return;
// }
//       print('Calling API for Team ID: $teamId');
//
// // 2. Call API via repository
// final response = await _strategyRepository.getTeamStrategy(teamId: teamId, role: role);
//  teamStrategyResponse.value = response;
//       print('API Response Status Code: ${response.statusCode}');
//       print('API Response Title: ${response.title}');
//
// if (response.title != null) {
//  // 3. Map API success to UI update
// final randomIndex = Random().nextInt(cardAssets.length);
// revealCard(randomIndex, name: response.title);
//
//  selectedStrategy.value = response.title!;
//       print('Success: Strategy revealed: ${response.title}');
//
//       // 4. Initialize timer with real game time from API response
//       if (response.remainingTime != null) {
//         _timerController.initializeTimer(
//           minutes: response.remainingTime!.minutes,
//           seconds: response.remainingTime!.seconds,
//         );
//         print('Timer initialized with ${response.remainingTime!.minutes}:${response.remainingTime!.seconds}');
//       }
//
//  } else {
//  // Handle API success but null/empty data
//  Get.snackbar('Error', response.message ?? 'No strategy found for your team.');
//         print('Error: API returned no title.');
// } } catch (e) {
// // Catch exceptions thrown by repository (e.g., API errors, network issues)
//  Get.snackbar('Error', 'Failed to fetch team strategy: $e');
//       print('Catch Block Error: $e');
// } finally {
//  isLoading.value = false;
//       print('Function finished. isLoading=false');
//       print('-------------------');
//  } }
//
// // ... rest of the file ...
//
//   /// Override the method called by CustomCardPagerBuilder (UI)
//   void revealRandomCard({String? name}) {
//     fetchAndRevealStrategy();
//   }
//
// // -----------------------------------------------------------
// // -----------------------------------------------------------
//
//   /// Reveal a specific card asset and set the name
//   void revealCard(int index, {String? name}) {
//     selectedCardIndex.value = index;
//     isCardRevealed.value = true;
//
//     if (name != null) selectedStrategy.value = name;
//
//     // ✅ Mark step 0 as completed & update journey progress
//     journey.completeStep(0);
//   }
//
//   /// Hide the card → Show backcard again
//   void hideCard() {
//     selectedCardIndex.value = -1;
//     isCardRevealed.value = false;
//     selectedStrategy.value = '';
//
//     // ✅ Reset journey progress for step 0
//     journey.resetStep(0);
//   }
//
//   /// Reset and allow drawing again
//   void resetAndDrawNewCard() {
//     hideCard();
//   }
//
//
//   /// Begin team mission → navigate to next screen
//  /// Corrected: Pass arguments to the next screen (TeamObjectiveScreen)
//   void beginMission({bool isCampaignMode = false}) {
//     if (!isCardRevealed.value) {
//         SnackbarHelper.warning("Please reveal the strategy card first!");
//         return;
//     }
//
//     // Get the arguments that were passed to THIS screen (Strategy Selection)
//     final args = Get.arguments as Map<String, dynamic>?;
//     final selectedRole = args?['selectedRole'];
//     final selectedIndustry = args?['selectedIndustry'];
//
//     // Update journey progress
//     journey.completeStep(0);
//
//     // ✅ FIX: Navigate to Objective Selection with arguments
//     Get.toNamed(
//         AppRoutes.teamObjectiveSelectionScreen,
//         arguments: {
//             'selectedRole': selectedRole,      // Forwarding the Role
//             'selectedIndustry': selectedIndustry, // Forwarding the Industry
//         }
//     );
//   }
// }