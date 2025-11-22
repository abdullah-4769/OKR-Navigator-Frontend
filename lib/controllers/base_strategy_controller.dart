// // base_strategy_controller.dart
// import 'package:game_app/generated/models/responses/strategy/strategy_response.dart';
// import 'package:get/get.dart';
//
// import '../presentation/routes/app_routes.dart';
// import 'journey_controller.dart';
// import 'language_controller.dart';
//
// abstract class BaseStrategyController extends GetxController {
//   /// Back card asset
//   final String backCardAsset = 'assets/images/backcard_img.png';
//
//   /// ✅ FIXED: English strategy card assets
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
//   /// ✅ FIXED: English card titles with proper backend cardId mapping
//   final List<String> englishCardTitles = [
//     "Improved Environmental Sustainability",    // cardId 0
//     "Customer Engagement Strategy",              // cardId 1
//     "Process Optimization Strategy",             // cardId 2
//     "Talent Development Strategy",               // cardId 3
//     "Revenue Maximization Strategy",             // cardId 4
//     "Continuous Innovation Strategy",            // cardId 5
//     "Cultural Reinforcement Strategy",           // cardId 6
//     "Market Expansion Strategy",                 // cardId 7
//   ];
//
//   /// ✅ FIXED: French strategy card assets
//   final List<String> frenchCardAssets = [
//     "assets/frencardsstrategy/1.jpeg",
//     "assets/frencardsstrategy/2.jpeg",
//     "assets/frencardsstrategy/3.jpeg",
//     "assets/frencardsstrategy/4.jpeg",
//     "assets/frencardsstrategy/5.jpeg",
//     "assets/frencardsstrategy/6.jpeg",
//     "assets/frencardsstrategy/7.jpeg",
//     "assets/frencardsstrategy/8.jpeg",
//   ];
//
//   /// ✅ FIXED: French strategy card titles with proper backend cardId mapping
//   final List<String> frenchCardTitles = [
//     "Amélioration de la Durabilité Environnementale",     // cardId 0
//     "Augmentation de la satisfaction client",             // cardId 1
//     "Amélioration de l'Efficience opérationnelle",        // cardId 2
//     "Optimisation de la Gestion des Ressources Humaines", // cardId 3
//     "Accroissement de la Rentabilité",                    // cardId 4
//     "Innovation dans les Offres de Produits/Services",    // cardId 5
//     "Renforcement de la Culture d'Entreprise",            // cardId 6
//     "Développement de Nouveaux Marchés",                  // cardId 7
//   ];
//
//   /// ✅ FIXED: Spanish strategy card assets
//   final List<String> spanishCardAssets = [
//     "assets/cartes objectifs/cartes objectifs_Page_1.png",
//     "assets/cartes objectifs/cartes objectifs_Page_2.png",
//     "assets/cartes objectifs/cartes objectifs_Page_4.png",
//     "assets/cartes objectifs/cartes objectifs_Page_6.png",
//     "assets/cartes objectifs/cartes objectifs_Page_8.png",
//     "assets/cartes objectifs/cartes objectifs_Page_10.png",
//     "assets/cartes objectifs/cartes objectifs_Page_12.png",
//     "assets/cartes objectifs/cartes objectifs_Page_14.png",
//     "assets/cartes objectifs/cartes objectifs_Page_16.png",
//   ];
//
//   /// ✅ FIXED: Spanish strategy card titles with proper backend cardId mapping
//   final List<String> spanishCardTitles = [
//     "Mejora de la Sostenibilidad Ambiental",    // cardId 0
//     "Estrategia de Compromiso del Cliente",     // cardId 1
//     "Estrategia de Optimización de Procesos",   // cardId 2
//     "Estrategia de Desarrollo de Talento",      // cardId 3
//     "Estrategia de Maximización de Ingresos",   // cardId 4
//     "Estrategia de Innovación Continua",        // cardId 5
//     "Estrategia de Refuerzo Cultural",          // cardId 6
//     "Estrategia de Expansión de Mercado",       // cardId 7
//     "Estrategia de Eficiencia Operativa",       // cardId 8
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
//   /// Helper method to check if language is French
//   bool get isFrench {
//     final lang = languageController.selectedLanguage.value;
//     final langStr = lang.toString().toLowerCase();
//     return langStr.contains('french') || langStr.contains('.fr') || langStr.endsWith('fr');
//   }
//
//   /// Helper method to check if language is Spanish
//   bool get isSpanish {
//     final lang = languageController.selectedLanguage.value;
//     final langStr = lang.toString().toLowerCase();
//     return langStr.contains('spanish') || langStr.contains('.es') || langStr.endsWith('es');
//   }
//
//   /// Get strategy card assets based on selected language
//   List<String> get strategyCardAssets {
//     if (isFrench) {
//       print('🇫🇷 Using French cards (${frenchCardAssets.length} cards)');
//       return frenchCardAssets;
//     } else if (isSpanish) {
//       print('🇪🇸 Using Spanish cards (${spanishCardAssets.length} cards)');
//       return spanishCardAssets;
//     } else {
//       print('🇬🇧 Using English cards (${englishCardAssets.length} cards)');
//       return englishCardAssets;
//     }
//   }
//
//   /// Get strategy card titles based on selected language
//   List<String> get strategyCardTitles {
//     if (isFrench) {
//       return frenchCardTitles;
//     } else if (isSpanish) {
//       return spanishCardTitles;
//     } else {
//       return englishCardTitles;
//     }
//   }
//
//   /// ✅ FIXED: Direct backend cardId to local index mapping
//   int getCardIndexFromBackendId(int? backendCardId) {
//     if (backendCardId == null) {
//       print('⚠️ Backend cardId is null, using index 0');
//       return 0;
//     }
//
//     // Backend card IDs are 0-based, our arrays are 0-based
//     // Direct mapping: backend ID 0 → index 0, backend ID 1 → index 1, etc.
//     final localIndex = backendCardId;
//     final assets = strategyCardAssets;
//     final titles = strategyCardTitles;
//
//     print('🔄 Card Index Mapping:');
//     print('   Backend cardId: $backendCardId');
//     print('   Local assets count: ${assets.length}');
//     print('   Local titles count: ${titles.length}');
//     print('   Mapped local index: $localIndex');
//
//     // Safety check - ensure index is within bounds
//     if (localIndex < 0 || localIndex >= assets.length) {
//       print('⚠️ WARNING: Mapped index $localIndex out of bounds for assets (0-${assets.length - 1}), using 0');
//       return 0;
//     }
//
//     if (localIndex >= titles.length) {
//       print('⚠️ WARNING: Mapped index $localIndex out of bounds for titles (0-${titles.length - 1}), using 0');
//       return 0;
//     }
//
//     // Log what we're actually selecting
//     print('🎴 Final Selection:');
//     print('   Asset: ${assets[localIndex]}');
//     print('   Title: ${titles[localIndex]}');
//
//     return localIndex;
//   }
//
//   /// Get title for a specific card index
//   String? getCardTitle(int cardIndex) {
//     final titles = strategyCardTitles;
//
//     if (cardIndex >= 0 && cardIndex < titles.length) {
//       final title = titles[cardIndex];
//       print('📋 Getting card title for index $cardIndex: $title');
//       return title;
//     }
//
//     print('⚠️ Card index $cardIndex out of bounds for titles (length: ${titles.length})');
//     return null;
//   }
//
//   /// Get title from backend card ID
//   String? getCardTitleFromBackendId(int? backendCardId) {
//     if (backendCardId == null) return null;
//
//     final index = getCardIndexFromBackendId(backendCardId);
//     final titles = strategyCardTitles;
//
//     if (index >= 0 && index < titles.length) {
//       final title = titles[index];
//       print('🎴 Backend ID $backendCardId → Local index $index → Title: $title');
//       return title;
//     }
//
//     return null;
//   }
//
//   /// Get asset for a specific backend card ID
//   String getCardAssetFromBackendId(int? backendCardId) {
//     if (backendCardId == null) return backCardAsset;
//
//     final index = getCardIndexFromBackendId(backendCardId);
//     final assets = strategyCardAssets;
//
//     if (index >= 0 && index < assets.length) {
//       return assets[index];
//     }
//
//     return backCardAsset;
//   }
//
//   /// Get all card assets including back card
//   List<String> get cardAssets => [backCardAsset] + strategyCardAssets;
//
//   /// Get current card asset based on selected strategy
//   String get currentCardAsset {
//     if (selectedCardIndex.value == -1) {
//       return backCardAsset;
//     }
//
//     // If we have a selected strategy with backend ID, use that for mapping
//     if (selectedStrategy.value?.cardId != null) {
//       final asset = getCardAssetFromBackendId(selectedStrategy.value!.cardId);
//       print('🎴 Current Asset from Backend ID:');
//       print('   Backend cardId: ${selectedStrategy.value!.cardId}');
//       print('   Mapped asset: $asset');
//       return asset;
//     }
//
//     // Fallback to index-based selection
//     if (selectedCardIndex.value >= 0 && selectedCardIndex.value < strategyCardAssets.length) {
//       return strategyCardAssets[selectedCardIndex.value];
//     }
//
//     return backCardAsset;
//   }
//
//   /// Get card display text with proper backend ID mapping
//   String get cardDisplayText {
//     if (!isCardRevealed.value) {
//       return 'Tap to Reveal Strategy';
//     }
//
//     // Use backend card ID to get the correct title
//     final displayTitle = getCardTitleFromBackendId(selectedStrategy.value?.cardId) ??
//         selectedStrategy.value?.title ??
//         'Strategy Card';
//
//     return displayTitle;
//   }
//
//   /// Check if user can reveal card
//   bool get canUserReveal => canReveal.value && !isCardRevealed.value;
//
//   /// ✅ FIXED: Enhanced reveal card with better debugging
//   void revealCard(StrategyResponse strategy) {
//     print('🎴 ========== REVEALING CARD ==========');
//     print('   Backend cardId: ${strategy.cardId}');
//     print('   Backend title: ${strategy.title}');
//     print('   Language: ${languageController.selectedLanguage.value}');
//     print('   Is French: $isFrench');
//     print('   Is Spanish: $isSpanish');
//
//     selectedStrategy.value = strategy;
//
//     // Map backend cardId to local index for display
//     final mappedIndex = getCardIndexFromBackendId(strategy.cardId);
//     selectedCardIndex.value = mappedIndex;
//
//     isCardRevealed.value = true;
//
//     print('   Mapped local index: $mappedIndex');
//     print('   Selected Card Index: ${selectedCardIndex.value}');
//     print('   Display title: ${getCardTitleFromBackendId(strategy.cardId)}');
//     print('   Display asset: ${getCardAssetFromBackendId(strategy.cardId)}');
//     print('   Current Asset: $currentCardAsset');
//     print('🎴 ========== CARD REVEALED ==========');
//   }
//
//   /// Hide card (reset to back card)
//   void hideCard() {
//     selectedCardIndex.value = -1;
//     isCardRevealed.value = false;
//     selectedStrategy.value = null;
//     print('🔄 Card hidden - reset to back card');
//   }
//
//   /// Reset and draw new card
//   void resetAndDrawNewCard() {
//     hideCard();
//     canReveal.value = true;
//     print('🔄 Reset and ready for new card draw');
//   }
//
//   /// Abstract method to be implemented by child controllers
//   Future<void> revealRandomCard();
//
//   /// Begin mission with correct backend ID mapping
//   void beginMission(
//       Map<String, dynamic>? selectedRole,
//       Map<String, dynamic>? selectedIndustry,
//       ) {
//     if (!isCardRevealed.value) {
//       Get.snackbar(
//         'Error',
//         'Please reveal a strategy card first',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     // Get the correct display title using backend card ID mapping
//     final displayTitle = getCardTitleFromBackendId(selectedStrategy.value?.cardId) ??
//         selectedStrategy.value?.title ??
//         'Strategy Card';
//
//     print('🚀 ========== BEGIN MISSION ==========');
//     print('   Backend cardId: ${selectedStrategy.value?.cardId}');
//     print('   Mapped local index: ${getCardIndexFromBackendId(selectedStrategy.value?.cardId)}');
//     print('   Language: ${languageController.selectedLanguage.value}');
//     print('   Is French: $isFrench');
//     print('   Is Spanish: $isSpanish');
//     print('   Display title: $displayTitle');
//     print('   API title: ${selectedStrategy.value?.title}');
//     print('🚀 ===================================');
//
//     Get.toNamed(
//       AppRoutes.keyObjectiveScreen,
//       arguments: {
//         'selectedRole': selectedRole,
//         'selectedIndustry': selectedIndustry,
//         'strategy': selectedStrategy.value,
//         'strategyDisplayTitle': displayTitle,
//         'strategyCardIndex': getCardIndexFromBackendId(selectedStrategy.value?.cardId),
//       },
//     );
//   }
// }
// base_strategy_controller.dart - COMPLETE FIXED VERSION
// import 'package:game_app/generated/models/responses/strategy/strategy_response.dart';
// import 'package:get/get.dart';
//
// import '../presentation/routes/app_routes.dart';
// import 'journey_controller.dart';
// import 'language_controller.dart';
//
// abstract class BaseStrategyController extends GetxController {
//   /// Back card asset
//   final String backCardAsset = 'assets/images/backcard_img.png';
//
//   /// ✅ English strategy card assets (8 cards, index 0-7)
//   final List<String> englishCardAssets = [
//     'assets/images/strategy1.png',  // Index 0 → Backend cardId 1
//     'assets/images/strategy2.png',  // Index 1 → Backend cardId 2
//     'assets/images/strategy3.png',  // Index 2 → Backend cardId 3
//     'assets/images/strategy4.png',  // Index 3 → Backend cardId 4
//     'assets/images/strategy5.png',  // Index 4 → Backend cardId 5
//     'assets/images/strategy6.png',  // Index 5 → Backend cardId 6
//     'assets/images/strategy7.png',  // Index 6 → Backend cardId 7
//     'assets/images/strategy8.png',  // Index 7 → Backend cardId 8
//   ];
//
//   /// ✅ FINAL FIX: English card titles mapped to ACTUAL card image text
//   /// Based on the physical card images in assets/images/strategy*.png
//   /// Backend cardId 1 = index 0 (strategy1.png), cardId 2 = index 1 (strategy2.png), etc.
//   final List<String> englishCardTitles = [
//     "Improved Environmental Sustainability",      // cardId 1 → index 0 → strategy1.png (tree with roots)
//     "Improve Operational Efficiency",             // cardId 2 → index 1 → strategy2.png (computer with gears)
//     "Optimize Human Resources Management",        // cardId 3 → index 2 → strategy3.png (puzzle pieces with people)
//     "Increase Profitability",                     // cardId 4 → index 3 → strategy4.png (gold coins)
//     "Innovation in Product/Service Offerings",    // cardId 5 → index 4 → strategy5.png (innovation tree)
//     "Reinforcement of Corporate Culture",         // cardId 6 → index 5 → strategy6.png (diverse team)
//     "Development of New Markets",                 // cardId 7 → index 6 → strategy7.png (handshake tree)
//     "Increase Customer Satisfaction",             // cardId 8 → index 7 → strategy8.png (person with phone)
//   ];
//
//   /// ✅ French strategy card assets (8 cards)
//   final List<String> frenchCardAssets = [
//     "assets/frencardsstrategy/1.jpeg",   // cardId 1 → index 0
//     "assets/frencardsstrategy/2.jpeg",   // cardId 2 → index 1
//     "assets/frencardsstrategy/3.jpeg",   // cardId 3 → index 2
//     "assets/frencardsstrategy/4.jpeg",   // cardId 4 → index 3
//     "assets/frencardsstrategy/5.jpeg",   // cardId 5 → index 4
//     "assets/frencardsstrategy/6.jpeg",   // cardId 6 → index 5
//     "assets/frencardsstrategy/7.jpeg",   // cardId 7 → index 6
//     "assets/frencardsstrategy/8.jpeg",   // cardId 8 → index 7
//   ];
//
//   /// ✅ French strategy card titles (8 cards)
//   final List<String> frenchCardTitles = [
//     "Amélioration de la Durabilité Environnementale",     // cardId 1 → index 0
//     "Augmentation de la satisfaction client",             // cardId 2 → index 1
//     "Amélioration de l'Efficience opérationnelle",        // cardId 3 → index 2
//     "Optimisation de la Gestion des Ressources Humaines", // cardId 4 → index 3
//     "Accroissement de la Rentabilité",                    // cardId 5 → index 4
//     "Innovation dans les Offres de Produits/Services",    // cardId 6 → index 5
//     "Renforcement de la Culture d'Entreprise",            // cardId 7 → index 6
//     "Développement de Nouveaux Marchés",                  // cardId 8 → index 7
//   ];
//
//   /// ✅ Spanish strategy card assets
//   final List<String> spanishCardAssets = [
//     "assets/cartes objectifs/cartes objectifs_Page_1.png",  // cardId 1 → index 0
//     "assets/cartes objectifs/cartes objectifs_Page_2.png",  // cardId 2 → index 1
//     "assets/cartes objectifs/cartes objectifs_Page_4.png",  // cardId 3 → index 2
//     "assets/cartes objectifs/cartes objectifs_Page_6.png",  // cardId 4 → index 3
//     "assets/cartes objectifs/cartes objectifs_Page_8.png",  // cardId 5 → index 4
//     "assets/cartes objectifs/cartes objectifs_Page_10.png", // cardId 6 → index 5
//     "assets/cartes objectifs/cartes objectifs_Page_12.png", // cardId 7 → index 6
//     "assets/cartes objectifs/cartes objectifs_Page_14.png", // cardId 8 → index 7
//     "assets/cartes objectifs/cartes objectifs_Page_16.png", // cardId 9 → index 8
//   ];
//
//   /// ✅ Spanish strategy card titles
//   final List<String> spanishCardTitles = [
//     "Mejora de la Sostenibilidad Ambiental",    // cardId 1 → index 0
//     "Estrategia de Compromiso del Cliente",     // cardId 2 → index 1
//     "Estrategia de Optimización de Procesos",   // cardId 3 → index 2
//     "Estrategia de Desarrollo de Talento",      // cardId 4 → index 3
//     "Estrategia de Maximización de Ingresos",   // cardId 5 → index 4
//     "Estrategia de Innovación Continua",        // cardId 6 → index 5
//     "Estrategia de Refuerzo Cultural",          // cardId 7 → index 6
//     "Estrategia de Expansión de Mercado",       // cardId 8 → index 7
//     "Estrategia de Eficiencia Operativa",       // cardId 9 → index 8
//   ];
//
//   /// Reactive properties
//   final RxInt selectedCardIndex = (-1).obs;
//   final RxBool isCardRevealed = false.obs;
//   final RxBool loading = false.obs;
//   final Rxn<StrategyResponse> selectedStrategy = Rxn();
//   final RxBool canReveal = true.obs;
//
//   /// Get controllers
//   JourneyController get journey => Get.find<JourneyController>();
//   LanguageController get languageController => Get.find<LanguageController>();
//
//   /// Helper method to check if language is French
//   bool get isFrench {
//     final lang = languageController.selectedLanguage.value;
//     final langStr = lang.toString().toLowerCase();
//     return langStr.contains('french') || langStr.contains('.fr') || langStr.endsWith('fr');
//   }
//
//   /// Helper method to check if language is Spanish
//   bool get isSpanish {
//     final lang = languageController.selectedLanguage.value;
//     final langStr = lang.toString().toLowerCase();
//     return langStr.contains('spanish') || langStr.contains('.es') || langStr.endsWith('es');
//   }
//
//   /// Get strategy card assets based on selected language
//   List<String> get strategyCardAssets {
//     if (isFrench) {
//       print('🇫🇷 Using French cards (${frenchCardAssets.length} cards)');
//       return frenchCardAssets;
//     } else if (isSpanish) {
//       print('🇪🇸 Using Spanish cards (${spanishCardAssets.length} cards)');
//       return spanishCardAssets;
//     } else {
//       print('🇬🇧 Using English cards (${englishCardAssets.length} cards)');
//       return englishCardAssets;
//     }
//   }
//
//   /// Get strategy card titles based on selected language
//   List<String> get strategyCardTitles {
//     if (isFrench) {
//       return frenchCardTitles;
//     } else if (isSpanish) {
//       return spanishCardTitles;
//     } else {
//       return englishCardTitles;
//     }
//   }
//
//   /// ✅ Get all card assets including back card (for legacy support if needed)
//   /// INDEX 0 = backcard, INDEX 1+ = strategy cards
//   List<String> get cardAssets => [backCardAsset] + strategyCardAssets;
//
//   /// ✅ CRITICAL: Get strategy card asset by selectedCardIndex (0-based, WITHOUT backcard)
//   /// Use this for displaying revealed cards in CustomCardPagerBuilder
//   String getStrategyCardAsset(int index) {
//     if (index < 0 || index >= strategyCardAssets.length) {
//       print('⚠️ Strategy card index $index out of bounds, returning backcard');
//       return backCardAsset;
//     }
//     return strategyCardAssets[index];
//   }
//
//   /// ✅ CRITICAL FIX: Backend uses 1-based cardId, convert to 0-based index
//   /// Backend cardId 1 → local index 0
//   /// Backend cardId 2 → local index 1
//   /// Backend cardId 3 → local index 2, etc.
//   /// SPECIAL CASE: Sometimes backend returns cardId 0, treat it as cardId 1
//   int getCardIndexFromBackendId(int? backendCardId) {
//     if (backendCardId == null) {
//       print('⚠️ Backend cardId is null, using index 0');
//       return 0;
//     }
//
//     // ✅ CRITICAL: Handle backend bug where it returns cardId 0
//     if (backendCardId == 0) {
//       print('⚠️ Backend returned cardId 0, treating as cardId 1 (index 0)');
//       return 0;
//     }
//
//     // ✅ Convert 1-based backend cardId to 0-based array index
//     final localIndex = backendCardId - 1;
//     final assets = strategyCardAssets;
//     final titles = strategyCardTitles;
//
//     print('🔄 Card Index Mapping:');
//     print('   Backend cardId (1-based): $backendCardId');
//     print('   Converted to local index (0-based): $localIndex');
//     print('   Local assets count: ${assets.length}');
//     print('   Local titles count: ${titles.length}');
//
//     // Safety check - ensure index is within bounds
//     if (localIndex < 0 || localIndex >= assets.length) {
//       print('⚠️ WARNING: Mapped index $localIndex out of bounds for assets (0-${assets.length - 1}), using 0');
//       return 0;
//     }
//
//     if (localIndex >= titles.length) {
//       print('⚠️ WARNING: Mapped index $localIndex out of bounds for titles (0-${titles.length - 1}), using 0');
//       return 0;
//     }
//
//     // Log what we're actually selecting
//     print('🎴 Final Selection:');
//     print('   Asset: ${assets[localIndex]}');
//     print('   Title: ${titles[localIndex]}');
//
//     return localIndex;
//   }
//
//   /// Get title for a specific card index
//   String? getCardTitle(int cardIndex) {
//     final titles = strategyCardTitles;
//
//     if (cardIndex >= 0 && cardIndex < titles.length) {
//       final title = titles[cardIndex];
//       print('📋 Getting card title for index $cardIndex: $title');
//       return title;
//     }
//
//     print('⚠️ Card index $cardIndex out of bounds for titles (length: ${titles.length})');
//     return null;
//   }
//
//   /// Get title from backend card ID
//   String? getCardTitleFromBackendId(int? backendCardId) {
//     if (backendCardId == null) return null;
//
//     final index = getCardIndexFromBackendId(backendCardId);
//     final titles = strategyCardTitles;
//
//     if (index >= 0 && index < titles.length) {
//       final title = titles[index];
//       print('🎴 Backend ID $backendCardId (1-based) → Local index $index (0-based) → Title: $title');
//       return title;
//     }
//
//     return null;
//   }
//
//   /// Get asset for a specific backend card ID
//   String getCardAssetFromBackendId(int? backendCardId) {
//     if (backendCardId == null) return backCardAsset;
//
//     final index = getCardIndexFromBackendId(backendCardId);
//     final assets = strategyCardAssets;
//
//     if (index >= 0 && index < assets.length) {
//       return assets[index];
//     }
//
//     return backCardAsset;
//   }
//
//   /// Get current card asset based on selected strategy
//   String get currentCardAsset {
//     if (selectedCardIndex.value == -1) {
//       return backCardAsset;
//     }
//
//     // If we have a selected strategy with backend ID, use that for mapping
//     if (selectedStrategy.value?.cardId != null) {
//       final asset = getCardAssetFromBackendId(selectedStrategy.value!.cardId);
//       print('🎴 Current Asset from Backend ID:');
//       print('   Backend cardId: ${selectedStrategy.value!.cardId}');
//       print('   Mapped asset: $asset');
//       return asset;
//     }
//
//     // Fallback to index-based selection
//     if (selectedCardIndex.value >= 0 && selectedCardIndex.value < strategyCardAssets.length) {
//       return strategyCardAssets[selectedCardIndex.value];
//     }
//
//     return backCardAsset;
//   }
//
//   /// Get card display text with proper backend ID mapping
//   String get cardDisplayText {
//     if (!isCardRevealed.value) {
//       return 'Tap to Reveal Strategy';
//     }
//
//     // Use backend card ID to get the correct title
//     final displayTitle = getCardTitleFromBackendId(selectedStrategy.value?.cardId) ??
//         selectedStrategy.value?.title ??
//         'Strategy Card';
//
//     return displayTitle;
//   }
//
//   /// Check if user can reveal card
//   bool get canUserReveal => canReveal.value && !isCardRevealed.value;
//
//   /// Reveal card with correct mapping
//   void revealCard(StrategyResponse strategy) {
//     print('🎴 ========== REVEALING CARD ==========');
//     print('   Backend cardId (1-based): ${strategy.cardId}');
//     print('   Backend title: ${strategy.title}');
//     print('   Language: ${languageController.selectedLanguage.value}');
//     print('   Is French: $isFrench');
//     print('   Is Spanish: $isSpanish');
//
//     selectedStrategy.value = strategy;
//
//     // ✅ Convert backend cardId (1-based) to local index (0-based)
//     final mappedIndex = getCardIndexFromBackendId(strategy.cardId);
//     selectedCardIndex.value = mappedIndex;
//
//     isCardRevealed.value = true;
//
//     print('   Mapped local index (0-based): $mappedIndex');
//     print('   Selected Card Index: ${selectedCardIndex.value}');
//     print('   Display title: ${getCardTitleFromBackendId(strategy.cardId)}');
//     print('   Display asset: ${getCardAssetFromBackendId(strategy.cardId)}');
//     print('   Current Asset: $currentCardAsset');
//     print('🎴 ========== CARD REVEALED ==========');
//   }
//
//   /// Hide card (reset to back card)
//   void hideCard() {
//     selectedCardIndex.value = -1;
//     isCardRevealed.value = false;
//     selectedStrategy.value = null;
//     print('🔄 Card hidden - reset to back card');
//   }
//
//   /// Reset and draw new card
//   void resetAndDrawNewCard() {
//     hideCard();
//     canReveal.value = true;
//     print('🔄 Reset and ready for new card draw');
//   }
//
//   /// Abstract method to be implemented by child controllers
//   Future<void> revealRandomCard();
//
//   /// Begin mission with correct backend ID mapping
//   void beginMission(
//       Map<String, dynamic>? selectedRole,
//       Map<String, dynamic>? selectedIndustry,
//       ) {
//     if (!isCardRevealed.value) {
//       Get.snackbar(
//         'Error',
//         'Please reveal a strategy card first',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     // Get the correct display title using backend card ID mapping
//     final displayTitle = getCardTitleFromBackendId(selectedStrategy.value?.cardId) ??
//         selectedStrategy.value?.title ??
//         'Strategy Card';
//
//     print('🚀 ========== BEGIN MISSION ==========');
//     print('   Backend cardId (1-based): ${selectedStrategy.value?.cardId}');
//     print('   Mapped local index (0-based): ${getCardIndexFromBackendId(selectedStrategy.value?.cardId)}');
//     print('   Language: ${languageController.selectedLanguage.value}');
//     print('   Is French: $isFrench');
//     print('   Is Spanish: $isSpanish');
//     print('   Display title: $displayTitle');
//     print('   API title: ${selectedStrategy.value?.title}');
//     print('🚀 ===================================');
//
//     Get.toNamed(
//       AppRoutes.keyObjectiveScreen,
//       arguments: {
//         'selectedRole': selectedRole,
//         'selectedIndustry': selectedIndustry,
//         'strategy': selectedStrategy.value,
//         'strategyDisplayTitle': displayTitle,
//         'strategyCardIndex': getCardIndexFromBackendId(selectedStrategy.value?.cardId),
//       },
//     );
//   }
// }
// base_strategy_controller.dart - COMPLETE FIXED VERSION
import 'package:game_app/generated/models/responses/strategy/strategy_response.dart';
import 'package:get/get.dart';

