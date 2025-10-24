import 'dart:developer';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/controllers/team_mode_controller/create_team_controller.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../../presentation/routes/app_routes.dart';

class TeamGameCompleteController extends GetxController {
  // ----------------------
  // Observables
  // ----------------------

  /// Final score
  final RxInt score = 0.obs;

  /// Rewards & Achievements
  final RxList<String> badges = <String>[].obs;
  final RxList<String> titles = <String>[].obs;
  final RxString trophy = "".obs;

  /// Performance breakdown
  final RxInt points = 0.obs;
  final RxInt totalPoints = 0.obs;
  final RxList<Map<String, dynamic>> breakdownItems = <Map<String, dynamic>>[].obs;

  /// Achievements
  final RxList<String> achievements = <String>[].obs;

  /// Journey Map state
  final RxBool showJourneyDetails = true.obs;

  // Dependencies
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();

  // ----------------------
  // Lifecycle
  // ----------------------

  @override
  void onInit() {
    super.onInit();
    _loadGameResults();
  }

  // ----------------------
  // Private Methods
  // ----------------------

  /// Fetches game results from the final score API endpoint
  void _loadGameResults() async {
    // Get dependencies
    final teamId = Get.find<CreateTeamController>().createdTeamId.value; //
    final userId = _storageRepository.getUser()?.id; //

    if (teamId == null || userId == null) {
        log('Team ID or User ID missing for final score fetch. Using fallback.');
        SnackbarHelper.error('Cannot load game results. Missing game context.'); //
        _useFallbackData();
        return;
    }
    
    try {
      // API Call: GET /final-team-score/{teamId}/summary 
      // This is the call that retrieves the result data submitted by TeamContextualAdjustmentController.
      final summaryResult = await _strategyRepository.getFinalTeamScoreSummary(teamId); //

      // Extract and map data
      score.value = summaryResult['teamScore'] ?? 0;
      
      final breakdown = summaryResult['breakdown'] as Map<String, dynamic>?;
      if (breakdown != null) {
          points.value = breakdown['totalPointsAchieved'] ?? 0;
          totalPoints.value = breakdown['totalPointsPossible'] ?? 0;

          // Note: Assuming API returns the score values for breakdown items
          breakdownItems.assignAll([
              {"title": "Strategy Selection", "score": "${breakdown['alignmentStrategy']}/15", "success": (breakdown['alignmentStrategy']??0) > 0},
              {"title": "Objective Alignment", "score": "${breakdown['objectiveClarity']}/15", "success": (breakdown['objectiveClarity']??0) > 0},
              {"title": "Key Results Quality", "score": "${breakdown['keyResultQuality']}/25", "success": (breakdown['keyResultQuality']??0) > 0},
              {"title": "Initiative Relevance", "score": "${breakdown['initiativeRelevance']}/25", "success": (breakdown['initiativeRelevance']??0) > 0},
              {"title": "Challenge Adaptation", "score": "${breakdown['challengeAdoption']}/20", "success": (breakdown['challengeAdoption']??0) > 0},
          ]);
      }
      
      achievements.assignAll(summaryResult['achievements'] ?? ["Completed strategic cycle".tr]);
      badges.assignAll(summaryResult['badges'] ?? ["Strategic Thinker".tr]);
      titles.assignAll(summaryResult['titles'] ?? ["Master Adapter".tr]);
      trophy.value = summaryResult['teamTrophy'] ?? "Bronze".tr; 
      
      log('Team game results loaded successfully.');

    } catch (e, s) {
      log('Error fetching team final score: $e', stackTrace: s);
      SnackbarHelper.error('Failed to load final results: ${e.toString()}'); //
      _useFallbackData();
    }
  }

  void _useFallbackData() {
    // Fallback data structure maintained
    score.value = 91;

    badges.assignAll(["Strategic Thinker".tr, "Team Player".tr]);
    titles.assignAll(["Master Adapter".tr, "Collaboration Expert".tr]);
    trophy.value = "Silver".tr;

    points.value = 9;
    totalPoints.value = 10;

    breakdownItems.assignAll([
      {"title": "Strategy Selection", "score": "2/2", "success": true},
      {"title": "Objective Alignment", "score": "2/2", "success": true},
      {"title": "Key Results Quality", "score": "1/2", "success": false},
      {"title": "Initiative Relevance", "score": "2/2", "success": true},
      {"title": "Challenge Adaptation", "score": "2/2", "success": true},
    ]);

    achievements.assignAll([
      "Completed strategic planning cycle as a team".tr,
      "Successfully adapted to market challenge collaboratively".tr,
      "Demonstrated excellent team coordination".tr,
      "Earned 'Strategic Architect' certification as a team".tr,
    ]);
  }

  // ----------------------
  // Actions
  // ----------------------

 void toggleJourneyDetails() {
        showJourneyDetails.value = !showJourneyDetails.value;
    }

    /// Resets scores and navigates to the Game Mode selection screen for a fresh start.
    void playAgain() {
        // Reset state
        score.value = 0;
        points.value = 0;
        totalPoints.value = 0;
        badges.clear();
        titles.clear();
        trophy.value = "";
        breakdownItems.clear();
        achievements.clear();
        showJourneyDetails.value = true;

        // Navigate to new game screen entry point
        Get.offAllNamed(AppRoutes.gameMode);
    }

    /// Navigates to the Team Achievements screen.
    void viewBadges() {
        Get.toNamed(AppRoutes.teamAchievementsScreen);
    }

    /// Displays a message confirming the share action.
    void shareScore() {
        // Placeholder for actual sharing mechanism (requires external package like share_plus)
        SnackbarHelper.info("Sharing team score of ${score.value}%...");
    }

    /// Navigates to the Team Strategic Journey screen.
    void viewJourney() {
        Get.toNamed(AppRoutes.teamStrategicJourneyScreen);
    }
}