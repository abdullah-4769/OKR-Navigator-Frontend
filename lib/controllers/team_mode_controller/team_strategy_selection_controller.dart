import 'dart:math';
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
  final RxBool _isLoading = false.obs;

  bool get loading => _isLoading.value;
  /// Repository instance
  final StrategyRepository _strategyRepository = StrategyRepository();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();

  /// List of card assets
  final List<String> cardAssets = [
    'assets/images/card_1.png',
    'assets/images/card_1.png',
    'assets/images/card_1.png',
    'assets/images/card_1.png',
  ];

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

  /// Access JourneyController
  JourneyController get journey => Get.find<JourneyController>();
final TeamGameTimerController _timerController = Get.find<TeamGameTimerController>(); // <--- NEW FIND
// -----------------------------------------------------------
// ✅ INTEGRATED API CALL AND REVEAL LOGIC
// -----------------------------------------------------------

  /// Fetches team strategy from API and reveals a random card asset with the fetched name
// lib/controllers/team_mode_controller/team_strategy_selection_controller.dart

// ... existing code ...
/// Fetches team strategy from API and reveals a random card asset with the fetched name
 Future<void> fetchAndRevealStrategy() async {
    // 📝 New: Always print when the function starts
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
      // Defensive Find: Ensure CreateTeamController is available
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
final randomIndex = Random().nextInt(cardAssets.length);
revealCard(randomIndex, name: response.title); 

 selectedStrategy.value = response.title!;
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
} } catch (e) {
// Catch exceptions thrown by repository (e.g., API errors, network issues)
 Get.snackbar('Error', 'Failed to fetch team strategy: $e');
      print('Catch Block Error: $e');
} finally {
 isLoading.value = false;
      print('Function finished. isLoading=false');
      print('-------------------');
 } }

// ... rest of the file ...

  /// Override the method called by CustomCardPagerBuilder (UI)
  void revealRandomCard({String? name}) {
    fetchAndRevealStrategy();
  }

// -----------------------------------------------------------
// -----------------------------------------------------------
  
  /// Reveal a specific card asset and set the name
  void revealCard(int index, {String? name}) {
    selectedCardIndex.value = index;
    isCardRevealed.value = true;

    if (name != null) selectedStrategy.value = name;

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
 /// Corrected: Pass arguments to the next screen (TeamObjectiveScreen)
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
}