import '../presentation/routes/app_routes.dart';
import 'journey_controller.dart';
import 'language_controller.dart';

abstract class BaseStrategyController extends GetxController {
  /// Back card asset
  final String backCardAsset = 'assets/images/backcard_img.png';

  /// ✅ English strategy card assets (8 cards, index 0-7)
  final List<String> englishCardAssets = [
    'assets/images/strategy1.png',  // Index 0 → Backend cardId 1
    'assets/images/strategy2.png',  // Index 1 → Backend cardId 2
    'assets/images/strategy3.png',  // Index 2 → Backend cardId 3
    'assets/images/strategy4.png',  // Index 3 → Backend cardId 4
    'assets/images/strategy5.png',  // Index 4 → Backend cardId 5
    'assets/images/strategy6.png',  // Index 5 → Backend cardId 6
    'assets/images/strategy7.png',  // Index 6 → Backend cardId 7
    'assets/images/strategy8.png',  // Index 7 → Backend cardId 8
  ];

  /// ✅ FINAL FIX: English card titles mapped to ACTUAL card image text
  /// Based on the physical card images in assets/images/strategy*.png
  /// Backend cardId 1 = index 0 (strategy1.png), cardId 2 = index 1 (strategy2.png), etc.
  final List<String> englishCardTitles = [
    "Improved Environmental Sustainability",      // cardId 1 → index 0 → strategy1.png (tree with roots)
    "Improve Operational Efficiency",             // cardId 2 → index 1 → strategy2.png (computer with gears)
    "Optimize Human Resources Management",        // cardId 3 → index 2 → strategy3.png (puzzle pieces with people)
    "Increase Profitability",                     // cardId 4 → index 3 → strategy4.png (gold coins)
    "Innovation in Product/Service Offerings",    // cardId 5 → index 4 → strategy5.png (innovation tree)
    "Reinforcement of Corporate Culture",         // cardId 6 → index 5 → strategy6.png (diverse team)
    "Development of New Markets",                 // cardId 7 → index 6 → strategy7.png (handshake tree)
    "Increase Customer Satisfaction",             // cardId 8 → index 7 → strategy8.png (person with phone)
  ];

  /// ✅ French strategy card assets (8 cards)
  final List<String> frenchCardAssets = [
    "assets/frencardsstrategy/1.jpeg",   // cardId 1 → index 0
    "assets/frencardsstrategy/2.jpeg",   // cardId 2 → index 1
    "assets/frencardsstrategy/3.jpeg",   // cardId 3 → index 2
    "assets/frencardsstrategy/4.jpeg",   // cardId 4 → index 3
    "assets/frencardsstrategy/5.jpeg",   // cardId 5 → index 4
    "assets/frencardsstrategy/6.jpeg",   // cardId 6 → index 5
    "assets/frencardsstrategy/7.jpeg",   // cardId 7 → index 6
    "assets/frencardsstrategy/8.jpeg",   // cardId 8 → index 7
  ];

  /// ✅ FIXED: French strategy card titles matching backend API order
  /// Backend sends English titles, these are French translations in SAME order
  final List<String> frenchCardTitles = [
    "Amélioration de la Durabilité Environnementale",     // cardId 1 → index 0 → Improved Environmental Sustainability
    "Amélioration de l'Efficience opérationnelle",        // cardId 2 → index 1 → Improve Operational Efficiency
    "Optimisation de la Gestion des Ressources Humaines", // cardId 3 → index 2 → Optimize Human Resources Management
    "Accroissement de la Rentabilité",                    // cardId 4 → index 3 → Increase Profitability
    "Innovation dans les Offres de Produits/Services",    // cardId 5 → index 4 → Innovation in Product/Service Offerings
    "Renforcement de la Culture d'Entreprise",            // cardId 6 → index 5 → Reinforcement of Corporate Culture ✅
    "Développement de Nouveaux Marchés",                  // cardId 7 → index 6 → Development of New Markets
    "Augmentation de la satisfaction client",             // cardId 8 → index 7 → Increase Customer Satisfaction
  ];

  /// ✅ Spanish strategy card assets
  final List<String> spanishCardAssets = [
    "assets/cartes objectifs/cartes objectifs_Page_1.png",  // cardId 1 → index 0
    "assets/cartes objectifs/cartes objectifs_Page_2.png",  // cardId 2 → index 1
    "assets/cartes objectifs/cartes objectifs_Page_4.png",  // cardId 3 → index 2
    "assets/cartes objectifs/cartes objectifs_Page_6.png",  // cardId 4 → index 3
    "assets/cartes objectifs/cartes objectifs_Page_8.png",  // cardId 5 → index 4
    "assets/cartes objectifs/cartes objectifs_Page_10.png", // cardId 6 → index 5
    "assets/cartes objectifs/cartes objectifs_Page_12.png", // cardId 7 → index 6
    "assets/cartes objectifs/cartes objectifs_Page_14.png", // cardId 8 → index 7
    "assets/cartes objectifs/cartes objectifs_Page_16.png", // cardId 9 → index 8
  ];

  /// ✅ Spanish strategy card titles
  final List<String> spanishCardTitles = [
    "Mejora de la Sostenibilidad Ambiental",    // cardId 1 → index 0
    "Estrategia de Compromiso del Cliente",     // cardId 2 → index 1
    "Estrategia de Optimización de Procesos",   // cardId 3 → index 2
    "Estrategia de Desarrollo de Talento",      // cardId 4 → index 3
    "Estrategia de Maximización de Ingresos",   // cardId 5 → index 4
    "Estrategia de Innovación Continua",        // cardId 6 → index 5
    "Estrategia de Refuerzo Cultural",          // cardId 7 → index 6
    "Estrategia de Expansión de Mercado",       // cardId 8 → index 7
    "Estrategia de Eficiencia Operativa",       // cardId 9 → index 8
  ];

  /// Reactive properties
  final RxInt selectedCardIndex = (-1).obs;
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
      return englishCardTitles;
    }
  }

  /// ✅ Get all card assets including back card (for legacy support if needed)
  /// INDEX 0 = backcard, INDEX 1+ = strategy cards
  List<String> get cardAssets => [backCardAsset] + strategyCardAssets;

  /// ✅ CRITICAL: Get strategy card asset by selectedCardIndex (0-based, WITHOUT backcard)
  /// Use this for displaying revealed cards in CustomCardPagerBuilder
  String getStrategyCardAsset(int index) {
    if (index < 0 || index >= strategyCardAssets.length) {
      print('⚠️ Strategy card index $index out of bounds, returning backcard');
      return backCardAsset;
    }
    return strategyCardAssets[index];
  }

  /// ✅ CRITICAL FIX: Backend uses 1-based cardId, convert to 0-based index
  /// Backend cardId 1 → local index 0
  /// Backend cardId 2 → local index 1
  /// Backend cardId 3 → local index 2, etc.
  /// SPECIAL CASE: Sometimes backend returns cardId 0, treat it as cardId 1
  int getCardIndexFromBackendId(int? backendCardId) {
    if (backendCardId == null) {
      print('⚠️ Backend cardId is null, using index 0');
      return 0;
    }

    // ✅ CRITICAL: Handle backend bug where it returns cardId 0
    if (backendCardId == 0) {
      print('⚠️ Backend returned cardId 0, treating as cardId 1 (index 0)');
      return 0;
    }

    // ✅ Convert 1-based backend cardId to 0-based array index
    final localIndex = backendCardId - 1;
    final assets = strategyCardAssets;
    final titles = strategyCardTitles;

    print('🔄 Card Index Mapping:');
    print('   Backend cardId (1-based): $backendCardId');
    print('   Converted to local index (0-based): $localIndex');
    print('   Local assets count: ${assets.length}');
    print('   Local titles count: ${titles.length}');

    // Safety check - ensure index is within bounds
    if (localIndex < 0 || localIndex >= assets.length) {
      print('⚠️ WARNING: Mapped index $localIndex out of bounds for assets (0-${assets.length - 1}), using 0');
      return 0;
    }

    if (localIndex >= titles.length) {
      print('⚠️ WARNING: Mapped index $localIndex out of bounds for titles (0-${titles.length - 1}), using 0');
      return 0;
    }

    // Log what we're actually selecting
    print('🎴 Final Selection:');
    print('   Asset: ${assets[localIndex]}');
    print('   Title: ${titles[localIndex]}');

    return localIndex;
  }

  /// Get title for a specific card index
  String? getCardTitle(int cardIndex) {
    final titles = strategyCardTitles;

    if (cardIndex >= 0 && cardIndex < titles.length) {
      final title = titles[cardIndex];
      print('📋 Getting card title for index $cardIndex: $title');
      return title;
    }

    print('⚠️ Card index $cardIndex out of bounds for titles (length: ${titles.length})');
    return null;
  }

  /// Get title from backend card ID
  String? getCardTitleFromBackendId(int? backendCardId) {
    if (backendCardId == null) return null;

    final index = getCardIndexFromBackendId(backendCardId);
    final titles = strategyCardTitles;

    if (index >= 0 && index < titles.length) {
      final title = titles[index];
      print('🎴 Backend ID $backendCardId (1-based) → Local index $index (0-based) → Title: $title');
      return title;
    }

    return null;
  }

  /// Get asset for a specific backend card ID
  String getCardAssetFromBackendId(int? backendCardId) {
    if (backendCardId == null) return backCardAsset;

    final index = getCardIndexFromBackendId(backendCardId);
    final assets = strategyCardAssets;

    if (index >= 0 && index < assets.length) {
      return assets[index];
    }

    return backCardAsset;
  }

  /// Get current card asset based on selected strategy
  String get currentCardAsset {
    if (selectedCardIndex.value == -1) {
      return backCardAsset;
    }

    // If we have a selected strategy with backend ID, use that for mapping
    if (selectedStrategy.value?.cardId != null) {
      final asset = getCardAssetFromBackendId(selectedStrategy.value!.cardId);
      print('🎴 Current Asset from Backend ID:');
      print('   Backend cardId: ${selectedStrategy.value!.cardId}');
      print('   Mapped asset: $asset');
      return asset;
    }

    // Fallback to index-based selection
    if (selectedCardIndex.value >= 0 && selectedCardIndex.value < strategyCardAssets.length) {
      return strategyCardAssets[selectedCardIndex.value];
    }

    return backCardAsset;
  }

  /// Get card display text with proper backend ID mapping
  String get cardDisplayText {
    if (!isCardRevealed.value) {
      return 'Tap to Reveal Strategy';
    }

    // Use backend card ID to get the correct title
    final displayTitle = getCardTitleFromBackendId(selectedStrategy.value?.cardId) ??
        selectedStrategy.value?.title ??
        'Strategy Card';

    return displayTitle;
  }

  /// Check if user can reveal card
  bool get canUserReveal => canReveal.value && !isCardRevealed.value;

  /// Reveal card with correct mapping
  void revealCard(StrategyResponse strategy) {
    print('🎴 ========== REVEALING CARD ==========');
    print('   Backend cardId (1-based): ${strategy.cardId}');
    print('   Backend title: ${strategy.title}');
    print('   Language: ${languageController.selectedLanguage.value}');
    print('   Is French: $isFrench');
    print('   Is Spanish: $isSpanish');

    selectedStrategy.value = strategy;

    // ✅ Convert backend cardId (1-based) to local index (0-based)
    final mappedIndex = getCardIndexFromBackendId(strategy.cardId);
    selectedCardIndex.value = mappedIndex;

    isCardRevealed.value = true;

    print('   Mapped local index (0-based): $mappedIndex');
    print('   Selected Card Index: ${selectedCardIndex.value}');
    print('   Display title: ${getCardTitleFromBackendId(strategy.cardId)}');
    print('   Display asset: ${getCardAssetFromBackendId(strategy.cardId)}');
    print('   Current Asset: $currentCardAsset');
    print('🎴 ========== CARD REVEALED ==========');
  }

  /// Hide card (reset to back card)
  void hideCard() {
    selectedCardIndex.value = -1;
    isCardRevealed.value = false;
    selectedStrategy.value = null;
    print('🔄 Card hidden - reset to back card');
  }

  /// Reset and draw new card
  void resetAndDrawNewCard() {
    hideCard();
    canReveal.value = true;
    print('🔄 Reset and ready for new card draw');
  }

  /// Abstract method to be implemented by child controllers
  Future<void> revealRandomCard();

  /// Begin mission with correct backend ID mapping
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

    // Get the correct display title using backend card ID mapping
    final displayTitle = getCardTitleFromBackendId(selectedStrategy.value?.cardId) ??
        selectedStrategy.value?.title ??
        'Strategy Card';

    print('🚀 ========== BEGIN MISSION ==========');
    print('   Backend cardId (1-based): ${selectedStrategy.value?.cardId}');
    print('   Mapped local index (0-based): ${getCardIndexFromBackendId(selectedStrategy.value?.cardId)}');
    print('   Language: ${languageController.selectedLanguage.value}');
    print('   Is French: $isFrench');
    print('   Is Spanish: $isSpanish');
    print('   Display title: $displayTitle');
    print('   API title: ${selectedStrategy.value?.title}');
    print('🚀 ===================================');

    Get.toNamed(
      AppRoutes.keyObjectiveScreen,
      arguments: {
        'selectedRole': selectedRole,
        'selectedIndustry': selectedIndustry,
        'strategy': selectedStrategy.value,
        'strategyDisplayTitle': displayTitle,
        'strategyCardIndex': getCardIndexFromBackendId(selectedStrategy.value?.cardId),
      },
    );
  }
}